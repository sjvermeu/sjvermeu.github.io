Title: How logins get their SELinux user context
Date: 2013-04-27 03:50
Category: SELinux
Tags: context, selinux, user
Slug: how-logins-get-their-selinux-user-context

Sometimes, especially when users are converting their systems to be
SELinux-enabled, their user context is wrong. An example would be when,
after logon (in permissive mode), the user is in the
`system_u:system_r:local_login_t` domain instead of a user domain like
`staff_u:staff_r:staff_t`.  
So, how does a login get its SELinux user context?

Let's look at the entire chain of SELinux context changes across a boot.
At first, when the system boots, the kernel (and all processes invoked
from it) run in the `kernel_t` domain (I'm going to ignore the other
context fields for now until they become relevant). When the kernel
initialization has been completed, the kernel executes the **init**
binary. When you use an initramfs, then a script might be called. This
actually doesn't matter that much yet, since SELinux stays within the
`kernel_t` domain *until* a SELinux-aware **init** is launched.

When the **init** binary is executed, init of course starts. But as
mentioned, init is SELinux-aware, meaning it will invoke SELinux-related
commands. One of these is that it will load the SELinux policy (as
stored in `/etc/selinux`) and then reexecute itself. Because of that,
its process context changes from `kernel_t` towards `init_t`. This is
because the **init** binary itself is labeled as `init_exec_t` and a
type transition is defined from `kernel_t` towards `init_t` when
`init_exec_t` is executed.

Ok, so **init** now runs in `init_t` and it goes on with whatever it
needs to do. This includes invoking init scripts (which, btw, run in
`initrc_t` because the scripts are labeled `initrc_exec_t` or with a
type that has the `init_script_file_type` attribute set, and a
transition from `init_t` to `initrc_t` is defined when such files are
executed). When the bootup is finally completed, **init** launches the
*getty* processes. The commands are mentioned in `/etc/inittab`:

    $ grep getty /etc/inittab
    c1:12345:respawn:/sbin/agetty --noclear 38400 tty1 linux
    c2:2345:respawn:/sbin/agetty 38400 tty2 linux
    ...

These binaries are also explicitly labeled `getty_exec_t`. As a result,
the **getty** (or **agetty**) processes run in the `getty_t` domain
(because a transition is defined from `init_t` to `getty_t` when
`getty_exec_t` is executed). Ok, so gettys run in `getty_t`. But what
happens when a user now logs on to the system?

Well, the getty's invoke the **login** binary which, you guessed it
right, is labeled as something: `login_exec_t`. As a result (because,
again, a transition is defined in the policy), the login process runs as
`local_login_t`. Now the login process invokes the various PAM
subroutines which follow the definitions in `/etc/pam.d/login`. On
Gentoo systems, this by default points to the `system-local-login`
definitions which points to the `system-login` definitions. And in this
definition, especially under the sessions section, we find a reference
to `pam_selinux.so`:

    session         required        pam_selinux.so close
    ...
    session         required        pam_selinux.so multiple open

Now here is where some of the magic starts (see my post on [Using
pam\_selinux to switch
contexts](http://blog.siphos.be/2012/12/using-pam_selinux-to-switch-contexts/)
for the gritty details). The methods inside the `pam_selinux.so` binary
will look up what the context should be for a user login. For instance,
when the *root* user logs on, it has SELinux checking what SELinux user
*root* is mapped to, equivalent to running **semanage login -l**:

    $ semanage login -l | grep ^root
    root                      root                     

In this case, the SELinux user for root is *root*, but this is not
always the case (that login and user are the same). For instance, my
regular administrative account maps to the *staff\_u* SELinux user.

Next, it checks what the default context should be for this user. This
is done by checking the `default_contexts` file (such as the one in
`/etc/selinux/strict/contexts` although user-specific overrides can be
(and are) placed in the `users` subdirectory) based on the context of
the process that is asking SELinux what the default context should be.
In our case, it is the **login** process running as `local_login_t`:

    $ grep -HR local_login_t /etc/selinux/strict/contexts/*
    default_contexts:system_r:local_login_t user_r:user_t staff_r:staff_t sysadm_r:sysadm_t unconfined_r:unconfined_t
    users/unconfined_u:system_r:local_login_t               unconfined_r:unconfined_t
    users/guest_u:system_r:local_login_t            guest_r:guest_t
    users/user_u:system_r:local_login_t             user_r:user_t
    users/staff_u:system_r:local_login_t            staff_r:staff_t sysadm_r:sysadm_t
    users/root:system_r:local_login_t  unconfined_r:unconfined_t sysadm_r:sysadm_t staff_r:staff_t user_r:user_t
    users/xguest_u:system_r:local_login_t   xguest_r:xguest_t

Since we are verifying this for the *root* SELinux user, the following
line of the `users/root` file is what matters:

    system_r:local_login_t  unconfined_r:unconfined_t sysadm_r:sysadm_t staff_r:staff_t user_r:user_t

Here, SELinux looks for the first match in that line that the user has
access to. This is defined by the roles that the user is allowed to
access:

    $ semanage user -l | grep root
    root            staff_r sysadm_r

As *root* is allowed both the *staff\_r* and *sysadm\_r* roles, the
first one found *in the default context file* that matches will be used.
So it is *not* the order in which the roles are displayed in the
**semanage user -l** output that matters, but the order of the contexts
in the *default context* file. In the example, this is
`sysadm_r:sysadm_t`:

    system_r:local_login_t  unconfined_r:unconfined_t sysadm_r:sysadm_t staff_r:staff_t user_r:user_t
                            <-----------+-----------> <-------+-------> <------+------> <-----+----->
                                        `- no matching role   `- first (!)     `- second      `- no match

Now that we know what the context *should* be, this is used for the
first execution that the process (still **login**) will do. So **login**
changes the Linux user (if applicable) and invokes the shell of that
user. Because this is the first execution that is done by **login**, the
new context is set (being `root:sysadm_r:sysadm_t`) for the shell.

And that is why, if you run **id -Z**, it returns the user context
(`root:sysadm_r:sysadm_t`) if everything works out fine ;-)
