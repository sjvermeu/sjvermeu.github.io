Title: Gentoo Hardened on the move
Date: 2012-07-26 00:41
Category: Gentoo
Slug: gentoo-hardened-on-the-move

Gentoo Hardened is thriving and going forward. For those that don't
exactly know what [Gentoo Hardened](http://hardened.gentoo.org) is - it
is a Gentoo project dedicated to bring Gentoo in a shape ready for
highly secure, high stability production server environments. This is
what we live by, and why we do what we do. To accomplish this goal, we
use a great community of developers & users that work on several
subprojects: the implementation of kernel hardening features such as
grSecurity, memory-based protection schemes such as PaX, toolchain
updates to harden against buffer overflows and memory attacks, mandatory
access control schemes such as SELinux and RSBAC.

In Gentoo Hardened we then integrate these technologies in Gentoo Linux
so that it is usable by a larger community, well documented and
supported. I'm myself heavily working on the SELinux integration &
documentation aspects, and am hoping to contribute even further - but
more about that in a minute.

Today, we had an online meeting where developers present their current
"state of affairs" and the upcoming things they are going to work on.
This is done about once every month in the IRC chat channel
\#gentoo-hardened on the freenode network. Of course, most of the
developers are available on the chat channel on an (almost) daily basis.

Todays meeting gave us feedback on the following (and remind you, this
is one month of volunteer-driven work)...

**Toolchain**

When we talk about the toolchain, we mean the set of tools and libraries
needed to build a (hardened) system. We put most focus on the GCC
compiler because it contains most of the changes we support (like stack
smashing protection, position independent code/executable changes, etc.)
but work on libraries like glibc and uclibc are on their way as well.

Zorry (yeah, I'm going to use nicknames here so you know who you're
talking to on IRC ;-) is working on getting our patches upstream
(meaning that the main GCC development can incorporate our patches).
Sending and working together with the main projects is very important as
it provides not only continuity on the patches (once they are upstream,
more people are maintaining the code than just you/us), but also gives a
multi-eye view on the code: is it of high quality? Does it comply with
the proper security guidelines? What about impact of the code on things
we don't or haven't considered yet?

On the library part, blueness (one of our Gentoo Hardened developers and
- imho - an expert in many fields) has been working on Hardened support
on ARM (armv7a) with uclibc. He has put up stage4 files for armv7a
softfloat uclibc hardened and is working on those for hardfloat. This
means that ARM with uclibc+hardened or ARM with glibc+hardened are
working - he has even tested an xfce4 desktop on ARM with uclibc and
hardened toolchain.

ARM support is becoming more and more important in the technology field.
Other major processor players like SPARC, Itanium, PowerPC, ... are
slowly seeing less and less market share, whereas ARM - albeit currently
still a very small player - is rapidly gaining momentum. You all know
ARM from the smartphones and other embedded-like platforms, but ARM on
servers is coming faster than you expect. Being a simple platform with
low energy consumption and good commercial backing (both on CPU level as
well as platform support), we can see ARM becoming a major player on
this - and Gentoo Hardened is actively working towards it.

**Kernel**

Within Gentoo Hardened, we support the
[grSecurity](https://grsecurity.net/) and
[PaX](https://pax.grsecurity.net/) kernel patches for a more hardened
Linux kernel. But this additional hardening can also sometimes interfere
with the normal functioning of systems. To help users in their
configuration quest, grSecurity allows users to select a few "prebuilt
configuration types" in the kernel build.

Previously, these types where one of the following label:
"virtualization", "workstation" or "server". Based on these labels, the
security settings that did not negatively effect the functioning of the
system were selected. Recently, the labels have changed into a
question-based configuration: is it a server or not? will you use it for
virtualization and if so, on host or guest? Is performance for you more
important than security? These questions are now also
[integrated](http://archives.gentoo.org/gentoo-hardened/msg_00005.xml)
in our hardened-sources.

While working and testing one of the kernel settings (KERNEXEC - kernel
non-executable pages, to protect non-code containing memory pages from
being used to run (potentially hostile/injected) code from) in a
virtualized environment, prometheanfire (another Gentoo Hardened
developer) noticed a possible regression on the performance of guests if
the host had KERNEXEC set. A severe performance hit is to be expected if
the host processor doesn't support hardware-assisted nested page tables
(a method for supporting memory page virtualization), but this also
seemed to occur on systems with nested page tables (`/proc/cpuinfo` flag
`ept` for Intel, or `rvi` for AMD). So more testing (from others as
well) is therefore needed to confirm and work on this.

**SELinux**

One of Gentoo Hardened's subprojects (and one I'm most actively working
on) is its support for SELinux or Security Enhanced Linux. It offers a
Mandatory Access Control implementation for Linux, ensuring that users
cannot change the security settings that an administrator has set (which
is Discretionary Access Control if they can), but also enforce that
services/processes can not be forced to do things they are not meant to
do. This provides reasonable protection against things like remote code
execution exploits, or just limit what an administrator wants particular
processes to do. With SELinux, you can even define roles to properly
identify and segregate tasks, providing a method for "segregation of
duties" on OS level.

Anyway, as I said, Gentoo Hardened is actively working on SELinux
integration. First of all is stages support (providing a small,
deployable system unit that users can use to install a SELinux-enabled
system) as currently, users are forced to switch to SELinux after having
installed Gentoo, which is a [multi-step
approach](http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml?part=2&chap=1).
By offering stages, we can simplify the deployment of Gentoo Hardened
SELinux. Currently, building stages works but requires some manual steps
(labeling mostly) which need to be removed before we can automatically
build stages. The next steps here are to see if we can build SELinux
stages on non-SELinux systems (as all we need is to link the proper
files with the SELinux-supporting libraries, which should work
regardless of SELinux being enabled or not). The fact that users need to
relabel their system during deployment is just a minor inconvenience
(and a one-command fix, so easy to document too).

Another item of progression made is a SELinux-enabled (well, Gentoo
Hardened grSecurity with PaX and SELinux enforcing enabled) [virtual
image](http://distfiles.gentoo.org/experimental/amd64/qemu-selinux/)
called "selinuxnode". This Qemu/KVM image is a simple Gentoo base
installation but with those security features already enabled, allowing
users to take a first look at SELinux before trying it out on their own
system. But this image has the potential (and now roadmap ;-) to become
much more:

-   Provide a play-ground for users to test things in. Try out hammering
    the SELinux policy, or reproducing potential issues before reporting
    them (to make sure they are easily reproduceable).
-   Become a Proof-of-Concept location for new enhancements: not only
    updates on SELinux, but also on other hardening measures and
    technologies that Gentoo Hardened can support. Implementing the
    technologies in the VM allow other developers to test and work on it
    without needing to sacrifice one of their own systems.
-   Become the main system for educational (course-like) documentation.
    If we develop HOWTO documents, using this VM as a base allows users
    to follow the instructions to the letter and try things out while
    keeping the documentation consistent. The documentation can, in the
    future, also contain instructions that users need to follow as a
    sort-of test. At the end of the test, a simple script can easily
    verify on the VM if the test was finished succesfully or not.

Even further down the road, it might evolve into a system for building
appliance-like, hardened services based on Gentoo Hardened. But that's a
milestone too far for now. But you can always dream ;-)

On the SELinux policy development side, I'm recently focusing on two
aspects: the change towards `/run` (which already required a few
"urgent" updates and will probably need a lot more) as well as confining
popular attack surfaces like browsers. Not many SELinux users run their
browser in a confined space, but I personally don't run anything in
unconfined domains and feel that browsers are too popular in the
security area to not put attention to. So I'm struggling to have the
browsers (first focus is Chromium as that one has an open bug for it,
and Firefox because that is my main browser platform) fully confined yet
still flexible enough (using SELinux booleans) to support users that
have other wishes on their browsers.

Speaking of policy development, in the meeting it was also brought
forward to support a change of stabilization of SELinux policies from
the standard 30-days towards a 14-day stabilization period. In most
cases, this doesn't harm users as policies are usually enhanced (allow
something that was denied before) and less about reducing privileges (as
it is quite hard to find out why a rule was enabled in the first place,
hence our reluctant approach to "quickly" update policies). For such
updates, We're suggesting a 14-day stabilization period, while retaining
30 days for larger updates such as domain policy rewrites (which are
sometimes needed if an application changes too much - think init and
systemd - or when its segregated into multiple parts that each need (or
can have) their own SELinux domain.

Finally, we gave a quick update on our status for upstream support (as I
mentioned before, having patches supported and accepted upstream is very
important for us): we have 116 changesets to the policy in comparison
with the 20120215 refpolicy release (which is our "upstream"). Of those
changesets, 45 have been accepted and implemented upstream, 12 are
pending. 55 have not been sent yet (because they still need work or more
documentation before they can be accepted) and 4 will not be sent
(mostly because they are gentoo-only or deviate from upstream's
acceptance guidelines but fit in Gentoo's approach).

**grSecurity's PaX**

Blueness worked on the *xattr pax* support implementation (using
extended attributes to store and manage the PaX flags, rather than using
the ELF header changes used in the past) within Gentoo Hardened. This is
now production-ready, so the proper tools will be made generally
available shortly whereas the older method (mainly chpax) will be
decommissioned in the very near future.

PaX markings allow the Linux kernel to toggle specific PaX settings on
or off for processes so that the general state of the system can use the
PaX protections while a very few set of programs that cannot work with
these settings (often binary software or third party software, but some
self-built software can have difficulties with PaX as well) can run
without them (or with a lower set). This is much more flexible than an
all-or-nothing approach. By using extended attributes, managing these
markings can be done without modifying the binaries themselves. In
Gentoo, proper support is also given through the `paxctl-ng.eclass` so
developers can automatically set markings at deploy-time when needed.

**Profiles**

In Gentoo, users select "profiles" as a way to define the defaults for
their system. Profiles define stuff like the default kernel, C library,
specific USE flags, toolchain, etc. For instance, users that want to use
a Gentoo Hardened system with SELinux on an x86\_64 system with
no-multilib (all 64-bit only) select the
hardened/linux/amd64/no-multilib/selinux profile.

In the last few weeks, blueness has been working on the uclibc-related
profiles (hardened/linux/uclibc/\${ARCH}) using a clean slate. Gentoo
supports profile inheritance, so you can "stack" one profile on top of
the other. This is great for manageability, but when the profile is to
support systems that are quite different from what Gentoo developers are
used to, it makes sense to use a clean setup and start from there. And
this is the case for hardened uclibc systems.

**System integrity subproject**

On this meeting the initial kick-off (after approval) was given of a new
hardened subproject called *system integrity*. This project will focus
on the implementation and support of integrity-related technologies such
as (well, mainly) [Linux IMA/EVM](http://linux-ima.sf.net) and its
supporting userspace utilities and documentation. Integrity validation &
enforcement is an important aspect of system security and, since I
already work with SELinux, feel this is a natural improvement (since you
need a MAC to enforce runtime security and use integrity to enforce
detection and prevention of offline tampering).

We have great plans with IMA/EVM here, and can hopefully introduce the
first few steps towards it in the selinuxnode virtual image soon ;-)

**Documentation**

Of course, technologies are great, but documentation is always needed
(even if nobody reads it (sic)). I have been documenting hardening of
some settings/services using the XCCDF/OVAL languages (part of the
[SCAP](https://wiki.gentoo.org/wiki/SCAP) set of standards) since not
only do they provide the means to generate guides (we can generate
guides in every language, XCCDF is probably the least flexible of them
all) but they also support the validation of the settings in an
automated manner.

By using XCCDF/OVAL-supporting software such as
[Open-SCAP](http://open-scap.org/page/Main_Page)
(`app-forensics/openscap` in Gentoo) you can interpret these guides in
an unattended manner, generating reports on the state of your services
compared to these guides, and even have specific profiles (one system
uses a different set of hardening guidelines than another). Since Gentoo
Hardened is about supporting secure & stable production environments, it
is logical that we can offer best practices on how to handle
Gentoo-provided/supported services. And by using these within the SCAP
standard, the guides might even be leveraged further than a regular
online HOWTO could.

**And all that from one project?**

Not really. Gentoo Hardened here plays several roles: integrator for
technologies that are managed in other (free software) projects, and
development for technologies or settings that are either specific to
Gentoo or not available to the public to the extend Gentoo Hardened
believes is needed. You must understand this is possible thanks to the
tremendous effort that all these projects perform. Gentoo Hardened here
plays the role that every Linux distribution has: making all these
technologies and advancements fit in a way that the users can easily
work with it - integrated and well supported.

Thanks to the free software nature though, Gentoo Hardened does more
than what "commercial integrators" do when they deal with closed,
propriatary software: it updates the code, improves it and brings it
back for broader re-use. As such, it also acts a bit as development
within those projects to assist them in their quest. And in my book,
users are more likely to believe in an integrator that can react
code-wise rather than using workarounds or "helping create a service
request".

The full excerpts of this meeting (the meeting minutes - well, actually
an IRC chat log excerpt) will be sent out soon by the Gentoo Hardened
project lead, Zorry. Big thanks to him (and the rest of the crew) to
make all this happen! I love to be part of it, and hope I can remain so
for a long, long time.

*Edit:* [RSBAC](http://www.rsbac.org/), not grSecurity's RBAC.
