Title: Gentoo Hardened progress meeting
Date: 2012-10-14 15:00
Category: Gentoo
Slug: gentoo-hardened-progress-meeting

Not that long ago we had our monthly Gentoo Hardened project meeting (on
October 3rd to be exact). On these meetings, we discuss the progress of
the project since the last meeting.

For our *toolchain* domain, Zorry reported that the PIE patchset is
updated for GCC, fixing bug [\#436924](https://bugs.gentoo.org/436924).
Blueness also mentioned that he will most likely create a separate
subproject for the alternative hardened systems (such as mips and arm).
This is mostly for management reasons (as the information is currently
scattered throughout the Gentoo project at large).

For the *kernel* domain, since version 3.5.4-r2 (and higher), the
kernexec and uderef settings (for grSecurity) should no longer impact
performance on virtualized platforms (when hardware acceleration is used
of course), something that has been bothering Intel-based systems for
quite some time already. Also, the problem with guest systems
immediately reserving (committing) all memory on the host should be
fixed with recent kernels as well. Of course, this is only true as long
as you don't sanitize your memory, otherwise all memory gets allocated
regardless.

In the *SELinux* subproject, we now have live ebuilds allowing users to
pull in the latest policy changes directly from the git repository where
we keep our policy at. Also, we will see a high commit frequency in the
next few weeks (or perhaps even months) as Fedora's changes are being
merged with upstream. Another change is that our patchbundles no longer
contain all individual patches, but a merged patch. This increases the
deployment time of a SELinux policy package considerably (up to 30%
faster since patching is now only a second or less). And finally, the
latest userspace utilities are in the hardened-dev overlay ready for
broader testing.

*grSecurity* is still focusing on the XATTR-based PaX flags. The eclass
(pax-utils) has been updated, and we will now be looking at supporting
the PaX extended attributes for file systems such as tmpfs.

For *profiles*, people will notice that in the next few weeks, we will
be dropping the (extremely) old SELinux profiles as the current ones
have been marked stable long time ago.

In the *system integrity* domain, IMA is being worked on (packages and
documentation) after which we'll move to the EVM support to protect
extended attributes.

And finally, klondike held a good talk about Gentoo Hardened at the
Flossk conference in Kosovo.

All in all a good month of work, again with many thanks to the
volunteers that are keeping Gentoo Hardened alive and kicking!
