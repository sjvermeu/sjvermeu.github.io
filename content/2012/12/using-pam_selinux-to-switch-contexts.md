Title: Using pam_selinux to switch contexts
Date: 2012-12-10 22:11
Category: SELinux
Slug: using-pam_selinux-to-switch-contexts

With SELinux managing the access controls of applications towards the
resources on the system, a not-to-be forgotten important component on
any Unix/Linux system is the authentication part. Most systems use or
support PAM, the *Pluggable Authentication Modules*, and for SELinux
this plays an important role.

Applications that are PAM-enabled use PAM for the authentication of user
activities. If this includes setting up an authenticated session, then
the "session" part of the PAM configuration is also handled. And for
SELinux, this is a nice-to-have, since this means applications that are
not SELinux-aware can still enjoy transitions towards specified domains
depending on the user that is authenticated.

The "not SELinux-aware" here is important. By default, applications keep
running in one security context for their lifetime. If they invoke a
`execve` or similar call (which is used to start another application or
command when used in combination with a `fork`), then the SELinux policy
*might* trigger an automatic transition if the holy grail of fourfold
rules is set:

1.  a transition from the current context to the new one is allowed
2.  the label of the executed command/label is marked as an entrypoint
    for the new context
3.  the current context is allowed to execute that application
4.  an automatic transition rule is made from the current context to the
    new one over the command label

Or, in SELinux policy terms, assuming the domains are `source_t` and
`destination_t` with the label of the executed file being `file_exec_t`:

    allow source_t destination_t:process transition;
    allow destination_t file_exec_t:file entrypoint;
    allow source_t file_exec_t:file execute;
    type_transition source_t file_exec_t : process destination_t;

If those four settings are valid, then (and only then) can the automatic
transition be active.

Sadly, for applications that run user actions (like cron systems, remote
logon services and more) this is not sufficient, since there are two
major downsides to this "flexibility":

1.  The rules to transition are static and do not depend on the identity
    of the user for which activities are launched. The policy can not
    deduce this identity from a file context either.
2.  The policy is statically defined: different transitions based on
    different user identities are not possibel.

To overcome this problem, applications can be made SELinux-aware,
linking with the libselinux library and invoking the necessary switches
themselves (or running the commands with `runcon`). Luckily, this is
where the PAM system comes to play to aide us in setting up this policy
behavior.

When an application is PAM-enabled, it will invoke PAM calls to
authenticate and possibly set up the user session. The actions that PAM
invokes are defined by the PAM configuration files. For instance, for
the at daemon:

    ## /etc/pam.d/atd
    #
    # The PAM configuration file for the at daemon
    #

    auth    required        pam_env.so
    auth    include         system-services
    account include         system-services
    session include         system-services

I am not going to dive into the details of PAM in this blog post, so
let's just jump to the session management part. In the above example
file, if PAM sets up (or shuts down) a user session for the service (at
in our case), it will go through the PAM services that are listed in the
*system-services* definition, which looks like so:

    ## /etc/pam.d/system-services
    auth            sufficient      pam_permit.so
    account         include         system-auth
    session         optional        pam_loginuid.so
    session         required        pam_limits.so 
    session         required        pam_env.so 
    session         required        pam_unix.so 
    session         optional        pam_permit.so

Until now, nothing SELinux-specific is enabled. But if we change the
session section of the at service to the following, then the SELinux pam
module will be called as well:

    session optional        pam_selinux.so close
    session include         system-services
    session optional        pam_selinux.so multiple open

Now that the SELinux module is called, pam\_selinux will try to switch
the context of the process based on the definitions in the
/etc/selinux/strict/contexts location (substitute strict with the policy
type you use). The outcome of this switching can be checked with the
**getseuser** application:

    ~# getseuser root system_u:system_r:crond_t
    seuser:  root, level (null)
    Context 0       root:sysadm_r:cronjob_t
    Context 1       root:staff_r:cronjob_t

By providing the contexts in configurable files in
/etc/selinux/strict/contexts, a non-SELinux aware application suddenly
becomes SELinux-aware (through the PAM support it already has) without
needing to patch or even rebuild the application. All that is need is to
allow the security context of the application to switch ids and roles
(as that is by default not allowed), which I believe is offered through
the following statements:

    domain_subj_id_change_exemption(atd_t)
    domain_role_change_exemption(atd_t)

    selinux_validate_context(atd_t)
    selinux_compute_access_vector(atd_t)
    selinux_compute_create_context(atd_t)
    selinux_compute_relabel_context(atd_t)
    selinux_compute_user_contexts(atd_t)

    seutil_read_config(atd_t)
    seutil_read_default_contexts(atd_t)
