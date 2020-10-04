Title: Using CUSTOM_BUILDOPT in refpolicy for USE flag-alike functionality?
Date: 2013-08-16 09:17
Category: Gentoo
Tags: boolean, Gentoo, policy, selinux, use, useflag
Slug: using-custom_buildopt-in-refpolicy-for-use-flag-alike-functionality

As you are probably aware, Gentoo uses the [reference
policy](http://oss.tresys.com/projects/refpolicy/) as its base for
SELinux policies. Yes, we do customize it and not everything is already
pushed upstream (for instance, our approach to use `xdg_*_home_t`
customizable types to further restrict user application access has been
sent up for comments a few times but we still need to iron it out
further) but all in all, we're pretty close to the upstream releases.
This is also visible when there are changes upstream as we very easily
integrate them back in our repository.

But there are still a few things that I want to implement further, and
one of these things is perhaps too specific for Gentoo but would benefit
us (security-wise) in great detail: enabling domain privileges based on
USE flags. Allow me to quickly use an example to make this more
tangible.

Consider the MPlayer application. As a media application, it of course
offers support for ALSA and PulseAudio (amongst other things). In the
SELinux policy, support for (and thus privileges related to) ALSA and
PulseAudio is handled through *optional\_policy* statements:

    optional_policy(`
      pulseaudio_tmpfs_content(mplayer_tmpfs_t)
    ')

This means that the rules defined in *pulseaudio\_tmpfs\_content* are
executed if the dependencies match:

    interface(`pulseaudio_tmpfs_content',`
            gen_require(`
                    attribute pulseaudio_tmpfsfile;
            ')

            typeattribute $1 pulseaudio_tmpfsfile;
    ')

If the `pulseaudio_tmpfsfile` attribute exists, then the
`mplayer_tmpfs_t` type gets the `pulseaudio_tmpfsfile` attribute
assigned to it.

This is flexible, because if the server/workstation does not use
PulseAudio, then in Gentoo, no pulseaudio SELinux module will be loaded
and thus the attribute will not exist. However, Gentoo tries to be a bit
more flexible in this - it is very well possible to have PulseAudio
installed, but disable PulseAudio support in MPlayer (build mplayer with
USE="-pulseaudio"). The current definitions in the policy do not support
this flexibility: if the pulseaudio module is loaded, then the
privileges become active.

One way SELinux supports a more flexible approach is to use conditionals
in the policy. One could create booleans that administrators can toggle
to enable / disable SELinux rules. For instance, in the mplayer policy:

    tunable_policy(`allow_mplayer_execstack',`
            allow mencoder_t self:process { execmem execstack };
    ')

If an administrator toggles the `allow_mplayer_execstack` boolean to
"on", then the mentioned `allow` rule becomes active.

Sadly, this approach is not fully usable for USE driven decisions. Not
all rules can be enclosed in `tunable_policy` statements, and [assigning
attributes to a
type](http://oss.tresys.com/pipermail/refpolicy/2013-July/006452.html)
is one of them (cfr our pulseaudio example). A recent discussion on the
reference policy mailinglist gave me two ideas to investigate:

-   See if we can support CIL (a new language for SELinux
    policy definitions) where such an approach would be easier
-   Use build-time decisions

In this post, I want to go through the *build-time decisions* idea. The
reference policy supports build-time options using *ifdef* constructs.
These look at parameters provided by the build system (M4/Makefile
based) to see if rules need to be activated or not. For type attribute
declarations, this is a valid approach. So one idea would be to
transform USE flags, if they are set, into `use_${USEFLAG}`, and make
decisions based on this in the policy code:

    ifdef(`use_pulseaudio',`
      optional_policy(`
        pulseaudio_tmpfs_content(mplayer_tmpfs_t)
      ')
    ')

We can add in the USE flags, if set, through the `CUSTOM_BUILDOPT`
parameter that the reference policy provides. So introducing this is not
that difficult. The only thing I'm currently a bit weary about is the
impact on the policy files themselves (which is why I haven't done this
already) and the fact that USE flags on the "real" package are not know
to policy packages. In other words, if a user explicitly marks
`USE="-pulseaudio"` on mplayer, but has `USE="pulseaudio"` set as
general value, then the `selinux-mplayer` package will still have
pulseaudio enabled.

Still, I do like the idea. It would make it more consistent with what
Gentoo aims to do: if you do not want a certain support/feature in the
code, then why would the policy still have to allow it? With the proper
documentation towards administrators, I think this would be a good
approach.
