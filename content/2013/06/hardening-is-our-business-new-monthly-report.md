Title: Hardening is our business... new monthly report ;-)
Date: 2013-06-27 23:03
Category: Gentoo
Tags: Gentoo, hardened, irc, meeting, progress
Slug: hardening-is-our-business-new-monthly-report

We're back with another report on the [Gentoo
Hardened](http://www.gentoo.org/proj/en/hardened) project. Please excuse
my brevity, as you've noticed I'm not that active (yet) due to work on
an external project - I'll be back mid-July though. I promise.

On the *Toolchain* side, GCC 4.8.1 is in the tree and has the GCC plugin
header fix. Also, for IA64 and ARM, the necessary PIE patches are
available as well to make this work on those architectures too.

For uclibc, blueness is continuing the necessary support for everything
so far. He has also added mips64 n32 uclibc because new router boards
use this.

In his time, blueness is also playing with a uclibc-powered desktop and
another C library called [musl](http://www.musl-libc.org/).

On the *Kernel*, *grSecurity* and *PaX* side, we are having troubles
with the 3.8+ kernels and UEFI machines when the machines have ltitle
memory available (for instance when it is limited with `mem=`).

The PaX extended attribute support is still on-going, mainly because we
need to have support for the `user.pax` attributes in common tools like
**install**, which is heavily used in Gentoo's ebuilds. The merge phase,
where the data is moved from the image location to the root, has been
supporting xattr moves for a while thanks to zmedico and arfrever, but
other installation phases still needed to be fixed or worked around. We
tried with a common patch on this, but there was little interest in this
approach, so we settled with a wrapper around **install** inside of
Portage. This will be soon released and we again have full end-to-end
xattr pax flag support.

On the *SELinux* support, the latest userland and policy releases have
been stabilized in the Gentoo tree.

On the *Profiles*, blueness added a musl subprofile for testing of the
musl C library.
