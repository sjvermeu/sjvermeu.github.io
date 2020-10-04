Title: Hardening the Linux kernel
Date: 2012-07-20 22:05
Category: Security
Slug: hardening-the-linux-kernel

I have moved out the kernel configuration settings (and **sysctl**
stuff) from the [Hardening Gentoo Linux
benchmark](https://dev.gentoo.org/~swift/docs/security_benchmarks/gentoo.html)
into its own [Hardening the Linux
kernel](https://dev.gentoo.org/~swift/docs/security_benchmarks/kernel.html)
guide. It covers some common hardening-related kernel configuration
entries (although I'm sure I'm missing a lot of them still) as well as
grSecurity and PaX settings (which is something the [Gentoo
Hardened](http://hardened.gentoo.org) project works on), and finally the
system controls (sysctl) that are commonly suggested for a more secure
system.

The [overview of hardening
guides](https://dev.gentoo.org/~swift/docs/security_benchmarks/) now
thus contains three guides: one for Gentoo, one for OpenSSH and one for
the kernel. These ones were definitions I already had in the past so
were "quickly" possible to write down. I'm going to look at BIND and
DHCP next.

But simultaneously, I'm looking at [Linux
IMA/EVM](http://linux-ima.sourceforge.net/) support in the hope I can
have this supported in Gentoo as well. Looks like a promising
technology, and if I can get it working, it'll definitely deserve its
place within Gentoo Hardened!
