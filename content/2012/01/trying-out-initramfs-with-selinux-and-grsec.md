Title: Trying out initramfs with selinux and grsec
Date: 2012-01-15 12:58
Category: SELinux
Slug: trying-out-initramfs-with-selinux-and-grsec

I'm no fan of initramfs. All my systems boot up just fine without it, so
I often see it as an additional layer of obfuscation. But there are
definitely cases where initramfs is needed, and from the [looks of
it](http://thread.gmane.org/gmane.linux.gentoo.devel/74464), we might be
needing to push out some documentation and support for initramfs. Since
my primary focus is to look at a hardened system, I started playing with
initramfs together with Gentoo Hardened, grSecurity and SELinux. And
what a challenge it was...

But first, a quick introduction to initramfs. The Linux kernel supports
*initrd* images for quite some time. These images are best seen as
loopback-mountable images containing a whole file system that the Linux
kernel boots as the root device. On this initrd image, a set of tools
and scripts then prepare the system and finally switch towards the real
root device. The initrd feature was often used when the root device is a
network-mounted location or on a file system that requires additional
activities (like an encrypted file system or even on LVM. But it also
had some difficulties with it.

Using a loopback-mountable image means that this is seen as a full
device (with file system on it), so the Linux kernel also tries caching
the files on it, which leads to some unwanted memory consumption. It is
a static environment, so it is hard to grow or shrink it. Every time an
administrator creates an initrd, he needs to carefully design
(capacity-wise) the environment not to request too much or too little
memory.

Enter *initramfs*. The concept is similar: an environment that the Linux
kernel boots as a root device which is used to prepare for booting
further from the real root file systems. But it uses a different
approach. First of all, it is no longer a loopback-mountable image, but
a cpio archive that is used on a tmpfs file system. Unlike initrd, tmpfs
can grow or shrink as necessary, so the administrator doesn't need to
plan the capacity of the image. And because it is a tmpfs file system,
the Linux kernel doesn't try to cache the files in memory (as it knows
they already are in memory).

There are undoubtedly more advantages to initramfs, but let's stick to
the primary objective of this post: talk about its implementation on a
hardened system.

I started playing with **dracut**, a tool to create initramfs archives
which is seen as a widely popular implementation (and suggested on the
gentoo development mailinglist). It uses a simple, modular approach to
building initramfs archives. It has a base, which includes a small
`init` script and some device handling (based on `udev`), and modules
that you can add depending on your situation (such as adding support for
RAID devices, LVM, NFS mounted file systems etc.)

On a SELinux system (using a strict policy, enforcing mode) running
dracut in the `sysadm_t` domain doesn't work, so I had to create a
`dracut_t` domain (which has been pushed to the Portage tree yesterday).
But other than that, it is for me sufficient to call dracut to create an
initramfs:

    # dracut -f "" 3.1.6-hardened

My grub then has an additional set of lines like so:

    title Gentoo Linux Hardened (initramfs)
    root (hd0,0)
    kernel /boot/vmlinuz-3.1.6-hardened root=/dev/vda1 console=ttyS0 console=tty0
    initrd /boot/initramfs-3.1.6-hardened.img

Sadly, the bugger didn't boot. The first problem I hit was that the
Linux kernel I boot has chroot restrictions in it (grSecurity). These
restrictions further tighten chroot environments so that it is much more
difficult to "escape" a chroot. But **dracut**, and probably all others,
use **chroot** to further prepare the bootup and eventually switch to
the chrooted environment to boot up further. Having the chroot
restrictions enabled effectively means that I cannot use initramfs
environments. To work around, I enabled *sysctl* support for all the
chroot restrictions and made sure that their default behavior is to be
disabled. Then, when the system boots up, it enables the restrictions
later in the boot process (through the `sysctl.conf` settings) and then
locks these settings (thanks to grSecurity's `grsec_lock` feature) so
that they cannot be disabled anymore later.

But no, I did get further, up to the point that either the openrc init
is called (which tries to load in the SELinux policy and then breaks) or
that the initramfs tries to load the SELinux policy - and then breaks.
The problem here is that there is too much happening before the SELinux
policy is loaded. Files are created (such as device files) or
manipulated, chroots are prepared, udev is (temporarily) ran, mounts are
created, ... all before a SELinux policy is loaded. As a result, the
files on the system have incorrect contexts and the moment the SELinux
policy is loaded, the processes get denied all access and other
privileges they want against these (wrongly) labeled files. And since
after loading the SELinux policy, the process runs in `kernel_t` domain,
it doesn't have the privileges to relabel the entire system, let alone
call commands.

This is currently where I'm stuck. I can get the thing boot up, if you
temporarily work in permissive mode. When the openrc init is eventually
called, things proceed as usual and the moment udev is started (again,
now from the openrc init) it is possible to switch to enforcing mode.
All processes are running by then in the correct domain and there do not
seem to be any files left with wrong contexts (since the initramfs is
not reachable anymore and the device files in `/dev` are now set again
by udev which is SELinux aware.

But if you want to boot up in enforcing straight away, there are still
things to investigate. I think I'll need to put the policy in the
initramfs as well (which has the huge downside that every update on the
policy requires a rebuild of the initramfs as well). In that case I can
load the policy early up the chain and have the initramfs work further
running in an enforced situation. Or I completely regard the initramfs
as an "always trusted" environment and wait for openrc's init to load
the SELinux policy. In that case, I need to find a way to relabel the
(temporarily created) `/dev` entries (like console, kmsg, ...) before
the policy is loaded.

Definitely to be continued...
