Title: Another hardened month has passed...
Date: 2012-12-13 10:02
Category: Gentoo
Slug: another-hardened-month-has-passed

... so it's time for a new update ;-)

*Toolchain*

GCC 4.8 is still in its stage 3 development phase, so Zorry will send
out the patches to the GCC development community when this phase is
done. For Gentoo hardened itself, we now support all architectures
except for IA64 (which never had SSP).

Full uclibc support is now in place for amd64, i686, mips32r2: not only
is their technological support ok, but stages are now also automatically
built to support installations through the regular installation
instructions. The next target to get stages automatically built for is
armv7a.

*Kernel and grSecurity/PaX*

Stabilization on 3.6.x is still showing some difficulties. Until those
are resolved, we're still stable in 3.5.4. We have a couple of panics in
some odd cases, but these will need to be resolved before we can
stabilize further.

glibc-2.16 will also drop the declarations for PT\_PAX (in elf.h) and
the binutils will also not cover PT\_PAX phdr anymore. So, we will
standardize fully on xattr-based PaX flags. This will get some proper
focus in the next period to ensure this is done correctly. Most work on
this support is focusing on communication towards users and the
pax-utils eclass support.

There was some confusion if the tmpfs-xattr patch would or would not
properly restrict access, but it looks like the PaX patch on mm/shmem.c
was based upon the Gentoo patch and enhanced with the needed
restrictions, so we can just keep the PaX code.

On USE="pax\_kernel", which should enable some updates on userland
utilities when applications are run under a PaX enabled kernel,
prometheanfire tried to get this as a global USE flag (as many
applications might eventually want to get a trigger on it). However, due
to some confusion on the meaning of the USE flag, and potential need to
depend on additional tools, we're going to stick with a local flag for
now.

*SELinux*

schmitt953 will help in the testing and possible development of SELinux
policies for Samba 4.

Furthermore, the userspace utilities have been stabilized (except for
the setools-3.3.7-r5+ due to some swig problems, but those have been
worked around in setools-3.3.7-r6). Also, the rev8 policies are in the
tree and no big problems were reported on them. They are currently still
\~arch, but will be stabilized in the next few days. A new rev9 release
will be pushed to the hardened-dev overlay soon as well.

*Profiles*

nvidia is unmasked for the hardened profiles, but still has X and tools
USE flags masked, and is only supported on kernels 3.0.x and higher.

Also, the hardened/linux/uclibc/arm/armv7a profile is now available as a
development profile. Profiles will be updated as the architectures for
ARM are getting supported, so expect more in the next month.

*System Integrity*

We were waiting for kernel 3.7, which just got released, so we can now
start integrating this further. Expect more updates by next meeting.

*Docs*

For SELinux, some information on USE="unconfined" is added to the
SELinux handbook. Blueness will also start documenting the xattr pax
stuff.
