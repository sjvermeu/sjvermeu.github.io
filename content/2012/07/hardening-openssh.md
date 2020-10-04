Title: Hardening OpenSSH
Date: 2012-07-18 22:20
Category: Security
Slug: hardening-openssh

A while ago I wrote about a [Gentoo Security
Benchmark](https://dev.gentoo.org/~swift/docs/security_benchmarks/gentoo.html)
which would talk about hardening a Gentoo Linux installation. Within
that document, I was documenting how to harden specific services as
well. However, I recently changed my mind and wanted to move the
hardening stuff for the services in separate documents.

The first one is now finished - [Hardening
OpenSSH](https://dev.gentoo.org/~swift/docs/security_benchmarks/openssh.html)
is a benchmark informing you how to potentially harden your SSH
installation further. It uses
[XCCDF](https://dev.gentoo.org/~swift/docs/security_benchmarks/openssh-xccdf.txt)/[OVAL](https://dev.gentoo.org/~swift/docs/security_benchmarks/openssh-oval.txt)
so that users of **openscap** (and other compliant tools) can test their
system automatically, generating nice
[reports](https://dev.gentoo.org/~swift/docs/security_benchmarks/openssh-report.html)
on the state of their SSH configuration.

For now, the SSH stuff is also still part of the Gentoo document, but
I'll move that out soon and refer to this new document.

Hardened Gentoo's purpose is to make Gentoo viable for highly secure,
high stability production server environments. Hence, hardening
documents  
should be one of its deliverables as well. So, dear users, do you think
it is wise for the Gentoo Hardened project to also focus on delivering
hardening guides for services? If so, I'm sure we can draft up others...
