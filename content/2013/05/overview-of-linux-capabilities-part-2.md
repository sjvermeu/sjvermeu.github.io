Title: Overview of Linux capabilities, part 2
Date: 2013-05-05 03:50
Category: Security
Tags: capabilities, grsecurity, linux, nosuid, selinux, tpe
Slug: overview-of-linux-capabilities-part-2

As I've (in a very high level) [described
capabilities](http://blog.siphos.be/2013/05/capabilities-a-short-intro/)
and talked a bit on how to [work with
them](http://blog.siphos.be/2013/05/restricting-and-granting-capabilities/),
I started with a small overview of
[file-related](http://blog.siphos.be/2013/05/overview-of-linux-capabilities-part-1/)
capabilities. So next up are process-related capabilities (note, this
isn't a conform terminology, more some categorization that I do myself).

CAP\_IPC\_LOCK
:   Allow the process to lock memory

CAP\_IPC\_OWNER
:   Bypass the permission checks for operations on System V IPC objects
    (similar to the `CAP_DAC_OVERRIDE` for files)

CAP\_KILL
:   Bypass permission checks for sending signals

CAP\_SETUID
:   Allow the process to make arbitrary manipulations of process UIDs
    and create forged UID when passing socket credentials via UNIX
    domain sockets

CAP\_SETGID
:   Same, but then for GIDs

CAP\_SYS\_NICE
:   This capability governs several permissions/abilities, namely to
    allow the process to
    </p>
    -   change the *nice* value of itself and other processes
    -   set real-time scheduling priorities for itself, and set
        scheduling policies and priorities for arbitrary processes
    -   set the CPU affinity for arbitrary processes
    -   apply *migrate\_pages* to arbitrary processes and allow
        processes to be migrated to arbitrary nodes
    -   apply *move\_pages* to arbitrary processes
    -   use the `MPOL_MF_MOVE_ALL` flag with *mbind()* and
        *move\_pages()*

    <p>
    The abilities related to page moving, migration and nodes is of
    importance for NUMA systems, not something most workstations have
    or need.

CAP\_SYS\_PACCT
:   Use *acct()*, to enable or disable system resource accounting for
    the process

CAP\_SYS\_PTRACE
:   Allow the process to trace arbitrary processes using *ptrace()*,
    apply *get\_robust\_list()* against arbitrary processes and inspect
    processes using *kcmp()*.

CAP\_SYS\_RAWIO
:   Allow the process to perform I/O port operations, access
    `/proc/kcore` and employ the `FIBMAP` *ioctl()* operation.

Capabilities such as `CAP_KILL` and `CAP_SETUID` are very important to
govern correctly, but this post would be rather dull (given that the
definitions of the above capabilities can be found from the manual page)
if I wouldn't talk a bit more about its feasibility. Take a look at the
following C application code:

    #include <errno.h>
    #include <stdio.h>
    #include <string.h>
    #include <sys/capability.h>
    #include <sys/prctl.h>
    #include <sys/types.h>
    #include <unistd.h>

    int main(int argc, char ** argv) {
      printf("cap_setuid and cap_setgid: %d\n", prctl(PR_CAPBSET_READ, CAP_SETUID|CAP_SETGID, 0, 0, 0));
      printf(" %s\n", cap_to_text(cap_get_file(argv[0]), NULL));
      printf(" %s\n", cap_to_text(cap_get_proc(), NULL));
      if (setresuid(0, 0, 0));
        printf("setresuid(): %s\n", strerror(errno));
      execve("/bin/sh", NULL, NULL);
    }

At first sight, it looks like an application to get root privileges
(*setresuid()*) and then spawn a shell. If that application would be
given `CAP_SETUID` and `CAP_SETGID` effectively, it would allow anyone
who executed it to automatically get a root shell, wouldn't it?

    $ gcc -o test -lcap test.c
    # setcap cap_setuid,cap_setgid+ep test
    $ ./test
    cap_setuid and cap_setgid: 1
     = cap_setgid,cap_setuid+ep
     =
    setresuid() failed: Operation not permitted

So what happened? After all, the two capabilities are set with the *+ep*
flags given. Then why aren't these capabilities enabled? Well, this
binary was stored on a file system that is mounted with the *nosuid*
option. As a result, this capability is *not* enabled and the
application didn't work. If I move the file to another file system that
doesn't have the *nosuid* option:

    $ /usr/local/bin/test
    cap_setuid and cap_setgid: 1
     = cap_setgid,cap_setuid+ep
     = cap_setgid,cap_setuid+ep
    setresuid() failed: Operation not permitted

So the capabilities now do get enabled, so why does this still fail?
This now is due to SELinux:

    type=AVC msg=audit(1367393377.342:4778): avc:  denied  { setuid } for  pid=21418 comm="test" capability=7  scontext=staff_u:staff_r:staff_t tcontext=staff_u:staff_r:staff_t tclass=capability

And if you enable grSecurity's TPE, we can't even start the binary to
begin with:

    $ ./test
    -bash: ./test: Permission denied
    $ /lib/ld-linux-x86-64.so.2 /home/test/test
    /home/test/test: error while loading shared libraries: /home/test/test: failed to map segment from shared object: Permission denied

    # dmesg
    ...
    [ 5579.567842] grsec: From 192.168.100.1: denied untrusted exec (due to not being in trusted group and file in non-root-owned directory) of /home/test/test by /home/test/test[bash:4221] uid/euid:1002/1002 gid/egid:100/100, parent /bin/bash[bash:4195] uid/euid:1002/1002 gid/egid:100/100

When all these "security obstacles" are not enabled, then the call
succeeds:

    $ /usr/local/bin/test
    cap_setuid and cap_setgid: 1
     = cap_setgid,cap_setuid+ep
     = cap_setgid,cap_setuid+ep
    setresuid() failed: Success
    root@hpl tmp # 

This again shows how important it is to regularly review
capability-enabled files on the file system, as this is a major security
problem that cannot be detected by only looking for setuid binaries, but
also that securing a system is not limited to one or a few settings: one
always has to take the entire setup into consideration, hardening the
system so it becomes more difficult for malicious users to abuse it.

    # filecap -a
    file                 capabilities
    /usr/local/bin/test     setgid, setuid
