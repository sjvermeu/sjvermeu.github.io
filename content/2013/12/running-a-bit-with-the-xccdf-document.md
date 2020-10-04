Title: Running a bit with the XCCDF document
Date: 2013-12-18 04:23
Category: Security
Tags: openscap, scap, sce, xccdf
Slug: running-a-bit-with-the-xccdf-document

In my [previous
post](http://blog.siphos.be/2013/12/xccdf-documenting-a-bit-more-than-just-descriptions/)
I introduced automated checking of rules through *SCE (Script Check
Engine)*. Let's focus a bit more now on running with an XCCDF document:
how to automatically check the system, read the results and find more
information of those results.

To provide a usable example, you can download the following files:

-   [test-xccdf.xml](http://dev.gentoo.org/~swift/blog/201312/18/test-xccdf.txt),
    a sample XCCDF document that documents and tests a few settings
    (save it with the `.xml` extension, I publish it as txt to make
    downloading and viewing easier).
-   [gentoo-cpe.xml](http://dev.gentoo.org/~swift/blog/201312/18/gentoo-cpe.txt)
    which defines when a system is a Gentoo system (I'll cover this in
    a minute).
-   [gentoo-platform.sh](http://dev.gentoo.org/~swift/blog/201312/18/gentoo-platform.sh)
    which is the script that tests if a system is a Gentoo system.
-   [gentoo-fstab-noroot.sh](http://dev.gentoo.org/~swift/blog/201312/18/gentoo-fstab-noroot.sh)
    which tests that `/dev/ROOT` is not set in `/etc/fstab`
-   [gentoo-fstab-noboot.sh](http://dev.gentoo.org/~swift/blog/201312/18/gentoo-fstab-noboot.sh)
    which tests that `/dev/BOOT` is not set in `/etc/fstab`
-   [gentoo-rc.conf-rc\_sys.sh](http://dev.gentoo.org/~swift/blog/201312/18/gentoo-rc.conf-rc_sys.sh)
    which tests that the `rc_sys` variable is declared in
    `/etc/rc.conf`.

Extract it to a directory of your choice, and let's get started.

With [openscap](http://www.open-scap.org) (available as
*app-forensics/openscap* in Gentoo), we can generate a guide of the
XCCDF document as follows:

```
~$ oscap xccdf generate guide test-xccdf.xml > guide-test-xccdf.html
```

The
[result](http://dev.gentoo.org/~swift/blog/201312/18/guide-test-xccdf.html)
is an HTML guide that reflects the content of the XCCDF document. By
default, it contains all text and rules, but shows no information about
the profiles (if any). We can add in the `--profile ...` tag to include
an overview of the checks that are selected if that profile is selected.
That would give a result similar to [this
one](http://dev.gentoo.org/~swift/blog/201312/18/guide-test-xccdf-withprofile.html).

Using the `--format docbook` arguments, the output can also be DocBook
instead of HTML. The advantage of DocBook is that it can generate a
multitude of other formats, including
[PDF](http://dev.gentoo.org/~swift/blog/201312/18/guide-test-xccdf-withprofile.pdf),
although I had to do some manual cleanups in the output to have it
render a PDF here using FOP (there are other methods to create PDFs too)
such as removing the `<preface>` part.

Let's try evaluating the XCCDF document on the system:

```
~$ oscap xccdf eval test-xccdf.xml
```

Nothing happened. That is because there are no rules that are by default
selected (all rules in the document have `selected="false"`) and we have
not passed on a profile. I don't know if there is a way to automatically
make a particular profile default, so let's try it with the
*xccdf\_org.gentoo.dev.swift\_profile\_default* (which I always use as
the default profile name for all my XCCDF documents):

```
~$ export PROFILE="xccdf_org.gentoo.dev.swift_profile_default"
~$ oscap xccdf eval --profile ${PROFILE} test-xccdf.xml

Title   There should be no /dev/ROOT in /etc/fstab
Rule    xccdf_org.gentoo.dev.swift_rule_installation-fstab-root
Result  notapplicable

Title   There should be no /dev/BOOT in /etc/fstab
Rule    xccdf_org.gentoo.dev.swift_rule_installation-fstab-boot
Result  notapplicable

Title   rc_sys should be defined in /etc/rc.conf
Rule    xccdf_org.gentoo.dev.swift_rule_installation-rc_sys
Result  notapplicable
```

At least we have output now, but still no results. In fact, all rules
have *notapplicable* as a result. What gives?

The reason is that the XCCDF interpreter (**oscap**) does not know about
the Gentoo Linux platform, whereas the XCCDF document explicitly
mentions that it is applicable to a Gentoo Linux system.

What we need to do is to provide the XCCDF interpreter with a test that
helps it evaluate if a system is a Gentoo Linux system or not. In other
words, a test that the XCCDF interpreter will run if the
*cpe:/o:gentoo:linux* platform is mentioned. We do this with a *CPE
dictionary* element which is saved as
[gentoo-cpe.xml](http://dev.gentoo.org/~swift/blog/201312/18/gentoo-cpe.txt).

In the dictionary, the coupling between cpe:/o:gentoo:linux and a scripted
check called gentoo-platform.sh is made. Let's now give this info to oscap:

```
~$ oscap xccdf eval --profile ${PROFILE} --cpe gentoo-cpe.xml test-xccdf.xml
Title   There should be no /dev/ROOT in /etc/fstab
Rule    xccdf_org.gentoo.dev.swift_rule_installation-fstab-root
Result  pass

Title   There should be no /dev/BOOT in /etc/fstab
Rule    xccdf_org.gentoo.dev.swift_rule_installation-fstab-boot
Result  pass

Title   rc_sys should be defined in /etc/rc.conf
Rule    xccdf_org.gentoo.dev.swift_rule_installation-rc_sys
Result  pass

OpenSCAP Error: Document is empty [./gentoo-platform.sh:1] [elements.c:207]
No definition with ID: (null) in definition model. [oval_probe.c:338]
No definition with ID: (null) in result model. [oval_agent.c:184]
No definition with ID: (null) in definition model. [oval_probe.c:338]
No definition with ID: (null) in result model. [oval_agent.c:184]
No definition with ID: (null) in definition model. [oval_probe.c:338]
No definition with ID: (null) in result model. [oval_agent.c:184]
```

Great; we now see that openscap ran the tests and gave feedback. It also
gave a few errors. These can be ignored now - it is openscap that tries
to interpret the shell scripts as OVAL scripts (I'll talk about OVAL in
a later post). After changing my system to be non-compliant, I see that
openscap detects that as well:

```
Title   rc_sys should be defined in /etc/rc.conf
Rule    xccdf_org.gentoo.dev.swift_rule_installation-rc_sys
Result  fail
```

Now, by itself the rule might give us enough clues as to what is wrong,
but sometimes you might want to get the output of the scripts as well.
You can enable this through the `--check-engine-results` option. This
will leave the generated output of the scripts available as XML files.

In it, we see the output (through `<sceres:stdout>`) of the **grep**
command we did in the script.

Finally, by adding in a `--report report-test-xccdf.html` to the
argument list, the results of the XCCDF evaluation is also saved as
[HTML](http://dev.gentoo.org/~swift/blog/201312/18/report-test-xccdf.html).

The oscap command has many more options, which I will not discuss in
more detail now, but are important to know (for instance, you can save
the XCCDF results in XML format for future processing).

```
~$ oscap xccdf eval -h
 oscap -> xccdf -> eval

Perform evaluation driven by XCCDF file and use OVAL as checking engine

Usage: oscap [options] xccdf eval [options] INPUT_FILE [oval-definitions-files]

INPUT_FILE - XCCDF file or a source data stream file

Options:
   --profile               - The name of Profile to be evaluated.
   --tailoring-file        - Use given XCCDF Tailoring file.
   --tailoring-id  - Use given DS component as XCCDF Tailoring file.
   --cpe                   - Use given CPE dictionary or language (autodetected)
                                   for applicability checks.
   --oval-results                - Save OVAL results as well.
   --sce-results                 - Save SCE results as well. (DEPRECATED! use --check-engine-results)
   --check-engine-results        - Save results from check engines loaded from plugins as well.
   --export-variables            - Export OVAL external variables provided by XCCDF.
   --results               - Write XCCDF Results into file.
   --results-arf           - Write ARF (result data stream) into file.
   --report                - Write HTML report into file.
   --skip-valid                  - Skip validation.
   --fetch-remote-resources      - Download remote content referenced by XCCDF.
   --progress                    - Switch to sparse output suitable for progress reporting.
                                   Format is "$rule_id:$result\n".
   --datastream-id           - ID of the datastream in the collection to use.
                                   (only applicable for source datastreams)
   --xccdf-id                - ID of component-ref with XCCDF in the datastream that should be evaluated.
                                   (only applicable for source datastreams)
   --benchmark-id            - ID of XCCDF Benchmark in some component in the datastream that should be evaluated.
                                   (only applicable for source datastreams)
                                   (only applicable when datastream-id AND xccdf-id are not specified)
   --remediate                   - Automatically execute XCCDF fix elements for failed rules.
                                   Use of this option is always at your own risk.
```

In my next post, I'll talk a bit more about remediation.

This post is part of a series on SCAP content:

1.  [Documenting security best practices - XCCDF
    introduction](http://blog.siphos.be/2013/12/documenting-security-best-practices-xccdf-introduction/)
2.  [An XCCDF skeleton for
    PostgreSQL](http://blog.siphos.be/2013/12/an-xccdf-skeleton-for-postgresql/)
3.  [Documenting a bit more than just
    descriptions](http://blog.siphos.be/2013/12/xccdf-documenting-a-bit-more-than-just-descriptions/)

