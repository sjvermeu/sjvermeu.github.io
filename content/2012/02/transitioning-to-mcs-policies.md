Title: Transitioning to MCS policies
Date: 2012-02-24 22:12
Category: SELinux
Slug: transitioning-to-mcs-policies

Since I started maintaining the [SELinux
policies](http://hardened.gentoo.org/selinux) for [Gentoo
Hardened](http://hardened.gentoo.org), the policy types we supported
were primarily `strict` and `targeted`. About half a year ago, we also
started supported `mcs` and offered the possibility for using `mls` as
well (but didn't really support that one).

With the recent release of the newer userspace utilities, we found out
that Gentoo Hardened is one of the few distributions that still really
supports policy types without levels (MCS and MLS have support for
levels, strict and targeted don't) as libsemanage had a failure when
running simple activities on a system without level support. The fix is
fairly trivial, but it does gave me the signal to start moving towards
MCS.

So, now that the new userspace utilities are in the hardened-dev overlay
(please test them ;-) I will now focus on the 2.20120215 policy release,
getting that in good shape (forward-porting the patches that haven't
made it to the refpolicy repository yet) and then see how we can
transition users from strict or targeted to MCS (documentation, upgrade
guide and software or packages when needed) so that we are up to par
with the majority of other distributions.

I personally like the strict policy type as it is fairly simple to
explain to users, but I'm sure I can deal with MCS and (in the future)
MLS equally well ;-)
