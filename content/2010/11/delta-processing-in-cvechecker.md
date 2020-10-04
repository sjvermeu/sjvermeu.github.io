Title: Delta processing in cvechecker
Date: 2010-11-02 00:30
Category: Security
Slug: delta-processing-in-cvechecker

The [cvechecker](http://cvechecker.sourceforge.net) application will
support delta file processing as well as higher version matching with
its next release. The functionality is currently in version control and
I still have to work out quite a few things before they can go live, but
the functionality is there.

Now why would these functions be interesting?

Well, first of all, by supporting **delta file processing** I am able to
use **cvechecker** with Portage' hooks. Every time a package is
unmerged, **cvechecker** will remove the files from its database (so
that it doesn't get picked up in vulnerability reports anymore).
Similarly, every time a package is emerged, the files are stored in the
database. There is no need to perform a full system scan every time the
system has been updated.

Second, being able to report on **higher version vulnerabilities** the
tool can now also trap potential issues with reports that do not contain
the exact version as detected by **cvechecker** but *can* be relevant.
For instance, a version detection of `Linux 2.6.35-hardened-r1` might
otherwise not be noticed (for instance because no CVE is reported on the
hardened-r1 release) yet a CVE report on `2.6.35` or even `2.6.36-rc4`
might be of interest. By using the higher version reporting, you'll be
notified of this as well. Same goes for vulnerability reports on an
entire branch (say `Python 2.4`), especially when those branches are not
actively being developed anymore (so the vulnerability remains). And
another benefit is that you might be informed about higher versions of
particular software being available ;-)

Now, a very quick warning before everybody cheers and does the penguin
dance: enabling higher version reports will give you *lots* of false
hits:

-   First of all, detecting if a version is higher than another version
    isn't easy. The tool is able to put `0.9.8 - 0.9.8a - 0.9.8b` in the
    right order, as well as `0.5.1_alpha - 0.5.1_beta - 0.5.1`, but the
    same algorithm will make `2.6.35-hardened-r1` be less than `2.6.35`,
    and a secure `0.9.8` version will be seen vulnerable when
    `1.0.0_alpha` has a vulnerability.
-   Second of all, official CVE entries don't always provide a good
    version match themselves. For instance,
    [CVE-2008-4609](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2008-4609)
    has been configured that `Linux Kernel 390` and `Linux Kernel 3.25`
    (I know those are not correct version numbers - my point exactly)
    are vulnerable. So yes, `390` is (a lot) higher than `2.6.35`...
-   Third, many tools use parallel development branches. Take Python for
    instance: even when version 2.6.5 would have no vulnerabilities and
    2.7 or 3.2 alpha releases do, it will still report the 2.6.5 one as
    having a potential vulnerability. This seems to give (for me
    at least) the most false positives of all.

I still don't know how to deal with this huge amount of false positives
- comments are always welcome.
