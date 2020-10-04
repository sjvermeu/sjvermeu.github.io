Title: The hardened project continues going forward...
Date: 2012-11-17 21:34
Category: Gentoo
Slug: the-hardened-project-continues-going-forward

This wednesday, the [Gentoo
Hardened](http://www.gentoo.org/proj/en/hardened) team held its monthly
online meeting, discussing the things that have been done the last few
weeks and the ideas that are being worked out for the next. As I did
with the last few meetings, allow me to summarize it for all interested
parties...

**Toolchain**

The upstream GCC development on the 4.8 version progressed into its 3rd
stage of its development cycle. Sadly, many of our hardened patches
didn't make the release. Zorry will continue working on these things,
hopefully still being able to merge a few - and otherwise it'll be for
the next release.

For the MIPS platform, we might not be able to support the hardenedno\*
GCC profiles \[1\] in time. However, this is not seen as a blocker
(we're mostly interested in the hardened ones, not the ones without
hardening ;-) so this could be done later on.

Blueness is migrating the stage building for the uclibc stages towards
catalyst, providing more clean stages. For the amd64 and i686 platforms,
the uclibc-hardened and uclibc-vanilla stages are already done, and
mips32r2/uclibc is on the way. Later, ARM stages will be looked at.
Other platforms, like little endian MIPS, are also on the roadmap.

**Kernel**

The latest hardened-sources (\~arch) package contains a patch supporting
the *user.\** namespace for extended attributes in tmpfs, as needed for
the XATTR\_PAX support \[2\]. However, this patch has not been properly
investigated nor tested, so input is definitely welcome. During the
meeting, it was suggested to cap the length of the attribute value and
only allow the *user.pax* attribute, as we are otherwise allowing
unprivileged applications to "grow data" in the kernel memory space (the
tmpfs).

Prometheanfire confirmed that recent-enough kernels (3.5.4-r1 and later)
with nested paging do not exhibit the performance issues reported
earlier.

**SELinux**

The 20120725 upstream policies are stabilized on revision 5. Although a
next revision is already available in the hardened-dev overlay, it will
not be pushed to the main tree due to a broken admin interface. Revision
7 is slated to be made available later the same day to fix this, and is
the next candidate for being pushed to the main tree.

The september-released newer userspace utilities for SELinux are also
going to be stabilized in the next few days (at the time of writing this
post, they are ;-). These also support *epatch\_user* so that users and
developers can easily add in patches to try out stuff without having to
repackage the application themselves.

**grSecurity and PaX**

The toolchain support for PT\_PAX (the ELF-header based PaX markings) is
due to be removed soon, meaning that the XATTR\_PAX support will need to
be matured by then. This has a few consequences on available packages
(which will need a bump and fix) such as elfix, but also on the
[pax-utils.eclass](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-dev.git;a=commit;h=eb3a2e198c926aca7063aa036793bb94bfbec1ef)
file (interested parties are kindly requested to test out the new eclass
before it reaches "production"). Of course, it will also mean that the
new PaX approach needs to be properly documented for end users and
developers.

pipacs also mentioned that he is working on a paxctld daemon. Just like
SELinux' restorecond daemon, this deamon will look for files and check
them against a known database of binaries with their appropriate PaX
markings. If the markings are set differently (or not set), the paxctld
daemon will rectify the situation. For Gentoo, this is less of a concern
as we already set the proper information through the ebuilds.

**Profiles**

The old SELinux profiles, which were already deprecated for a while,
have been removed from the portage tree. That means that all
SELinux-using profiles use the *features/selinux* inclusion rather than
a fully build (yet difficult to maintain) profile definition.

**System Integrity**

A few packages, needed to support or work with ima/evm, have been pushed
to the hardened-dev overlay.

**Documentation**

The SELinux handbook has been updated with the latest policy changes
(such as supporting the named init scripts). We also [documented SELinux
policy
constraints](http://www.gentoo.org/proj/en/hardened/selinux-constraints.xml)
which was long overdue.

So again a nice month of (volunteer) work on the security state of
Gentoo Hardened. Thanks again to all (developers, contributors and
users) for making Gentoo Hardened where it is today. Zorry will send out
the meeting log later to the mailinglist, so you can look at the more
gory details of the meeting if you want.

-   \[1\] GCC profiles are a set of parameters passed on to GCC as a
    "default" setting. Gentoo hardened uses GCC profiles to support
    using non-hardening features if the users wants to (through the
    **gcc-config** application).
-   \[2\] XATTR\_PAX is a new way of handling PaX markings on binaries.
    Previously, we kept the PaX markings (i.e. flags telling the kernel
    PaX code to allow or deny specific behavior or enable certain
    memory-related hardening features for a specific application) as
    flags in the binary itself (inside the ELF header). With XATTR\_PAX,
    this is moved to an extended attribute called "user.pax".

