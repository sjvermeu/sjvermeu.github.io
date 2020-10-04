Title: What is OVAL?
Date: 2013-12-22 04:40
Category: Security
Tags: openscap, oval, scap, sce, xccdf
Slug: what-is-oval

Time to discuss **OVAL (Open Vulnerability Assessment Language)**. In
all the [previous
posts](http://blog.siphos.be/2013/12/running-a-bit-with-the-xccdf-document/)
I focused the checking of rules (does the system comply with the given
rule) on scripts, through the Script Check Engine supported by openscap.
The advantage of SCE is that most people can quickly provide automated
checks to run in script format. But SCE has a few downsides.

-   You cannot guarantee that the scripts will do no harm on the system.
    A badly written script might manipulate system settings, get a huge
    amount of resources, leave stale result files on the system, flood
    file systems and more. If you get scripts from other parties, you'll
    need to review them thoroughly before running them against all
    your systems. Especially when you run the compliance validation tool
    (openscap in our example) as root.
-   SCE support is only available for openscap (and perhaps one or
    two others) as it is not an international standard. If you use any
    of the [SCAP validated tools](https://nvd.nist.gov/scapproducts.cfm)
    then you will not be able to benefit from the SCE scripts. And that
    would make the XCCDF document back to a purely documenting
    best practice.
-   Every rule requires separate scripts, even though many of the rules
    will be very similar and thus reuse a lot of the scripts.

OVAL on the other hand provides those advantages. An OVAL file is an XML
file that contains the tests to run, in an (I must say) somewhat complex
manner. Really, OVAL is not simple, but it does contain advantages that
SCE doesn't.

-   It is a standard, part of the SCAP standards. OVAL files are
    reusable across multiple tools, allowing you to focus once on the
    rules rather than having to rewrite the rules for every time you
    change the tool.
-   OVAL can be platform-agnostic. Of course, not all tests are
    platform-agnostic (validating registry keys is a Windows-only check)
    but many are.
-   All rules can be mentioned in a single file (or spread across
    multiple files if that makes management easier), but more
    importantly rules will also reuse definitions from other rules. If
    you have three rules that pertain to a file (say `/etc/rc.conf`)
    then the definition of that file is shared across all rules.
-   The OVAL standard is designed to be non-intrusive. All declarations
    you do in an OVAL file are pure read-only statements. This gives
    more confidence to have OVAL statements from third parties ran
    across your organization. Of course, reviewing them never hurts, but
    you already know that they will not modify any setting.

Like SCE, OVAL checks are individual checks that are executed and
returned. They too return a success or failure (or error) and can
deliver more detailed information as part of their result (like the SCE
results output we looked at before) so allow administrators to
investigate further why a rule failed (without needing to log on to the
system and look for themselves).

A basic structure of OVAL is a *definition* that describes what the rule
is for. The definition refers to one or more *tests* that are evaluated
on a system. These tests refer to an *object* that needs to be checked,
and optionally a *state* to which the object should (or shouldn't)
match.

Consider the test we made with SCE to see if a platform is a Gentoo
Linux system:

```
#!/bin/sh

# If /etc/gentoo-release exists then the system is a Gentoo Linux system.
test -f /etc/gentoo-release && exit ${XCCDF_RESULT_PASS};
exit ${XCCDF_RESULT_FAIL};
```

In OVAL, this would be structured as follows (pseudo-OVAL):

definition
:   The system is a Gentoo Linux system

test
:   The object that represents /etc/gentoo-release must exist

object
:   The /etc/gentoo-release file

The resulting OVAL file is quite complex for a simple rule. I see the
OVAL complexity as part of a normalization (similar to database
normalization) process to allow higher reuse. If we later want to check
the content of the `gentoo-release` file, we will reuse the definition
(object with id *oval:org.gentoo.dev.swift:obj:1*) rather than making a
second object for it, and use that definition to create new tests.

The structure of OVAL is the same everywhere. First define the
definitions, then the tests, then the objects and then, optionally, the
states. A very important aspect is to have the identifiers (`id="..."`)
correct. The structure of OVAL identifiers is standardized as well:

(XML content lost during blog conversion)

namespace
:   Like the namespace used in XCCDF documents, this is the reverse
    notation of a domainname. In the example above, this
    is org.gentoo.dev.swift.

type
:   The type of the entry in OVAL. This can be def (definition), tst
    (test), obj (object), ste (state) or var (variable).

id
:   The identifier of this particular entry. This identifier has to be a
    positive integer.

By standardizing the identifiers, you can create repositories within
your organization, and have other teams reuse your OVAL components when
needed. As the identifier remains the same (even when you update the
OVAL object itself to be more precise) those tests keep validating
correctly. For instance, say that Gentoo Linux would be changed in the
future not to provide a `gentoo-release` file anymore, but
`gentoo-linux-release` file instead (not that it is planning that, it is
just hypothetical), then you can update the test (with description
"Gentoo Linux is installed") to check if either of the two files exist:

(XML content lost due to blog conversion)

If we save all Gentoo releated OVAL statements in a file called
`gentoo-oval.xml` then we can update the `gentoo-cpe.xml` file (which we
discussed in the past) to the following:

(XML content lost during blog conversion)

With this change, openscap (or any other XCCDF interpreter) will use the
OVAL definition to see if a platform is Gentoo Linux or not, and does
not need to execute the `gentoo-platform.sh` script anymore, which is
now fully deprecated and superceded by the OVAL statement.

In the next posts, I'll write up one of the other tests we had (which
checks the content of a file - one of the most used tests I think) in
OVAL, and have the XCCDF document updated to only use OVAL statements.

This post is part of a series on SCAP content:

1.  [Documenting security best practices - XCCDF
    introduction](http://blog.siphos.be/2013/12/documenting-security-best-practices-xccdf-introduction/)
2.  [An XCCDF skeleton for
    PostgreSQL](http://blog.siphos.be/2013/12/an-xccdf-skeleton-for-postgresql/)
3.  [Documenting a bit more than just
    descriptions](http://blog.siphos.be/2013/12/xccdf-documenting-a-bit-more-than-just-descriptions/)
4.  [Running a bit with the XCCDF
    document](http://blog.siphos.be/2013/12/running-a-bit-with-the-xccdf-document/)
5.  [Remediation through
    SCAP](http://blog.siphos.be/2013/12/remediation-through-scap/)

