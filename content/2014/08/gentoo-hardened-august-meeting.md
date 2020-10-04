Title: Gentoo Hardened august meeting
Date: 2014-08-29 16:43
Category: Gentoo
Tags: Gentoo, hardened, irc, meeting
Slug: gentoo-hardened-august-meeting

Another month has passed, so we had another online meeting to discuss
the progress within Gentoo Hardened.

*Lead elections*

The yearly lead elections within Gentoo Hardened were up again. Zorry
(Magnus Granberg) was re-elected as project lead so doesn't need to
update his LinkedIn profile yet ;-)

*Toolchain*

blueness (Anthony G. Basile) has been working on the uclibc stages for
some time. Due to the configurable nature of these setups, many
`/etc/portage` files were provided as part of the stages, which
[shouldn't](https://bugs.gentoo.org/show_bug.cgi?id=519686) happen. Work
is on the way to update this accordingly.

For the musl setup, blueness is also rebuilding the stages to use a
symbolic link to the dynamic linker (`/lib/ld-linux-arch.so`) as
recommended by the musl maintainers.

*Kernel and grsecurity with PaX*

A [bug](https://bugs.gentoo.org/show_bug.cgi?id=520198) has been
submitted which shows that large binary files (in the bug, a chrome
binary with debug information is shown to be more than 2 Gb in size)
cannot be pax-mark'ed, with `paxctl` informing the user that the file is
too big. The problem is when the PAX marks are in ELF (as the
application mmaps the binary) - users of extended attributes based PaX
markings do not have this problem. blueness is working on making things
a bit more intelligent, and to fix this.

*SELinux*

I have been making a few changes to the SELinux setup:

-   The live ebuilds (those with version 9999 which use the repository
    policy rather than snapshots of the policies) are now being used as
    "master" in case of releases: the ebuilds can just be copied to the
    right version to support the releases. The release script inside the
    repository is adjusted to reflect this as well.
-   The SELinux eclass now supports two variables, `SELINUX_GIT_REPO`
    and `SELINUX_GIT_BRANCH`, which allows users to use their own
    repository, and developers to work in specific branches together. By
    setting the right value in the users' `make.conf` switching policy
    repositories or branches is now a breeze.
-   Another change in the SELinux eclass is that, after the installation
    of SELinux policies, we will check the reverse dependencies of the
    policy package and relabel the files of these packages. This allows
    us to only have `RDEPEND` dependencies towards the SELinux policy
    packages (if the application itself does not otherwise link with
    *libselinux*), making the dependency tree within the package manager
    more correct. We still need to update these packages to drop the
    `DEPEND` dependency, which is something we will focus on in the next
    few months.
-   In order to support improved cooperation between SELinux developers
    in the Gentoo Hardened team - perfinion (Jason Zaman) is in the
    queue for becoming a new developer in our mids - a [coding style for
    SELinux
    policies](https://wiki.gentoo.org/wiki/Project:SELinux/CodingStyle)
    is being drafted up. This is of course based on the coding style of
    the reference policy, but with some Gentoo specific improvements and
    more clarifications.
-   perfinion has been working on improving the SELinux support in
    OpenRC (release 0.13 and higher), making some of the additions that
    we had to make in the past - such as the `selinux_gentoo` init
    script - obsolete.

The meeting also discussed a few bugs in more detail, but if you really
want to know, just hang on and wait for the IRC logs ;-) Other usual
sections (system integrity and profiles) did not have any notable topics
to describe.
