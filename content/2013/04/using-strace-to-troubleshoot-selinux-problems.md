Title: Using strace to troubleshoot SELinux problems
Date: 2013-04-24 03:50
Category: SELinux
Tags: debug, selinux, strace
Slug: using-strace-to-troubleshoot-selinux-problems

When SELinux is playing tricks on you, you can just "allow" whatever it
wants to do, but that is not always an option: sometimes, there is no
denial in sight because the problem lays within SELinux-aware
applications (applications that might change their behavior based on
what the policy sais or even based on if SELinux is enabled or not). At
other times, you get a strange behavior that isn't directly visible what
the cause is. But mainly, if you want to make sure that allowing
something is correct (and not just a corrective action), you need to be
absolutely certain that what you want to allow is security-wise
acceptable.

To debug such issues, I often take the **strace** command to debug the
application at hand. To use **strace**, I toggle the *allow\_ptrace*
boolean (**strace** uses `ptrace()` which, by default, isn't allowed
policy-wise) and then run the offending application through **strace**
(or attach to the running process if it is a daemon). For instance, to
debug a [tmux issue](https://bugs.gentoo.org/show_bug.cgi?id=463222) we
had with the policy not that long ago:

    # setsebool allow_ptrace on
    # strace -o strace.log -f -s 256 tmux

The resulting log file (strace.log) might seem daunting at first to look
at. What you see are the system calls that the process is performing,
together with their options but also the return code of each call. This
is especially important as SELinux, if it denies something, often
returns something like EACCESS (Permission Denied).

    7313  futex(0x349e016f080, FUTEX_WAKE_PRIVATE, 2147483647) = 0
    7313  futex(0x5aad58fd84, FUTEX_WAKE_PRIVATE, 2147483647) = 0
    7313  stat("/", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
    7313  stat("/home", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
    7313  stat("/home/swift", {st_mode=S_IFDIR|0755, st_size=12288, ...}) = 0
    7313  stat("/home/swift/.pki", {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
    7313  stat("/home/swift/.pki/nssdb", {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
    7313  statfs("/home/swift/.pki/nssdb", 0x3c3cab6fa50) = -1 EACCES (Permission denied)

Most (if not all) of the methods shown in a strace log are documented
through manpages, so you can quickly find out that `futex()` is about
fast user-space locking, `stat()` (**man 2 stat** to see the information
about the method instead of the application) is about getting file
status and `statfs()` is for getting file system statistics.

The most common permission issues you'll find are file related:

    7313  open("/proc/filesystems", O_RDONLY) = -1 EACCES (Permission denied)

In the above case, you notice that the application is trying to open the
`/proc/filesystems` file read-only. In the SELinux logs, this might be
displayed as follows:

    audit.log:type=AVC msg=audit(1365794728.180:3192): avc:  denied  { read } for  
    pid=860 comm="nacl_helper_boo" name="filesystems" dev="proc" ino=4026532034 
    scontext=staff_u:staff_r:chromium_naclhelper_t tcontext=system_u:object_r:proc_t tclass=file

Now the case of **tmux** before was not an obvious one. In the end, I
compared the strace output's of two runs (one in enforcing and one in
permissive) to find what the difference would be. This is the result:

    Enforcing:

    10905 fcntl(9, F_GETFL) = 0x8000 (flags O_RDONLY|O_LARGEFILE) 
    10905 fcntl(9, F_SETFL, O_RDONLY|O_NONBLOCK|O_LARGEFILE) = 0

    Permissive:

    10905 fcntl(9, F_GETFL) = 0x8002 (flags O_RDWR|O_LARGEFILE) 
    10905 fcntl(9, F_SETFL, O_RDWR|O_NONBLOCK|O_LARGEFILE) = 0

You notice the difference? In enforcing-mode, one of the flags on the
file descriptor has `O_RDONLY` whereas the one in permissive mode as
`O_RDWR`. This means that the file descriptor in enforcing mode is
read-only whereas in permissive-mode is read-write. What we then do in
the strace logs is to see where this file descriptor (with id=9) comes
from:

    10905 dup(0)     = 9
    10905 dup(1)     = 10
    10905 dup(2)     = 11

As the man-pages sais, `dup()` duplicates a file descriptor. And
because, by convention, the first three file descriptors of an
application correspond with standard input (0), standard output (1) and
error output (2), we now know that the file descriptor with id=9 comes
from the standard input file descriptor. Although this one should be
read-only (it is the input that the application gets = reads), it seems
that tmux might want to use this for writes as well. And that is what
happens - tmux sends the file descriptor to the tmux server to check if
it is a tty and then uses it to write to the screen.

Now what does that have to do with SELinux? It has to mean something,
otherwise running in permissive mode would give the same result. After
some investigation, we found out that using **newrole** to switch roles
changes the flags of the standard input (as then provided by
**newrole**) from `O_RDWR` to `O_RDONLY` (code snippet from `newrole.c`
- look at the first call to `open()`):

    /* Close the tty and reopen descriptors 0 through 2 */
    if (ttyn) {
            if (close(fd) || close(0) || close(1) || close(2)) {
                    fprintf(stderr, _("Could not close descriptors.\n"));
                    goto err_close_pam;
            }
            fd = open(ttyn, O_RDONLY | O_NONBLOCK);
            if (fd != 0)
                    goto err_close_pam;
            fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0) & ~O_NONBLOCK);
            fd = open(ttyn, O_RDWR | O_NONBLOCK);
            if (fd != 1)
                    goto err_close_pam;
            fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0) & ~O_NONBLOCK);
            fd = open(ttyn, O_RDWR | O_NONBLOCK);
            if (fd != 2)
                    goto err_close_pam;
            fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0) & ~O_NONBLOCK);
    }

Such obscure problems are much easier to detect and troubleshoot thanks
to tools like **strace**.
