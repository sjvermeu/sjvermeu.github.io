Title: Why you need the real_* thing with genkernel
Date: 2012-11-25 21:05
Category: Gentoo
Slug: why-you-need-the-real_-thing-with-genkernel

Today it bit me. I rebooted my workstation, and all hell broke loose.
Well, actually, it froze. Literally, if you consider my root file
system. When the system tried to remount the root file system
read-write, it gave me this:

    mount: / not mounted or bad option

So I did the first thing that always helps me, and that is to disable
the initramfs booting and boot straight from the kernel. Now for those
wondering why I boot with an initramfs while it still works directly
with a kernel: it's a safety measure. Ever since there are talks,
rumours, fear, uncertainty and doubt about supporting a separate /usr
file system I started supporting an initramfs on my system in case an
update really breaks the regular boot cycle. Same because I use lvm on
most file systems, and software RAID on all of them. If I wouldn't have
an initramfs laying around, I would be screwed the moment userspace
decides not to support this straight from a kernel boot. Luckily, this
isn't the case (yet) so I could continue working without an initramfs.
But I digress. Back to the situation.

Booting without initramfs worked without errors of any kind. Next thing
is to investigate why it fails. I reboot back with the initramfs, get my
read-only root file system and start looking around. In my **dmesg**
output, I notice the following:

    EXT4-fs (md3): Cannot change data mode on remount

So that's weird, not? What is this data mode? Well, the [data
mode](https://www.kernel.org/doc/Documentation/filesystems/ext4.txt)
tells the file system (ext4 for me) how to handle writing data to disk.
As you are all aware, ext4 is a journaled file system, meaning it writes
changes into a journal before applying, allowing changes to be replayed
when the system suddenly crashes. By default, ext4 uses ordered mode,
writing the metadata (information about files and such, like inode
information, timestamps, block maps, extended attributes, ... but not
the data itself) to the journal right after writing data to the disk,
after which the metadata is then written to disk as well.

On my system though, I use `data=journal` so data too is written to the
journal first. This gives a higher degree of protection in case of a
system crash (or immediate powerdown - my laptop doesn't recognize
batteries anymore and with a daughter playing around, I've had my share
of sudden powerdowns). I do boot with the `rootflags=data=journal` and I
have `data=journal` in my fstab.

But the above error tells me otherwise. It tells me that the mode is not
what I want it to be. So after fiddling a bit with the options and (of
course) using Google to find more information, I found out that my
initramfs doesn't check the <e>rootflags</e> parameter, so it mounts the
root file system with the standard (ordered) mode. Trying to remount it
later will fail, as my fstab contains the `data=journal` tag, and
running **mount -o remount,rw,data=ordered** for fun doesn't give many
smiles.

The man page for **genkernel** however showed me that it uses
`real_rootflags`. So I reboot with that parameter set to
`real_rootflags=data=journal` and all is okay again.

*Edit:* I wrote that even changing the default mount options in the file
system itself (using **tune2fs /dev/md3 -o journal\_data**) didn't help.
However, that seems to be an error on my part, I didn't reboot after
toggling this, which is apparently required. Thanks to Xake for pointing
that out.
