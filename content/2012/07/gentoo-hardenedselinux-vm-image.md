Title: Gentoo Hardened/SELinux VM image
Date: 2012-07-10 21:27
Category: Gentoo
Slug: gentoo-hardenedselinux-vm-image

A few weeks ago, I pushed out a VM image (Qemu QCOW2 format) to the
`/experimental/amd64/qemu-selinux/` location in our mirrors. This VM
image (which is about 1.6 Gib large decompressed) provides a
SELinux-enabled, Gentoo Hardened (with PaX and other grSecurity security
settings) base installation. Thanks to the Qcow2 image format, only the
used 1.6 Gib of data is taken on your disk, even though the image is
made for a 50 Gib deployment).

The purpose of this image is, eventually, to allow users to test our
Gentoo Hardened with SELinux in a virtual environment, offering decent
isolation (so you can mess things up if you want, it doesn't hurt your
own system). I'm also contemplating of providing more serious
SELinux-focused course material (self-teaching stuff) based on this
image, so that users can learn about Gentoo Hardened (and SELinux) in a
structured manner.

But before all that, I first need to see if the image is usable by most
people:

-   Does it boot? It is an amd64 image for the Qemu KVM64 CPU, but the
    kernel uses paravirtualization for disk and network access, and I
    don't know if that's a safe bet to do or not. People that know KVM
    know that the paravirtualization support is needed for decent
    performance, but I'm not sure if it still makes the images
    sufficiently portable or not.
-   Does it work? The build is done based on my own systems, but these
    are all built in a similar fashion (and use binhosts to
    simplify deployment) so in effect, I can only test the images on a
    single system type (multiple, but they're all the same, so
    doesn't matter).

If I can get some comments on this (it boots, it doesn't boot, it sucks,
...) and can work out things, I hope I can have the images better for
all of us.

*Edit:* yes, keyboard layout is azerty, not qwerty. So your rootpass
will be rootpqss. Updates-are-a-comin'
