Title: A SELinux policy for incron: default set
Date: 2013-05-28 03:50
Category: SELinux
Tags: booleans, incrond, policy, selinux
Slug: a-selinux-policy-for-incron-default-set

I finished the last post a bit with a
[cliffhanger](http://blog.siphos.be/2013/05/a-selinux-policy-for-incron-the-incrond-daemon/)
as **incrond** is still not working properly, and we got a few denials
that needed to be resolved; here they are again for your convenience:

    type=AVC msg=audit(1368734110.912:28353): avc:  denied  { getattr } for  pid=9716 comm="incrond" path="/home/user/test2" dev="dm-0" ino=16 scontext=system_u:system_r:incrond_t tcontext=user_u:object_r:user_home_t tclass=dir
    type=AVC msg=audit(1368734110.913:28354): avc:  denied  { read } for  pid=9716 comm="incrond" name="test2" dev="dm-0" ino=16 scontext=system_u:system_r:incrond_t tcontext=user_u:object_r:user_home_t tclass=dir

The permission we are looking for here is
*userdom\_list\_user\_home\_content*, but this is only for when we want
to watch a user home directory. What if we want to watch a server upload
directory? Or a cache directory? We might need to have **incrond** have
the proper accesses on all directories. But then again, *all* does sound
a bit... much, doesn't it? So let's split it up in three waves:

1.  The `incrond_t` domain will support a minimal set of types that it
    can watch, based on common approaches
2.  I will introduce an interface that allows other modules to mark
    specific types as being "watch-worthy"
3.  A boolean will be set to allow `incrond_t` to watch a very large set
    of types (just in case the admin trusts it sufficiently)

Let's first consider a decent minimal set. Within most SELinux policies,
two types are often used for public access (or for uploading of data).
These types are `public_content_t` and `public_content_rw_t`, and is
used for instance for FTP definitions (upload folders), HTTP servers and
such. So we introduce the proper rights to watch that data. There is an
interface available called *miscfiles\_read\_public\_files* but let's
first see if that interface isn't too broad (after all, watching might
not be the same as reading).

    # This is only to temporarily check if the rights of the interface are too broad or not
    # You can set this using "selocal" or in a module (in which case you'll need to 'require'
    # the two types)
    allow incrond_t public_content_t:dir { read getattr };

After editing the incrontab to watch a directory labeled with
`public_content_t`, we now get the following:

    # tail cron.log
    May 17 08:46:12 test incrond[9716]: (user) CMD (/usr/local/bin/test)
    May 17 08:46:12 test incrond[11281]: cannot exec process: Operation not permitted
    May 17 08:46:12 test incrond[9716]: cannot send SIGCHLD token to notification pipe

    # tail audit.log
    type=AVC msg=audit(1368773172.313:28386): avc:  denied  { setgid } for  pid=11281 comm="incrond" capability=6  scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=capability
    type=AVC msg=audit(1368773172.314:28387): avc:  denied  { read } for  pid=9716 comm="incrond" path="pipe:[14027]" dev="pipefs" ino=14027 scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=fifo_file
    type=AVC msg=audit(1368773172.315:28388): avc:  denied  { write } for  pid=9716 comm="incrond" path="pipe:[14027]" dev="pipefs" ino=14027 scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=fifo_file

As the incrontab is a user incrontab, we can expect `incrond_t` to
require setuid and setgid privileges. Also, the *fifo\_file* access is
after forking (notice the difference in PID values) and most likely to
communicate to the master process. So let's allow those:

    allow incrond_t self:capability { setuid setgid };
    allow incrond_t self:fifo_file { read write };

With that set, we get the following upon triggering a file write:

    # tail cron.log
    May 17 08:52:46 test incrond[9716]: (user) CMD (/usr/local/bin/test)
    May 17 08:52:46 test incrond[11338]: cannot exec process: Permission denied

    # tail audit.log
    type=AVC msg=audit(1368773566.606:28394): avc:  denied  { read } for  pid=11338 comm="incrond" name="ngroups_max" dev="proc" ino=5711 scontext=system_u:system_r:incrond_t tcontext=system_u:object_r:sysctl_kernel_t tclass=file
    type=AVC msg=audit(1368773566.607:28395): avc:  denied  { search } for  pid=11338 comm="incrond" name="bin" dev="dm-3" ino=1048578 scontext=system_u:system_r:incrond_t tcontext=system_u:object_r:bin_t tclass=dir

The `ngroups_max` pseudo-file (in `/proc/sys/kernel`) returns the
maximum number of supplementary group IDs per process, and is consulted
through the *initgroups()* method provided by a system library, so it
*might* make sense to allow it. For now though, I will not enable it (as
reading `sysctl_kernel_t` exposes a lot of other system information) but
I might be forced to do so later if things don't work out well. The
*search* privilege on `bin_t` is needed to find the script that I have
prepared (`/usr/local/bin/test`) to be executed, so I add in a
*corecmd\_search\_bin* and retry.

    # tail cron.log
    May 17 09:02:55 test incrond[9716]: (user) CMD (/usr/local/bin/test)
    May 17 09:02:55 test incrond[11427]: cannot exec process: Permission denied

    # tail audit.log
    type=AVC msg=audit(1368774175.646:28441): avc:  denied  { read } for  pid=11427 comm="incrond" name="sh" dev="dm-2" ino=131454 scontext=system_u:system_r:incrond_t tcontext=root:object_r:bin_t tclass=lnk_file

Still not there yet apparently. The **incrond** forked process wants to
execute the script, but to do so it has to follow a symbolic link
labeled `bin_t`. This is because the script points to `#!/bin/sh` which
is a symlink to the system shell. We need to follow this link before the
execution can occur; only after execution will the transition from
`incrond_t` to `system_cronjob_t` be done.

    corecmd_read_bin_symlinks(incrond_t)

With that set in the policy, the watch works, **incrond** properly
launches the command and the command properly transitions into
`system_cronjob_t` as we defined earlier (I check this by echo'ing the
output of **id -Z** into a temporary file).

So we are left with the (temporary) rights we granted on
`public_content_t`. Consider the rules we had versus the rules applied
with *miscfiles\_read\_public\_files*:

    allow incrond_t public_content_t:dir { read getattr };

    # miscfiles_read_public_files
    allow $1 { public_content_t public_content_rw_t }:dir list_dir_perms;
    read_files_pattern($1, { public_content_t public_content_rw_t }, { public_content_t public_content_rw_t })
    read_lnk_files_pattern($1, { public_content_t public_content_rw_t }, { public_content_t public_content_rw_t })

The rights here seem to bemore than what we need. Playing around a bit
with the directories reveals that **incrond** requires a bit more. For
instance, when you create additional directories (subdirectories) and
want to match multiple ones:

    # tail cron.log
    May 17 09:16:08 test incrond[11704]: access denied on /var/www/test/* - events will be discarded silently
    May 17 09:16:08 test incrond[11704]: cannot create watch for user user: (13) Permission denied

    # tail audit.log
    type=AVC msg=audit(1368774968.416:28504): avc:  denied  { search } for  pid=11704 comm="incrond" name="test" dev="dm-4" ino=1488 scontext=system_u:system_r:incrond_t tcontext=root:object_r:public_content_t tclass=dir
    type=AVC msg=audit(1368774968.416:28505): avc:  denied  { search } for  pid=11704 comm="incrond" name="test" dev="dm-4" ino=1488 scontext=system_u:system_r:incrond_t tcontext=root:object_r:public_content_t tclass=dir

Similarly if you want to watch on a particular file:

    type=AVC msg=audit(1368775274.655:28552): avc:  denied  { getattr } for  pid=11704 comm="incrond" path="/var/www/test/testfile" dev="dm-4" ino=1709 scontext=system_u:system_r:incrond_t tcontext=root:object_r:public_content_t tclass=file
    type=AVC msg=audit(1368775274.655:28553): avc:  denied  { read } for  pid=11704 comm="incrond" name="testfile" dev="dm-4" ino=1709 scontext=system_u:system_r:incrond_t tcontext=root:object_r:public_content_t tclass=file

So it looks like *miscfiles\_read\_public\_files* isn't that bad after
all.

All we are left with is the access to `ngroups_max`. We can ignore the
calls and make sure they don't show up in standard auditing using
*kernel\_dontaudit\_read\_kernel\_sysctls* or we can allow it with
*kernel\_read\_kernel\_sysctls*. I'm going to take the former approach
for my system, but your own idea might be different.

I tested all this with user incrontabs (as those are the "most"
advanced) but one can easily test with system incrontabs as well
(placing one in `/etc/incron.d`). Just be aware that *incrond* will take
the first match and will not seek other matches. So if a system
incrontab watches `/var/www` and another line (or user incrontab)
watches `/var/www/localhost/upload` it is very well possible that only
the `/var/www` watch is triggered.

So right now, our `incrond_t` policy looks like so:

    ###########################################
    #
    # incrond policy
    #

    allow incrond_t self:capability { setgid setuid };

    allow incrond_t incron_spool_t:dir list_dir_perms;
    allow incrond_t incron_spool_t:file read_file_perms;

    allow incrond_t self:fifo_file { read write };

    allow incrond_t incrond_var_run_t:file manage_file_perms;
    files_pid_filetrans(incrond_t, incrond_var_run_t, file)

    kernel_dontaudit_read_kernel_sysctls(incrond_t)

    corecmd_read_bin_symlinks(incrond_t)
    corecmd_search_bin(incrond_t)

    files_search_spool(incrond_t)

    logging_send_syslog_msg(incrond_t)

    auth_use_nsswitch(incrond_t)

    miscfiles_read_localization(incrond_t)
    miscfiles_read_public_files(incrond_t)

Next on the agenda is another interface to make other types
"watch-worthy".
