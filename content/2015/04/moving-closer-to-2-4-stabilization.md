Title: Moving closer to 2.4 stabilization
Date: 2015-04-27 19:18
Category: Gentoo
Tags: 2.4, Gentoo, hardened, selinux, userspace
Slug: moving-closer-to-2-4-stabilization

The [SELinux userspace](https://github.com/SELinuxProject/selinux/wiki)
project has released version 2.4 in february this year, after release
candidates have been tested for half a year. After its release, we at
the [Gentoo Hardened](https://wiki.gentoo.org/wiki/Project:Hardened)
project have been working hard to integrate it within Gentoo. This
effort has been made a bit more difficult due to the migration of the
policy store from one location to another while at the same time
switching to HLL- and CIL based builds.

Lately, 2.4 itself has been pretty stable, and we're focusing on the
proper migration from 2.3 to 2.4. The SELinux policy has been adjusted
to allow the migrations to work, and a few final fixes are being tested
so that we can safely transition our stable users from 2.3 to 2.4.
Hopefully we'll be able to stabilize the userspace this month or
beginning of next month.
