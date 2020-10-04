Title: Chroots for SELinux enabled applications
Date: 2014-06-22 20:16
Category: SELinux
Tags: bind-mount, bindmount, mount, read-only, ro, selinux
Slug: chroots-for-selinux-enabled-applications

Today I had to prepare a chroot jail (thank you grsecurity for the neat
additional chroot protection features) for a SELinux-enabled
application. As a result, "just" making a chroot was insufficient: the
application needed access to `/sys/fs/selinux`. Of course, granting
access to `/sys` is not something I like to see for a chroot jail.

Luckily, all other accesses are not needed, so I was able to create a
static `/sys/fs/selinux` directory structure in the chroot, and then
just mount the SELinux file system on that:

    ~# mount -t selinuxfs none /var/chroot/sys/fs/selinux

In hindsight, I probably could just have created a `/selinux` location
as that location, although deprecated, is still checked by the SELinux
libraries.

Anyway, there was a second requirement: access to `/etc/selinux`.
Luckily it was purely for read operations, so I was first contemplating
of copying the data and doing a **chmod -R a-w
/var/chroot/etc/selinux**, but then considered a bind-mount:

    ~# mount -o bind,ro /etc/selinux /var/chroot/etc/selinux

Alas, bad luck - the read-only flag is ignored during the mount, and the
bind-mount is still read-write. A [simple article on
lwn.net](http://lwn.net/Articles/281157/) informed me about the
solution: I need to do a remount afterwards to enable the read-only
state:

    ~# mount -o remount,ro /var/chroot/etc/selinux

Great! And because my brain isn't what it used to be, I just make a
quick blog for future reference ;-)
