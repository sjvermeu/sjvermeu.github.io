Title: Gentoo Hardened progress report
Date: 2013-08-29 20:27
Category: Gentoo
Tags: Gentoo, hardened, irc, meeting, minutes, progress_report, report
Slug: gentoo-hardened-progress-report

Today, we had our monthly online meeting to discuss the progress amongst
the various Gentoo Hardened projects. As usual, here is a small
write-up.

*Lead election*

As every year, we also reviewed the current project leads. No surprises
here, everybody is happy with the current leads so they are re-elected
for another term. We did have two candidates for the lead position, but
even the other candidate vote for Zorry - so we had a unanimous vote ;-)

*Toolchain*

GCC version 4.8.1 will be unmasked pretty soon, and the `hardenedno*`
specs on it will work. However, there is still no progress on the asan
(Address Sanitizer) support together with UDEREF. As mentioned in a
previous post, UDEREF "reduces" the address space a bit which doesn't
play well with asan. Still, it isn't inevitable, since PowerPC also has
a reduced address space and so does Windows. So perhaps we can use the
same model for UDEREF enabled kernels? We'll send the suggestion and the
already-existing fixes upstream and hope for the best.

In GCC 4.8.1, the `-fstack-check` option might be enabled by default,
but the question is for which architectures and platforms. We know a few
packages, such as *ffmpeg* and *libav* have problems with it. In those
cases, the ebuild will be modified to use `-fno-stack-check` (if
hardened). We opt to enable it for all as we don't really expect much
(if any) breakage that can't be dealt with swiftly.

Support for hardened uClibc is still going steadily. Blueness is heating
his room a bit with it, seeing that mips32r2 takes about 2 weeks to
build hardened and vanilla stages - he is using an Ubiquity router
station for this.

*Kernel and Grsecurity/PaX*

Due to some boot freezes, as explained in bugs
[482010](https://bugs.gentoo.org/482010) and
[481790](https://bugs.gentoo.org/481790), we don't have a stable 3.10.x
kernel yet. However, most of the issues should be resolved and we're
waiting for confirmation, so we can be looking at a stable 3.10.x kernel
soon.

The 3.10 kernel will probably not be a long-term support kernel for PaX
and Grsecurity - such LTS kernel will be picked next year, most likely
the same kernel version that Ubuntu LTS settles on.

*SELinux*

A small update on `policycoreutils` has been made that updates **rlpkg**
and **selocal**. Other than that, our policies are in nice shape. A new
revision will be pushed to the tree soon.

*Integrity*

On the Integrity side, recent kernels support custom IMA policies
(again) so our documentation is accurate again. Next to IMA/EVM, I'll be
working on documentation for cryptographically signed kernel module
support soon as well as SCAP-based security baselines for Gentoo.

*Profiles*

Blueness added a MUSL-based Gentoo profile (`hardened/linux/musl`). Musl
is an even more slim libc and its profile is extremely experimental for
now. The profile structure is still a bit off though, a reorganization
will be suggested soon so that the profile inheritance is clear and
predictable, starting off with a non-hardened one
(`default/linux/{uclibc,musl}`) and then a hardened specific one that
inherits from the default.

*Documentation*

The [Gentoo Hardened
project](https://wiki.gentoo.org/wiki/Project:Hardened) now has its main
project page on the [Gentoo Wiki](https://wiki.gentoo.org), and all
(most) documentation is moved to there as well for the Gentoo Hardened
subprojects.

I also explained to the folks that I have authored a book on SELinux
System Administration (for Packt Publishing), which was why I was less
active the last few months. However, that is now done so I'm back on
track. More information about the book follows later on my blog ;-)

*Media*

And as usual, klondike has been tweeting the entire meeting through our
`@GentooHardened` twitter account ;-)
