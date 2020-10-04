Title: Gentoo Hardened meeting 201310
Date: 2013-10-24 23:25
Category: Gentoo
Tags: Gentoo, hardened, irc, meeting, online
Slug: gentoo-hardened-meeting-201310

We gathered online again to talk about the progress, changes and other
stuff related to the [Gentoo
Hardened](https://wiki.gentoo.org/wiki/Project:Hardened) project.

*New Developer*

We welcomed Zero\_Chaos as a new addition to our team. Big welcome, with
the usual IRC kick in between, ensued.

*Toolchain*

GCC 4.8.x is unmasked and ready for testing. The ASAN problem however is
not resolved and it doesn't look like upstream wants to provide the fix
for this. As a result, if you want to use ASAN, you will need to disable
UDEREF in the kernel.

A difficult problem here is that, if a user forgets to disable UDEREF,
then building with ASAN will fail. If he disabled UDEREF and uses ASAN,
then booting into a UDEREF enabled kernel will fail. If he starts
building with ASAN on UDEREF kernels, things will break. Its ugly, and
unless the ASAN code is changed to support other technologies using the
address space layout information, it will remain mutually exclusive.

For now, we'll properly document the situation.

GCC 4.9 will end its stage1 development phase on November 21st.

The uclibc stages are currently built with GCC-4.7.3-r1, except for the
MIPS architectures which use GCC 4.8.1-r1.  
The stages are built once every two months, give or take.

*Kernel grSec/PaX*

Standard maintenance, such as keeping up with upstream changes, has
taken place. The XATTR problems with the **install** binary/phase has
not been resolved yet due to time constraints. First focus will be on
writing the C-based wrapper to see if this significantly speeds things
up.

*USE=pax\_kernel*

There is ambiguity of the meaning or use of the `pax_kernel` USE flag.
It seems to be used for multiple, exclusive things, like limiting builds
on PaX kernels or limiting run-time behavior on PaX kernels. To build
Gentoo images, developers need to set `pax_kernel` on some packages and
disable it on others in order for the image to build properly.

    <@blueness> USE=pax_kernel in the case of userland should apply patches etc, that fix the code
                so that it won't trip pax protection eg mprotect
    <@blueness> in the case of kernel modules, it can't mean that obviously!

One of the mentioned problems is that some ebuilds only enable pax
markings when `pax_kernel` is set. However, that shouldn't be done
conditionally. PaX markings can be done even without a PaX kernel.

Zero\_Chaos (new developers always have the necessary energy) will try
to update ebuilds where applicable.

*SELinux and System Integrity*

Nothing worth mentioning here.

*Profile*

Many users were using hardened profiles on the desktop. In the past, we
had the desktop/hardened profiles removed (referring users to the
regular hardened profiles and asking them to update their system with
the USE flags (and other settings) they want for their desktop.
Apparently, this is giving some problems for some users, so the idea is
to reinstate the desktop/hardened profiles where the hardened settings
overrule the desktop settings.

However, we should take care of tackling the issues we had in the past
(which is the reason why we removed the profiles in the first place). It
is recommended that we discuss this outside the IRC meeting to make sure
we don't reintroduce the issues again while using a flexible approach.

That's it. A big thanks to the developers, contributors and thousands of
users!
