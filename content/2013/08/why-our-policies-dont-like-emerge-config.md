Title: Why our policies don't like emerge --config
Date: 2013-08-23 11:53
Category: Gentoo
Tags: Gentoo, pkg_config, portage, selinux
Slug: why-our-policies-dont-like-emerge-config

One of the features that Portage provides is to have post-processing
done on request of the administrator for certain packages. For instance,
for the `dev-db/postgresql-server` package we can call its
`pkg_config()` phase to create the PostgreSQL instance and configure it
so that the configuration of the database is stored in
`/etc/postgresql-9.2` rather than together with the data files.

When you run Gentoo with SELinux however, you might already have noticed
that this doesn't work. The reason is that, whenever an administrator
calls **emerge**, the process (and by default its child processes) will
run in a confined domain called `portage_t`. The domain is still quite
privileged, but not as privileged as the administrator domain
`sysadm_t`. It holds the rights to build software and install files,
directories and other things on the file system. But it does not support
switching users for instance, which is what the PostgreSQL
`pkg_config()` does: it wants to run a certain command as the `postgres`
user, which is prohibited by SELinux.

I'm not sure yet how to tackle this properly. One thing is that I might
update Portage to run in the user domain by default, and transition
dynamically towards the proper domains according to the task(s) it is
executing. We already do this for building software (where we transition
to a `portage_sandbox_t` confined domain), perhaps it can be expanded to
support transitioning to `portage_t` when it isn't running the
`pkg_config()` phase. But that means injecting (more) SELinux-specific
code in Portage, something I'd rather not do (introduces additional
complexity and maintenance).

Another possibility would be to have administrators explicitly state
that no transition should occur, like so:

    ~# runcon -t sysadm_t emerge --config =dev-db/postgresql-server-9.2.4

With a minor addition to the policy, this gave me a good hope... until I
noticed that **emerge** underlyingly calls **ebuild** and **ebuild.sh**,
both labeled as `portage_exec_t`, so these calls transition to
`portage_t` again.

I'm going to look further into this - there are quite a few options
still open.
