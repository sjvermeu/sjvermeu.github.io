Title: Kickstarting the Integrity subproject
Date: 2012-07-30 21:34
Category: Gentoo
Slug: kickstarting-the-integrity-subproject

Now that Gentoo Hardened has its
[integrity](http://www.gentoo.org/proj/en/hardened/integrity/index.xml)
subproject, I started with writing down the
[concepts](http://goo.gl/57K8g) (draft - will move to the project site
when finished!) used within the subproject: what is integrity, how does
trust fit into this, what kind of technologies will we look at, etc. I'm
hoping that this document will help users in positioning this project as
well as already identify a few areas where I think we need to work on.

The guide starts with talking about hashes (since hashes are often used
in integrity validation schemes), continuing towards HMAC (for
authenticated hashes) and signed HMAC digests (for better protection of
the cryptographic keys while verifying the integrity). It already talks
a bit about trust (and trust chains) and how it works in both ways
(top-down and bottom up - the latter especially when considering you are
running services on platforms you do not manage yourself).

I will be working further on this, describing how the trusted computing
group's vision and the trusted platform module standard they developed
fits into this as a *possible implementation* of trust validation
(hopefully without getting to the religious part of it) as well as
giving first highlights on other technologies we will look at as well.
