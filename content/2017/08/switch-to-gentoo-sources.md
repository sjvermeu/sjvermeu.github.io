Title: Switch to Gentoo sources
Date: 2017-08-22 19:04
Category: Gentoo
Tags: gentoo,hardened,grsecurity,selinux
Slug: switch-to-gentoo-sources

You've might already read it on the Gentoo news site, the [Hardened Linux kernel sources
are removed from the tree][1] due to the [grsecurity][2] change where the grsecurity
Linux kernel patches are no longer provided for free. The decision was made due to
supportability and maintainability reasons.

That doesn't mean that users who want to stick with the grsecurity related hardening
features are left alone. [Agostino Sarubbo has started providing sys-kernel/grsecurity-sources][3]
for the users who want to stick with it, as it is based on [minipli's unofficial patchset][4].
I seriously hope that the patchset will continue to be maintained and, who knows, even evolve further.

Personally though, I'm switching to the Gentoo sources, and stick with SELinux as one of the
protection measures. And with that, I might even start using my NVidia graphics card a bit more, 
as that one hasn't been touched in several years (I have an Optimus-capable setup with both an
Intel integrated graphics card and an NVidia one, but all attempts to use nouveau for the one game
I like to play - minecraft - didn't work out that well).

<!-- PELICAN_END_SUMMARY -->

**How secure is Gentoo sources with SELinux?**

It is hard to just say that one kernel tree or another is safe(r) or not. Security is not something
one can get with a simple check-list. It is a matter of properly configuring services and systems,
patching it when needed, limiting expoosure and what not.

A huge advantage of grsecurity was that it had very insightful and advanced protection measures
(many of them focusing on memory-related attacks), and prevented unwanted behavior from applications
(and users) in a very fine-grained manner. With SELinux, I can still prevent some unwanted behavior,
but it is important to know that SELinux and grsecurity's kernel hardening features are orthogonal
to each other. It is only the grsecurity RBAC model that is somewhat in competition with SELinux.

SELinux is able to define and manage behavior between types. However, within a single type, many
actions are not governed at all. SELinux can manage which types (domains) are able to invoke which
system calls, but once a call is allowed, SELinux doesn't do any additional controls anymore.

Loosing protection controls from grsecurity, as a security activist, is not something I like. But
on the other hand, I need to consider the wide SELinux using audience in Gentoo, who is most likely
going to switch to the gentoo sources as well (at least the majority of them).

Gentoo sources is not insecure by itself, as are many other kernel sources. A huge advantage is that
the gentoo sources are well maintained, so any kernel vulnerability that gets reported and fixed will
receive the proper fix in the Gentoo sources quickly as well (and if you think it can go even faster,
consider [becoming a Gentoo security padawan][5]. And with SELinux enabled, some additional security
controls can be implemented (the efficacy of it depends on the quality of the policy).

The [Kernel Self Protection Project][6] also aims to improve the Linux kernel security, and immediately
through upstreamed and accepted patches. This means that the protection measures, once in the kernel,
should remain inside (awkward regressions notwithstanding). I truly hope that the KSPP moves forward.
In the mean time, read up on the [Kernel Self-Protection][7] document to learn more about how to harden
the Linux kernel.

**So that's it, just one less security control?**

For now, there is no immediate substitute. But that doesn't mean that there is nothing one can do
to increase the secure state of a Linux desktop, workstation or even IoT device. Although remotely
executable exploits do pop up and exist, many vulnerabilities in the Linux kernel are mainly exploitable
through a local access pattern.

That means that vulnerabilities often can only be exploited through a local invocation (or through chaining
by using other vulnerabilities - often in completely different applications or services - in order to
execute the local malware). Hence, hardening of the entire system is extremely important.

Previously, I had an account with multiple SELinux roles assigned to it. Depending on what I wanted to
do, I transitioned to the right role (either through the ``newrole`` command, or through ``sudo`` which
has integrated SELinux support). With the switch to the gentoo sources, I decided to make it a bit
harder for malware on my system to work: i start using separate Linux accounts depending on the purpose
(which I call persona).

Developing SELinux policies is now done on a separate account, managing remote systems through another
account (although my servers use multi-factor authentication so there was already some additional safeguard
in place there), handling my side-work with another account, playing games with another account, etc.

It isn't that I don't trust SELinux for this (as each domain is well isolated and controlled). But SELinux
cannot prevent vulnerabilities within applications if the action/result of a succesfully exploited
vulnerability does not change the expected behavior of the application versus the other resources
on the system (and even there, the fine-grained approach of policies might not even be sufficiently
fine-grained, as SELinux uses labels, and many resources have the same label assigned).

Suppose some malware is able to capture me giving in my password, or is trying to phish for it. By
using separate accounts (with separate passphrazes of course) the impact is reduced a bit.

**Other things on the plate**

The change to different accounts was one thing I wanted to establish before switching to a new kernel
tree. There are other aspects that I want to investigate in the near future as well though.

First of all, I'm probably going to enable [U2F authentication][8] on my workstation as well for
all interactive accounts. It has been on my list for quite some time, and quickly going through the
publicly available fora doesn't reveal any major challenges to do so. Build the PAM module, update
the PAM service configurations and you're done. Hopefully. ;-)

Next, I'm going to play around a bit with [AddressSanitizer][9]. ASAN was incompatible with grsecurity,
but now that that's out of the way, there's no reason not to investigate it further. I am not going
to enable it for the kernel though (as some KSPP implemented measures are incompatible with ASAN as well),
and probably not for my complete workstation yet (even though it is sufficiently powerful to handle the major
performance impact).

I'm going to put some more focus on [Integrity Measurement Architecture support][10], although my main protection
measure with IMA - the TPM or Trusted Platform Module - has been fried (don't ask) so I can't use it anymore.
Perhaps I'm going to buy a very lightweight/small system with a TPM on it to continue development. We'll see.

My current knowledge of [seccomp][11] is fairly theoretical (with a few hands-on tutorials, but that's it). It
has been on my TODO list for some time to look in more depth to it. Perhaps this is the right time.


[1]: https://www.gentoo.org/news/2017/08/19/hardened-sources-removal.html
[2]: http://grsecurity.net/
[3]: https://blogs.gentoo.org/ago/2017/08/21/sys-kernel-grsecurity-sources-available/#utm_source=feed&utm_medium=feed&utm_campaign=feed
[4]: https://github.com/minipli/linux-unofficial_grsec
[5]: https://wiki.gentoo.org/wiki/Project:Security/Padawan_Process
[6]: https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project
[7]: https://www.kernel.org/doc/html/latest/security/self-protection.html
[8]: https://github.com/Yubico/pam-u2f
[9]: https://wiki.gentoo.org/wiki/AddressSanitizer
[10]: https://wiki.gentoo.org/wiki/Integrity_Measurement_Architecture
[11]: https://en.wikipedia.org/wiki/Seccomp


