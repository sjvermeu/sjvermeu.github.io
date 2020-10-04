Title: A SELinux policy for incron: the basic skeleton
Date: 2013-05-23 03:50
Category: SELinux
Tags: fc, incron, policy, selinux, skeleton, te
Slug: a-selinux-policy-for-incron-the-basic-skeleton

So, in the [previous
post](http://blog.siphos.be/2013/05/a-selinux-policy-for-incron-what-does-it-do/)
I talked about *incron* and why I think moving it into the existing cron
policy would not be a good idea. It works, somewhat, but is probably not
that future-proof. So we're going to create our own policy for it.

In SELinux, policies are generally written through 3 files:

1.  a *type enforcement* file that contains the SELinux rules applicable
    to the domain(s) related to the application (in our example,
    *incron*)
2.  a *file context* file that tells the SELinux utilities how the files
    and directories offered by the application should be labeled
3.  an *interface definition* file that allows other SELinux policy
    modules to gain rights offered through the (to be written) *incron*
    policy

We now need to create a skeleton for the policy. This skeleton will
define the types related to the application. Such types can be the
domains for the processes (the context of the **incrond** and perhaps
also **incrontab** applications), the contexts for the directories (if
any) and files, etc.

So let's take a look at the content of the *incron* package. On Gentoo,
we can use **qlist incron** for this. In the output of **qlist**, I
added comments to show you how contexts can be (easily) deduced.

    # Application binary for managing user crontabs. We want to give this a specific
    # context because we want the application (which will manage the incrontabs in
    # /var/spool/incron) in a specific domain
    /usr/bin/incrontab  ## incrontab_exec_t

    # General application information files, do not need specific attention
    # (the default context is fine)
    /usr/share/doc/incron-0.5.10/README.bz2
    /usr/share/doc/incron-0.5.10/TODO.bz2
    /usr/share/doc/incron-0.5.10/incron.conf.example.bz2
    /usr/share/doc/incron-0.5.10/CHANGELOG.bz2
    /usr/share/man/man8/incrond.8.bz2
    /usr/share/man/man5/incron.conf.5.bz2
    /usr/share/man/man5/incrontab.5.bz2
    /usr/share/man/man1/incrontab.1.bz2

    # Binary for the incrond daemon. This definitely needs its own context, since
    # it will be launched from an init script and we do not want it to run in the
    # initrc_t domain.
    /usr/sbin/incrond ## incrond_exec_t

    # This is the init script for the incrond daemon. If we want to allow 
    # some users the rights to administer incrond without needing to grant
    # those users the sysadm_r role, we need to give this file a different
    # context as well.
    /etc/init.d/incrond ## incrond_initrc_exec_t

With this information at hand, and the behavior of the application we
know from the previous post, can lead to the following `incron.fc` file,
which defines the file contexts for the application.

    /etc/incron.d(/.*)?     gen_context(system_u:object_r:incron_spool_t,s0)

    /etc/rc\.d/init\.d/incrond      --      gen_context(system_u:object_r:incrond_initrc_exec_t,s0)

    /usr/bin/incrontab      --      gen_context(system_u:object_r:incrontab_exec_t,s0)

    /usr/sbin/incrond       --      gen_context(system_u:object_r:incrond_exec_t,s0)

    /var/spool/incron(/.*)?         gen_context(system_u:object_r:incron_spool_t,s0)

The syntax of this file closely follows the syntax that **semanage
fcontext** takes - at least for the regular expressions in the
beginning. The last column is specifically for policy development to
generate a context based on the policies' requirements: an MCS/MLS
enabled policy will get the trailing sensitivity with it, but when
MCS/MLS is disabled then it is dropped. The middle column is to specify
if the label should only be set on regular files (`--`), directories
(`-d`), sockets (`-s`), symlinks (`-l`), etc. If it is omitted, it
matches whatever class the path matches.

The second file needed for the skeleton is the `incron.te` file, which
would look like so. I added in inline comments here to explain why
certain lines are prepared, but generally this is omitted when the
policy is [upstreamed](http://oss.tresys.com/projects/refpolicy/).

    policy_module(incron, 0.1)
    # The above line declares that this file is a SELinux policy file. Its name
    # is incron, so the file should saved as incron.te

    # First, we declare the incrond_t domain, used for the "incrond" process.
    # Because it is launched from an init script, we tell the policy that
    # incrond_exec_t (the context of incrond), when launched from init, should
    # transition to incrond_t.
    #
    # Basically, the syntax here is:
    # type 
    # type 
    # 
    type incrond_t;
    type incrond_exec_t;
    init_daemon_domain(incrond_t, incrond_exec_t)

    # Next we declare that the incrond_initrc_exec_t is an init script context
    # so that init can execute it (remember, SELinux is a mandatory access control
    # system, so if we do not tell that init can execute it, it won't).
    type incrond_initrc_exec_t;
    init_script_file(incrond_initrc_exec_t)

    # We also create the incrontab_t domain (for the "incrontab" application), which
    # is triggered through the incrontab_exec_t labeled file. This again follows a bit
    # the syntax as we used above, but now the interface call is "application_domain".
    type incrontab_t;
    type incrontab_exec_t;
    application_domain(incrontab_t, incrontab_exec_t)

    # Finally we declare the spool type as well (incron_spool_t) and tell SELinux that
    # it will be used for regular files.
    type incron_spool_t;
    files_type(incron_spool_t)

Knowing which interface calls, like *init\_daemon\_domain* and
*application\_domain*, we should use is not obvious at first. Most of
this can be gathered from existing policies. Other frequently occurring
interfaces to be used immediately at the skeleton side are (examples for
a `foo_t` domain):

-   *logging\_log\_file(foo\_log\_t)* to inform SELinux that the context
    is used for logging purposes. This allows generic log-related
    daemons to do "their thing" with the file.
-   *files\_tmp\_file(foo\_tmp\_t)* to identify the context as being
    used for temporary files
-   *files\_tmpfs\_file(foo\_tmpfs\_t)* for tmpfs files (which could be
    shared memory)
-   *files\_pid\_file(foo\_var\_run\_t)* for PID files (and other run
    metadata files)
-   *files\_config\_file(foo\_conf\_t)* for configuration files (often
    within `/etc`)
-   *files\_lock\_file(foo\_lock\_t)* for lock files (often within
    `/run/lock`)

We might be using these later as we progress with the policy (for
instance, the PID file is a very high candidate for needing to be
included). However, with the information currently at hand, we have our
first policy module ready for building. Save the type enforcement rules
in `incron.te` and the file contexts in `incron.fc` and you can then
build the SELinux policy:

    # make -f /usr/share/selinux/strict/include/Makefile incron.pp
    # semodule -i incron.pp

On Gentoo, you can then relabel the files and directories offered
through the package using **rlpkg**:

    # rlpkg incron

Next is to start looking at the **incrontab** application.
