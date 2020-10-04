Title: Dropping sesandbox support
Date: 2014-05-09 21:03
Category: Gentoo
Tags: Gentoo, hardened, policycoreutils, selinux, seunshare, vulnerability
Slug: dropping-sesandbox-support

A [vulnerability in
seunshare](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-3215),
part of `policycoreutils`, came to light recently (through [bug
509896](https://bugs.gentoo.org/show_bug.cgi?id=509896)). The issue is
within `libcap-ng` actually, but the specific situation in which the
vulnerability can be exploited is only available in `seunshare`.

Now, `seunshare` is not built by default on Gentoo. You need to define
`USE="sesandbox"`, which I implemented as an optional build because I
see no need for the `seunshare` command and the *SELinux sandbox
(sesandbox)* support. Upstream (Fedora/RedHat) calls it *sandbox*, which
Gentoo translates to *sesandbox* as it collides with the Gentoo sandbox
support otherwise. But I digress.

The build of the SELinux sandbox support is optional, mostly because we
do not have a direct reason to support it. There are no Gentoo users
that I'm aware of that use it. It is used to start an application in a
chroot-like environment, based on Linux namespaces and a specific
SELinux policy called `sandbox_t`. The idea isn't that bad, but I rather
focus on proper application confinement and full system enforcement
support (rather than specific services). The SELinux sandbox makes a bit
more sense when the system supports unconfined domains (and users are in
the `unconfined_t` domain), but Gentoo focuses on strict policy support.

Anyway, this isn't the first vulnerability in `seunshare`. In 2011,
another privilege escalation vulnerability was found in the application
(see [bug 374897](https://bugs.gentoo.org/show_bug.cgi?id=374897)).

But having a vulnerability in the application (or its interaction with
`libcap-ng`) doesn't mean an exploitable vulnerability. Most users will
not even have `seunshare`, and those that do have it will not be able to
call it if you are running with SELinux in *strict* or have
`USE="-unconfined"` set for the other policies. If `USE="unconfined"` is
set and you run *mcs*, *targeted* or *mls* (which isn't default either,
the default is *strict*) then if your users are still mapped to the
regular user domains (`user_t`, `staff_t` or even `sysadm_t`) then
`seunshare` doesn't work as the SELinux policy prevents its behavior
before the vulnerability is triggered.

Assuming you *do* have a *targeted* policy with users mapped to
`unconfined_t` and you have built `policycoreutils` with
`USE="sesandbox"` or you run in SELinux in permissive mode, then please
tell me if you can trigger the exploit. On my systems, `seunshare` fails
with the message that it can't drop its privileges and thus exits
(instead of executing the exploit code as it suggested by the reports).

Since I mentioned that most user don't use SELinux sandbox, and because
I can't even get it to work (regardless of the vulnerability), I decided
to drop support for it from the builds. That also allows me to more
quickly introduce the new userspace utilities as I don't need to
refactor the code to switch from `sandbox` to `sesandbox` anymore.

So, `policycoreutils-2.2.5-r4` and `policycoreutils-2.3_rc1-r1` are now
available which do not build `seunshare` anymore. And now I can focus on
providing the full *2.3* userspace that has been announced today.
