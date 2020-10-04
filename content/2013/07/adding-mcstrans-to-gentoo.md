Title: Adding mcstrans to Gentoo
Date: 2013-07-07 20:38
Category: Gentoo
Tags: categories, mcs, mcstrans, mls, selinux, sensitivity
Slug: adding-mcstrans-to-gentoo

If you use SELinux, you might be using an MLS-enabled policy. These are
policies that support sensitivity labels on resources and domains. In
Gentoo, these are supported in the `mcs` and `mls` policy stores. Now
sensitivity ranges are fun to work with, but the moment you have several
sensitivity levels, or you have several dozen categories (sets or tags
that can be used in conjunction with pure sensitivity levels) these can
become a burden to maintain.

The SELinux developers have had the same issue, so they wrote a tool
called *mcstransd*, a translation daemon that reads the sensitivity
labels from the SELinux context (such as `s0-s0:c0.c1023` or `s0:c12`)
and displays a more human readable string for this (such as
`SystemLow-SystemHigh` or `SalesTeam`). The daemon is not a super
intelligent one - we just configure it by creating a mapping file in
`/etc/selinux/mcs` called `setrans.conf` which contains the mappings:

` ## setrans.conf ## s0-s0:c0.c1023=SystemLow-SystemHigh s0:c12=SalesTeam`

The SELinux libraries (libselinux and libsemanage) use a socket to
communicate with the daemon to see if "translated" values need to be
displayed. If not (because the daemon is missing) the libraries keep the
SELinux syntax displayed. If it is, then the translated labels are
displayed.

Support for categories and sensitivity labels is handled through the
**chcat** tool, so you can list the current categories (and their
translated values) as well as assign them to files (or even logins).

Although we supported categories for a while already, a recent update on
the `policycoreutils` package now includes the mcstrans daemon as well.
Documentation is available, currently in the [pending changes
section](http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml?part=2&chap=7#doc_chap3)
of the SELinux handbook (as this is not in the stable package yet) and
it will be moved to the main document when the package has stabilized.
