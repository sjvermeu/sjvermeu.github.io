Title: Keeping /selinux
Date: 2012-05-04 22:26
Category: Gentoo
Slug: keeping-selinux

Just a very quick paragraph on a just-reported issue: if you upgrade
your SELinux utilities to the latest version *and* you switch from
`/selinux` to `/sys/fs/selinux` as the mountpoint for the SELinux file
system, you might get into issues. Apparently, **init** (which is
responsible for mounting the SELinux file system through a call to
libselinux) is trying to mount it on - well yes - `/sys/fs/selinux` but
at that time, `/sys` is not mounted yet.

I haven't been able to reproduce just yet, because I just recently had
to move all my systems to use an initramfs (thank you
you-need-an-initramfs-when-you-have-a-separate-usr-partition) which
premounts /sys. But the current workaround should be to keep `/selinux`
for now. The utilities support it still, and that gives me some time to
look and investigate the issue.
