Title: Mounting QEMU images
Date: 2016-09-26 19:26
Category: Free Software
Tags: qemu
Slug: mounting-qemu-images

While working on the second edition of my first book, [SELinux System Administration - Second Edition](https://www.packtpub.com/networking-and-servers/selinux-system-administration-second-edition)
I had to test out a few commands on different Linux distributions to make sure
that I don't create instructions that only work on Gentoo Linux. After all, as
awesome as Gentoo might be, the Linux world is a bit bigger. So I downloaded a
few live systems to run in Qemu/KVM.

Some of these systems however use [cloud-init](https://cloudinit.readthedocs.io/en/latest/)
which, while interesting to use, is not set up on my system yet. And without 
support for cloud-init, how can I get access to the system?

<!-- PELICAN_END_SUMMARY -->

**Mounting qemu images on the system**

To resolve this, I want to mount the image on my system, and edit the `/etc/shadow`
file so that the root account is accessible. Once that is accomplished, I can
log on through the console and start setting up the system further.

Images that are in the qcow2 format can be mounted through the nbd driver, but that
would require some updates on my local SELinux policy that I am too lazy to do right
now (I'll get to them eventually, but first need to finish the book). Still, if you
are interested in using nbd, see [these instructions](https://www.kumari.net/index.php/system-adminstration/49-mounting-a-qemu-image)
or a [related thread](https://forums.gentoo.org/viewtopic-t-822672.html) on the Gentoo
Forums.

Luckily, storage is cheap (even SSD disks), so I quickly converted the qcow2 images
into raw images:

```
~$ qemu-img convert root.qcow2 root.raw
```

With the image now available in raw format, I can use the loop devices to mount
the image(s) on my system:

```
~# losetup /dev/loop0 root.raw
~# kpartx -a /dev/loop0
~# mount /dev/mapper/loop0p1 /mnt
```

The `kpartx` command will detect the partitions and ensure that those are
available: the first partition becomes available at `/dev/loop0p1`, the
second `/dev/loop0p2` and so forth.

With the image now mounted, let's update the `/etc/shadow` file.

**Placing a new password hash in the shadow file**

A google search quickly revealed that the following command generates
a shadow-compatible hash for a password:

```
~$ openssl passwd -1 MyMightyPassword
$1$BHbMVz9i$qYHmULtXIY3dqZkyfW/oO.
```

The challenge wasn't to find the hash though, but to edit it:

```
~# vim /mnt/etc/shadow
vim: Permission denied
```

The image that I downloaded used SELinux (of course), which meant that the `shadow`
file was labeled with `shadow_t` which I am not allowed to access. And I didn't
want to put SELinux in permissive mode just for this (sometimes I /do/ have some
time left, apparently).

So I remounted the image, but now with the `context=` mount option, like so:

```
~# mount -o context="system_u:object_r:var_t:s0: /dev/loop0p1 /mnt
```

Now all files are labeled with `var_t` which I do have permissions to edit. But
I also need to take care that the files that I edited get the proper label again.
There are a number of ways to accomplish this. I chose to create a `.autorelabel`
file in the root of the partition. Red Hat based distributions will pick this up
and force a file system relabeling operation.

**Unmounting the file system**

After making the changes, I can now unmount the file system again:

```
~# umount /mnt
~# kpart -d /dev/loop0
~# losetup -d /dev/loop0
```

With that done, I had root access to the image and could start testing out
my own set of commands.

It did trigger my interest in the cloud-init setup though...

