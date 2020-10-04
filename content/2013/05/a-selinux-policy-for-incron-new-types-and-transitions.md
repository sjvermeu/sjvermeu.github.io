Title: A SELinux policy for incron: new types and transitions
Date: 2013-05-26 03:50
Category: SELinux
Tags: incron, policy, selinux
Slug: a-selinux-policy-for-incron-new-types-and-transitions

So I've shown the [iterative approach
used](http://blog.siphos.be/2013/05/a-selinux-policy-for-incron-basic-set-for-incrontab/)
to develop policies. Again, please be aware that this is my way of
developing policies, other policy developers might have a different
approach. We were working on the **incrontab** command, so let's
continue with trying to create a new user incrontab:

    $ incrontab -e
    cannot create temporary file: Permission denied

    # tail audit.log
    type=AVC msg=audit(1368709633.285:28211): avc:  denied  { setgid } for  pid=8159 comm="incrontab" capability=6  scontext=user_u:user_r:incrontab_t tcontext=user_u:user_r:incrontab_t tclass=capability
    type=AVC msg=audit(1368709633.285:28212): avc:  denied  { setuid } for  pid=8159 comm="incrontab" capability=7  scontext=user_u:user_r:incrontab_t tcontext=user_u:user_r:incrontab_t tclass=capability
    type=AVC msg=audit(1368709633.287:28213): avc:  denied  { search } for  pid=8159 comm="incrontab" name="/" dev="tmpfs" ino=3927 scontext=user_u:user_r:incrontab_t tcontext=system_u:object_r:tmp_t tclass=dir

The requests for the setuid and setgid capabilities are needed for the
application to safely handle the user incrontabs. Note that SELinux does
not "remove" the setuid bit on the binary itself, but does govern the
related capabilities. Since this is required, we will add these
capabilities to the policy. We also notice that **incrontab** searched
in the `/tmp` location.

    allow incrontab_t self:capability { setuid setgid };
    ...
    files_search_tmp(incrontab_t)

In the next round of iteration, we notice the same error message with
the following denial:

    type=AVC msg=audit(1368728433.521:28215): avc:  denied  { write } for  pid=8913 comm="incrontab" name="/" dev="tmpfs" ino=3927 scontext=user_u:user_r:incrontab_t tcontext=system_u:object_r:tmp_t tclass=dir

It is safe to assume here that the process wants to create a temporary
file (if it is a directory, we will find out later and can adapt). But
when temporary files are created, we better make those files a specific
type, like `incrontab_tmp_t`. So we define that on top of the policy:

    type incrontab_tmp_t;
    files_tmp_file(incrontab_tmp_t)

Also, we need to allow the `incrontab_t` domain write privileges into
the `tmp_t` labeled directory, but with an automatic file transition
towards `incrontab_tmp_t` for every file written. This is done through
the *files\_tmp\_filetrans* method:

    files_tmp_filetrans(incrontab_t, incrontab_tmp_t, file)

What this sais is that, if a domain `incrontab_t` wants to create a
`file` inside `tmp_t`, then this file is automatically labeled
`incrontab_tmp_t`. With SELinux, you can make this more precise: if you
know what the file name would be, then you can add that as a fourth
argument. However, this does not seem necessary now since we definitely
want all files created in `tmp_t` to become `incrontab_tmp_t`. All that
rests us is to allow **incrontab** to actually manage those files:

    allow incrontab_t incrontab_tmp_t:file manage_file_perms;

With those in place, let's look at the outcome:

    $ incrontab -e
    editor finished with error: No such file or directory

    # tail audit.log
    type=AVC msg=audit(1368729268.465:28217): avc:  denied  { search } for  pid=8981 comm="incrontab" name="bin" dev="dm-3" ino=524289 scontext=user_u:user_r:incrontab_t tcontext=system_u:object_r:bin_t tclass=dir

Considering that here, **incrontab** is going to launch the users
`$EDITOR` application to allow him (or her) to create an incrontab, we
need to allow `incrontab_t` not only search privileges inside `bin_t`
directories, but also execute rights:
*corecmd\_exec\_bin(incrontab\_t)*. We choose here to execute the editor
inside the existing domain (`incrontab_t`) instead of creating a
different domain for the editor for the following reasons:

-   If we would create a separate domain for the editor, the editor
    would eventually need to have major permissions, depending on when
    it is used. Editors can be used to modify the sudoers files, passwd
    files, the `/etc/selinux/config` file, etc. Instead, it makes much
    more sense to just be able to launch the editor in the current
    domain (which is much more confined to its specific purpose)
-   The additional privileges needed to launch the editor are usually
    very slim, or even nonexistent. It generally only makes sense if, by
    executing it, the existing domain would need many more privileges,
    because then a new (confined) domain keeps the privileges for the
    current domain low.

Let's see if things work now:

    $ incrontab -e
    (Editor opened, so I added in an incrontab line. Upon closing:)
    cannot move temporary table: Permission denied

    # tail audit.log
    type=AVC msg=audit(1368729825.673:28237): avc:  denied  { dac_read_search } for  pid=9030 comm="incrontab" capability=2  scontext=user_u:user_r:incrontab_t tcontext=user_u:user_r:incrontab_t tclass=capability
    type=AVC msg=audit(1368729825.673:28237): avc:  denied  { dac_override } for  pid=9030 comm="incrontab" capability=1  scontext=user_u:user_r:incrontab_t tcontext=user_u:user_r:incrontab_t tclass=capability

From a quick look through **ps**, I notice that the application runs as
the user (luckily, otherwise I could use the editor to escape and get a
root shell) after which it tries to do something. Of course, it makes
sense that it wants to move this newly created incrontab file somewhere
in `/var/spool/incron` so we grant it the permission to
`dac_read_search` (which is lower than `dac_override` as [explained
before](http://blog.siphos.be/2013/05/the-weird-audit_access-permission/)):

    allow incrontab_t self:capability { dac_read_search setuid setgid };

On to the next failure:

    $ incrontab -e 
    cannot move temporary table: Permission denied

    # tail audit.log
    type=AVC msg=audit(1368730155.706:28296): avc:  denied  { write } for  pid=9088 comm="incrontab" name="incron" dev="dm-4" ino=19725 scontext=user_u:user_r:incrontab_t tcontext=root:object_r:incron_spool_t tclass=dir

Now the application wants to write this file there. Now remember we
already have `search_dir_perms` permissions into `incron_spool_t`? We
need to expand those with read/write permissions into the directory, and
manage permissions on files (manage because users should be able to
create, modify and delete their files). These two permissions are
combined in the *manage\_files\_pattern* interface, and makes the search
one obsolete:

    manage_files_pattern(incrontab_t, incron_spool_t, incron_spool_t)

    $ incrontab -e
    ...
    table updated

Finally! And looking at the other options in **incrontab**, it seems
that the policy for `incrontab_t` is finally complete, and looks like
so:


    ###########################################
    #
    # incrontab policy
    #

    allow incrontab_t self:capability { setuid setgid dac_read_search };

    manage_files_pattern(incrontab_t, incron_spool_t, incron_spool_t)

    allow incrontab_t incrontab_tmp_t:file manage_file_perms;
    files_tmp_filetrans(incrontab_t, incrontab_tmp_t, file)

    corecmd_exec_bin(incrontab_t)

    domain_use_interactive_fds(incrontab_t)

    files_search_spool(incrontab_t)
    files_search_tmp(incrontab_t)

    auth_use_nsswitch(incrontab_t)

    userdom_use_user_terminals(incrontab_t)

Next on the agenda: the `incrond_t` domain.
