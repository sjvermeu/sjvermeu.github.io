Title: Why does it access /etc/shadow?
Date: 2014-12-30 22:48
Category: SELinux
Tags: chkpwd, pam, selinux, shadow, unix_chkpwd
Slug: why-does-it-access-etcshadow

While updating the SELinux policy for the Courier IMAP daemon, I noticed
that it (well, the authdaemon that is part of Courier) wanted to access
`/etc/shadow`, which is of course a big no-no. It doesn't take long to
know that this is through the PAM support (more specifically,
`pam_unix.so`). But why? After all, `pam_unix.so` should try to execute
`unix_chkpwd` to verify a password and not read in the shadow file
directly (which would require all PAM-aware applications to be granted
access to the shadow file).

So I dived into the PAM-Linux sources (yay free software).

In `pam_unix_passwd.c`, the *\_unix\_run\_verify\_binary()* method is
called but only if the *get\_account\_info()* method returns
`PAM_UNIX_RUN_HELPER`.

``` {lang="c"}
static int _unix_verify_shadow(pam_handle_t *pamh, const char *user, unsigned int ctrl)
{
...
        retval = get_account_info(pamh, user, &pwent, &spent);
...
        if (retval == PAM_UNIX_RUN_HELPER) {
                retval = _unix_run_verify_binary(pamh, ctrl, user, &daysleft);
                if (retval == PAM_AUTH_ERR || retval == PAM_USER_UNKNOWN)
                        return retval;
        }
```

In `passverify.c` this method will check the password entry file and, if
the entry is a shadow file, will return `PAM_UNIX_RUN_HELPER` if the
current user id is not root, or if SELinux is enabled:

``` {lang="c"}
PAMH_ARG_DECL(int get_account_info,
        const char *name, struct passwd **pwd, struct spwd **spwdent)
{
        /* UNIX passwords area */
        *pwd = pam_modutil_getpwnam(pamh, name);        /* Get password file entry... */
        *spwdent = NULL;

        if (*pwd != NULL) {
...
                } else if (is_pwd_shadowed(*pwd)) {
                        /*
                         * ...and shadow password file entry for this user,
                         * if shadowing is enabled
                         */
#ifndef HELPER_COMPILE
                        if (geteuid() || SELINUX_ENABLED)
                                return PAM_UNIX_RUN_HELPER;
#endif
```

The `SELINUX_ENABLED` is a C macro defined in the same file:

``` {lang="c"}
#ifdef WITH_SELINUX
#include 
#define SELINUX_ENABLED is_selinux_enabled()>0
#else
#define SELINUX_ENABLED 0
#endif
```

And this is where my "aha" moment came forth: the Courier authdaemon
runs as root, so its user id is 0. The *geteuid()* method will return 0,
so the `SELINUX_ENABLED` macro must return non-zero for the proper path
to be followed. A quick check in the audit logs, after disabling
*dontaudit* lines, showed that the Courier IMAPd daemon wants to get the
attribute(s) of the `security_t` file system (on which the SELinux
information is exposed). As this was denied, the call to
*is\_selinux\_enabled()* returns -1 (error) which, through the macro,
becomes 0.

So granting *selinux\_getattr\_fs(courier\_authdaemon\_t)* was enough to
get it to use the `unix_chkpwd` binary again.

To fix this properly, we need to grant this to all PAM using
applications. There is an interface called *auth\_use\_pam()* in the
policies, but that isn't used by the Courier policy. Until now, that is
;-)
