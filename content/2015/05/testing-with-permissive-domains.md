Title: Testing with permissive domains
Date: 2015-05-18 13:40
Category: SELinux
Tags: permissive, policy, selinux, semanage, test
Slug: testing-with-permissive-domains

When testing out new technologies or new setups, not having (proper)
SELinux policies can be a nuisance. Not only are the number of SELinux
policies that are available through the standard repositories limited,
some of these policies are not even written with the same level of
confinement that an administrator might expect. Or perhaps the
technology to be tested is used in a completely different manner.

Without proper policies, any attempt to start such a daemon or
application might or will cause permission violations. In many cases,
developers or users tend to disable SELinux enforcing then so that they
can continue playing with the new technology. And why not? After all,
policy development is to be done *after* the technology is understood.

<!-- PELICAN_END_SUMMARY -->

But completely putting the system in permissive mode is overshooting. It
is much easier to make a very simple policy to start with, and then mark
the domain as a permissive domain. What happens is that the software
then, after transitioning into the "simple" domain, is not part of the
SELinux enforcements anymore whereas the rest of the system remains in
SELinux enforcing mode.

For instance, create a minuscule policy like so:

    policy_module(testdom, 1.0)

    type testdom_t;
    type testdom_exec_t;
    init_daemon_domain(testdom_t, testdom_exec_t)

Mark the executable for the daemon as `testdom_exec_t` (after building
and loading the minuscule policy):

    ~# chcon -t testdom_exec_t /opt/something/bin/daemond

Finally, tell SELinux that `testdom_t` is to be seen as a permissive
domain:

    ~# semanage permissive -a testdom_t

When finished, don't forget to remove the permissive bit
(`semanage permissive -d testdom_t`) and unload/remove the SELinux
policy module.

And that's it. If the daemon is now started (through a standard init
script) it will run as `testdom_t` and everything it does will be
logged, but not enforced by SELinux. That might even help in
understanding the application better.
