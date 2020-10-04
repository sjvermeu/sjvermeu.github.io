Title: SELinux Gentoo profile updates
Date: 2011-05-03 23:17
Category: Gentoo
Slug: selinux-gentoo-profile-updates

The SELinux support within Gentoo Hardened is continuing to go forward.
Anthony G. Basile has been working on the new SELinux Gentoo profiles
which were in dire need of updates. With the rework, we'll also support
the AMD64 no-multilib environment properly. With the new profiles we'll
also make *USE="open\_perms"* enabled by default. This will enable the
"open" permission within the SELinux policies. And of course we'll
remove that *FEATURES="loadpolicy"*.

Not in git yet, but close, are further updates on the policy ebuilds.
Revision 14 of our `selinux-base-policy` package will fail when the base
policy couldn't be loaded properly. This will ensure that a successful
installation means that the policies are loaded successfully as well. If
we wouldn't do this, then users might assume that the policies are
constantly being updated while in reality their system has always been
working with older policies. I am also going to, based on the [QA
reports](http://qa-reports.gentoo.org), update the `sec-policy/*`
packages so they are not mentioned in those reports anymore.

In other related news, the [Gentoo Hardened SELinux
FAQ](http://goo.gl/uaaf4) will get updates on UBAC, cron issues and a
few errors (cosmetic or not) that you might have when working with
Gentoo Hardened SELinux. I'm also constantly updating the [Gentoo
Hardened SELinux Handbook (PDF)](http://goo.gl/DlHJD) with the latest
information and developments.
