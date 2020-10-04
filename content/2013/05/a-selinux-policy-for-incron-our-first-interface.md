Title: A SELinux policy for incron: our first interface
Date: 2013-05-24 03:50
Category: SELinux
Tags: incron, interface, policy
Slug: a-selinux-policy-for-incron-our-first-interface

The next step after having [a basic
skeleton](http://blog.siphos.be/2013/05/a-selinux-policy-for-incron-the-basic-skeleton/)
is to get **incrontab** running. We know however that everything invoked
from the main daemon will be running with the rights of the daemon
context (unless we would patch the source code, but that is beyond the
scope of this set of posts). As a result, we probably do not want
everyone to be able to launch commands through this application.

What we want to do is to limit who can invoke **incrontab** and, as
such, limit who can decide what is invoked through **incrond**. First of
all, we define a *role attribute* called `incrontab_roles`. Every role
that gets this attribute assigned will be able to transition to the
`incrontab_t` domain.

We can accomplish this by editing the `incron.te` file:

    policy_module(incron, 0.2)

    # Declare the incrontab_roles attribute
    attribute_role incrontab_roles;

    ...
    type incrontab_t;
    type incrontab_exec_t;
    application_domain(incrontab_t, incrontab_exec_t)
    # Allow incrontab_t for all incrontab_roles 
    role incrontab_roles types incrontab_t;

Next, we need something where we can allow user domains to call
incrontab. This will be done through an interface. Let's look at
`incron.if` with one such interface in it: the *incron\_role* interface.

    ## inotify-based cron-like daemon

    #########################################
    ## <summary>
    ##      Role access for incrontab
    ## </summary>
    ## <param name="role">
    ##      <summary>
    ##      Role allowed access.
    ##      </summary>
    ## </param>
    ## <param name="domain">
    ##      <summary>
    ##      User domain for the role.
    ##      </summary>
    ## </param>
    #
    interface(`incron_role',`
            gen_require(`
                    attribute_role incrontab_roles;
                    type incrontab_exec_t, incrontab_t;
            ')

            roleattribute $1 incrontab_roles;

            domtrans_pattern($2, incrontab_exec_t, incrontab_t)

            ps_process_pattern($2, incrontab_t)
            allow $2 incrontab_t:process signal;
    ')

The comments in the file are somewhat special: if the comments start
with two hashes (`##`) then it is taken into account while building the
policy documentation in `/usr/share/doc/selinux-base-*`. The interface
itself, *incron\_role*, grants a user role and domain the necessary
privileges to transition to the `incrontab_t` domain as well as read
process information (as used through **ps**, hence the name of the
pattern being `ps_process_pattern`) and send a standard signal to it.
Most of the time, you can use `signal_perms` here but from looking at
the application we see that the application is setuid root, so we don't
want to grant too many privileges by default if they are not needed.

With this interface file created, we can rebuild the module and load it.

    # make -f /usr/share/selinux/strict/include/Makefile incron.pp
    # semodule -i incron.pp

But how to assign this interface to users? Well, what we want to do is
something like the following:

    incron_role(user_r, user_t)

When interfaces are part of the policy provided by the distribution, the
definitions of it are stored in the proper location and you can easily
add it. For instance, in Gentoo, if you want to allow the `user_r` role
and `user_t` domain the *cron\_role* access (and assuming it doesn't
have so already), then you can call **selocal** as follows:

    # selocal -a "cron_role(user_r, user_t)" -c "Granting user_t cron access" -Lb

However, because the interface is currently not known yet, we need to
create a second small policy that does this. Create a file (called
`localuser.te` or so) with the following content:

    policy_module(localuser, 0.1)

    gen_require(`
            type user_t;
            role user_r;
    ')

    incron_role(user_r, user_t)

Now build the policies and load them. We'll now just build and load all
the policies in the current directory (which will be the incron and
localuser ones):

    # make -f /usr/share/selinux/strict/include/Makefile
    # semodule -i *.pp

You can now verify that the user is allowed to transition to the
`incrontab_t` domain:

    # seinfo -ruser_r -x | grep incron
             incrontab_t
    # sesearch -s user_t -t incrontab_exec_t -AdCTS
    Found 1 semantic av rules:
       allow user_t incrontab_exec_t : file { read getattr execute open } ; 

    Found 1 semantic te rules:
       type_transition user_t incrontab_exec_t : process incrontab_t; 

Great, let's get to our first failure to resolve... in the next post ;-)
