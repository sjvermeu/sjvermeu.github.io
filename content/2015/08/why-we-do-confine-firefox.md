Title: Why we do confine Firefox
Date: 2015-08-11 19:18
Category: SELinux
Tags: gentoo, selinux, policy, firefox, cve, vulnerability, xdg
Slug: why-we-do-confine-firefox

If you're a bit following the SELinux development community you will know
[Dan Walsh](http://danwalsh.livejournal.com), a [Red Hat](http://people.redhat.com/dwalsh/)
security engineer. Today he [blogged](http://danwalsh.livejournal.com/72697.html) 
about _CVE-2015-4495 and SELinux, or why doesn't SELinux confine Firefox_. He 
should've asked why the _reference policy_ or _Red Hat/Fedora policy_ does not
confine Firefox, because SELinux is, as I've
[mentioned before](http://blog.siphos.be/2015/08/dont-confuse-selinux-with-its-policy/),
not the same as its policy.

In effect, Gentoo's SELinux policy _does_ confine Firefox by default. One of the
principles we focus on in Gentoo Hardened is to
[develop desktop policies](https://wiki.gentoo.org/wiki/Project:SELinux/Development_policy#Develop_desktop_policies)
in order to reduce exposure and information leakage of user documents. We might
not have the manpower to confine all desktop applications, but I do think it is
worthwhile to at least attempt to do this, even though what Dan Walsh mentioned
is also correct: desktops are notoriously difficult to use a mandatory access
control system on.

<!-- PELICAN_END_SUMMARY -->

**How Gentoo wants to support more confined desktop applications**

What Gentoo Hardened tries to do is to support the
[XDG Base Directory Specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-0.8.html)
for several documentation types. Downloads are marked as `xdg_downloads_home_t`,
pictures are marked as `xdg_pictures_home_t`, etc.

With those types defined, we grant the regular user domains full access to
those types, but start removing access to user content from applications. Rules
such as the following are commented out or removed from the policies:

```
# userdom_manage_user_home_content_dirs(mozilla_t)
# userdom_manage_user_home_content_files(mozilla_t)
```

Instead, we add in a call to a template we have defined ourselves:

```
userdom_user_content_access_template(mozilla, { mozilla_t mozilla_plugin_t })
```

This call makes access to user content optional through SELinux booleans. For
instance, for the `mozilla_t` domain (which is used for Firefox), the following
booleans are created:

```
# Read generic (user_home_t) user content
mozilla_read_generic_user_content       ->      true

# Read all user content
mozilla_read_all_user_content           ->      false

# Manage generic (user_home_t) user content
mozilla_manage_generic_user_content     ->      false

# Manage all user content
mozilla_manage_all_user_content         ->      false
```

As you can see, the default setting is that Firefox can read user content, but
only non-specific types. So `ssh_home_t`, which is used for the SSH related
files, is not readable by Firefox with our policy _by default_.

By changing these booleans, the policy is fine-tuned to the requirements of
the administrator. On my systems, `mozilla_read_generic_user_content` is switched
off.

You might ask how we can then still support a browser if it cannot access user
content to upload or download. Well, as mentioned before, we support the XDG
types. The browser is allowed to manage `xdg_download_home_t` files and
directories. For the majority of cases, this is sufficient. I also don't mind
copying over files to the `~/Downloads` directory just for uploading files. But
I am well aware that this is not what the majority of users would want, which
is why the default is as it is.

**There is much more work to be done sadly**

As said earlier, the default policy will allow _reading_ of user files if those
files are not typed specifically. Types that are protected by our policy (but not
by the reference policy standard) includes SSH related files at `~/.ssh` and
GnuPG files at `~/.gnupg`. Even other configuration files, such as for my Mutt
configuration (`~/.muttrc`) which contains a password for an IMAP server I connect
to, are not reachable.

However, it is still far from perfect. One of the reasons is that many desktop
applications are not "converted" yet to our desktop policy approach. Yes, Chromium
is also already converted, and policies we've added such as for Skype also do not
allow direct access unless the user explicitly enabled it. But Evolution for instance
isn't yet.

Converting desktop policies to a more strict setup requires lots of testing, which
translates to many human resources. Within Gentoo, only a few developers and 
contributors are working on policies, and considering that this is not a change
that is already part of the (upstream) reference policy, some contributors also
do not want to put lots of focus on it either. But without having done the works,
it will not be easy (nor probably acceptable) to upstream this (the XDG patch has
been submitted a few times already but wasn't deemed ready yet then).

**Having a more restrictive policy isn't the end**

As the blog post of Dan rightly mentioned, there are still quite some other
ways of accessing information that we might want to protect. An application 
might not have access to user files, but can be able to communicate (for instance
through DBus) with an application that does, and through that instruct it to
pass on the data.

Plugins might require permissions which do not match with the principles set up
earlier. When we tried out Google Talk (needed for proper Google Hangouts support)
we noticed that it requires many, many more privileges. Luckily, we were able to
write down and develop a policy for the Google Talk plugin (`googletalk_plugin_t`)
so it is still properly confined. But this is just a single plugin, and I'm sure
that more plugins exist which will have similar requirements. Which leads to more
policy development.

But having workarounds does not make the effort we do worthless. Being able to
work around a firewall through application data does not make the firewall
useless, it is just one of the many security layers. The same is true with SELinux
policies.

I am glad that we at least try to confine desktop applications more, and
that Gentoo Hardened users who use SELinux are at least somewhat more protected
from the vulnerability (even with the default case) and that our investment for
this is sound.

