Title: Overview of Linux capabilities, part 1
Date: 2013-05-04 03:50
Category: Security
Tags: capabilities, linux
Slug: overview-of-linux-capabilities-part-1

In the
[previous](http://blog.siphos.be/2013/05/capabilities-a-short-intro/)
[posts](http://blog.siphos.be/2013/05/restricting-and-granting-capabilities/),
I talked about capabilities and how they can be used to allow processes
to run in a privileged fashion without granting them full root access to
the system. An example given was how capabilities can be leveraged to
run **ping** without granting it setuid root rights. But what are the
various capabilities that Linux is, well, capable of?

There are many, and as time goes by, more capabilities are added to the
set. The last capability added to the main Linux kernel tree was the
`CAP_BLOCK_SUSPEND` in the 3.5 series. An overview of all capabilities
can be seen with **man capabilities** or by looking at the Linux kernel
source code, `include/uapi/linux/capability.h`. But because you are all
lazy, and because it is a good exercise for myself, I'll go through many
of them in this and the next few posts.

For now, let's look at file related capabilities. As a reminder, if you
want to know which SELinux domains are "granted" a particular
capability, you can look this up using **sesearch**. The capability is
either in the *capability* or *capability2* class, and is named after
the capability itself, without the `CAP_` prefix:

    $ sesearch -c capability -p chown -A

CAP\_CHOWN
:   Allow making changes to the file UIDs and GIDs.

CAP\_DAC\_OVERRIDE
:   Bypass file read, write and execute permission checks. I came across
    a [reddit
    post](http://www.reddit.com/r/linux/comments/1cnn15/for_chmod_why_is_root_allowed_to_execute_programs/)
    that was about this capability not that long ago.

CAP\_DAC\_READ\_SEARCH
:   Bypass file read permission and directory read/search
    permission checks.

CAP\_FOWNER
:   This capability governs 5 capabilities in one:
    </p>
    -   Bypass permission checks on operations that normally require the
        file system UID of the process to match the UID of the file
        (unless already granted through `CAP_DAC_READ_SEARCH` and/or
        `CAP_DAC_OVERRIDE`)
    -   Allow to set extended file attributes
    -   Allow to set access control lists
    -   Ignore directory sticky bit on file deletion
    -   Allow specifying `O_NOATIME` for files in *open()* and *fnctl()*
        calls

CAP\_FSETID
:   Do not clear the setuid/setgid permission bits when a file is
    modified

CAP\_LEASE
:   Allow establishing leases on files

CAP\_LINUX\_IMMUTABLE
:   Allow setting *FS\_APPEND\_FL* and *FP\_IMMUTABLE\_FL* inode flags

CAP\_MKNOD
:   Allow creating special files with **mknod**

CAP\_SETFCAP
:   Allow setting file capabilities (what I did with the **anotherping**
    binary in the previous post)

When working with SELinux (especially when writing applications), you'll
find that the `CAP_DAC_READ_SEARCH` and `CAP_DAC_OVERRIDE` capability
come up often. This is the case when applications are written to run as
root yet want to scan through, read or even execute non-root owned
files. Without SELinux, because these run as root, this is all granted.
However, when you start confining those applications, it becomes
apparent that they require this capability. Another example is when you
run user applications, as root, like when trying to play a movie or
music file with **mplayer** when this file is owned by a regular user:

    type=AVC msg=audit(1367145131.860:18785): avc:  denied  { dac_read_search } for
    pid=8153 comm="mplayer" capability=2  scontext=staff_u:sysadm_r:mplayer_t
    tcontext=staff_u:sysadm_r:mplayer_t tclass=capability

    type=AVC msg=audit(1367145131.860:18785): avc:  denied  { dac_override } for
    pid=8153 comm="mplayer" capability=1  scontext=staff_u:sysadm_r:mplayer_t
    tcontext=staff_u:sysadm_r:mplayer_t tclass=capability

Notice the time stamp: both checks are triggered at the same time. What
happens is that the Linux security hooks first check for
`DAC_READ_SEARCH` (the "lesser" grants of the two) and then for
`DAC_OVERRIDE` (which contains `DAC_READ_SEARCH` and more). In both
cases, the check failed in the above example.

The `CAP_LEASE` capability is one that I had not heard about before
(actually, I had not heard of getting "file leases" on Linux either). A
file lease allows for the lease holder (which requires this capability)
to be notified when another process tries to open or truncate the file.
When that happens, the call itself is blocked and the lease holder is
notified (usually using SIGIO) about the access. It is not really to
lock a file (since, if the lease holder doesn't properly release it, it
is forcefully "broken" and the other process can continue its work) but
rather to properly close the file descriptor or flushing caches, etc.

BTW, on my system, only 5 SELinux domains hold the *lease* capability.

There are 37 capabilities known by the Linux kernel at this time. The
above list has 9 file related ones. So perhaps next I can talk about
process capabilities.
