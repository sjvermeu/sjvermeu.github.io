Title: If things are weird, check for policy.29
Date: 2014-04-17 21:01
Category: SELinux
Tags: load_policy, policy, selinux, semanage
Slug: if-things-are-weird-check-for-policy-29

Today we analyzed a weird issue one of our SELinux users had with their
system. He had a denial when calling **audit2allow**, informing us that
`sysadm_t` had no rights to read the SELinux policy. This is a known
issue that has been resolved in our current SELinux policy repository
but which needs to be pushed to the tree (which is my job, sorry about
that). The problem however is when he added the policy - it didn't work.

Even worse, **sesearch** told us that the policy has been modified
correctly - but it still doesn't work. Check your policy with
**sestatus** and **seinfo** and they're all saying things are working
well. And yet ... things don't. Apparently, all policy changes are
ignored.

The reason? There was a `policy.29` file in `/etc/selinux/mcs/policy`
which was always loaded, even though the user already edited
`/etc/selinux/semanage.conf` to have `policy-version` set to 28.

It is already a problem that we need to tell users to edit
`semanage.conf` to a fixed version (because binary version 29 is not
supported by most Linux kernels as it has been very recently introduced)
but having **load\_policy** (which is called by **semodule** when a
policy needs to be loaded) loading a stale `policy.29` file is just...
disappointing.

Anyway - if you see weird behavior, check both the `semanage.conf` file
(and set `policy-version = 28`) as well as the contents of your
`/etc/selinux/*/policy` directory. If you see any `policy.*` that isn't
version 28, delete them.
