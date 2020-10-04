Title: A SELinux policy for incron: the incrond daemon
Date: 2013-05-27 03:50
Category: SELinux
Tags: incrond, selinux
Slug: a-selinux-policy-for-incron-the-incrond-daemon

With `incrontab_t` (hopefully) complete, let's look at the `incrond_t`
domain. As this domain will also be used to execute the user (and
system) commands provided through the incrontabs, we need to consider
how we are going to deal with this wide range of possible permissions
that it might take. One would be to make `incrond_t` quite powerful, and
extend its privileges as we go further. But in my opinion, that's not a
good way to deal with it.

Another would be to support a small set of permissions, and introduce an
interface that other modules can use to create a transition when
`incrond_t` executes a script properly labeled for a transition. For
instance, a domain `foo_t` might have an executable type `foo_exec_t`.
Most modules support an interface similar to *foo\_domtrans* (and
*foo\_role* if roles are applicable as well), but that assumes that the
*incron* policy is modified every time a new target module is made
available (since we then need to add the proper *\*\_domtrans* rules to
the *incron* policy. Instead, we might want to make this something that
the *foo* SELinux module can decide.

It is that approach that we are going to take here. To do so, we will
create a new interface called *incron\_entry*, taken a bit from the
*cron\_system\_entry* interface already in place for the regular *cron*
domain (the following comes in `incron.if`):

    ## <summary>
    ##      Make the specified program domain
    ##      accessible from the incrond job.
    ## </summary>
    ## <param name="domain">
    ##      <summary>
    ##      The type of the process to transition to
    ##      </summary>
    ## </param>
    ## <param name="entrypoint">
    ##      <summary>
    ##      The type of the file used as an entrypoint to this domain
    ##      </summary>
    ## </param>
    #
    interface(`incron_entry',`
            gen_require(`
                    type incrond_t;
            ')

            domtrans_pattern(incrond_t, $2, $1)
    ')

With this in place, the *foo* SELinux module can call
*incron\_entry(foo\_t, foo\_exec\_t)* so that, the moment `incrond_t`
executes a file with label `foo_exec_t`, the resulting process will run
in `foo_t`. I am going to *test* (and I stress that it is only for
*testing*) this by assigning *incron\_entry(system\_cronjob\_t,
shell\_exec\_t)*, making every shell script being called run in
`system_cronjob_t` domain (for instance in the `localuser.te` file that
already assigned *incron\_role* to the `user_t` domain.

With that in place, it's time to start our iterations again.

    # run_init rc-service incrond start
    * start-stop-daemon: failed to start '/usr/sbin/incrond' [ !! ]
    * ERROR: incrond failed to start

    # tail audit.log
    type=AVC msg=audit(1368732494.275:28319): avc:  denied  { read } for  pid=9282 comm="incrond" name="localtime" dev="dm-2" ino=393663 scontext=system_u:system_r:incrond_t tcontext=system_u:object_r:locale_t tclass=file
    type=AVC msg=audit(1368732494.275:28320): avc:  denied  { create } for  pid=9282 comm="incrond" scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=unix_dgram_socket
    type=AVC msg=audit(1368732494.276:28321): avc:  denied  { read } for  pid=9282 comm="incrond" name="incron.d" dev="dm-2" ino=394140 scontext=system_u:system_r:incrond_t tcontext=root:object_r:incron_spool_t tclass=dir
    type=AVC msg=audit(1368732494.276:28322): avc:  denied  { create } for  pid=9282 comm="incrond" scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=unix_dgram_socket
    type=AVC msg=audit(1368732494.276:28323): avc:  denied  { create } for  pid=9282 comm="incrond" scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=unix_dgram_socket

Ignoring the *unix\_dgram\_socket* for now, we need to allow `incrond_t`
to read locale information, and to read the files in the
`/var/spool/incron` location (this goes in `incron.te` again):

    ###########################################
    #
    # incrond policy
    #

    read_files_pattern(incrond_t, incron_spool_t, incron_spool_t)

    files_search_spool(incrond_t)

    miscfiles_read_localization(incrond_t)

The next run fails again, with the following denials:

    type=AVC msg=audit(1368732806.757:28328): avc:  denied  { create } for  pid=9419 comm="incrond" scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=unix_dgram_socket
    type=AVC msg=audit(1368732806.757:28329): avc:  denied  { read } for  pid=9419 comm="incrond" name="incron.d" dev="dm-2" ino=394140 scontext=system_u:system_r:incrond_t tcontext=root:object_r:incron_spool_t tclass=dir
    type=AVC msg=audit(1368732806.757:28330): avc:  denied  { create } for  pid=9419 comm="incrond" scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=unix_dgram_socket
    type=AVC msg=audit(1368732806.757:28331): avc:  denied  { create } for  pid=9419 comm="incrond" scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=unix_dgram_socket

So although `incrond_t` has search rights on the `incron_spool_t`
directories (through the `read_files_pattern`), we need to grant it
*list\_dir\_perms* as well (which contains the *read* permission). As
*list\_dir\_perms* contains search anyhow, we can just update the line
with:

    allow incrond_t incron_spool_t:dir list_dir_perms;
    allow incrond_t incron_spool_t:file read_file_perms;

Now the startup seems to work, but we still get denials:

    # run_init rc-service incrond start
    * Starting incrond... [ ok ]

    # ps -eZ | grep incrond
    # tail /var/log/cron.log
    (nothing)

    # tail audit.log
    type=AVC msg=audit(1368733443.799:28340): avc:  denied  { create } for  pid=9551 comm="incrond" scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=unix_dgram_socket
    type=AVC msg=audit(1368733443.802:28341): avc:  denied  { write } for  pid=9552 comm="incrond" name="/" dev="tmpfs" ino=1970 scontext=system_u:system_r:incrond_t tcontext=system_u:object_r:var_run_t tclass=dir
    type=AVC msg=audit(1368733443.806:28342): avc:  denied  { create } for  pid=9552 comm="incrond" scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=unix_dgram_socket
    type=AVC msg=audit(1368733443.806:28343): avc:  denied  { create } for  pid=9552 comm="incrond" scontext=system_u:system_r:incrond_t tcontext=system_u:system_r:incrond_t tclass=unix_dgram_socket

Those *unix\_dgram\_sockets* are here again. But seeing that `cron.log`
is empty, and *logging\_send\_syslog\_msg* is one of the interfaces that
would enable it, we might want to do just that so that we get more
information about why **incrond** doesn't properly start. Also, it tries
to write into `var_run_t` labeled directories, probably for its PID
file, so add in a proper file transition as well as manage rights:

    type incrond_var_run_t;
    files_pid_file(incrond_var_run_t)
    ...
    allow incrond_t incrond_var_run_t:file manage_file_perms;
    files_pid_filetrans(incrond_t, incrond_var_run_t, file)
    ...
    logging_send_syslog_msg(incrond_t)

With that in place:

    # run_init rc-service incrond start
    * Starting incrond... [ ok ]

    # ps -eZ | grep incron
    system_u:system_r:incrond_t      9648 ?        00:00:00 incrond

    # tail /var/log/cron.log 
    May 16 21:51:34 test incrond[9647]: starting service (version 0.5.10, built on May 16 2013 12:11:29)
    May 16 21:51:34 test incrond[9648]: loading system tables
    May 16 21:51:34 test incrond[9648]: loading user tables
    May 16 21:51:34 test incrond[9648]: table for invalid user user found (ignored)
    May 16 21:51:34 test incrond[9648]: ready to process filesystem events

    # tail audit.log
    type=AVC msg=audit(1368733894.641:28347): avc:  denied  { read } for  pid=9648 comm="incrond" name="nsswitch.conf" dev="dm-2" ino=393768 scontext=system_u:system_r:incrond_t tcontext=system_u:object_r:etc_t tclass=file
    type=AVC msg=audit(1368733894.645:28349): avc:  denied  { read } for  pid=9648 comm="incrond" name="passwd" dev="dm-2" ino=394223 scontext=system_u:system_r:incrond_t tcontext=system_u:object_r:etc_t tclass=file

It looks like we're getting there. Similar as with **incrontab** we
allow *auth\_use\_nsswitch* as well, and then get:

    # tail cron.log
    May 16 21:55:10 test incrond[9715]: starting service (version 0.5.10, built on May 16 2013 12:11:29)
    May 16 21:55:10 test incrond[9716]: loading system tables
    May 16 21:55:10 test incrond[9716]: loading user tables
    May 16 21:55:10 test incrond[9716]: loading table for user user
    May 16 21:55:10 test incrond[9716]: access denied on /home/user/test2 - events will be discarded silently
    May 16 21:55:10 test incrond[9716]: cannot create watch for user user: (13) Permission denied
    May 16 21:55:10 test incrond[9716]: ready to process filesystem events

    # tail audit.log
    type=AVC msg=audit(1368734110.912:28353): avc:  denied  { getattr } for  pid=9716 comm="incrond" path="/home/user/test2" dev="dm-0" ino=16 scontext=system_u:system_r:incrond_t tcontext=user_u:object_r:user_home_t tclass=dir
    type=AVC msg=audit(1368734110.913:28354): avc:  denied  { read } for  pid=9716 comm="incrond" name="test2" dev="dm-0" ino=16 scontext=system_u:system_r:incrond_t tcontext=user_u:object_r:user_home_t tclass=dir

What happens is that **incrond** read the (user) crontab, found that it
had to "watch" `/home/user/test2` but fails because SELinux doesn't
allow it to do so. We could just allow that, but we might do it a bit
better by looking into what we want it to do in a flexible manner...
next time ;-)
