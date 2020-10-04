Title: Online hardened meeting of March
Date: 2014-03-27 23:44
Category: Gentoo
Tags: Gentoo, hardened, irc, meeting
Slug: online-hardened-meeting-of-march

I'm back from the depths of the unknown, so time to pick up my usual
write-up of the online Gentoo Hardened meeting.

*Toolchain*

GCC 4.9 is being worked on, and might be released by end of April (based
on the amount of open bugs). You can find the [changes
online](http://gcc.gnu.org/gcc-4.9/changes.html).

Speaking of GCC, pipacs asked if it is possible in the upcoming 4.8.2
ebuilds to disable the SSP protection for development purposes (such as
when you're developing GCC plugins that do similar protection measures
like SSP, but you don't want those to collide with each other). Recent
discussion on Gentoo development mailinglist had a consensus that the
SSP protection measures (`-fstack-protector`) can be enabled by default,
but of course if people are developing new GCC plugins which might
interfere with SSP, disabling it is needed. One can use
`-fno-stack-protector` for this, or build stuff with `-D__KERNEL__` (as
for kernel builds the default SSP handling is disabled anyway, allowing
for kernel-specific implementations).

Other than those, there is no direct method to make SSP generally
unavailable.

Blueness is also working on [musc-libc](http://www.musl-libc.org/) on
Gentoo, which would give a strong incentive for hardened embedded
devices. For desktops, well, don't hold your breath just yet.

*Kernel grSec/PaX*

It looks like kernel 3.13 will be Ubuntu's LTS kernel choice, which also
makes it the kernel version that grSecurity will put the long term
support for in. And with Linux 3.14 almost out, the grsec patches for it
are ready as well. Of the previous LTS kernels, 3.2 will probably finish
seeing grsec support somewhere this year.

The C wrapper (called **install-xattr**) used to preserve xattr
information during Portage builds has not been integrated in Portage
yet, but the development should be finished.

During the chat session, we also discussed the
[gold](https://lwn.net/Articles/274859/)
[linker](https://wiki.gentoo.org/wiki/Gold) and how it might be used by
more and more packages (so not only by users that explicitly ask for
it). udev version 210 onwards is one example, but some others exist. But
other than its existence there's not much to say right here.

*SELinux*

The
[20140311](http://oss.tresys.com/projects/refpolicy/wiki/DownloadRelease)
release of the reference policy is now in the Portage tree.

Also, prometheanfire caught a vulnerability
([CVE-2014-1874](https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-1874))
in SELinux which has been fixed in the latest kernels.

*System Integrity*

I made a few updates to the [gentoo hardening
guide](http://dev.gentoo.org/~swift/docs/security_benchmarks/) in
XCCDF/OVAL format. Nothing major, and I still need to add in a lot of
other best practices (as well as automate the tests through OVAL), but I
do intend to update the files (at least the gentoo one and ssh as
OpenSSH 6 is now readily available) regularly in the next few weeks.

*Profiles*

A few minor changes have been made to `hardened/uclibc` to support
multilib, but other than that nothing has been done (nor needed to be
done) to our profiles.

That's it for this months hardened meeting write-up. See you next time!
