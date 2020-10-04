Title: Documenting security best practices - XCCDF introduction
Date: 2013-12-12 16:04
Category: Security
Tags: postgresql, scap, xccdf
Slug: documenting-security-best-practices-xccdf-introduction

When I have some free time, I try to work on a [Gentoo Security
Benchmark](http://dev.gentoo.org/~swift/docs/security_benchmarks/gentoo.html)
which not only documents security best practices (loosely based on the
[Gentoo Security
Handbook](http://www.gentoo.org/doc/en/security/security-handbook.xml)
which hasn't seen much updates in the last few years) but also uses the
SCAP protocols. This set of protocols allows security administrators to
automate and document many of their tasks, and a security best practices
guide is almost a must-have in any organization. So I decided to do a
few write-ups about these SCAP protocols and how I hope to be using them
more in the future.

In this post, I'm going to focus on a very simple matter: documenting.
SCAP goes much, much beyond documenting, but I'll discuss those various
features in subsequent posts. The end goal of the series is to have a
best practice document for PostgreSQL.

To document the secure state of a component, it is important to first
have an idea about what you are going to document. Some people might
want to document best practices across many technologies so that there
is a coherent, single document explaining the security best practices
for the entire organization. In my opinion, that is not manageable in
the long term. We tried that with the Gentoo Security Handbook, but you
quickly start wrestling with the order of chapters, style concerns and
what not. Also, some technologies will be much more discussed in depth
than others, making the book look "unfinished".

Personally, I rather focus on a specific technology. For instance:
[Hardening
OpenSSH](http://dev.gentoo.org/~swift/docs/security_benchmarks/openssh.html)
(very much work in progress - the rules are generated automatically for
now and will be rewritten in the near future). It talks about a single
component (OpenSSH) allowing the freedom for the author to focus on what
matters. By providing security best practices on these component levels,
you'll create a set of security best practices that can often be reused.
This is what [the Center for Internet
Security](http://www.cisecurity.org) is doing with its benchmarks:
popular technologies are described in detail on how to configure them to
be more secure.

Once you know what technology you want to describe, we need to consider
how this technology is used. Some technologies are very flexible in
their setup, and might have different security setups depending on their
use. For instance, an OpenLDAP server can be used internally as a public
address book, or disclosed on the Internet in a multi-replicated setup
with authentication data in it. The security best practices for these
deployments will vary. The **XCCDF (Extensible Configuration Checklist
Description Format)** standard allows authors to write a single guide,
while taking into account the different deployment approaches through
the use of `Profile` settings.

In XCCDF, `Profile`s allow for selectively enabling or disabling
document fragments (called `Group`s) and checks (called `Rule`s - I will
post about checks later) or even change values (like the minimum
password length) depending on the profile. A document can then describe
settings with different profiles depending on the use and deployment of
the technology. Profiles can also inherit from each other, so you can
have a base (default) security conscious setup, and enhance it through
other profiles.

Next to the "how", we also need to consider the structure we want for
such a best practice:

-   We will have rules in place for the deployment of PostgreSQL itself.
    These rules range from making sure a stable, patched version is
    used, to the proper rights on the software files, partitioning and
    file system rules and operating system level requirements (such as
    particular kernel parameters).
-   We will also have rules for each instance. We could plan on running
    multiple PostgreSQL instances next to each other, so these rules are
    distinct from the deployment rules. These rules include settings on
    instance level, process ownership (in case of running PostgreSQL as
    different service user), etc.
-   We might even have rules for databases and users (roles) in
    the database.

It *might* make sense to split the best practices in separate documents,
such as one for PostgreSQL infrastructure (which is database-agnostic)
and one for PostgreSQL databases (and users). I would start with one
document for the technology if I was responsible for the entire
definition, but if this responsibility is not with one person (or team),
it makes sense to use different documents. Also, as we will see later,
XCCDF documents can be "played" against a target. If the target is
different (for infrastructure, the target usually is the host on which
PostgreSQL is installed, whereas for the database settings the target is
probably the PostgreSQL instance itself) I would definitely have the
definitions through separate profiles, but that does not mean the
document needs to be split either.

Finally, documenting a secure best practice also involves keeping track
of the references. It is not only about documenting something and why
*you* think this is the best approach, but also about referring readers
to more information and other resources that collaborate your story.
These can be generic control objectives (such as those provided by the
[open security
architecture](http://www.opensecurityarchitecture.org/cms/library/0802control-catalogue))
or specific best practices of the vendor itself or third parties.

At the end, for a PostgreSQL security guide, we would probably start
with:

    Hardening PostgreSQL
    +- Basic setup
    +- Instance level configuration
    |  +- Pre-startup configuration
    |  `- PostgreSQL internal configuration
    +- Database recommendations
    `- User definitions

Profile-wise, I probably would need an *infrastructure* profile, an
*instance* profile, a *user* profile and a *database* profile. I might
even have profiles for the different roles (*functional account*,
*administrator* and *end user* profiles which inherit from the *user*
profile) as they will have different rules assigned to them.

In my next post, we'll create a skeleton XCCDF document and already talk
about some of the XCCDF features that we can benefit from immediately.
