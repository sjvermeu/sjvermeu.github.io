Title: Gentoo Hardened, June 2014
Date: 2014-06-15 21:28
Category: Gentoo
Tags: Gentoo, hardened, irc, meeting
Slug: gentoo-hardened-june-2014

Friday the [Gentoo
Hardened](https://wiki.gentoo.org/wiki/Project:Hardened) project had its
monthly online meeting to talk about the progress within the various
tools, responsibilities and subprojects.

On the **toolchain** part, Zorry mentioned that GCC 4.9 and 4.8.3 will
have SSP enabled by default. The hardened profiles will still have a
different SSP setting than the default (so yes, there will still be
differences between the two) but this will help in securing the Gentoo
default installations.

Zorry is also working on upstreaming the PIE patches for GCC 4.10.

Next to the regular toolchain, blueness also mentioned his intentions to
launch a [Hardened
musl](https://wiki.gentoo.org/wiki/Project:Hardened_musl) subproject
which will focus on the musl C library (rather than glibc or uclibc) and
hardening.

On the **kernel** side, two recent kernel vulnerabilities in the vanilla
kernel Linux (pty race and privilege escalation through futex code)
painted the discussions on IRC recently. Some versions of the hardened
kernels are still available in the tree, but the more recent
(non-vulnerable) kernels have proven not to be as stable as we'd hoped.

The pty race vulnerability is possibly not applicable to hardened
kernels thanks to grSecurity, due to its protection to access the kernel
symbols.

The latest kernels should not be used with KSTACKOVERFLOW on production
systems though; there are some issues reported with virtio network
interface support (on the guests) and ZFS.

Also, on the **Pax** support, the `install-xattr` saga continues. The
new wrapper that blueness worked in dismissed some code to keep the
`PWD` so the `$S` directory knowledge was "lost". This is now fixed. All
that is left is to have the wrapper included and stabilized.

On **SELinux** side, it was the usual set of progress. Policy
stabilization and user land application and library stabilization. The
latter is waiting a bit because of the multilib support that's now being
integrated in the ebuilds as well (and thus has a larger set of
dependencies to go through) but no show-stoppers there. Also, the
[SELinux documentation portal](https://wiki.gentoo.org/wiki/SELinux) on
the wiki was briefly mentioned.

Also, the [policycoreutils
vulnerability](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-3215)
has been [worked
around](http://blog.siphos.be/2014/05/dropping-sesandbox-support/) so it
is no longer applicable to us.

On the hardened **profiles**, we had a nice discussion on enabling
capabilities support (and move towards capabilities instead of setuid
binaries), which klondike will try to tackle during the summer holidays.

As I didn't take notes during the meeting, this post might miss a few
(and I forgot to enable logging as well) but as Zorry sends out the
meeting logs anyway later, you can read up there ;-)
