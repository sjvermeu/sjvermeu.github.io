Title: Why oh why does a process run in unlabeled_t?
Date: 2013-05-21 03:50
Category: SELinux
Tags: policy, selinux, unlabeled
Slug: why-oh-why-does-a-process-run-in-unlabeled_t

If you notice that a process is running in the `unlabeled_t` domain, the
first question to ask is how it got there.

Well, one way is to have a process running in a known domain, like
`screen_t`, after which the SELinux policy module that provides this
domain is removed from the system (or updated and the update does not
contain the `screen_t` definition anymore):

    test ~ # ps -eZ | grep screen
    root:sysadm_r:sysadm_screen_t    5047 ?        00:00:00 screen
    test ~ # semodule -r screen
    test ~ # ps -eZ | grep screen
    system_u:object_r:unlabeled_t    5047 ?        00:00:00 screen

In permissive mode, this will be visible easily; in enforcing mode, the
domains you are running in might not be allowed to do anything with
`unlabeled_t` files, directories and processes, so **ps** might not show
it even though it still exists:

    test audit # ps -eZ | grep 5047
    test audit # ls -dZ /proc/5047
    ls: cannot access /proc/5047: Permission denied
    test audit # tail audit.log | grep unlabeled
    type=AVC msg=audit(1368698097.494:27806): avc:  denied  { getattr } for  pid=4137 comm="bash" path="/proc/5047" dev="proc" ino=6677 scontext=root:sysadm_r:sysadm_t tcontext=system_u:object_r:unlabeled_t tclass=dir

Notice that, if you reload the module, the process becomes visible
again. That is because the process context itself (`screen_t`) is
retained, but because the policy doesn't know it anymore, it shows it as
`unlabeled_t`.

Basically, the moment the policy doesn't know how a label would be
(should be), it uses `unlabeled_t`. The SELinux policy then defines how
this `unlabeled_t` domain is handled. Processes getting into
`unlabeled_t` is not that common though as there is no supported
transition to it. The above one is one way that this still can occur.
