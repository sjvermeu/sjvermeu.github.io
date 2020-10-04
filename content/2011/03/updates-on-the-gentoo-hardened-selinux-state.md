Title: Updates on the Gentoo Hardened SELinux state
Date: 2011-03-02 23:09
Category: Gentoo
Slug: updates-on-the-gentoo-hardened-selinux-state

For those following the progress of SELinux support in Gentoo
Hardened...

In the *hardened-development* overlay, the `selinux-base-policy` package
has been updated, hopefully fixing a nasty issue with support for the
targeted policy (up to today, I only tested strict policies so I missed
that). It also fixes an issue with dhcpcd not functioning properly. If
you use SELinux and don't have the *hardened-development* overlay yet,
please use **layman -a hardened-development**, synchronize (**layman
-S**) and update your system to get the latest base policy. Also, please
report bugs on [Gentoo Bugzilla](https://bugs.gentoo.org) (and perhaps
immediately add *selinux@gentoo.org* to the Cc-list.

The [Gentoo Hardened SELinux Handbook](http://goo.gl/DlHJD), still in
draft, has gotten a few updates. It now documents the use of the
**gentoo\_try\_dontaudit** boolean which the Gentoo Hardened SELinux
developers use to hide potential cosmetic denials. If they are truly
cosmetic, they will be reported upstream later to be included in the
reference policy. If they are not, then users can simple toggle the
boolean (**setsebool gentoo\_try\_dontaudit off**) to see the denials
that the developers hid.

The [Gentoo Hardened SELinux Policy](http://goo.gl/2U0Zr) now includes
the naming convention on the SELinux policy packages with a very short
explanation why this particular convention was chosen. The discussion on
it can be found on the
[gentoo-hardened](http://news.gmane.org/gmane.linux.gentoo.hardened)
mailing list and the last [online
meeting](http://article.gmane.org/gmane.linux.gentoo.hardened/4765).
