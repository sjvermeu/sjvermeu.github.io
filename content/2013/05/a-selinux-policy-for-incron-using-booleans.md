Title: A SELinux policy for incron: using booleans
Date: 2013-05-30 03:50
Category: SELinux
Tags: boolean, incron, policy, selinux
Slug: a-selinux-policy-for-incron-using-booleans

After using a default set of directories to watch, and [allowing admins
to mark other
types](http://blog.siphos.be/2013/05/a-selinux-policy-for-incron-marking-types-eligible-for-watching/)
as such as well, let's consider another approach for making the policy
more flexible: booleans. The idea now is that a boolean called
*incron\_notify\_non\_security\_files* enables **incrond** to be
notified on changes on all possible non-security related files (the
latter is merely an approach, you can define other sets as well if you
want, including all possible files).

Booleans in SELinux policy can be generated in the `incron.te` file as
follows:

    ## <desc>
    ## <p>
    ##      Determine whether incron can watch all non-security
    ##      file types
    ## </p>
    ## </desc>
    gen_tunable(incron_notify_non_security_files, false)

With this boolean in place, the policy can be enhanced with code like
the following:

    tunable_policy(`incron_notify_non_security_files',`
            files_read_non_security_files(incrond_t)
            files_read_all_dirs_except(incrond_t)
    ')

This code tells SELinux that, *if* the
*incron\_notify\_non\_security\_files* boolean is set (which by default
is not the case), then `incrond_t` is able to read non security files.

Let's try to watch for changes in the AIDE log directory:

    # tail audit.log
    type=AVC msg=audit(1368777675.597:28611): avc:  denied  { search } for  pid=11704 comm="incrond" name="log" dev="dm-4" ino=13 scontext=system_u:system_r:incrond_t tcontext=system_u:object_r:var_log_t tclass=dir
    type=AVC msg=audit(1368777675.597:28612): avc:  denied  { search } for  pid=11704 comm="incrond" name="log" dev="dm-4" ino=13 scontext=system_u:system_r:incrond_t tcontext=system_u:object_r:var_log_t tclass=dir

    # tail cron.log
    May 17 10:01:15 test incrond[11704]: access denied on /var/log/aide - events will be discarded silently

    # getsebool incron_notify_non_security_files
    incron_notify_non_security_files --> off

Let's enable the boolean and try again:

    # setsebool incron_notify_non_security_files on

Reloading the incrontab tables now works, and the notifications work as
well.

As you can see, once a policy is somewhat working, policy developers are
considering the various "use cases" of an application, trying to write
down policies that can be used by the majority of users, without
granting too many rights automatically.
