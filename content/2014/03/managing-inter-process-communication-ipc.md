Title: Managing Inter-Process Communication (IPC)
Date: 2014-03-30 12:50
Category: Free-Software
Tags: ipc, ipcrm, ipcs, linux, msg, sem, shmem
Slug: managing-inter-process-communication-ipc

As a Linux administrator, you'll eventually need to concern you about
*Inter-Process Communication (IPC)*. The IPC primitives that most POSIX
operating systems provide are semaphores, shared memory and message
queues. On Linux, the first utility that helps you with those primitives
is **ipcs**. Let's start with semaphores first.

Semaphores in general are integer variables that have a positive value,
and are accessible by multiple processes (users/tasks/whatever). The
idea behind a semaphore is that it is used to streamline access to a
shared resource. For instance, a device' control channel might be used
by multiple applications, but only one application at a time is allowed
to put something on the channel. Through semaphores, applications check
the semaphore value. If it is zero, they wait. If it is higher, they
attempt decrement the semaphore. If it fails (because another
application in the mean time has decremented the semaphore) then the
application waits, otherwise it continues as it has successfully
decremented the semaphore. In effect, it acts as a sort-of lock towards
a common resource.

An example you can come across is with ALSA. Some of the ALSA plugins
(such as dmix) use IPC semaphores to allow multiple ALSA applications to
connect to and use the sound subsystem. When an ALSA-enabled application
is using the sound system, you'll see that a semaphore is active:

    ~$ ipcs -s
    ------ Semaphore Arrays --------
    key        semid      owner      perms      nsems     
    0x0056a4d5 32768      swift      660        1

More information about a particular semaphore can be obtained using
**ipcs -s -i SEMID** where `SEMID` is the value in the *semid* column:

    ~$ ipcs -s -i 32768
    Semaphore Array semid=32768
    uid=1001         gid=18  cuid=1001       cgid=100
    mode=0660, access_perms=0660
    nsems = 1
    otime = Sun Mar 30 12:33:46 2014  
    ctime = Sun Mar 30 12:33:38 2014  
    semnum     value      ncount     zcount     pid       
    0          0          0          0          32061

As with all IPC resources, we have information about the owner of the
semaphore (`uid` and `gid`), the creator of the semaphore (`cuid` and
`cgid`) as well as its access mask, similar to the file access mask on
Linux systems (`mode` and `access_perms`). Specific to the IPC
semaphore, you can also notice the `nsems = 1`. Unlike the general
semaphores, IPC semaphores are actually a wrapper around one or more
"real" semaphores. The `nsems` variable shows how many "real" semaphores
are handled by the IPC semaphore.

Another very popular IPC resource is *shared memory*. This is memory
that is accessible by multiple applications, and provides a very
versatile approach to sharing information and collaboration between
processes. Usually, a semaphore is also used to govern writes and reads
to the shared memory, so that one process that wants to update a part of
the shared memory takes a semaphore (a sort-of lock), makes the updates,
and then increments the semaphore again.

You can see the currently defined shared memory using **ipcs -m**:

    ~$ ipcs -m
    ------ Shared Memory Segments --------
    key        shmid      owner      perms      bytes      nattch     status      
    0x00000000 655370     swift      600        393216     2          dest

Again, more information can be obtained through **-i SHMID**. An
interesting value to look at as well is the creator PID (just in case
the process still runs, or through the audit logs) and the last PID used
to operate on the shared memory (which also might no longer exist, but
is still an important value to investigate).

    ~$ ipcs -m -p
    ------ Shared Memory Creator/Last-op PIDs --------
    shmid      owner      cpid       lpid      
    655370     swift      6147       6017

    ~$ ps -ef | grep -E '(6147|6017)'
    root      6017  6016  0 09:49 tty1     00:01:30 /usr/bin/X -nolisten tcp :0 -auth /home/swift/.serverauth.6000
    swift     6147     1  2 09:50 tty1     00:05:10 firefox

In this case, the shared memory is most likely used to handle the UI of
firefox towards the X server.

A last IPC resource are message queues, through which processes can put
messages on a queue and remove messages (by reading them) from the
queue. I don't have an example at hand for the moment, but just like
semaphores and shared memory, queues can be looked at through **ipcs
-q** with more information being available through **ipcs -q -i MSQID**.

Now what if you need to operate these? For this, you can use **ipcrm**
to remove an IPC resource whereas **ipcmk** can be used to create one
(although the latter is not that often used for administrative purposes,
whereas **ipcrm** can help you troubleshoot and fix issues without
having to reboot a system). Of course, removing IPC resources from the
system should only be done when there is a bug in the application(s)
that use it (for instance, a process decreased a semaphore and then
crashed - in that case, remove the semaphore and start one of the
application(s) that also operates on the semaphore as they usually
recreate it and continue happily).

Now before finishing this post, I do need to tell you about the
difference between an IPC resource key and its identifier. The *key* is
like a path or URL, and is a value used by the applications to find and
obtain existing IPC resources (something like, "give me the list of
semaphores that I can access with key 12345"). The *identifier* is a
unique ID generated by the Linux kernel at the moment that the IPC
resource is created. Unlike the key, which can be used for multiple IPC
resources, the identifier is unique. This is why the identifier is used
in the **ipcs -i** command rather than the key. Also, that means that if
applications would properly document their IPC usage then we would
easily know what an IPC resource is used for.
