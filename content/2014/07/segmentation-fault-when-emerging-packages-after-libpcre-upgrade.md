Title: Segmentation fault when emerging packages after libpcre upgrade?
Date: 2014-07-09 20:35
Category: SELinux
Tags: file_contexts, fix, Gentoo, libselinux, pcre
Slug: segmentation-fault-when-emerging-packages-after-libpcre-upgrade

SELinux users might be facing failures when emerge is merging a package
to the file system, with an error that looks like so:

    >>> Setting SELinux security labels
    /usr/lib64/portage/bin/misc-functions.sh: line 1112: 23719 Segmentation fault      /usr/sbin/setfiles "${file_contexts_path}" -r "${D}" "${D}"
     * ERROR: dev-libs/libpcre-8.35::gentoo failed:
     *   Failed to set SELinux security labels.

This has been [reported as bug
516608](https://bugs.gentoo.org/show_bug.cgi?id=516608) and, after some
investigation, the cause is found. First the quick workaround:

    ~# cd /etc/selinux/strict/contexts/files
    ~# rm *.bin

And do the same for the other SELinux policy stores on the system
(targeted, mcs, mls, ...).

Now, what is happening... Inside the mentioned directory, binary files
exist such as `file_contexts.bin`. These files contain the compiled
regular expressions of the non-binary files (like `file_contexts`). By
using the precompiled versions, regular expression matching by the
SELinux utilities is a lot faster. Not that it is massively slow
otherwise, but it is a nice speed improvement nonetheless.

However, when pcre updates occur, then the basic structures that pcre
uses internally might change. For instance, a number might switch from a
signed integer to an unsigned integer. As pcre is meant to be used
within the same application run, most applications do not have any
issues with such changes. However, the SELinux utilities effectively
serialize these structures and later read them back in. If the new pcre
uses a changed structure, then the read-in structures are incompatible
and even corrupt.

Hence the segmentation faults.

To resolve this, [Stephen
Smalley](http://marc.info/?l=selinux&m=140492568205937&w=2) created a
patch that includes PCRE version checking. This patch is now included in
[sys-libs/libselinux](http://packages.gentoo.org/package/sys-libs/libselinux)
version 2.3-r1. The package also recompiles the existing `*.bin` files
so that the older binary files are no longer on the system. But there is
a significant chance that this update will not trickle down to the users
in time, so the workaround might be needed.

I considered updating the pcre ebuilds as well with this workaround, but
considering that libselinux is most likely to be stabilized faster than
any libpcre bump I let it go.

At least we have a solution for future upgrades; sorry for the noise.

*Edit:* `libselinux-2.2.2-r5` also has the fix included.
