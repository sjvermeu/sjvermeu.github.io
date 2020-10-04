Title: And now, 31 days later... 
Date: 2013-08-01 22:43
Category: Gentoo
Tags: Gentoo, grsecurity, hardened, irc, irl, meeting, minutes, pax, project, selinux, toolchain
Slug: and-now-31-days-later

... the [Gentoo Hardened](http://www.gentoo.org/proj/en/hardened) team
had its monthly online meeting again ;-)

On the agenda were the usual suspects, such as the *toolchain*. In this
category, Zorry mentioned that he has a fix for GCC 4.8.1 for the
`hardenedno*` and vanilla `gcc-config` options which will be added to
the tree after some more testing. The problem is that with GCC 4.8,
certain settings need to be set sooner than before (in the code path),
which is what the fix focuses on. The ASAN issue is still unresolved,
but otherwise GCC 4.8 is working fine.

On *SELinux*, the policycoreutils package has been bumped to include
support for `mcstrans`, a translation daemon that visualizes humanly
readable strings instead of the standard sensitivity/category sets in
case of MCS/MLS policies.

Regarding documentation, the wiki team (most notably a3li) is working
hard to support project pages on the [Gentoo
Wiki](https://wiki.gentoo.org). Once we can, we will be moving our
project page with all related documentation to the wiki, allowing for
easier documentation development and a more modern look. To support
this, an XML-to-wiki stylesheet is available that translates ProjectXML
and GuideXML to the wiki language.

During the meeting, we also mentioned the stabilization policy (or at
least, no-longer-stabilization) of the vanilla sources (plain kernel.org
Linux kernel sources). This doesn't immediately effect the hardened
project, but is important to know nonetheless, especially for users of
hardened technologies that are in the main kernel already (like SELinux
or IMA/EVM) as they have to be aware to either use the latest
(regardless of the keywords in use) or switch to gentoo-sources or
(preferably) hardened-sources.

For uclibc support, the stages will be provided every 2 months rather
than every month as this is a resource-intensive process that isn't
fully automated yet (except for amd64 and x86 which are automated).

Finally, on PaX and grSecurity support, the XATTR patch for tmpfs is now
in the kernel, and the problem about loosing PaX markings during
installation is fixed as Portage (2.1.12.9 and higher) now preserves the
flags during installation (a wrapper on `install` is used that preserves
`usr.pax.flags`).
