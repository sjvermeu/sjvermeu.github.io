Title: Live SELinux userspace ebuilds
Date: 2015-06-10 20:07
Category: Gentoo
Tags: cil, Gentoo, selinux, userspace
Slug: live-selinux-userspace-ebuilds

In between courses, I pushed out live ebuilds for the SELinux userspace
applications: libselinux, policycoreutils, libsemanage, libsepol,
sepolgen, checkpolicy and secilc. These live ebuilds (with Gentoo
version 9999) pull in the current development code of the [SELinux
userspace](https://github.com/SELinuxProject/selinux) so that developers
and contributors can already work with in-progress code developments as
well as see how they work on a Gentoo platform.

<!-- PELICAN_END_SUMMARY -->

That being said, I do not recommend using the live ebuilds for anyone
else except developers and contributors in development zones (definitely
not on production). One of the reasons is that the ebuilds do not apply
Gentoo-specific patches to the ebuilds. I would also like to remove the
Gentoo-specific manipulations that we do, such as small Makefile
adjustments, but let's start with just ignoring the Gentoo patches.

Dropping the patches makes sure that we track upstream libraries and
userspace closely, and allows developers to try and send out patches to
the SELinux project to fix Gentoo related build problems. But as not all
packages can be deployed successfully on a Gentoo system some patches
need to be applied anyway. For this, users can drop the necessary
patches inside `/etc/portage/patches` as all userspace ebuilds use the
*epatch\_user* method.

Finally, observant users will notice that "secilc" is also provided.
This is a new package, which is probably going to have an official
release with a new userspace release. It allows for building CIL-based
SELinux policy code, and was one of the drivers for me to create the
live ebuilds as I'm experimenting with the CIL constructions. So expect
more on that later.
