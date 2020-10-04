Title: Mitigating risks, part 3 - hardening
Date: 2011-09-13 22:46
Category: Security
Slug: mitigating-risks-part-3-hardening

While I'm writing this post, my neighbor is shouting. He's shouting so
hard, that I was almost writing with CAPS on to make sure you could read
me. But don't worry, he's not fighting - it is how he expresses his
(positive) feelings about his religion.

Security is, for some, also a religion. They see risks and
vulnerabilities and what not everywhere. They're always thinking every
system in the world is or will be hacked in the near future and are
frantically trying to secure every service they are running - and more.
But security is also a real-life issue. If you take a look at the
compromised
[GlobalSign](http://www.globalsign.com/company/press/090611-security-response.html)
website (who mentions that the website is an isolated one - as [I
described
earlier](http://blog.siphos.be/2011/09/mitigating-risks-part-2-service-isolation/))
I hope that you look at security as being a *functional* requirement in
architecturing and design (and not a non-functional one as many
frameworks suggest).

And as you can see from the example, isolating services is not
sufficient to prevent a successful exploit of an insecure or unsupported
software (the reason why I started with this series). One additional
measure that you can take is **hardening** the server and service.

The act of hardening a server and service is to configure the system so
that it is as secure as possible, based on configuration entries. Many
vendors and projects offer a security guide (like the [Gentoo Security
Handbook](http://www.gentoo.org/doc/en/security/security-handbook.xml)
or the [Fedora Security
Guide](https://docs.fedoraproject.org/en-US/Fedora/16/html/Security_Guide/))
although most of them add this as part of their standard administrative
documents (like the [PostgreSQL "Server Setup and
Operation"](http://www.postgresql.org/docs/current/static/runtime.html)
chapter).

But for some reason, you'll find that default installations - even when
following the instructions of the vendor - are not as secure as you want
it to be. As a matter of fact, if you come in contact with auditors,
you'll probably fail any audit if you use a default installation. To
help administrators to secure their services, you will find lots of
third party sites offering advice on securing the operating system and
the services running on it. These guides are what you will need to
"harden" your system.

-   [OWASP](https://www.owasp.org/index.php/Main_Page), which stands for
    Open Web Application Security Project,
    [hosts](https://www.owasp.org/index.php/OWASP_Backend_Security_Project)
    some hardening guides and suggestions together with test scenarios.
    For front-end application servers (mostly web application servers)
    you will find lots of interesting resources in the OWASP site (and
    surrounding community).
-   [Google](http://www.google.com) is probably the best resource for
    finding hardening guides for your operating system or service. Just
    look for "hardening foo" and you will be reading for a week.
-   [CISecurity](http://www.cisecurity.org/), or "Center for Internet
    Security", is another one with a larger portfolio on
    hardening guides. Not only does it offer these guides (which it
    calls "benchmarks"), but organizations can also become a member and
    as such benefit from tooling that CISecurity supports for the
    validation of benchmarks (i.e. test if the system/deployment is
    compliant towards a particular benchmark). It does that by
    developing the benchmarks in a open specification called **OVAL**
    (the *Open Vulnerability and Assessment Language*) and **XCCDF**
    (*XML Configuration Checklist Data Format*). And CISecurity is not
    the only one there.
-   Another such resource is the [National Vulnerability
    Database](http://web.nvd.nist.gov/view/ncp/repository) (national for
    US residents, that is ;-) There you can find and download the
    OVAL/XCCDF resources for various software titles and
    operating systems. But as you can imagine from the abbreviations,
    the resources are XML files which are not made to be read by humans.

Although you can use the tool(s) that CISecurity offers, another
possibility is to use
[Open-SCAP](http://www.open-scap.org/page/Main_Page), an open source
framework for handling SCAP, OVAL, XCCDF and other such open
specifications on a system. Its
[documentation](http://www.open-scap.org/page/Documentation) offers a
first glance at what it can support.

However, this brings on he disadvantages of hardening services...

1.  Hardening a system and its services is a *time consuming* job. Its
    only purpose is to reduce the impact of exploited vulnerabilities
    and reduce the "attack surface" so that exploits on unused functions
    are not possible.
2.  Hardening a system and its services *can impact the service*. Make
    it too tight, and it might not behave anymore like you want it to.
3.  Also, since there are many, many resources "out there" on hardening,
    you will have to *manage your hardening rules*, document them
    for yourself. It is also advisable to document the rules you are not
    implementing, if not just for future's sake.
4.  The hardening guides also require quite some *expertise on the
    service*. If you are not experienced with the service but you need
    to harden it, you can be lucky and just implement what is suggested
    and hope for the best, but usually you will need to dive deeper in
    the subject and make (tough) choices.

Although specifications like SCAP exist to help you in your hardening
exercises, these are still difficult to manage (do *not* try to write
OVAL/SCAP/XCCDF content in your favorite text editor). Its adoption
however by Fedora and RedHat is showing a positive effect on the tools
surrounding this specification. I will be writing about SCAP, OVAL and
XCCDF later since I too see good use of it in organizations (or even
free software projects).

Does that mean that hardening is not beneficial? On the contrary:

-   You **gain lots of knowledge** in the matter, and also forces you to
    think about integration aspects. Since you are responsible for the
    service (or the damage that could be made if the service
    is exploited) being knowledgeable is definitely a good thing.
-   A considerable amount of vulnerabilities that are and will be
    reported on the service (check [CVE
    details](http://www.cvedetails.com) to find out about publicly known
    vulnerabilities, documented in the CVE specification) will not have
    their effect on a well hardened service. Or put another way, you
    will **reduce the number of real vulnerabilities** in your service.
    You will not be able to exclude all vulnerabilities, but the
    projected number is high - a fully hardened Windows or Linux system
    can mitigate up to 90% of the exploits on the operating system. It
    will considerably reduce the risks that you and your organization
    are taking.
-   A well defined hardening guide will also offer the means to
    **automatically audit** or check if the **system is still
    compliant** to the hardening setup you envisioned. Scheduled
    regularly, this will ensure that your configurations are not
    drifting away, back to a more vulnerable setup, for whatever reason.
-   By removing the functions that the service should not offer, you
    make sure that the use of the service is per the
    organizations' guidelines. (Internal) abuse of the service is made
    more difficult, so users are forced to take the regular way. Unlike
    service isolation, which allows you to keep track of data/service
    flows, hardening makes sure that **side-functionality is not used**
    without your consent. Or to put it more blunt, "Yes I know Oracle DB
    can be used to schedule tasks on the operating system, but no,
    you're not allowed to use that function".

And who knows, perhaps by optimizing the configuration, it might run
faster with a lower resource footprint ;-) If it does, that's perfect,
since the next topic on risk mitigation will have a negative influence
on performance: mandatory access control.
