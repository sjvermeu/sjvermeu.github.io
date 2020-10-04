Title: Today was a productive day
Date: 2013-08-15 20:58
Category: Misc
Tags: gimp, tablet, wacom
Slug: today-was-a-productive-day

Fixed 14 bugs today, with a few more pending (those for packages only
get marked as FIXED if it is moved to the stable state). One of the
changes is the
[GRUB2](http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=10#grub2)
support in the Gentoo Handbook (yes, finally, sorry about that). That
opens up the road for the stabilization of GRUB2.

I also added a dozen fixes to the Gentoo SELinux policy repository and
sent a few others upstream that have been lingering in our policy for
quite some time. But the highlight for me was that I got to play with my
Wacom Bamboo pen and touch which, I must say, integrated easily with my
system. I only had to build the `wacom.ko` kernel module and install the
`xf86-input-wacom` package, but that's all - no reboot needed. Even GIMP
immediately detected the new device and I can start drawing and fixing
pictures more easily (I work on pictures often and a mouse just isn't
that obvious).

One of the huge benefits is that the pressure you put on the drawing pad
is related (and configurable) to a drawing function in GIMP, something
you don't have with mice. For instance, if you need to Dodge or Burn on
layers, you don't need to continuously switch between the amount - just
adjust the pressure.
