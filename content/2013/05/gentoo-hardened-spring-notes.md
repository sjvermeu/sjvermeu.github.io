Title: Gentoo Hardened spring notes
Date: 2013-05-16 22:54
Category: Gentoo
Tags: Gentoo, hardened, irc, meeting, monthly, online
Slug: gentoo-hardened-spring-notes

We got back together on the `#gentoo-hardened` chat channel to discuss
the progress of [Gentoo
Hardened](http://www.gentoo.org/proj/en/hardened), so it's time for
another write-up of what was said.

*Toolchain*

GCC 4.8.1 will be out soon, although nothing major has occurred with it
since the last meeting. There is a plugin header install problem in 4.8
and its not certain that the (trivial) fix is in 4.8.1, but it certainly
is inside Gentoo's release.

Blueness is also (still, and hopefully for a long time ;-) maintaining
the uclibc hardened related toolchain aspects.

*Kernel and grSecurity/PaX*

The further progress on the XATTR\_PAX migration was put on a lower
level the past few weeks due to busy, busy... very busy weeks (but this
was announced and known in advance). We still need to do XATTR copying
in *install* for packages that do pax markings before *src\_install()*
and include the `user.pax` XATTR patch in the gentoo-sources kernel.
This will silence the errors for non-hardened users and fix the loss of
XATTR markings for those packages that do pax-mark before install.

The set then needs to be documented further and tested on vanilla and
hardened systems.

Zorry asked if a separate script can be provided for those ebuilds that
directly call **paxctl**. These ebuilds might want to switch to the
eclass, but if they need to call **paxctl** or similar directly (for
instance because the result is immediately used for further building), a
separate script or tool should be made available. Blueness will look
into this.

On `hardened-sources`, we are now with stable 2.6.32-r160, 3.2.42-r1 and
3.8.6 due to some vulnerabilities in earlier versions (in networking
code). There is still some bug (nfs-related) that is fixed in 3.2.44 so
that part might need a bump as well soon.

*SELinux*

The
[selocal](http://blog.siphos.be/2013/04/introducing-selocal-for-small-selinux-policy-enhancements/)
command is now available for Gentoo SELinux users, allowing them to
easily enhance the policy without having to maintain their own SELinux
policy modules (the script is a wrapper that does all that).

The setools package now also uses the [SLOT'ed
swig](http://blog.siphos.be/2013/04/sloting-the-old-swig-1/), so no more
dependency breakage.

On SELinux userspace and policy, both have seen a new release last
month, and both are already in the Gentoo portage tree.

Finally, the SELinux policy ebuilds now also call
[epatch\_user](http://blog.siphos.be/2013/05/overriding-the-default-selinux-policies/)
so users can customize the policies even further without having to copy
ebuilds to their overlay.

Now that **tar** supports XATTR well, we might want to look into SELinux
stages again. Jmbsvicetto did some work on that, but the builds failed
during stage1. We'll look into that later.

*Integrity*

Nothing much to say, we're waiting a bit until the patches proposed by
the IMA team are merged in the main kernel.

*Profiles*

Two no-multilib fixes have been applied to the
`hardened/amd64/no-multilib` profiles. One was a QA issue and quickly
resolved, the other is due to the profile stacking within Gentoo
profiles, where we missed a profile and thus were missing a few masks
defined in that (missed) profile. But including the profile creates a
lot of duplicates again, so we are going to copy the masks across until
the duplicates are resolved in the other profiles.

Blueness will also clean up the experimental `13.0` directory since all
hardened profiles now follow 13.0.

*Docs*

The latest changes on SELinux have been added to the Gentoo SELinux
handbook. Also, I've been slowly (but surely) adding topics to the
[SELinux tutorials
listing](https://wiki.gentoo.org/wiki/SELinux/Tutorials) on the Gentoo
wiki.

The grSecurity 2 document is very much out of date, blueness hopes to
put some time in fixing that soon.

So that's about it for the short write-up. Zorry will surely post the
log later on the appropriate channels. Good work done (again) by all
team members!
