Title: An XCCDF skeleton for PostgreSQL
Date: 2013-12-14 04:00
Category: Security
Tags: postgresql, scap, xccdf
Slug: an-xccdf-skeleton-for-postgresql

In a [previous
post](http://blog.siphos.be/2013/12/documenting-security-best-practices-xccdf-introduction/)
I wrote about the documentation structure I have in mind for a
PostgreSQL security best practice. Considering what XCCDF can give us,
the idea is to have the following structure:

    Hardening PostgreSQL
    +- Basic setup
    +- Instance level configuration
    |  +- Pre-startup configuration
    |  `- PostgreSQL internal configuration
    +- Database recommendations
    `- User definitions

For the profiles, I had:

    infrastructure
    instance
    user
    +- administrator
    +- end user
    `- functional account

Let's bring this into an XCCDF document.

The **XCCDF (Extensible Configuration Checklist Description Format)**
format is an XML structure in which we can document whatever we want -
but it is primarily used for configuration checklists and best
practices. The *documenting* aspect of a security best practice in XCCDF
is done through XHTML basic tags (do not use fancy things - limit
yourself to `p`, `pre`, `em`, `strong`, ... tags), so some knowledge on
XHTML (next to XML in general) is quite important while developing XCCDF
guides. At least, if you don't use special editors for that.

We start with the basics:

(XML content lost during blog conversion)

Two things I want to focus on here: the `xmlns:h` and `id` attributes.

-   The `xmlns:h` attribute is an XML requirement, telling whatever XML
    parser is used later that tags that use the `h:` namespace is for
    XHTML tags. So later in the document, we'll use `<h:p>...</h:p>` for
    XHTML paragraphs.
-   The `id` attribute is XCCDF specific, and since XCCDF 1.2 also
    requires to be in this particular syntax:

```
    </p>
        xccdf_<namespace>_benchmark_<name>

    <p>
```
    The `<namespace>` is recommended to be an inverted domain
    name structure. I also added my nickname so there are no collisions
    with namespaces provided by other developers in Gentoo. So *SwifT's
    dev.gentoo.org* becomes *org.gentoo.dev.swift*.

This id structure will be used in other tags as well. Instead of
`*_benchmark` it would be `*_rule` (for `Rule` ids), `*_group` (for
`Group` ids), etc. You get the idea.

Now we add in some metadata in the document (with `Benchmark` as
parent):

(XML content lost during blog conversion)

So what is all this?

-   The `<status>` tag helps in tracking the state of the document.
-   The `<platform>` tag is to tell the XCCDF interpreter when the
    document is applicable. It references a **CPE (Common
    Platform Enumeration)** entity, in this case for PostgreSQL. Later,
    we will see that an automated test is assigned to the detection of
    this CPE. If the test succeeds, then PostgreSQL is installed and the
    XCCDF interpreter can continue testing and evaluating the system for
    PostgreSQL best practices. If not, then PostgreSQL is not installed
    and the XCCDF does not apply to the system.
    </p>
    <p>
    There is a huge advantage to this: you can check all your systems
    for compliance with the PostgreSQL best practices (this
    XCCDF document) and on the systems that PostgreSQL is not installed,
    it will simply state that the document is not applicable (without
    actually trying to validate all the rules in the document). So there
    is no direct need to only check systems you know have PostgreSQL on
    (and thus potentially ignore systems that have PostgreSQL but that
    you don't know of - usually those systems are much less secure as
    well ;-).
-   The `<version>` tag versions the document.
-   The `<model>` tags tell the XCCDF interpreter which *scoring system*
    should be used.
    </p>
    <p>
    Scoring will give points to rules, and the XCCDF interpreter will
    sum the scores of all rules to give a final score to the
    "compliance" state of the system. But scoring can be done on
    several levels. The default one uses the hierarchy of the document
    (nested `Group`s and `Rule`s) to give a final number whereas the
    flat one does not care about the structure. Finally, the
    flat-unweighted one does not take into account the scores given by
    the author - all rules get the value of 1.

Now we define the `Profile`s to use. I will give the example for two:
*user* and *administrator*, you can fill in the other ones ;-)

(XML content lost during blog conversion)

Finally, the `Group`s (still with `Benchmark` as their parent, but below
the `Profile`s) which define the documentation structure of the guide:

(XML content lost during blog conversion)

With all this defined, our basic skeleton for the PostgreSQL best
practice document is ready. To create proper content, we can use the
XHTML code inside the `<description>` tags, like so:

(XML content lost during blog conversion)

As said in the previous post though, just documenting various aspects is
not enough. It is recommended to add references. In XCCDF, this is done
through the `<reference>` tag, which is within a `Group` and usually
below the `<description>` information:

(XML content lost during blog conversion)

With this alone, it is already possible to write up an XCCDF guide
describing how to securely setup (in our case) PostgreSQL while keeping
track of the resources that helped define the secure setup. Tools like
[openscap](http://www.open-scap.org) can generate HTML or even Docbook
(which in turn can be converted to manual pages, PDF, Word, RTF, ...)
from this information:

    # oscap xccdf generate guide --format docbook --output guide.docbook postgresql-xccdf.xml

In the next post, I'll talk about the other documenting entities within
XCCDF (besides `<description>` and their meaning) and start with
enhancing the document with automated checks.
