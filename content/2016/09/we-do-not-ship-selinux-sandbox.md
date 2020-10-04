Title: We do not ship SELinux sandbox
Date: 2016-09-27 20:47
Category: SELinux
Tags: selinux, sandbox, gentoo, vulnerability, seunshare
Slug: we-do-not-ship-selinux-sandbox

A few days ago a vulnerability was reported in the SELinux sandbox user space
utility. The utility is part of the `policycoreutils` package. Luckily, Gentoo's
`sys-apps/policycoreutils` package is not vulnerable - and not because we were
clairvoyant about this issue, but because we don't ship this utility.

<!-- PELICAN_END_SUMMARY -->

**What is the SELinux sandbox?**

The SELinux sandbox utility, aptly named `sandbox`, is a simple C application which
executes its arguments, but only after ensuring that the task it launches is
going to run in the `sandbox_t` domain.

This domain is specifically crafted to allow applications most standard privileges
needed for interacting with the user (so that the user can of course still use the
application) but removes many permissions that might be abused to either obtain 
information from the system, or use to try and exploit vulnerabilities to gain
more privileges. It also hides a number of resources on the system through
namespaces.

It was [developed in 2009](http://danwalsh.livejournal.com/28545.html) for Fedora
and Red Hat. Given the necessary SELinux policy support though, it was usable on
other distributions as well, and thus became part of the SELinux user space itself.

**What is the vulnerability about?**

The SELinux sandbox utility used an execution approach that did not shield off
the users' terminal access sufficiently. In the [POC post](http://www.openwall.com/lists/oss-security/2016/09/25/1)
we notice that characters could be sent to the terminal through the `ioctl()`
function (which executes the ioctl system call used for input/output operations
against devices) which are eventually executed when the application finishes.

That's bad of course. Hence the CVE-2016-7545 registration, and of course also
a possible [fix has been committed upstream](https://github.com/SELinuxProject/selinux/commit/acca96a135a4d2a028ba9b636886af99c0915379).

**Why isn't Gentoo vulnerable / shipping with SELinux sandbox?**

There's some history involved why Gentoo does not ship the SELinux sandbox (anymore).

First of all, Gentoo already has a command that is called `sandbox`, installed through
the `sys-apps/sandbox` application. So back in the days that we still shipped with
the SELinux sandbox, we continuously had to patch `policycoreutils` to use a
different name for the sandbox application (we used `sesandbox` then).

But then we had a couple of security issues with the SELinux sandbox application.
In 2011, [CVE-2011-1011](http://www.cvedetails.com/cve/CVE-2011-1011/)
came up in which the `seunshare_mount` function had a security issue. And in 2014,
[CVE-2014-3215](http://www.cvedetails.com/cve/CVE-2014-3215/) came up with - again -
a security issue with `seunshare`.

At that point, I had enough of this sandbox utility. First of all, it never quite worked
enough on Gentoo as it is (as it also requires a policy which is not part of the
upstream release) and given its wide open access approach (it was meant to contain
various types of workloads, so security concessions had to be made), I decided to
[no longer support the SELinux sandbox in Gentoo](http://blog.siphos.be/2014/05/dropping-sesandbox-support/).

None of the Gentoo SELinux users ever approached me with the question to add it back.

And that is why Gentoo is not vulnerable to this specific issue.

