Title: 20120215 policies now stable
Date: 2012-04-29 16:43
Category: Gentoo
Slug: 20120215-policies-now-stable

Today I've stabilized the `sec-policy/selinux-*` packages that provide
the 20120215 "series" of SELinux policies. Together with the
stabilization, the more recent userspace tools (like the policycoreutils
as well as libraries like libsemanage and libselinux) have been pushed
out as well. I will be dropping the older policies and userspace tools
soon (as they are now deprecated). The documentation has been updated to
reflect this too.

-   support for permissive domains (allowing users to mark one specific
    SELinux domain, such as mplayer\_t, as permissive (even though the
    rest of the system is running in enforcing mode)
-   support for file context translations, so we can now say "/usr/lib64
    (and below) should have the same contexts as /usr/lib"
-   support for role attributes, which means for policy developers, we
    now have similar freedom as with type attributes
-   support for named file transitions, so a policy rule can say that
    domain A, if creating a file in a directory labeled B, then that
    specific file should have label C. Same for directories, btw.

Although some of these enhancements were available as features
individually, the policies we had were not aligned with it - and now,
that has changed ;-)
