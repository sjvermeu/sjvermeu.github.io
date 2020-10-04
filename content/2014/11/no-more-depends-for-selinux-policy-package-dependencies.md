Title: No more DEPENDs for SELinux policy package dependencies
Date: 2014-11-02 14:51
Category: Gentoo
Tags: DEPEND, ebuild, Gentoo, RDEPEND, selinux
Slug: no-more-depends-for-selinux-policy-package-dependencies

I just finished updating 102 packages. The change? Removing the
following from the ebuilds:

    DEPEND="selinux? ( sec-policy/selinux-${packagename} )"

In the past, we needed this construction in both DEPEND and RDEPEND.
Recently however, the SELinux eclass got updated with some logic to
relabel files after the policy package is deployed. As a result, the
DEPEND variable no longer needs to refer to the SELinux policy package.

This change also means that for those moving from a regular Gentoo
installation to an SELinux installation will have much less packages to
rebuild. In the past, getting `USE="selinux"` (through the SELinux
profiles) would rebuild all packages that have a DEPEND dependency to
the SELinux policy package. No more - only packages that depend on the
SELinux libraries (like `libselinux`) or utilities rebuild. The rest
will just pull in the proper policy package.
