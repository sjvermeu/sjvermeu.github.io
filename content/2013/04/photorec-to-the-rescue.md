Title: photorec to the rescue
Date: 2013-04-29 03:50
Category: Free Software
Tags: corruption, photorec, recovery, shred
Slug: photorec-to-the-rescue

Once again
[PhotoRec](http://www.cgsecurity.org/wiki/PhotoRec_Step_By_Step) has
been able to save files from a corrupt FAT USB drive. The application
scans the partition, looking for known files (based on the file magic)
and then restores those files. The files are not named as they were
though, so there is still some manual work left, but the recovery works
pretty well:

    PhotoRec 6.12, Data Recovery Utility, May 2011
    Christophe GRENIER 
    http://www.cgsecurity.org

    Disk /dev/sdc1 - 1000 GB / 931 GiB (RO) - WD My Book
         Partition                  Start        End    Size in sectors
         No partition             0   0  1 121600 253 63 1953520002 [Whole disk]


    Pass 1 - Reading sector  464342462/1953520002, 10738 files found
    Elapsed time 2h46m01s - Estimated time to completion 8h52m25
    jpg: 7429 recovered
    txt: 961 recovered
    mp3: 558 recovered
    tx?: 373 recovered
    riff: 297 recovered
    gif: 218 recovered
    exe: 151 recovered
    ifo: 126 recovered
    mpg: 91 recovered
    pdf: 83 recovered
    others: 451 recovered

In Gentoo, you can find the package as part of `app-admin/testdisk`. To
recover the files, I ran the following command:

    $ photorec /log /d /path/to/recovery/dest /dev/sdc1

While skimming through the recovered files, I found a few ones that I
deleted a long time ago but apparently never got overwritten (the data,
that is). Scary to see how easy such recovery is... Makes me remember
that, if you really want to delete files in a less recoverable manner,
you can use **shred** for that.

And for those out there yelling to backup this data - you're absolutely
correct, but no. I backup my systems and important files daily, but this
disk contained (mainly) raw picture images and videorecordings. The
manipulated, finished images and recordings are backed up (or at least
on a disk *and* somewhere online), but the raw images and recordings are
often too much to introduce a backup for, and if I would really lost
them, I wouldn't shed a tear (nor panic).
