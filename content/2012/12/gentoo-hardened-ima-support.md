Title: Gentoo Hardened IMA support
Date: 2012-12-27 22:40
Category: Gentoo
Slug: gentoo-hardened-ima-support

Adventurous users, contributors and developers can enable the *Integrity
Measurement Architecture* subsystem in the Linux kernel with appraisal
(since Linux kernel 3.7). In an attempt to support IMA (and EVM and
other technologies) properly, the [System
Integrity](http://www.gentoo.org/proj/en/hardened/integrity/index.xml)
subproject within [Gentoo
Hardened](http://www.gentoo.org/proj/en/hardened) was launched a few
months ago. And now that Linux kernel 3.7 is out (and stable) you can
start enjoying this additional security feature.

With IMA (and IMA appraisal), you are able to protect your system from
offline tampering: modifications made to your files while the system is
offline will be detected as their hash values do not match the hash
values stored in extended attributes (whereas the extended attributes
are then protected through digitally signed values using the EVM
technology).

I'm working on integrating IMA (and later EVM) properly, which of course
includes the necessary documentation:
[concepts](http://www.gentoo.org/proj/en/hardened/integrity/docs/concepts.xml)
and a [ima
guide](http://www.gentoo.org/proj/en/hardened/integrity/docs/ima-guide.xml)
for starters, with more to follow. Be aware though that the integration
is still in its infancy, but any questions and feedback is greatly
appreciated, and bugreports (like [bug
448872](https://bugs.gentoo.org/show_bug.cgi?id=448872)) are definitely
welcome.
