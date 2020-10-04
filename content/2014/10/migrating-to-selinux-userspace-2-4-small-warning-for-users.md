Title: Migrating to SELinux userspace 2.4 (small warning for users)
Date: 2014-10-30 19:44
Category: Gentoo
Tags: cil, Gentoo, migrate, selinux, semanage, upgrade, userspace
Slug: migrating-to-selinux-userspace-2-4-small-warning-for-users

In a few moments, SELinux users which have the \~arch KEYWORDS set
(either globally or for the SELinux utilities in particular) will notice
that the SELinux userspace will upgrade to version 2.4 (release
candidate 5 for now). This upgrade comes with a manual step that needs
to be performed after upgrade. The information is mentioned as
post-installation message of the `policycoreutils` package, and
basically sais that you need to execute:

    ~# /usr/libexec/selinux/semanage_migrate_store

The reason is that the SELinux utilities expect the SELinux policy
module store (and the semanage related files) to be in
`/var/lib/selinux` and no longer in `/etc/selinux`. Note that this does
not mean that the SELinux policy itself is moved outside of that
location, nor is the basic configuration file (`/etc/selinux/config`).
It is what tools such as **semanage** manage that is moved outside that
location.

I tried to automate the migration as part of the packages themselves,
but this would require the `portage_t` domain to be able to move,
rebuild and load policies, which it can't (and to be honest, shouldn't).
Instead of augmenting the policy or making updates to the migration
script as delivered by the upstream project, we currently decided to
have the migration done manually. It is a one-time migration anyway.

If for some reason end users forget to do the migration, then that does
not mean that the system breaks or becomes unusable. SELinux still
works, SELinux aware applications still work; the only thing that will
fail are updates on the SELinux configuration through tools like
**semanage** or **setsebool** - the latter when you want to persist
boolean changes.

    ~# semanage fcontext -l
    ValueError: SELinux policy is not managed or store cannot be accessed.

    ~# setsebool -P allow_ptrace on
    Cannot set persistent booleans without managed policy.

If you get those errors or warnings, all that is left to do is to do the
migration. Note in the following that there is a warning about 'else'
blocks that are no longer supported: that's okay, as far as I know (and
it was mentioned on the upstream mailinglist as well as not something to
worry about) it does not have any impact.

    ~# /usr/libexec/selinux/semanage_migrate_store
    Migrating from /etc/selinux/mcs/modules/active to /var/lib/selinux/mcs/active
    Attempting to rebuild policy from /var/lib/selinux
    sysnetwork: Warning: 'else' blocks in optional statements are unsupported in CIL. Dropping from output.

You can also add in `-c` so that the old policy module store is cleaned
up. You can also rerun the command multiple times:

    ~# /usr/libexec/selinux/semanage_migrate_store -c
    warning: Policy type mcs has already been migrated, but modules still exist in the old store. Skipping store.
    Attempting to rebuild policy from /var/lib/selinux

You can manually clean up the old policy module store like so:

    ~# rm -rf /etc/selinux/mcs/modules

So... don't worry - the change is small and does not break stuff. And
for those wondering about CIL I'll talk about it in one of my next
posts.
