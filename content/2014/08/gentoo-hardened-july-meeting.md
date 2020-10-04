Title: Gentoo Hardened July meeting
Date: 2014-08-01 21:48
Category: Gentoo
Tags: Gentoo, hardened, irc, meeting
Slug: gentoo-hardened-july-meeting

I failed to show up myself (I fell asleep - kids are fun, but deplete
your energy source quickly), but that shouldn't prevent me from making a
nice write-up of the meeting.

*Toolchain*

GCC 4.9 gives some issues with kernel compilations and other components.
Lately, breakage has been reported with GCC 4.9.1 compiling MySQL or
with debugging symbols. So for hardened, we'll wait this one out until
the bugs are fixed.

For GCC 4.10, the
[--enable-default-pie](https://gcc.gnu.org/ml/gcc-patches/2014-07/msg02231.html)
patch has been sent upstream. If that is accepted, the SSP one will be
sent as well.

In uclibc land, stages are being developed for PPC. This is the final
architecture that is often used in embedded worlds that needed support
for it in Gentoo, and that's now being finalized. Go blueness!

*SELinux*

A `libpcre` upgrade broke relabeling operations on SELinux enabled
systems. A fix for this has been made part of libselinux, but a little
too late, so some users will be affected by the problem. It's easily
worked around (removing the `*.bin` files in the `contexts/files/`
directory of the SELinux configuration) and hopefully will never occur
again.

The 2.3 userland has finally been stabilized (we had a few dependencies
that we were waiting for - and we were a dependency ourselves for other
packages as well).

Finally, some [thought
discussion](http://article.gmane.org/gmane.linux.gentoo.hardened/6266)
is being done (not that there's much feedback on it, but every
documented step is a good step imo) on the SELinux policy within Gentoo
(and the principles that we'll follow that are behind it).

*Kernel and grsecurity / PaX*

Due to some security issues, the Linux kernel sources have been
stabilized more rapidly than usual, which left little time for broad
validation and regression testing. Updates and fixes have been applied
since and new stabilizations occurred. Hopefully we're now at the right,
stable set again.

The C-based `install-xattr` application (which is performance-wise a big
improvement over the Python-based one) is working well in "lab
environments" (some developers are using it exclusively). It is included
in the Portage repository
^(if\\ I\\ understand\\ the\\ chat\\ excerpts\\ correctly)^ but as such
not available for broader usage yet.

An update against `elfix` is made as well as there was a dependency
mismatch when building with `USE=-ptpax`. This will be corrected in
elfix-0.9.

Finally, blueness is also working on a GLEP (Gentoo Linux Enhancement
Proposal) to export VDB information (especially `NEEDED.ELF.2`) as this
is important for ELF/library graph information (as used by revdep-pax,
migrate-pax, etc.). Although Portage already does this, this is not part
of the PMS and as such other package managers might not do this (such as
Paludis).

*Profiles*

Updates on the profiles has been made to properly include multilib
related variables and other metadata. For some profiles, this went as
easy as expected (nice stacking), but other profiles have inheritance
troubles making it much harder to include the necessary information.
Although some talks have arised on the gentoo-dev mailinglist about
refactoring how Gentoo handles profiles, there hasn't been done much
more than just talking :-( But I'm sure we haven't heard the last of
this yet.

*Documentation*

Blueness has added information on `EMULTRAMP` in the kernel
configuration, especially noting to the user that it is needed for
Python support in Gentoo Hardened. It is also in the [PaX
Quickstart](https://wiki.gentoo.org/wiki/Hardened/PaX_Quickstart)
document, although this document is becoming a very large one and users
might overlook it.
