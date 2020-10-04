Title: Gentoo Hardened in August
Date: 2012-08-25 17:18
Category: Gentoo
Slug: gentoo-hardened-in-august

Last wednesday [Gentoo Hardened](http://hardened.gentoo.org) held its
monthly online meeting to discuss the progress of the various
subprojects, reconfirm the current project leads, talk about potential
new projects and discuss some bugs that were getting on our nerves...

For the project leads, all current leads were reconfirmed: Zorry will
keep tight ship as Gentoo Hardened project lead, and will also continue
as the lead for the toolchain-related projects. Blueness keeps tackling
the kernel, pax, grsec and rsbac subprojects, klondike the documentation
and media and I will continue with the SELinux and integrity
subprojects.

On the toolchain progress, Zorry is working on the 4.8 patches and hopes
to be able to submit them upstream later this month. Blueness continues
maintaining the uclibc architectures mentioned last month and is working
on the documentation related to it.

On the kernel side, there were some reports submitted that were
triggered by the integer overflow plugin. This plugin, called
[size\_overflow](https://grsecurity.net/pipermail/grsecurity/2012-March/001091.html)
aims to detect integer overflows where an increase of an integer value
goes beyond its maximum and wraps around (resulting in either a negative
or a small integer result). This is of course unwanted behavior, so a
gcc plugin (by Emese Revfy) is used to detect such occurrences.
Basically, this plugin will recalculate whatever is done with the
integers on a double precision integer level and see if the logic result
is the same. If it isn't, then an overflow has most likely occurred.
This is of course overly simply explained, but from what I can fond in
the interwebs, not that far from the truth.

The reports are generally about network-related applications, like
[tor](http://www.torproject.org), which are terminated because something
fishy occurred within the network handling code of the kernel (see for
instance bug
[\#430906](https://bugs.gentoo.org/show_bug.cgi?id=430906)).

In the SELinux camp, the documentation has been updated to inform users
on how to create a new role (see also an earlier post of mine) and a few
patches to the setools package have been added to support
Python-2.7-only systems as well as systems using the latest swig. Also,
all userspace utilities for SELinux should support both Python 2.7 and
Python 3.x - the only remaining aspect is the SELinux code within
Portage (see [bug
\#430488](https://bugs.gentoo.org/show_bug.cgi?id=430488)).

Regarding grSecurity and PaX, blueness is working on the xattr PaX
markings support in Gentoo, and a [tracker
bug](https://bugs.gentoo.org/show_bug.cgi?id=427888) has been opened to
manage the changes needed. Vapier suggested to move towards xattr
markings completely and drop the PT\_PAX ELF header support, but this
cannot be done until all file systems support user-level extended
attributes. That being said, it is a good idea to do this in the long
run though as extended attributes give greater flexibility and don't
manipulate the binaries of an application.

On the integrity subproject, the concepts and introduction documentation
is online. I'm working on a few ebuilds that are needed to support
IMA/EVM and should hopefully hit the hardened development overlay the
next week. The primary focus now is to support creating a "secure image"
which, when uploaded to a hosting service, would detect if the hosting
service tampered with the image outside (i.e. by manipulating the image
file itself).

Finally, on documentation and media, we will need to look into updating
the prelude/LIDS documentation (host intrusion prevention/detection
documentation) as it is quite old and obsoleted currently. Klondike also
recently gave a talk about Gentoo Hardened (put the stuff online
Francisco !) but I don't recall anymore where - I'lll update when I see
the meeting log ;-)

All by all a nice month! Good going guys.
