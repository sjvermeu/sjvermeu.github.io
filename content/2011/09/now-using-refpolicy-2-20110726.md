Title: Now using refpolicy 2.20110726
Date: 2011-09-04 20:38
Category: Gentoo
Slug: now-using-refpolicy-2-20110726

A few days ago, I committed the SELinux policy modules that are based on
the 2.20110726 set released upstream. For those that are using Gentoo
Hardened with SELinux, you'll find them if you use the \~arch set for
the `sec-policy` category.

When I talk about upstream, it usually is the [reference
policy](http://oss.tresys.com/projects/refpolicy) as maintained by
[Tresys](http://www.tresys.com/). This project, often abbreviated to
*refpolicy*, tries to maintain a set of SELinux policies that are useful
for the majority of Linux distributions. In fact, most (if not all)
Linux distributions that support SELinux base their policies on the
refpolicy.

Now maintaining a reference policy for SELinux is not that easy, even
with the contributions of many distributions and developers. Since the
policy is used for many distributions (including [RedHat Enterprise
Linux](https://www.redhat.com/rhel/server/features/benefits.html)) it is
vital that presented changes are only accepted if truly necessary (and
do not present additional security risks). That means that patches
should be well documented and easy to read. Patches that lack a proper
motivation and that are not trivial are not accepted.

When distributions want to push updates on the policy to the refpolicy,
they need to send the patches to the [refpolicy
mailinglist](http://oss.tresys.com/pipermail/refpolicy/). There they are
picked up and analyzed and eventually added to the release.

For [Gentoo Hardened's SELinux
project](http://hardened.gentoo.org/selinux), getting (the majority of)
our own patches in the reference policy is important, mainly because we
currently lack the manpower to maintain a huge patch set ourselves.
Every time a new release is made by the reference policy, we need to
re-apply (and redevelop) our own patches. For a small set of patches,
this isn't a lot of work, but the more changes you include, the more
time-consuming this "patch forwarding" becomes. Of course, by quickly
pushing out our patches we also get the confirmation (or rejection) of
the patch, allowing us to be certain that we are on the right track.
After all, it is a *security policy* that we are talking of.

Now, the reference policy is just one of "our upstreams". A second
important project - also governed by the Tresys organization - is what
is called the [SELinux
Userspace](http://userspace.selinuxproject.org/trac). This project
maintains the tools necessary to build the SELinux policy from readable
text for humans to interpretable binary blobs for the Linux kernel. It
maintains the tools that help us modify the policies' runtime behavior
(using conditionals), manage file contexts and more. As this tool
interacts intimately with the SELinux internals, development of these
tools is discussed on the [SELinux
mailinglist](http://www.nsa.gov/research/selinux/list.shtml) offered by
the NSA.

It is the SELinux userspace project that provides tools like
**semanage**, **semodule**, **restorecon**, **chcon**, etc.

So next time you hear me talk about upstream, you know what it is.
