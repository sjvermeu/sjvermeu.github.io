Title: Can SELinux substitute DAC?
Date: 2015-08-09 14:48
Category: SELinux
Tags: selinux, refpolicy, linux, dac, lsm
Slug: can-selinux-substitute-dac

A nice [twitter discussion](https://twitter.com/sjvermeu/status/630107879123623936)
with [Erling Hellenäs](https://twitter.com/erlheldata) caught my full attention later
when I was heading home: Can SELinux substitute DAC? I know it can't and doesn't
in the current implementation, but why not and what would be needed?

SELinux is implemented through the [Linux Security Modules framework](https://en.wikipedia.org/wiki/Linux_Security_Modules)
which allows for different security systems to be implemented and integrated
in the Linux kernel. Through LSM, various security-sensitive operations can be
secured further through _additional_ access checks. This criteria was made to
have LSM be as minimally invasive as possible.

<!-- PELICAN_END_SUMMARY -->

**The LSM design**

The basic LSM design paper, called [Linux Security Modules: General Security
Support for the Linux Kernel](http://www.kroah.com/linux/talks/usenix_security_2002_lsm_paper/lsm.pdf)
as presented in 2002, is still one of the better references for learning and
understanding LSM. It does show that there was a whish-list from the community
where LSM hooks could override DAC checks, and that it has been partially
implemented through permissive hooks (not to be mistaken with SELinux' 
permissive mode).

However, this definitely is _partially_ implemented because there are quite
a few restrictions. One of them is that, if a request is made towards a
resource and the UIDs match (see page 3, figure 2 of the paper) then
the LSM hook is not consulted. When they don't match, a permissive LSM
hook can be implemented. Support for permissive hooks is implemented
for capabilities, a powerful DAC control that Linux supports and which is
implemented [through LSM](http://www.hep.by/gnu/kernel/lsm/cap.html) as
well. I have [blogged](http://blog.siphos.be/tag/capabilities/index.html)
about this nice feature a while ago.

These restrictions are also why some other security-conscious developers,
such as [grsecurity's team](http://grsecurity.net/lsm.php) and [RSBAC](https://www.rsbac.org/documentation/why_rsbac_does_not_use_lsm)
do not use the LSM system. Well, it's not only through these restrictions
of course - other reasons play a role in them as well. But knowing what
LSM can (and cannot) do also shows what SELinux can and cannot do.

The LSM design itself is already a reason why SELinux cannot substitute
DAC controls. But perhaps we could disable DAC completely and thus only
rely on SELinux?


**Disabling DAC in Linux would be an excessive workload**

The discretionary access controls in the Linux kernel are not easy to remove.
They are often part of the code itself (just grep through the source code
after `-EPERM`). Some subsystems which use a common standard approach (such
as VFS operations) can rely on good integrated security controls, but these
too often allow the operation if DAC allows it, and will only consult the LSM
hooks otherwise.

VFS operations are the most known ones, but DAC controls go beyond file access.
It also entails reading program memory, sending signals to applications,
accessing hardware and more. But let's focus on the easier controls (as in,
easier to use examples for), such as sharing files between users, restricting
access to personal documents and authorizing operations in applications based
on the user id (for instance, the owner can modify while other users can only
read the file).

We could "work around" the Linux DAC controls by running everything as a single user
(the root user) and having all files and resources be fully accessible by this
user. But the problem with that is that SELinux would not be able to take
over controls either, because you will need some user-based access controls,
and within SELinux this implies that a mapping is done from a user to a 
SELinux user. Also, access controls based on the user id would no longer work,
and unless the application is made SELinux-aware it would lack any authorization
system (or would need to implement it itself).

With DAC Linux also provides quite some "freedom" which is well established
in the Linux (and Unix) environment: a simple security model where the user
and group membership versus the owner-privileges, group-privileges and
"rest"-privileges are validated. Note that SELinux does not really know
what a "group" is. It knows SELinux users, roles, types and sensitivities.

So, suppose we would keep multi-user support in Linux but completely remove
the DAC controls and rely solely on LSM (and SELinux). Is this something
reusable?

**Using SELinux for DAC-alike rules**

Consider the use case of two users. One user wants another user to read a few
of his files. With DAC controls, he can "open up" the necessary resources
(files and directories) through [extended access control lists](https://wiki.gentoo.org/wiki/Filesystem/Access_Control_List_Guide)
so that the other user can access it. No need to involve administrators.

With a MAC(-only) system, updates on the MAC policy usually require the security
administrator to write additional policy rules to allow something. With SELinux
(and without DAC) it would require the users to be somewhat isolated from each
other (otherwise the users can just access everything from each other), which
SELinux can do through [User Based Access Control](https://wiki.gentoo.org/wiki/SELinux/Constraints#UBAC_-_User_Based_Access_Control),
but the target resource itself should be labeled with a type that is not managed
through the UBAC control. Which means that the users will need the privilege to
change labels to this type (which is possible!), _assuming_ such a type is already
made available for them. Users can't create new types themselves.

UBAC is by default disabled in many distributions, because it has some nasty
side-effects that need to be taken into consideration. Just recently one of these
[came up on the refpolicy mailinglist](http://oss.tresys.com/pipermail/refpolicy/2015-August/007704.html).
But even with UBAC enabled (I have it enabled on most of my systems, but considering
that I only have a couple of users to manage and am administrator on these systems
to quickly "update" rules when necessary) it does not provide equal functionality as
DAC controls.

As mentioned before, SELinux does not know group membership. In order to create
something group-like, we will probably need to consider roles. But in SELinux,
roles are used to define what types are transitionable towards - it is not a
membership approach. A type which is usable by two roles (for instance, the
`mozilla_t` type which is allowed for `staff_r` and `user_r`) does not care about
the role. This is unlike group membership.

Also, roles only focus on _transitionable_ types (known as domains). It does not
care about _accessible_ resources (regular file types for instance). In order to
allow one person to read a certain file type but not another, SELinux will need
to control that one person can read this file through a particular domain while
the other user can't. And given that domains are part of the SELinux policy, any
situation that the policy has not thought about before will not be easily adaptable.

**So, we can't do it?**

Well, I'm pretty sure that a very extensive policy and set of rules can be made
for SELinux which would make a number of DAC permissions obsolete, and that we could
theoretically remove DAC from the Linux kernel.

End users would require a huge training to work with this system, and it would not
be reusable across other systems in different environments, because the policy
will be too specific to the system (unlike the current reference policy based ones,
which are quite reusable across many distributions).

Furthermore, the effort to create these policies would be extremely high, whereas
the DAC permissions are very simple to implement, and have been proven to be
well suitable for many secured systems. 

So no, unless you do massive engineering, I do not believe it is possible to
substitute DAC with SELinux-only controls.

