Title: Hardening the Linux kernel updates
Date: 2012-07-21 21:06
Category: Security
Slug: hardening-the-linux-kernel-updates

Thanks to a comment by Andy, the
[guide](https://dev.gentoo.org/~swift/docs/security_benchmarks/kernel.html)
now has information about additional settings: stackprotector, read-only
data, restrict access to /dev/mem, disable /proc/kcore and restrict
kernel syslog (dmesg). One suggestion he made didn't make it to the
guide (about CONFIG\_DEBUG\_STACKOVERFLOW) since I can't find any
resources about the setting on how it would made the system more secure
or more resilient against attacks.

Underlyingly, the
[OVAL](https://dev.gentoo.org/~swift/docs/security_benchmarks/scap-kernel-oval.txt)
now correctly identifies unset variables (it previously searched for "is
not set" strings in the kernel configuration, and now it searches for
the key entry definition and validates if it doesn't find it - e.g.
"CONFIG\_PROC\_KCORE=" - since that matches both the definition not
being there, or "\# CONFIG\_PROC\_KCORE has not been set").
