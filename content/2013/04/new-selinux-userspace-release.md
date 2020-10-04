Title: New SELinux userspace release
Date: 2013-04-26 03:50
Category: Gentoo
Tags: automation, regression, release, selinux, test, testing, userspace
Slug: new-selinux-userspace-release

A new [release](http://userspace.selinuxproject.org/trac/wiki/Releases)
of the SELinux userspace utilities was recently announced. I have made
the packages for Gentoo available and they should now be in the main
tree (\~arch of course). During the testing of the packages however, I
made a stupid mistake of running the tests on the wrong VM, one that
didn't contain the new packages. Result: no regressions (of course). My
fault for not using in-ebuild tests properly, as I
[should](https://bugs.gentoo.org/show_bug.cgi?id=465846). So you'll
probably see me blogging about the in-ebuild testing soon ;-)

In any case, the regressions I did find out (quite fast after I updated
my main laptop with them as well) where a [missing function in
libselinux](https://bugs.gentoo.org/show_bug.cgi?id=467258), a [referral
to a non-existing makefile when using "semanage
permissive"](https://bugs.gentoo.org/show_bug.cgi?id=467264) and the new
**sepolicy** application [requiring yum python
bindings](https://bugs.gentoo.org/show_bug.cgi?id=467268). At least,
with the missing function (hopefully correctly) resolved, all tests I
usually do (except for the permissive domains) are now running well
again.

This only goes to show how important testing is. Of course, I
[reported](http://marc.info/?l=selinux&m=136692033821285&w=2) the bugs
on the mailinglist of the userspace utilities as well. Hopefully they
can look at them while I'm asleep so I can integrate fixes tomorrow more
easily ;-)
