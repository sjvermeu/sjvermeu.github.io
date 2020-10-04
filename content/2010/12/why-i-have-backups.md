Title: Why I have backups
Date: 2010-12-30 20:06
Category: Gentoo
Slug: why-i-have-backups

You often read stories about people who have data loss and did not keep
any (recent) backups, and are now fully equipped with a state-of-the-art
backup mechanism. So no - no such failure story here but an example why
backups are important.

Yesterday I had a vicious RAID/LVM failure. Due to my expeditions in the
world of SELinux, for some odd reason when I booted with SELinux
enforcing on, my RAID-1 where an LVM volume group (with `/usr`, `/var`,
`/opt` and `/home`) was hosted (coincidentally the only RAID-1 with 1.2
metadata version, the others are at 0.90) suddenly decided to split
itself into two (!) degraded RAID-1 systems: `/dev/md126` and
`/dev/md127`. During detection, LVM found two devices (the two RAID
metadevices) but with the same meta data on it (same physical volume
signature), so randomly picked one as its physical volume.

` Found duplicate PV Lgrl5nNfenRUg9bIwM20q1hfMrWylyyL: using /dev/md126 not /dev/md127`

Result: after a few reboots (no, I didn't notice it at first - why would
I, everything seemed to work well so I didn't look at the dmesg output)
I started noticing that changes I made were suddenly gone (for instance,
ebuild updates that I made) which almost immediately triggers for me a
"*remount read-only, check logs and take emergency backup*"-adrenaline
surge. And then I noticed that there were I/O errors in my logs,
together with the previously mentioned error message. So I quickly made
an emergency backup of my most critical file system locations (`/home`
as well as `/etc` and some files in `var`) and then tried to fix the
problem (without having to reinstall everything).

The first thing I did - and that might have been the trigger for real
pandemonium - was to try and found out which RAID (md126 or md127) is
being used. The **vgdisplay** and other commands showed me that only
`md127` was used at that time. Also, `/proc/mdstats` showed that `md126`
was in a *auto read-only* state, meaning it wasn't touched since my
system booted. So I decided to drop `md126` and add its underlying
partitions to the `md127` RAID device. Once added, I would expect that
the degraded array would start syncing, but no: the moment the partition
was added, the RAID was shown to be fully operational.

So I rebooted my system, only to find out it couldn't mount `md127`.
File system checks, duplicate inodes, deleted blocks, the whole shebang.
Even running multiple **fsck -y** commands didn't help. The volume group
was totally corrupted and my system almost totally gone. At that time,
it was around 1am and knowing I wouldn't be able to sleep before my
system is back operational - and knowing that I cannot sleep long as my
daughter will wake up at her usual hour - I decided to remove the array,
recreate it and pull back my original backup (not the one I just took as
it might already have corrupted files). As I take daily backups (they
are made at 6 o'clock or during first boot, whatever comes first) I
quickly had most of my `/home` recovered (the backup doesn't take
caches, git/svn/cvs snapshots etc. into account). A quick delta check
between the newly restored `/home` and the backup I took yielded a few
files which I have changed since, so those were recovered as well. But
it also showed lost changes, lost files and just corrupted files so I'm
glad I have my original backups.

I don't take backups of my `/usr` as it is only a system-rebuild away.
As `/etc` wasn't corrupted, I recovered my `/var`, threw in a Gentoo
stage snapshot (but not the full tarball as that would overwrite clean
files) and ran a **emerge -pe world --keep-going**.

When I woke up, my system was almost fully recovered with only a few
failed installs - which were identified and fixed in the next hour.

Knowing that my backup system is rudimentary (an **rsync** command which
uses hardlinks for incremental updates towards a second system plus a
secure file upload to a remote system for really important files) I was
quite happy to have only lost a few changes which I neglected to
commit/push. So, what did I learn?

-   Keep taking backups (and perhaps start using binpkg for fast
    recovery),
-   Use 0.90 raid metadata version,
-   Commit often, and
-   Install a log checking tool that warns me the moment something weird
    might be occurring

