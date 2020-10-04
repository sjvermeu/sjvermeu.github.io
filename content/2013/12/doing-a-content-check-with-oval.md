Title: Doing a content check with OVAL
Date: 2013-12-24 04:25
Category: Security
Tags: openscap, oval, scap, xccdf
Slug: doing-a-content-check-with-oval

Let's create an OVAL check to see if `/etc/inittab`'s single user
definitions only refer to `/sbin/sulogin` or `/sbin/rc single`. First,
the skeleton:

(XML content lost during blog conversion)

The first thing we notice is that there are several namespaces defined
within OVAL. These namespaces refer to the platforms on which the tests
can be executed. OVAL has independent definitions, unix-global
definitions or linux-specific definitions. You can find the overview of
[all supported schemas and definitions
online](http://oval.mitre.org/language/version5.10.1/) - definitely
something to bookmark if you plan on developing your own OVAL checks.

So let's create the definition:

(XML content lost during blog conversion)

There is lots of information to be found in this simple snippet.

First of all, notice the `class="compliance"` part. OVAL definitions can
be given a class that informs the OVAL interpreter what kind of test it
is.

Supported classes are:

compliance
:   Does the system adhere to a predefined wanted state

inventory
:   Is the given software or hardware available/installed on the system

patch
:   Is the selected patch installed on the system

vulnerability
:   Is the system vulnerable towards this particular exposure (CVE)

miscellaneous
:   Everything that doesn't fit the above

Next, we see metadata that tells the OVAL interpreter that the
definition applies to Unix family systems, and more specifically a
Gentoo Linux system. However, this is not a CPE entry
(*cpe:/o:gentoo:linux*). The idea is that the OVAL Interpreter should
interpret the information as it wants without focusing on CPE details -
I think (I might be mistaken though) because the SCAP standard does not
want to introduce loops - a CPE that refers to an OVAL to validate,
which in turn refers to the same CPE.

Also, a reference is included in the OVAL. Remember that we also had
references in the XCCDF document? Well, the same is true for OVAL
statements - you can add in references that help administrators get more
information about a definition. In this case, it refers to a **CCE
(Common Configuration Enumeration)** entry. You can find all official
CCE entries [online as well](https://nvd.nist.gov/cce/index.cfm). This
particular one, CCE-4241-6, sais:

    CCE-4241-6  Platform: rhel5     Date: (C)2011-10-07   (M)2013-11-28

    The requirement for a password to boot into single-user mode should be configured correctly.

    Parameter: enabled/disabled

    Technical Mechanism: via /etc/inittab 

By requiring **sulogin** or **rc single** in `inittab`, Gentoo Linux
will ask for the root password before granting a shell, thereby
complying with the requirement to have a password before providing a
shell in single-user mode.

Finally, the definition refers to a single test, which we will now look
into:

(XML content lost during blog conversion)

This particular test is part of the *independent* definitions. Checking
the content of a file is something all platforms support. Within this
independent definition set, a [large set of
tests](http://oval.mitre.org/language/version5.10.1/ovaldefinition/documentation/independent-definitions-schema.html)
are supported, including file hash checking (does the checksum of a file
still match), environment variable test (verifying the existence and
content of an environment variable), LDAP tests and also text file
content tests.

In the test, there are two important attributes to closely look into:
`check` and `check_existence`.

The `check_existence` attribute tells the OVAL interpreter how to deal
with the object definition. In our case, the object will refer to the
lines in the `/etc/inittab` file that match a certain pattern. With
`check_existence="at_least_one_exists"` the OVAL interpreter knows it
has to have at least one line that matches the pattern before it can
continue. If no line matches, then the test fails.

Other values for `check_existence` are "all\_exist" (every object
described must exist), any\_exist (doesn't matter if zero, one or more
exists), none\_exist (no object described must exist) and
"only\_one\_exists" (one, and only one match for the described objects
must exist).

The `check` attributes tells the OVAL interpreter how to match the
object (if there is one) with the state. In our example, `check="all"`
tells the OVAL interpreter that all lines that match the object
definition must also match the state definition.

Other values for `check` are "at least one", "none satisfy" and "only
one". These should be self-explanatory. Notice that there are no
underscores involved here (unlike with the `check_existence` attribute).

See the [common
schema](https://oval.mitre.org/language/version5.10.1/ovaldefinition/documentation/oval-common-schema.html)
for more general OVAL attribute information.

The test refers to the following object:

(XML content lost during blog conversion)

The object represents lines in the `/etc/inittab` file that match the
expression `^[\S]+:S:[\S]+:.*`. The OVAL definition uses [perl-style
regular expressions](http://oval.mitre.org/language/about/perlre.html),
so this means that the lines must start with a non-whitespace string,
followed by a colon (:), followed by the letter "S", followed by a
colon, followed by non-whitespace string, followed by colon and then a
remainder string.

Also, the object evaluates if at least one such line is found.

The state, also referred to by the test, looks like so:

(XML content lost during blog conversion)

Here again we see a regular expression; this time, the expression sais
that the line must start with "su" and that the fourth field equals
`/sbin/rc single` or `/sbin/sulogin`. In our example, if there is at
least one "single user" line that does not match this expression, then
the OVAL statement will return a failure and the system is
non-compliant.

Now you could be wondering if this is the best approach. We can create
an object that refers to all single-user lines in `/etc/inittab` that do
not comply with the expression just in the object definition. The
expression would be more complex by itself, but wouldn't need a state
anymore. True, but the advantage here is that the object itself matches
all single user lines, and can be reused later in other tests. Also, if
we later evaluate the OVAL statements, we will get an overview of all
lines that match the object (and then evaluate these lines against the
state) - similar to the script output we got with SCE tests.

We can create other OVALs for all other tests. To refer to these OVAL
tests in an XCCDF document, take a look at the following example:

(XML content lost during blog conversion)

Instead of referring to the SCE engine (with
`system="http://open-scap.org/page/SCE"`) we refer to the OVAL with
`system="http://oval.mitre.org/XMLSchema/oval-definitions-5"`, point the
XCCDF interpreter where the OVAL statements are stored in
`href="gentoo-oval.xml"` and what definition we want to test
(`oval:org.gentoo.dev.swift:def:22`). The XCCDF interpreter will then
pass this information on to the OVAL interpreter (in case of openscap,
this is the same tool, but it doesn't have to be) so it can evaluate the
right OVAL statement on the system.

In the next post, I'll use the [Gentoo Security
Benchmark](http://dev.gentoo.org/~swift/docs/security_benchmarks/guide-gentoo-xccdf.html)
as a guide to explain how to further structure and document things in
XCCDF/OVAL.

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
6.  [What is OVAL?](http://blog.siphos.be/2013/12/what-is-oval/)

