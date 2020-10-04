Title: Gentoo Security Benchmark with OVAL and Open-SCAP
Date: 2011-11-16 23:09
Category: Gentoo
Slug: gentoo-security-benchmark-with-oval-and-open-scap

A while ago, I got referred to the [Open Vulnerability and Assessment
Language](http://oval.mitre.org/), which seems to be an open
specification (or even standard) for defining security
content/information and being able to document such things in a way that
tools can interpret it. Actually, it is a set of these specifications.
But first:

> tl;dr [Gentoo Security Benchmark
> Guide](http://dev.gentoo.org/~swift/docs/previews/oval/gentoo-xccdf-guide.html)
> with [example report on automated
> tests](http://dev.gentoo.org/~swift/docs/previews/oval/gentoo-xccdf-report.html)
> based on
> [XCCDF](http://dev.gentoo.org/~swift/docs/previews/oval/scap-gentoo-xccdf.txt)
> and
> [OVAL](http://dev.gentoo.org/~swift/docs/previews/oval/scap-gentoo-oval2.txt),
> interpreted by [Open-SCAP](http://www.open-scap.org/page/Main_Page).

There; now that we have that out of our way, let's continue on the
somewhat more gory details. In this first post, I'd like to talk a bit
about XCCDF and OVAL, which are both imo overly complex but interesting
XML formats.

The first one, XCCDF, is better known as the **Extensible Configuration
Checklist Description Format** and is an XML format in which you
document settings (what should a system look like). By itself, that
doesn't warrant another XML format. However, the power of XCCDF is that
you can define in the document *profiles*. Each of these profiles is
then documented with the set of rules that applies to the profile. So
you can have an XCCDF document on the configuration of BIND (the
nameserver) and have two profiles: one for a single-server setup, and
one for a multi-server (master/slave) setup.

These rules also define checks that you can have a tool performed
against your configuration. These checks are documented in an OVAL XML
file (**Open Vulnerability and Assessment Language**) which can be
interpreted by an OVAL-compliant tool. A very simply put statement could
be: "File /etc/ssh/sshd\_config must have a line that matches
'PermitRootLogin no'".

Of course, XML doesn't use simple statements. In the case of OVAL, a
specific form of normalization occurs.

-   At the beginning, you define a *definition* that explains what you
    want to achieve (similar to the above statement) in plain text, and
    then refer to one or more criteria that needs to be passed if this
    line applies. Most checks in a configuration guide are simple
    criteria, but with OVAL you can create criteria like "If my system
    is a Gentoo x86\_64 one, and I use the hardened profile, then
    criteria A must apply, but if my system does not use a hardened
    profile, it is criteria B".
-   The criteria refers to a *test* that needs to be executed. This test
    can be a file expression match, partition information check, service
    state, installed software, etc. but does not allow executing
    commands that the user defines (it is not considered a safe practice
    that you execute commands that are stated in the XML file since most
    OVAL interpreters will run as root). This test is based on two
    additional aspects:
    </p>
    -   The *object* refers to the object or resource that is checked.
        This can be a partition or a file, or a list of lines that match
        an expression in a file, etc.
    -   The *state* refers to the state that that object or resource
        should be in (or should match).

With this OVAL language in place, you can now refer to several tests to
enhance your XCCDF document, and allow OVAL interpreters to test the
various rules on your system. For me, this was the major reason to look
into the language, since I had my hopes up to update or rewrite the
[Gentoo Linux Security
Handbook](http://www.gentoo.org/doc/en/security/security-handbook.xml)
but with a way for users to validate if their system adheres to most/all
statements made in that document.

As a matter of exercise, I started making such a security benchmark of
which you can find a [HTML version
online](http://dev.gentoo.org/~swift/docs/previews/oval/gentoo-xccdf-guide.html)
(it's a preview URL, so might change in the future). And since it is
written with XCCDF and OVAL, I've also added an [example report on
automated
tests](http://dev.gentoo.org/~swift/docs/previews/oval/gentoo-xccdf-report.html)
too. The sources of these documents are available as well
([XCCDF](http://dev.gentoo.org/~swift/docs/previews/oval/scap-gentoo-xccdf.txt)
and
[OVAL](http://dev.gentoo.org/~swift/docs/previews/oval/scap-gentoo-oval2.txt)
- download as txt but rename to XML then).

For those adventurous enough to play with them: install
`app-forensics/openscap` so that you can parse the files. To generate
the guide itself, use
`oscap xccdf generate scap-gentoo-xccdf.xml > guide.html`. To run the
tests associated with it, use
`oscap xccdf eval --oval-results --profile Gentoo-Default --report report.html scap-gentoo-xccdf.xml`.
Also take a look at the
[Open-SCAP](http://www.open-scap.org/page/Main_Page) website which is a
good resource as well (and the mailinglists are low traffic but with
good response times!).

So, what is the future on all this for me?

First, I'm going to work a bit further on the OVAL statements, so that I
can automatically test the majority of settings that I currently have in
the benchmark/guide. Only when I'm far enough will I continue on the
content of the guide (since it is far from finished) and also see if
this isn't something that can be put on a somewhat more official
location. If not, I'll still continue developing it, but it'll remain on
my dev-page.

When I'm somewhat satisfied with that, I might check if I can't have
OVAL enhanced with some Gentoo-specific objects (there are already
objects for RedHat-like and Debian-like distributions) so that we can
write tests for Gentoo settings (like USE flags, profiles, enabled GCC
specs, etc.) If we have that, then we can even write checks (XCCDF and
OVAL based) to validate if a system is how it is supposed to be
(wouldn't that be great, an automated test that tells you if your system
is properly set up according to our documents).

But XCCDF and OVAL isn't the end. There are other formats available as
well, like CCE (for configuration entries), CVE/CPE (to check
vulnerability information and its target software/platform) and more. I
know RedHat is already actively using OVAL for its [security
advisories](https://www.redhat.com/security/data/oval/), and other sites
like [Center for Internet Security](http://cisecurity.org/) are also
using XCCDF and OVAL to document and work with security guides. So why
would Gentoo not get on that train as well?
