Title: Supporting fix scripts for XCCDF content and maintaining the documents
Date: 2011-12-23 16:00
Category: Gentoo
Slug: supporting-fix-scripts-for-xccdf-content-and-maintaining-the-documents

One of the features supported through OVAL (and Open-SCAP) is to
generate fix scripts when a test has failed. The administrator can then
verify this script (of course) and then execute it to correct wrong
settings. So I decided to play around with this as well and enhanced the
[Gentoo Security
Benchmark](http://dev.gentoo.org/~swift/docs/previews/oval/gentoo-xccdf-guide.html)
([XCCDF
source](http://dev.gentoo.org/~swift/docs/previews/oval/scap-gentoo-xccdf.txt))
with some fixables (like for the sysctl settings). And lo and behold:
the thing works ;-)

After evaluating the XCCDF (together with the
[OVAL](http://dev.gentoo.org/~swift/docs/previews/oval/scap-gentoo-oval.txt)
document) against my system, I had Open-SCAP generate a fix script:

    # oscap xccdf generate fix --result-id OSCAP-Test-Gentoo-Default xccdf-results.xml
    #!/bin/bash
    # OpenSCAP fix generator output for benchmark: Gentoo Security Benchmark

    # XCCDF rule: rule-sysctl-ipv4-forward
    echo 0 > /proc/sys/net/ipv4/ip_forward

    # generated: 2011-12-23T14:53:03+01:00
    # END OF SCRIPT

Now isn't that nice. But generating a fix script is one thing,
*maintaining the XCCDF and OVAL documents* is a completely other
picture.

One of the downsides that I talked about earlier already is that OVAL
has quite an extensible language (it's a large XML document). Although
this extensibility is very flexible and powerful, when you want to add
generic tests (like validating sysctl values or matching regular
expressions in files) having to write over 30 lines of XML code for a
single test is time-consuming at the least. So I quickly scripted
something to help me maintain these settings.

The [Generating OVAL documents with
genoval.sh](http://dev.gentoo.org/~swift/docs/genoval.xml) document
explains this script (which is retrievable from my [git
repository](https://github.com/sjvermeu/small.coding)) whose primary
purpose is to transform a single line into the entire OVAL structure.
With this script, I can now just say *gentoo variable USE must contain
ssl* and it generates both the rules in the XCCDF as the OVAL statements
in the OVAL document.

Okay, it's a script, not a feature-full application, but at least it
helps me (and perhaps others as well).
