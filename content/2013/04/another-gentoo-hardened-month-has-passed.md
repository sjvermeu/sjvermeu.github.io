Title: Another Gentoo Hardened month has passed
Date: 2013-04-18 23:36
Category: Gentoo
Tags: asan, gcc, Gentoo, grsecurity, hardened, integrity, irc, meeting, pax, selinux, uderef
Slug: another-gentoo-hardened-month-has-passed

Another month has passed, so time to mention again what we have all been
doing lately ;-)

*Toolchain*

Version 4.8 of GCC is available in the tree, but currently masked. The
package contains a fix needed to build hardened-sources, and a fix for
the asan (address sanitizer).
[asan](http://www.internetnews.com/blog/skerner/open-source-gcc-4.8-compiler-including-address-sanitizer-security.html)
support in GCC 4.8 might be seen as an improvement security-wise, but it
is yet unclear if it is an integral part of GCC or could be disabled
with a configure flag. Apparently, asan "makes building gcc 4.8 crazy".
Seeing that it comes from Google, and building Google Chromium is also
crazy, I start seeing a pattern here.

Anyway, it turns out that PaX/grSec and asan do not get along yet (ASAN
assumes/uses hardcoded userland address space size values, which breaks
when UDEREF is set as it pitches a bit from the size):

    ERROR: AddressSanitizer failed to allocate 0x20000001000 (2199023259648) bytes at address 0x0ffffffff000

Given that this is hardcoded in the resulting binaries, it isn't
sufficient to change the size value from 47 bits to 46 bits as hardened
systems can very well boot a kernel with and another kernel without
UDEREF, causing the binaries to fail on the other kernel. Instead, a
proper method would be to dynamically check the size of a userland
address.

However, GCC 4.8 also brings along some nice enhancements and features.
uclibc profiles work just fine with GCC 4.8, including armv7a and
mips/mipsel. The latter is especially nice to hear, since mips used to
require significant effort with previous GCCs.

*Kernel and grSecurity/PaX*

More recent kernels have now been stabilized to stay close to the
grSecurity/PaX upstream developments. The most recent stable kernel now
is hardened-sources-3.8.3. Others still available are hardened-sources
versions 3.2.40-r1 and 2.6.32-r156.

The support for XATTR\_PAX is still progressing, but a few issues have
come up. One is that non-hardened systems are seeing warnings about
**pax-mark** not being able to set the XATTR\_PAX on tmpfs since vanilla
kernels do not have the patch to support `user.*` extended attribute
namespaces for tmpfs. A second issue is that the **install**
application, as provided by `coreutils`, does not copy extended
attributes. This has impact on ebuilds where pax markings are done
before the install phase of a package. But only doing pax markings after
the install phase isn't sufficient either, since sometimes we need the
binaries to be marked already for test phases or even in the compile
phase. So this is still something on the near horizon.

Most likely the necessary tools will be patched to include extended
attributes on copy operations. However, we need to take care only to
copy over those attributes that make sense: `user.pax` does, but
security ones like `security.evm` and `security.selinux` shouldn't as
those are either recomputed when needed, or governed through policy. The
idea is that USE="pax\_kernel" will enable the above on `coreutils`.

*SELinux*

The SELinux support in Gentoo has seen a fair share of updates on the
userland utilities (like policycoreutils, setools, libselinux and such).
Most of these have already made the stable tree or are close to be
bumped to stable. The SELinux policy also has been updated a lot: most
changes can be tracked through bugzilla, looking for the
`sec-policy r13` whiteboard. The changes can be applied to the system
immediately if you use the live ebuilds (like `selinux-base-9999`), but
I'm planning on releasing revision 13 of our policy set soon.

*System Integrity*

Some of the "early adopter" problems we've noticed on Gentoo Hardened
have been integrated in the repositories upstream and are slowly
progressing towards the main Linux kernel tree.

*Profiles*

All hardened profiles have been moved to the 13.0 base. Some people
frowned when they noticed that the uclibc profiles do not inherit from
any architecture-related profile. This is however with reason: the
architecture profiles are (amongst other reasons) focusing on the glibc
specifics of the architecture. Since the profile intended here is for
uclibc, those changes are not needed (nor wanted). Hence, these are
collapsed in a single profile.

*Documentation*

For SELinux, the [SELinux
handbook](http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml)
now includes information about USE="unconfined" as well as the
`selinux_gentoo` init script as provided by `policycoreutils`. Users who
are already running with SELinux enabled can just look at the [Change
History](http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml?part=2&chap=7)
to see which changes affect them.

A set of [tutorials](https://wiki.gentoo.org/wiki/SELinux/Tutorials)
(which I've blogged about earlier as well) have been put online at the
[Gentoo Wiki](https://wiki.gentoo.org). Next to the SELinux tutorials,
an article pertaining to [AIDE](https://wiki.gentoo.org/wiki/AIDE) has
been added as well as it fits nicely within the principles/concepts of
the [System
Integrity](http://www.gentoo.org/proj/en/hardened/integrity/index.xml)
subproject.

*Media*

If you don't do it already, start following
[@GentooHardened](https://twitter.com/GentooHardened) ;-)
