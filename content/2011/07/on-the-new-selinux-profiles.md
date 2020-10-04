Title: On the new SELinux profiles
Date: 2011-07-14 19:31
Category: Gentoo
Slug: on-the-new-selinux-profiles

Ever since Anthony put in the [new SELinux
profiles](https://bugs.gentoo.org/show_bug.cgi?id=365483) - which was
long due - they have seen quite a few tests and the necessary,
evolutionary updates. No changes that broke things, no oddities that
would give a WTF to whomever is using it. The latest updates were to
remove some obsolete masks so that our visibility in the [Gentoo QA
Reports](http://qa-reports.gentoo.org/) is down again.

However, we are well aware that these profiles are still in the
dev(elopment) phase but would like to stabilize these soon. For this to
happen, we need SELinux users to give the new profiles a go. Become
`sysadm_r` & root and switch your profile to whichever SELinux profile
suits you the most (with the new profiles, we support SELinux on
multilib and no-multilib and across various settings).

All my local servers run with "hardened/linux/amd64/no-multilib/selinux"
whereas my main workstation uses "hardened/linux/amd64/selinux" (since I
still have some need for the multilib setup). We did some tests on
non-hardened profiles too as well as on the x86 architecture with no
problems whatsoever. So although we can't guarantee anything, I'm pretty
convinced that the profiles will work for you too!

So by all means, see if you can switch from the v2refpolicy/ profiles
and give us your feedback. You're always welcome for a chat on
`#gentoo-hardened` (irc.freenode.net) or on our mailinglists.
