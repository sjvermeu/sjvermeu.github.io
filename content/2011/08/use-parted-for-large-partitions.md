Title: Use parted for large partitions
Date: 2011-08-24 23:46
Category: Gentoo
Slug: use-parted-for-large-partitions

A few bugs that were sitting in Gentoo's bugzilla for the documentation
were related to large partitions (2 TB and higher). Previously, this
wasn't as much as an issue since the number of users that have 2+ TB
partitions are fairly slim. But of course time flies, hardware becomes
cheaper and I have large partitions myself now too. So we had to update
the docs.

Since yesterday or so, the Gentoo Handbook now provides instructions on
[using
parted](http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=4#parted)
for partitioning the disk (not for all architectures yet since I can't
validate if it works on those as well). The use of the **parted**
command, which is in the minimal LiveCDs for some time now, allows users
to create GPT partition labels (instead of the old-style msdos ones).
This partition system, which is supported by other operating systems as
well, does not stop at 4 primary partitions, and supports partitions of
a size I can currently only dream of (somewhere in the exabytes if I am
not mistaken).
