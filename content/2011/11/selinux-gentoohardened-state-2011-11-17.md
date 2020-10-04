Title: SELinux Gentoo/Hardened state 2011-11-17
Date: 2011-11-17 23:29
Category: Gentoo
Slug: selinux-gentoohardened-state-2011-11-17

A small write-down on the [Gentoo Hardened
SELinux](http://hardened.gentoo.org/selinux) state-of-affairs, largely
triggered because there was an online meeting for the [Gentoo
Hardened](http://hardened.gentoo.org) project today.

-   The SELinux policies offered in the `sec-policy` category are based
    on the latest refpolicy release. The older policies have been
    removed from the Portage tree. The patches that we include in our
    policies are sent upstream and are getting eventually merged. This
    way we ensure that we keep the policies manageable (larger
    development audience), secure (more eyes looking at policy changes)
    and usable for other SELinux-enabled distributions.
-   The userspace utilities to manage SELinux are also the latest ones
    available upstream; the older ones have been removed from the tree
    as well as to keep the number of ebuilds small enough.
-   The Gentoo profiles that enable SELinux support are currently the
    `selinux/v2refpolicy` ones and the `hardened/*/selinux` ones. The
    former are the older profiles and were a bit more difficult
    to maintain. The latter ones are the newer profiles which have been
    running for quite some time now. Alas, we will be deprecating the
    `selinux/v2refpolicy` profiles pretty soon now.
-   The various SELinux-related documents as offered on our [subproject
    page](http://hardened.gentoo.org/selinux) are regularly crosschecked
    to ensure that they are up-to-date with the latest
    SELinux state-of-affairs. An additional guide will be created on how
    to report SELinux policy bugs in bugzilla to ensure that we have the
    information that is needed to get a policy patch accepted upstream
    as well.
-   On a HR-note: Matt Thode (known as "prometheanfire") has joined the
    ranks of SELinux developers in Gentoo Hardened. I've also taken over
    the position as Gentoo Hardened SELinux subproject lead from
    Chris Pebenito.

