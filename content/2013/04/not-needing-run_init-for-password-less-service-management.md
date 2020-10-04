Title: Not needing run_init for password-less service management
Date: 2013-04-09 22:14
Category: Gentoo
Tags: Gentoo, hardened, pam, rootok, run_init, selinux
Slug: not-needing-run_init-for-password-less-service-management

One of the things that has been bugging me was why, even with having
`pam_rootok.so` set in `/etc/pam.d/run_init`, I cannot enjoy
passwordless service management without using **run\_init** directly:

    # rc-service postgresql-9.2 status
    Authenticating root.
    Password: 

    # run_init rc-service postgresql-9.2 status
    Authenticating root.
     * status: started

So I decided to **strace** the two commands and look for the
differences. I found out that there is even a SELinux permission for
being able to use the *rootok* setting for passwords! Apparently,
`pam_rootok.so` is SELinux-aware and does some additional checks.

Although I don't know the exact details of it, it looks for the context
before the call (exec) of **run\_init** occurred. Then it checks if this
domain has the right for *passwd { rootok }* (unless SELinux is in
permissive, in which case it just continues) and only then it allows the
"rootok" to succeed.

Now why doesn't this work without using **run\_init**? I think it has to
do with how we integrate **run\_init** in the scripts, because out of
the trace I found that the previous context was also *run\_init\_t*
(instead of *sysadm\_t*):

    20451 open("/proc/self/task/20451/attr/current", O_RDONLY) = 3
    20451 read(3, "root:sysadm_r:run_init_t\0", 4095) = 25
    20451 close(3)                          = 0
    20451 gettid()                          = 20451
    20451 open("/proc/self/task/20451/attr/prev", O_RDONLY) = 3
    20451 read(3, "root:sysadm_r:run_init_t\0", 4095) = 25
    20451 close(3) 

Because there already is a transition to *run\_init\_t* upon calling the
scripts, the underlying call to **runscripts** causes the "previous"
attribute to be set to *run\_init\_t* as well, and only then is
**run\_init** called (which then causes the PAM functions to be called).
But by prepending the commands with **run\_init** (which quickly causes
the PAM functions to be called) the previous context is *sysadm\_t*.

I tested on a system with the following policy update, and this succeeds
nicely.

    policy_module(localruninit, 1.0)

    gen_require(`
      class passwd { passwd chfn chsh rootok };
      type run_init_t;
    ')

    allow run_init_t self:passwd rootok;

I'll probably add this in Gentoo's policy.
