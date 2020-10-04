Title: November online hardened meeting
Date: 2013-12-11 12:12
Category: Gentoo
Tags: Gentoo, hardened, irc, meeting, online
Slug: november-online-hardened-meeting

Later than usual, as I wasn't able to make the meeting myself (thus had
to wait for the meeting logs in order to draft up this summary), so here
it is. The next meeting is scheduled for next week, btw ;-)

*Toolchain*

The 4.8.2 ebuild for GCC is available in the tree, currently still
masked.

*Kernel and grSecurity*

The grSecurity project has made the patches for the 3.12 kernel
available; a hardened 3.12 kernel is available in the
`hardened-development` overlay.

*SELinux*

Matthew is working on [ZFSonLinux and
SELinux](https://github.com/zfsonlinux/zfs/pull/1835) support.

*Profiles*

Matthew and Steev have been working on SELinux and ARM support. It seems
to work, but kernel versions matter greatly. We might want to open up
ARM keywords.

That's about it. As blueness wasn't there as well, the topics were
discussed quite fast. The full logs can be found [on the gentoo-hardened
mailinglist](http://thread.gmane.org/gmane.linux.gentoo.hardened/6117).
