Title: Giving weights to compliance rules
Date: 2013-12-26 04:13
Category: Security
Tags: ccss, cvss, scap, xccdf
Slug: giving-weights-to-compliance-rules

Now that we wrote up a few OVAL statements and used those instead of SCE
driven checks (where possible), let's finish up and go back to the XCCDF
document and see how we can put weights in place.

The **CVE (Common Vulnerability Exposure)** standard allows for
vulnerabilities to be given weights through a scoring mechanism called
**CVSS (Common Vulnerability Scoring System)**. The method for giving
weights to such vulnerabilities is based on several factors, which you
can play with through an [online CVSS
calculator](https://nvd.nist.gov/cvss.cfm?calculator&version=2).

Giving weights on a vulnerability based on these metrics is not that
difficult, but what about compliance misconfigurations?

There is a suggested standard for this, **CCSS (Common Configuration
Scoring System)** which is based on the CVSS scoring and CMSS scoring.
Especially the base scoring is tailored to the CVSS scoring, so let's
look at an example from the [Gentoo Security
Benchmark](http://dev.gentoo.org/~swift/docs/security_benchmarks/guide-gentoo-xccdf.html)
(still in draft):

(XML content lost during blog conversion)

The base scoring of a misconfiguration focuses on the following items:

Access Vector (AV)
:   How can the misconfiguration be "reached" or exploited - Local (on
    the system), Adjacent Network or Network

Access Complexity (AC)
:   How complex would it be to exploit the misconfiguration - High,
    Medium or Low

Authentication (Au)
:   Does the attacker need to be authenticated in order to exploit the
    misconfiguration - None, Single (one account) or Multiple (several
    accounts or multi-factor authenticated)

Confidentiality (C)
:   Does a successful exploit have impact on the confidentiality of the
    system or data (None, Partial or Complete)

Integrity (I)
:   Does a successful exploit have impact on the integrity of the system
    or data (None, Partial or Complete)

Availability (A)
:   Does a successful exploit have impact on the availability of the
    system or data (None, Partial or Complete)

In order to exploit that `/tmp` is not on a separate file system, we can
think about dumping lots of information in `/tmp`, flooding the root
file system. This is simple to accomplish locally and requires a single
authentication (you need to be authenticated on the system). Once
performed, this only impacts availability.

The CCSS (and thus CVSS) base vector looks like so:
`AV:L/AC:L/Au:S/C:N/I:N/A:C` and gives a base score of 4.6, which is
reflected in the XCCDF in the `weight="4.6"` attribute.

The severity I give in the XCCDF is "gut feeling". Basically, I use the
following description:

-   high constitutes a grave or critical problem. A rule with this
    severity MUST be tackled as it detected a misconfiguration that is
    easily exploitable and could lead to full system compromise.
-   medium reflects a fairly serious problem. A rule with this severity
    SHOULD be tackled as it detected a misconfiguration that is
    easily exploitable.
-   low reflects a non-serious problem. A rule with this severity has
    detected a misconfiguration but its influence on the overall system
    security is minor (if other compliance rules are followed).
-   info reflects an informational rule. Failure to comply with this
    rule does not mean failure to comply with the document itself.

Of course, you can put your own weights and severities in your XCCDF
documents. Important however is to make sure it is properly documented -
other people who read the document must be aware of the consequences of
the rules if they are not compliant.

By introducing weights and severities, administrators of systems that
are not compliant (or of a large set of systems) can prioritize which
misconfigurations or vulnerabilities they will handle first. And it
reduces the amount of discussions as well, because without these, your
administrators will start debating what to tackle first, each with their
own vision and opinion. Which is great, but not when time is ticking.
Having a predefined priority list makes it clear how to react now.

That's it for this post series. I hope you enjoyed it and learned from
it. Of course, this wont be the last post related to SCAP so stay tuned
for more ;-)

This post is the final one in a series on SCAP content:

1.  [Documenting security best practices – XCCDF
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
7.  [Doing a content check with
    OVAL](http://blog.siphos.be/2013/12/doing-a-content-check-with-oval/)

