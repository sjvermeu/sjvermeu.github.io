Title: Oh it is cron again...
Date: 2014-01-03 21:05
Category: SELinux
Tags: cron, selinux
Slug: oh-it-is-cron-again

Today I was pointed to the following error:

    test fcron[6722]: fcron[6722] 3.1.2 started
    test fcron[6722]: Cannot bind socket to '/var/run/fcron.fifo': Permission denied
    test fcron[6722]:  "at" reboot jobs will only be run at computer's startup.
    test fcron[6722]: updating configuration from /var/spool/fcron
    test fcron[6722]: adding file systab Jan  3 17:51:19 test fcron[6722]: adding new file user
    test fcron[6722]: NO CONTEXT for user "(null)": Invalid argument
    test fcron[6722]: ENTRYPOINT FAILED for user "user" (CONTEXT (null)) for file CONTEXT user_u:object_r:user_cron_spool_t:s0

First of all, the moment I notice that it is cron, I know I'm up for a
few hours at it. Cron has been notoriously difficult to integrate with
SELinux, because it doesn't use the simpler "fork-execute" method (where
we can put in transitions). Instead, it often has to call
SELinux-specific methods to get the job done. Same was true here.

Anyway, on to the issues. First of all, the *Cannot bind socket* is a
simple SELinux policy thingie that one can easily ignore for now (I'll
patch and upstream that in a minute). The problem is the *NO CONTEXT*
stuff.

The code looks as follows:

```
#ifdef SYSFCRONTAB
    if(!strcmp(cf->cf_user, SYSFCRONTAB))
        user_name = "system_u";
    else
#endif /* def SYSFCRONTAB */
        user_name = cf->cf_user;
    if(flask_enabled)
    {
        if(get_default_context(user_name, NULL, &cf->cf_user_context))
            error_e("NO CONTEXT for user \"%s\"", cf->cf_user_context);
        retval = security_compute_av(cf->cf_user_context, cf->cf_file_context
                , SECCLASS_FILE, FILE__ENTRYPOINT, &avd);

        if(retval || ((FILE__ENTRYPOINT & avd.allowed) != FILE__ENTRYPOINT))
        {
            syslog(LOG_ERR, "ENTRYPOINT FAILED for user \"%s\" "
                   "(CONTEXT %s) for file CONTEXT %s"
                   , cf->cf_user, cf->cf_user_context, cf->cf_file_context);
            goto err;
        }
```

It wasn't obvious to me either, but from a quick look through the
[selinux.h](http://userspace.selinuxproject.org/trac/browser/libselinux/include/selinux/selinux.h)
code I found out that *get\_default\_context()* requires the SELinux
user rather than Linux user.

The purpose of the *get\_default\_context()* method is to return the
SELinux context in which newly started tasks, originating from the
current context (if second argument is *NULL*) or given context (second
argument), owned by the given user (first argument) should start in. In
case of cron, the code is asking SELinux what the context should be for
the cronjob itself, considering that it has to be executed for a given
user.

Now the code currently passes on the owner (Linux user) of the crontab
file. As this owner usually is not a SELinux user (only when there is a
SELinux user named after the Linux user will this succeed), the method
returns *NULL*.

The right call here would be to first look up the correct SELinux user
for the given Linux user, and then call the *get\_default\_context()*
method. This will return a context to transition to.

Now, cron systems usually do a second check - they see if the file in
which the cronjobs are mentioned is an *entrypoint* for the context that
it should transition to. Even though the file itself will not be
directly executed, by checking if the *entrypoint* permission is set
cron can be reasonably certain that it should proceed. So for cron, this
is like saying "Yes, the file with context `cron_spool_t` is allowed to
contain job definitions for cron to execute".

I've sent the
[patch](http://thread.gmane.org/gmane.comp.sysutils.fcron.devel/89) for
this upstream and hopefully it gets added in - if I'm correct in the
deduction, that is.

So when you get issues with cron, do the following checks:

1.  Is the cron daemon running in the right domain? It should run in a
    `crond_t` domain, otherwise it will not be able to get a proper
    default context.
2.  Assuming that cron uses the right arguments, make sure that a
    default context is set for the given SELinux user (check the
    `contexts/default_contexts` and `contexts/users/*` files) and that
    this context is valid
3.  Check the context of the file in which the definitions are stored
    and make sure it is mentioned as an entrypoint for the job domain

Or, in some code:

    # ps -efZ | grep fcron | awk '{print $1}'
    system_u:system_r:crond_t
    # getseuser swift system_u:system_r:crond_t
    seuser: user_u
    Context 0     user_u:user_r:cronjob_t
    # ls -lZ /var/spool/fcron/new.user
    ... user_u:object_r:user_cron_spool_t
    # sesearch -s cronjob_t -t user_cron_spool_t -c file -p entrypoint -A
    Found 1 semantic av rules:
      allow cronjob_t user_cron_spool_t : file entrypoint ;
