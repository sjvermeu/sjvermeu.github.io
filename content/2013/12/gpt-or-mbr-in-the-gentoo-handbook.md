Title: GPT or MBR in the Gentoo Handbook
Date: 2013-12-18 12:25
Category: Gentoo
Tags: documentation, fdisk, gdp, Gentoo, gpt, handbook, mbr, parted
Slug: gpt-or-mbr-in-the-gentoo-handbook

I just committed a set of changes against the Gentoo Handbook (x86 and
amd64) with the intent to have better instructions on GPT (GUID
Partition Table) layout versus MBR (Master Boot Record) or MSDOS-style
layout.

The part on "Preparing the Disks" saw the most changes. It starts with
explaining the differences between the two layouts with advantages and
disadvantages. It then helps the user decide what layout is best for him
(or her).

Second, the *example* (and let me stress that one out again, because
many people have reported bugs on it: it is an *example*) partition
layout now includes a BIOS boot partition in the beginning, 2 MB in
size. This is to support GRUB2 on GPT, but doesn't hurt for GRUB2 with
the MSDOS-style layout either. That means that the partition numbers now
move up one (the *example* /boot is now at sda2, the swap at sda3 and
root on sda4).

The partitioning instructions now also include the proper alignment
instructions (using MB alignment), and use parted as the default
partitioning method.

The changes are submitted to CVS so will show up on the Gentoo site in
an hour or so (documentation on the sites is synchronized hourly if I'm
not mistaken). Please do give it a good read and report bugs on
[bugs.gentoo.org](https://bugs.gentoo.org). You might also want to ping
me on IRC if it is urgent, although no guarantees that I'm behind my
computer at any point.
