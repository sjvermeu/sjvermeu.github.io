Title: A SELinux policy for incron: basic set for incrontab
Date: 2013-05-25 03:50
Category: SELinux
Tags: incron, incrontab, policy, selinux
Slug: a-selinux-policy-for-incron-basic-set-for-incrontab

Now that our [regular user is
allowed](http://blog.siphos.be/2013/05/a-selinux-policy-for-incron-our-first-interface/)
to execute **incrontab**, let's fire it up and look at the denials to
build up the policy.

    $ incrontab --help

That doesn't show much does it? Well, if you look into the `audit.log`
(or `avc.log`) file, you'll notice a lot of denials. If you are
developing a policy, it is wise to clear the entire log and reproduce
the "situation" so you get a proper idea of the scope.

    # cd /var/log/audit
    # > audit.log
    # tail -f audit.log | grep AVC

Now let's run **incrontab --help** again and look at the denials:

    type=AVC msg=audit(1368707274.429:28180): avc:  denied  { read write } for  pid=7742 comm="incrontab" path="/dev/tty2" dev="devtmpfs" ino=1042 scontext=user_u:user_r:incrontab_t tcontext=user_u:object_r:user_tty_device_t tclass=chr_file
    type=AVC msg=audit(1368707274.429:28180): avc:  denied  { use } for  pid=7742 comm="incrontab" path="/dev/tty2" dev="devtmpfs" ino=1042 scontext=user_u:user_r:incrontab_t tcontext=system_u:system_r:getty_t tclass=fd
    type=AVC msg=audit(1368707274.429:28180): avc:  denied  { use } for  pid=7742 comm="incrontab" path="/dev/tty2" dev="devtmpfs" ino=1042 scontext=user_u:user_r:incrontab_t tcontext=system_u:system_r:getty_t tclass=fd
    type=AVC msg=audit(1368707274.429:28180): avc:  denied  { use } for  pid=7742 comm="incrontab" path="/dev/tty2" dev="devtmpfs" ino=1042 scontext=user_u:user_r:incrontab_t tcontext=system_u:system_r:getty_t tclass=fd

You can start piping this information into **audit2allow** to generate
policy statements, but I personally prefer not to use **audit2allow**
for building new policies. For one, it is not intelligent enough to
deduce if a denial should be fixed by allowing it, or by relabeling or
even by creating a new type. Instead, it always grants it. Second, it
does not know if a denial is cosmetic (and thus can be ignored) or not.

This latter is also why I don't run domains in permissive mode to see
the majority of denials first and to build from those: you might see
denials that are actually never triggered when running in enforcing
mode. So let's look at the access to `/dev/tty2`. Given that this is a
user application where we expect output to the screen, we want to grant
it the proper access. With **sefindif** as
[documented](http://blog.siphos.be/2013/05/commandline-selinux-policy-helper-functions/)
before, we can look for the proper interfaces we need. I look for
`user_tty_device_t` with `rw` (commonly used for read-write):

    $ sefindif user_tty_device_t.*rw
    system/userdomain.if: template(`userdom_base_user_template',`
    system/userdomain.if:   allow $1_t user_tty_device_t:chr_file { setattr rw_chr_file_perms };
    system/userdomain.if: interface(`userdom_use_user_ttys',`
    system/userdomain.if:   allow $1 user_tty_device_t:chr_file rw_term_perms;
    system/userdomain.if: interface(`userdom_use_user_terminals',`
    system/userdomain.if:   allow $1 user_tty_device_t:chr_file rw_term_perms;
    system/userdomain.if: interface(`userdom_dontaudit_use_user_terminals',`
    system/userdomain.if:   dontaudit $1 user_tty_device_t:chr_file rw_term_perms;
    system/userdomain.if: interface(`userdom_dontaudit_use_user_ttys',`
    system/userdomain.if:   dontaudit $1 user_tty_device_t:chr_file rw_file_perms;

Two of these look interesting: *userdom\_use\_user\_ttys* and
*userdom\_use\_user\_terminals*. Looking at the API documentation (or
the rules defined therein using **seshowif**) reveals that
*userdom\_use\_user\_terminals* is needed if you also want the
application to work when invoked through a devpts terminal, which is
probably also something our user(s) want to do, so we'll add that. The
second one - using the file descriptor that has the `getty_t` context -
is related to this, but not granted through the
*userdom\_use\_user\_ttys*. We could grant *getty\_use\_fds* but my
experience tells me that *domain\_use\_interactive\_fds* is more likely
to be needed: the application inherits and uses a file descriptor
currently owned by `getty_t` but it could be from any of the other
domains that has such file descriptors. For instance, if you grant the
*incron\_role* to `sysadm_r`, then a user that switched roles through
**newrole** will see denials for using a file descriptor owned by
`newrole_t`.

Experience is an important aspect in developing policies. If you would
go through with *getty\_use\_fds* it would work as well, and you'll
probably hit the above mentioned experience later when you try the
application through a few different paths (such as within a screen
session or so). When you *think* that the target context (in this case
`getty_t`) could be a placeholder (so other types are likely to be
needed as well), make sure you check which attributes are assigned to
the type:

    # seinfo -tgetty_t -x
       getty_t
          privfd
          mcssetcats
          mlsfileread
          mlsfilewrite
          application_domain_type
          domain

Of the above ones, `privfd` is the important one:

    $ sefindif privfd.*use
    kernel/domain.if: interface(`domain_use_interactive_fds',`
    kernel/domain.if:       allow $1 privfd:fd use;
    kernel/domain.if: interface(`domain_dontaudit_use_interactive_fds',`
    kernel/domain.if:       dontaudit $1 privfd:fd use;

So let's update `incron.te` accordingly:

    ...
    type incron_spool_t;
    files_type(incron_spool_t)

    ###########################################
    #
    # incrontab policy
    #

    userdom_use_user_terminals(incrontab_t)
    domain_use_interactive_fds(incrontab_t)

Rebuild the policy and load it in memory.

If we now run **incrontab** we get the online help as we expected. Let's
now look at the currently installed incrontabs (there shouldn't be any
of course):

    $ incrontab -l
    cannot determine current user

In the denials, we notice:

    type=AVC msg=audit(1368708632.060:28192): avc:  denied  { create } for  pid=7968 comm="incrontab" scontext=user_u:user_r:incrontab_t tcontext=user_u:user_r:incrontab_t tclass=unix_stream_socket
    type=AVC msg=audit(1368708632.060:28194): avc:  denied  { read } for  pid=7968 comm="incrontab" name="nsswitch.conf" dev="dm-2" ino=393768 scontext=user_u:user_r:incrontab_t tcontext=system_u:object_r:etc_t tclass=file
    type=AVC msg=audit(1368708632.062:28196): avc:  denied  { read } for  pid=7968 comm="incrontab" name="passwd" dev="dm-2" ino=394223 scontext=user_u:user_r:incrontab_t tcontext=system_u:object_r:etc_t tclass=file

Let's first focus on `nsswitch.conf` and `passwd`. Although both require
read access to `etc_t` files, it might be wrong to just add in
*files\_read\_etc* (which is what **audit2allow** is probably going to
suggest). For nsswitch, there is a special interface available:
*auth\_use\_nsswitch*. It is very, very likely that you'll need this
one, especially if you want to share the policy with others who might
not have all of the system databases in local files (as `etc_t` files).

    ...
    domain_use_interactive_fds(incrontab_t)
    auth_use_nsswitch(incrontab_t)

Let's retry:

    $ incrontab -l
    cannot read table for 'user': Permission denied

    # tail audit.log
    type=AVC msg=audit(1368708893.260:28199): avc:  denied  { search } for  pid=7997 comm="incrontab" name="spool" dev="dm-4" ino=20 scontext=user_u:user_r:incrontab_t tcontext=system_u:object_r:var_spool_t tclass=dir

So we need to grant search privileges on `var_spool_t`. This is offered
through *files\_search\_spool*. Add it to the policy, rebuild and retry.

    $ incrontab -l
    cannot read table for 'user': Permission denied

    # tail audit.log
    type=AVC msg=audit(1368709146.426:28201): avc:  denied  { search } for  pid=8046 comm="incrontab" name="incron" dev="dm-4" ino=19725 scontext=user_u:user_r:incrontab_t tcontext=root:object_r:incron_spool_t tclass=dir

For this one, no interface exists yet. We might be able to create one
for ourselves, but as long as other domains don't need it, we can just
add it locally in our policy:

    allow incrontab_t incron_spool_t:dir search_dir_perms;

Adding raw allow rules in a policy is, according to the [refpolicy
styleguide](http://oss.tresys.com/projects/refpolicy/wiki/StyleGuide),
only allowed if the policy module defines both the source and the
destination type of the rule. If you look into other policies you might
also find that you can use the *search\_dirs\_patter* call. However,
that one only makes sense if you need to do this on top of another
directory - just look at the definition of *search\_dirs\_pattern*. So
with this permission set, let's retry.

    $ incrontab -l
    no table for user

Great, we have successfully updated the policy until the commands
worked. In the next post, we'll enhance it even further while creating
new incrontabs.
