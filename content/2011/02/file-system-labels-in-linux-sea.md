Title: File System Labels in Linux Sea
Date: 2011-02-12 20:42
Category: Documentation
Slug: file-system-labels-in-linux-sea

I have added some information on file system labels in [Linux
Sea](http://swift.siphos.be/linux_sea)
([PDF](http://swift.siphos.be/linux_sea/linux_sea.pdf)). If you don't
know what labels are (or UUIDs), here is a quick summary.

Most, if not all file systems, assign a universally unique identifier
(UUID) which looks like a random hexadecimal string to each file system.
On a Gentoo system, you can get an overview of all UUIDs detected using
a simple **ls -l /dev/disk/by-uuid**, courtesy of the gentoo udev rules.
Users can also assign a specific label to a file system, either when
they create it (like **mkfs.ext4 -L ROOT /dev/sda2**) or afterwards
(**e2label /dev/sda2 ROOT**). This is also not limited to the content
file systems - you can also assign a label to a swap file system.

This information can then be used to uniquely identify the file system,
even if you don't know what the device file (/dev/sda2) is called. A
huge advantage is for those devices that often change device file
(removable media, but also SATA or SCSI disks on systems where the admin
loves adding and removing disks ;-) as you can keep your fstab
configuration static: the fstab file doesn't need to be changed, even
when the device files themselves change.

A simple fstab line (`/dev/sda2  /  ext4  defaults,noatime  0 0`) can
then easily be transformed to use the LABEL="..." syntax (like
`LABEL=ROOT /  ext4  defaults,noatime  0 0`).

Some people might also think they can use this mechanism for their
kernel boot parameter (like using `root=LABEL=ROOT` instead of
`root=/dev/sda2`). Sadly, the Linux kernel doesn't offer this
functionality. It is possible, but only when you use an initramfs (which
I don't).
