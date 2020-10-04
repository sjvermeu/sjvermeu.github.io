Title: cvechecker 2.0 released
Date: 2010-12-01 22:29
Category: Security
Slug: cvechecker-2-0-released

Okay, enough play - time for a new release. Since **cvechecker 1.0** was
released, a few important changes have been made to the [cvechecker
tools](http://cvechecker.sourceforge.net):

-   You can now tell cvechecker to only check newly added files, or
    remove a set of files from its internal database. Previously, you
    had to have cvechecker scan the entire system again.
-   cvechecker can now also report if vulnerabilities have been found in
    software versions that are higher than the version you currently
    have installed. This can help you find seriously outdated software,
    but also help you identify possible vulnerabilities if the CVE
    itself doesn't contain all vulnerable versions, just the "latest"
    vulnerable version.
-   The toolset now contains a command called **cverules** which, on a
    Gentoo system, will attempt to generate version matching rules for
    software that is currently not detected by cvechecker yet. Very
    useful as I myself cannot install every possible software on my
    system to enhance the version matching rules. If you want to help
    out, run the **cverules** command and send me the output.
-   Some needed performance enhancements have been added as well

One thing I wanted to include as well was a tool that validates
**cvechecker** output against the distribution security information.
Some distributions patch software (to fix a vulnerability) rather than
ask the user to upgrade to a non-vulnerable software. The cvechecker
tools often cannot differentiate between the vulnerable and
non-vulnerable binaries (as they both mention the same version), but
often you can check against some meta data files of the distribution if
and which CVEs have been resolved in which versions of a distribution
package.

The cvechecker tarball contains a script (see the `scripts/` folder for
**cvepkgcheck\_gentoo**) for Gentoo that tries to get this information
from the GLSAs, but it is far from ready. I should try setting up a KVM
instance with an "old" Gentoo installation just to validate if the
command works, but even if it does, I'm not happy with how it is
written. Seems to me a lot of trouble, and if it cannot be done simply,
I'm afraid I'm doing it wrong ;-)

Anyhow, I hope you enjoy version 2.0 of cvechecker.
