Title: Added UEFI instructions to AMD64/x86 handbooks
Date: 2014-12-23 18:08
Category: Documentation
Tags: efi, Gentoo, handbook, uefi
Slug: added-uefi-instructions-to-amd64x86-handbooks

I just finished up adding some UEFI instructions to the [Gentoo
handbooks](https://wiki.gentoo.org/wiki/Handbook:Main_Page) for AMD64
and x86 (I don't know how many systems are still using x86 instead of
the AMD64 one, and if those support UEFI, but the instructions are
shared and they don't collide). The entire EFI stuff can probably be
improved a lot, but basically the things that were added are:

1.  boot the system using UEFI already if possible (which is needed for
    efibootmgr to access the EFI variables). This is not entirely
    mandatory (as efibootmgr is not mandatory to boot a system)
    but recommended.
2.  use vfat for the `/boot/` location, as this now becomes the EFI
    System Partition.
3.  configure the Linux kernel to support EFI stub and EFI variables
4.  install the Linux kernel as the `bootx64.efi` file to boot the
    system with
5.  use efibootmgr to add boot options (if required) and create an EFI
    boot entry called "Gentoo"

If you find grave errors, please do mention them (either on a talk page
on the wiki, as a [bug](https://bugs.gentoo.org) or through IRC) so it
is picked up. All developers and trusted contributors on the wiki have
access to the files so can edit where needed (but do take care that, if
something is edited, that it is either architecture-specific or shared
across all architectures - check the page when editing; if it is
*Handbook:Parts* then it is shared, and *Handbook:AMD64* is specific for
the architecture). And if I'm online I'll of course act on it quickly.

Oh, and no - it is not a bug that there is a (now not used) `/dev/sda1`
"bios" partition. Due to the differences with the possible installation
alternatives, it is easier for us (me) to just document a common
partition layout than to try and write everything out (making it just
harder for new users to follow the instructions).
