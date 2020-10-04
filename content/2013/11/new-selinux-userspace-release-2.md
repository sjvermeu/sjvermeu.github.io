Title: New SELinux userspace release
Date: 2013-11-05 00:06
Category: Gentoo
Slug: new-selinux-userspace-release-2

Between now and an hour, Gentoo users using the \~arch branch will
notice that new versions of the [SELinux userspace
applications](http://userspace.selinuxproject.org/trac/wiki/Releases)
are now available. Released on October 30th, they contain many bug fixes
sent previously as well as a couple of interesting developments and
enhancements (more work on sepolicy, for instance).

My tests revealed only a single issue that I still need to solve
(another issue, [bug
490436](https://bugs.gentoo.org/show_bug.cgi?id=490436), is hopefully
properly worked around), which is [bug
490442](https://bugs.gentoo.org/show_bug.cgi?id=490442), where
audit2allow does not want to generate refpolicy-style SELinux policy
modules. Other than that, most infrastructural tests were successful.

Two SELinux policy updates were needed:

    manage_lnk_files_pattern(semanage_t, semanage_store_t, semanage_store_t)
    selinux_read_policy(sysadm_t)

The first one is sent upstream as I think it is an obvious one (new
userspace now using symbolic links). The other one I'm not that sure of,
but for now it works. I made the above policy changes locally; if
approved I'll commit them to our tree asap.

So, go play with it and report whatever you can on
[bugzilla](https://bugs.gentoo.org) (SELinux component).
