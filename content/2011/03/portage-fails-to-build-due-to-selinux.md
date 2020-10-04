Title: Portage fails to build due to SELinux?
Date: 2011-03-03 00:26
Category: SELinux
Slug: portage-fails-to-build-due-to-selinux

If you're having troubles getting Portage to build packages due to
SELinux, then the reason usually is that it is unable to transition to
the proper portage domains. You'll get a nice OSError back with an ugly
backtrace, saying somewhere that "setexeccon" is misbehaving.

Now, the real issue (not being able to transition) means that the
current domain you are in (check **id -Z**) has no right to transition
to the *portage\_fetch\_t*, *portage\_t* or *portage\_sandbox\_t*
domains. You can verify that with **seinfo**:

    ~# id -Z
    unconfined_u:unconfined_r:unconfined_t
    ~# seinfo -runconfined_r -x | grep portage

The above example shows it for the *unconfined\_t* domain, but the same
is true if your current domain is a more illogical *local\_login\_t*
(hint: check your PAM settings) or *initrc\_t*. Now, if you want to fix
these things, we will eventually ask you to reemerge some things - which
was the first reason why you came asking how to fix things.

There are two ways to handle this situation: the proper way (disabling
SELinux and reenabling later) or the ugly way (hack Portage to ignore).

In the first way, you need to edit */etc/selinux/config*, set
*SELINUX=disabled*, reboot, emerge whatever you need, edit the file
again restoring SELINUX to what you had before, reboot, relabel your
entire filesystem (**rlpkg -a -r**) and perhaps even reboot again.

In the second method, edit /usr/lib(64)/portage/pym/portage/\_selinux.py
and go to line 79. It reads:

            if selinux.setexeccon(ctx) < 0:

Comment out that line (so it isn't lost) and substitute it with

            if selinux.setexeccon("\n") < 0:

Now you should be able to install software without hitting the error.
But note that *this is only to help you fix the real problem* as we're
circumventing SELinux integration in Portage a bit.
