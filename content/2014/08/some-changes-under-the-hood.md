Title: Some changes under the hood
Date: 2014-08-09 21:45
Category: Gentoo
Tags: eclass, Gentoo, git, hardened, refpolicy, selinux
Slug: some-changes-under-the-hood

In between conferences, technical writing jobs and traveling, we did a
few changes under the hood for SELinux in Gentoo.

First of all, new policies are bumped and also stabilized (2.20130411-r3
is now stable, 2.20130411-r5 is \~arch). These have a few updates
(mergers from upstream), and r5 also has preliminary support for
[tmpfiles](http://www.freedesktop.org/software/systemd/man/tmpfiles.d.html)
(at least the OpenRC implementation of it), which is made part of the
[selinux-base-policy](http://packages.gentoo.org/package/sec-policy/selinux-base-policy)
package.

The ebuilds to support new policy releases now are relatively simple
copies of the live ebuilds (which always contain the latest policies) so
that bumping (either by me or other developers) is easy enough. There's
also a release script in our policy repository which tags the right git
commit (the point at which the release is made), creates the necessary
patches, uploads them, etc.

One of the changes made is to "drop" the `BASEPOL` variable. In the
past, `BASEPOL` was a variable inside the ebuilds that pointed to the
right patchset (and base policy) as we initially supported policy
modules of different base releases. However, that was a mistake and we
quickly moved to bumping all policies with every releaes, but kept the
`BASEPOL` variable in it. Now, `BASEPOL` is "just" the `${PVR}` value of
the ebuild so no longer needs to be provided. In the future, I'll
probably remove `BASEPOL` from the internal eclass and the
`selinux-base*` packages as well.

A more important change to the eclass is support for the
`SELINUX_GIT_REPO` and `SELINUX_GIT_BRANCH` variables (for live ebuilds,
i.e. those with the 9999 version). If set, then they pull from the
mentioned repository (and branch) instead of the default
[hardened-refpolicy.git](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-refpolicy.git;a=summary)
repository. This allows for developers to do some testing on a different
branch easily, or for other users to use their own policy repository
while still enjoying the SELinux integration support in Gentoo through
the `sec-policy/*` packages.

Finally, I wrote up a first attempt at our [coding
style](https://wiki.gentoo.org/wiki/Project:SELinux/CodingStyle),
heavily based on the coding style from the reference policy of course
(as our policy is still following this upstream project). This should
allow the team to work better together and to decide on namings
autonomously (instead of hours of discussing and settling for something
as silly as an interface or boolean name ;-)
