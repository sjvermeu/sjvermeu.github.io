Title: Policy 25, 26
Date: 2011-06-01 21:32
Category: SELinux
Slug: policy-25-26

Recently I've seen quite a few messages on IRC pop up about `policy.25`
or even `policy.26` so I harassed the guys in the chat channel to talk
about it. Apparently, these new binary policy formats add support for
filename transitions and non-process role transitions.

Currently, when you initiate a type transition, you would use something
like so:

    type_transition mysqld_t mysql_db_t:sock_file mysqld_var_run_t;

This statement sais that, if a process running in the `mysqld_t` domain
creates a socket in a directory labelled with `mysql_db_t`, then this
socket gets the `mysqld_var_run_t` label. In other words, the type
transitions from `mysql_db_t` (parent label) to `mysqld_var_run_t`.

What will be supported from version 25 onwards is that you can add
another argument, the file name (well, actually it is called "last name
component" and should be seen as what **basename /path/to/something**
returns). That allows processes running in the same domain and writing
files in directories labelled with the same type to still have these
files labelled specifically. A non-existing example:

    type_transition puppet_t etc_t:file locale_t timezone;
    type_transition puppet_t etc_t:file net_conf_t resolv.conf;

In the above example, if the `puppet_t` domain creates files in
<path>/etc</path> (which is labelled `etc_t`) then based on the file it
is creating, this file gets a different label (`/etc/timezone` gets
labelled `locale_t` whereas `/etc/resolv.conf` gets labelled
`net_conf_`).

The second change (valid since policy version 26) is that role
transitions now also support non-process class transitions. [A lengthy
post](http://permalink.gmane.org/gmane.comp.security.selinux/15079) that
Harry Ciao made helps to describe it. The `role_transition` support in
SELinux was previously used in the following way:

    role_transition roleA_r some_exec_t roleB_r;

What this statement indicates is that a domain running within `roleA_r`
and that is executing `some_exec_t` will change its runtime role to
`roleB_r`. If by calling `some_exec_t` a domain transition occurs as
well (which is most common when a role transition is supported as well)
then this domain will run with the `roleB_r` runtime role.

The added functionality is now that this isn't limited to processes
anymore. You can now define non-process classes as well. If the source
domain creates something new of a particular class and a role transition
is declared for that, then the resulting new object will have the
specified role assigned to it (rather than the default `object_r`). So
for instance:

    role_transition sysadm_r cron_spool_t:file sysadm_r;

If a domain running within the `sysadm_r` role creates a file in a
directory labelled `cron_spool_t`, then the resulting file will have the
role `sysadm_r` rather than `object_r`. This opens up more support for
role-based access controls (similar to the UBAC functionality that I
described earlier, but in some cases more flexible). I'm pretty sure
that the crontab management for vixie-cron will be one of the first ones
that can benefit greatly from this ;-)
