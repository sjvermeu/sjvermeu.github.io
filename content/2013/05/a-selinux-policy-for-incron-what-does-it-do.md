Title: A SELinux policy for incron: what does it do?
Date: 2013-05-22 03:50
Category: SELinux
Tags: incron, policy, selinux
Slug: a-selinux-policy-for-incron-what-does-it-do

In this series of posts, we'll go through the creation of a SELinux
policy for
[incron](http://inotify.aiken.cz/?section=incron&page=doc⟨=en), a simple
inotify based cron-like application. I will talk about the various steps
that I would take in the creation of this policy, and give feedback when
certain decisions are taken and why. At the end of the series, we'll
have a hopefully well working policy.

The first step in developing a policy is to know what the application
does and how/where it works. This allows us to check if its behavior
matches an existing policy (and as such might be best just added to this
policy) or if a new policy needs to be written. So, what does incron do?

From the documentation, we know that *incron* is a cron-like application
that, unlike cron, works with file system notification events instead of
time-related events. Other than that, it uses a similar way of working:

-   A daemon called **incrond** is the run-time application that reads
    in the *incrontab* files and creates the proper inotify watches.
    When a watch is triggered, it will execute the matching rule.
-   The daemon looks at two definitions (incrontabs): one system-wide
    (in `/etc/incron.d`) and one for users (in `/var/spool/incron`).
-   The user tabfiles are managed through **incrontab** (the command)
-   Logging is done through syslog
-   User commands are executed with the users' privileges (so the
    application calls *setuid()* and *setgid()*)

With this, one can create a script to be executed when a file is
uploaded (or deleted) to/from a file server, or when a process coredump
occurred, or whatever automation you want to trigger when some file
system event occurred. Events are plenty and can be found in
`/usr/include/sys/inotify.h`.

So, with this information, it is safe to assume that we might be able to
push incron in the existing *cron* policy. After all, it defines the
contexts for all these and probably doesn't need any additional
tweaking. And this seems to work at first, but a few tests reveal that
the behavior is not that optimal.

    # chcon -t crond_exec_t /usr/sbin/incrond
    # chcon -t crontab_exec_t /usr/bin/incrontab
    # chcon -R -t system_cron_spool_t /etc/incron.d
    # chcon -t cron_log_t /var/log/cron.log
    # chcon -R -t cron_spool_t /var/spool/incron

System tables work somewhat, but all commands are executed in the
`crond_t` domain, not in a `system_cronjob_t` or related domain.  
User tables fail when dealing with files in the users directories,
since these too run in `crond_t` and thus have no read access to the
user home directories.

The problems we notice come from the fact that the application is very
simple in its code: it is not SELinux-aware (so it doesn't change the
runtime context) as most cron daemons are, and when it changes the user
id it does not call PAM, so we cannot trigger `pam_selinux.so` to handle
context changes either. As a result, the entire daemon keeps running in
`crond_t`.

This is one reason why a separate domain could be interesting: we might
want to extend the rights of the daemon domain a bit, but don't want to
extend these rights to the other cron daemons (who also run in
`crond_t`). Another reason is that the cron policy has a few booleans
that would not affect the behavior at all, making it less obvious for
users to troubleshoot. As a result, we'll go for the separate policy
instead - which will be for the next post.
