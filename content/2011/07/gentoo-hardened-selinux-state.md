Title: Gentoo Hardened SELinux state
Date: 2011-07-09 16:39
Category: Gentoo
Slug: gentoo-hardened-selinux-state

Since last post, we've been working on the further stabilization and bug
fixing of the SELinux policies within Gentoo Hardened. You might have
noticed that we started working on the QA of the packages, like I
promised in the last post. The binaries within `selinux-base-policy` are
now published somewhere on blueness' [developer
page](http://dev.gentoo.org/~blueness/patchbundle-selinux-base-policy/)
since he's proxy'ing all my commits until recruiters get the chance to
pick up my [recruitment
bug](https://bugs.gentoo.org/show_bug.cgi?id=176886). Other patches that
are coming up will be published likewise as well if they get too big to
be within the main Portage tree.

Next to the binaries, I'm currently checking if the SELinux policy
packages can become [EAPI-4
compliant](http://devmanual.gentoo.org/ebuild-writing/eapi/index.html)
(they're currently still using EAPI-0). Same for the SELinux-specific
packages, like policycoreutils, libsemanage, libselinux etc.

During the last few days, I've tried to take a few stabs at supporting
Python 2 and Python 3 simultaneously. It seems to work for
policycoreutils and libsemanage (necessary fixes are in the
[gentoo-hardened
overlay](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-dev.git))
but any attempt to fix libselinux seems to give me hard walls. So for
now, we're still stuck with Python 2 support when using Portage (note
that you can still use Python 3 for all other things, but Portage
requires Python 2 as it calls libselinux). This is currently still
accomplished through a proper `use.mask` and `use.force` setting against
Portage.

Of course, the policies themselves are not silent either. I've updated
the `selinux-base-policy` package so that Portage can now support
NFS-mounted Portage trees and made quite a few openrc-related fixes as
well (against the policy, not against openrc ;-)

I promised to take a stab at MCS in the near future, and that's still
the plan. Hopefully in the coming few weeks ;-)
