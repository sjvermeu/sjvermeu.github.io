Title: Updated Gentoo Hardened/SELinux VM image
Date: 2012-07-16 18:31
Category: Gentoo
Slug: updated-gentoo-hardenedselinux-vm-image

I have updated the Gentoo Hardened/SELinux VM image, available on the
mirrors under `experimental/amd64/qemu-selinux`.

The new image now asks for the keyboard layout, has a short DHCP timeout
value (5 seconds) and provides the nano editor. If you plan on running
the image using qemu, please use `-cpu kvm64` to use a 64-bit virtual
processor.
