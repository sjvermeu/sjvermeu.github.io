Title: A SELinux policy for incron: finishing up
Date: 2013-05-31 03:50
Category: SELinux
Tags: incron, policy, selinux
Slug: a-selinux-policy-for-incron-finishing-up

After 9 posts, it's time to wrap things up. You can review the final
results online
([incron.te](http://dev.gentoo.org/~swift/blog/01/incron.te.txt),
[incron.if](http://dev.gentoo.org/~swift/blog/01/incron.if.txt) and
[incron.fc](http://dev.gentoo.org/~swift/blog/01/incron.fc.txt)) and
adapt to your own needs if you want. But we should also review what we
have accomplished so far...

We built the start of an entire policy for a daemon (the inotify cron
daemon) for two main types: the daemon itself, and its management
application **incrontab**. We defined new types and contexts, we used
attributes, declared a boolean and worked with interfaces. That's a lot
to digest, and yet it is only a part of the various capabilities that
SELinux offers.

The policy isn't complete though. We defined a type called
`incron_initrc_exec_t` but don't really use it further. In practice, we
would need to define an additional interface (probably named
*incron\_admin*) that allows users and roles to manage *incron* without
needing to grant this user/role `sysadm_r` privileges. I leave that up
to you as an exercise for now, but I'll post more about admin interfaces
and how to work with them on a system in the near future.

We also made a few assumptions and decisions while building the policy
that might not be how you yourself would want to build the policy.
SELinux is a MAC system, but the policy language is very flexible. You
can use an entirely different approach in policies if you want. For
instance, *incron* supports launching the **incrond** as a command-line,
foreground process. This could help users run **incrond** under their
privileges for their own files - we did not consider this case in our
design. Although most policies try to capture all use cases of an
application, there will be cases when a policy developer did either not
consider the use case or found that it infringed with his own principles
on policy development (and allowed activities on a system).

In Gentoo Hardened, I try to write down the principles and policies that
we follow in a [Gentoo Hardened SELinux Development
Policy](http://www.gentoo.org/proj/en/hardened/selinux-policy.xml)
document. As decisions need to be taken, such a document might help find
common consensus on how to approach SELinux policy development further,
and I seriously recommend that you consider writing up a similar
document yourself, especially if you are going to develop policies for a
larger organization.

One of the deficiencies of the current policy is that it worked with the
unmodified *incron* version. If we would patch *incron* so that it could
change context on executing the incrontab files of a user, then we can
start making use of the default context approach (and perhaps even
enhance with PAM services). In that case, user incrontabs could be
launched entirely from the users' context (like `user_u:user_r:user_t`)
instead of the `system_u:system_r:incrond_t` or transitioned
`system_u:system_r:whatever_t` contexts. Having user provided commands
executed in the system context is a security risk, so in our policy we
would *not* grant the *incron\_role* to untrusted users - probably only
to `sysadm_t` and even then he probably would be better with using the
`/etc/incron.d` anyway.

The downside of patching code however is that this is only viable if
upstream wants to support this - otherwise we would need to maintain the
patches ourselves for a long time, creating delays in releases (upstream
released a new version and we still need to reapply and refactor
patches) and removing precious (human) resources from other, Gentoo
Hardened/SELinux specific tasks (like bugfixing and documentation
writing ;-)

Still, the policy returned a fairly good view on how policies *can* be
developed. And as I said, there are still other things that weren't
discussed, such as:

-   Build-time decisions, which can change policies based on build
    options of the policy. In the reference policy, this is most often
    used for distribution-specific choices: if Gentoo would use one
    approach and Redhat another, then the differences would be separated
    through `` ifdef(`distro_gentoo',`...') `` and
    `` ifdef(`distro_redhat',`...') `` calls.
-   Some calls might only be needed if another policy is loaded. I think
    all calls made currently are part of base modules, so can be
    expected to be available at all times. But if we would need
    something like *icecast\_signal(incrond\_t)*, then we would need to
    put that call inside a `` optional_policy(`...') `` statement.
    Otherwise, our policy would fail to load because the *icecast*
    SELinux policy isn't loaded.
-   We could even introduce specific statements like *dontaudit* or
    *neverallow* to fine-tune the policy. Note though that *neverallow*
    is a compile-time statement: it is not a way to negate *allow*
    rules: if there is one *allow* that would violate the *neverallow*,
    then that module just refuses to build.

Furthermore, if you want to create policies to be pushed upstream to the
reference policy project, you will need to look into the
[StyleGuide](http://oss.tresys.com/projects/refpolicy/wiki/StyleGuide)
and
[InterfaceNaming](http://oss.tresys.com/projects/refpolicy/wiki/InterfaceNaming)
documents as those define the order that rules should be placed and the
name syntax for interfaces. I have been contributing a lot to the
reference policy and I still miss a few of these, so for me they are not
that obvious. But using a common style is important as it allows for
simple patching, code comparison and even allows us to easily read
through complex policies.

If you don't want to contribute it, but still use it on your Gentoo
system, you can use a simple ebuild to install the files. Create an
ebuild (for instance `selinux-incron`), put the three files in the
`files/` subdirectory, and use the following ebuild code:

    # Copyright 1999-2013 Gentoo Foundation
    # Distributed under the terms of the GNU General Public License v2
    # $Header$
    EAPI="4"

    IUSE=""
    MODS="incron"
    BASEPOL="2.20130424-r1"
    POLICY_FILES="incron.te incron.fc incron.if"

    inherit selinux-policy-2

    DESCRIPTION="SELinux policy for incron, the inotify cron daemon"

    KEYWORDS="~amd64 ~x86"

When installed, the interface files will be published as well and can
then be used by other modules (something we couldn't do in the past few
posts) or by the **selocal** tool.
