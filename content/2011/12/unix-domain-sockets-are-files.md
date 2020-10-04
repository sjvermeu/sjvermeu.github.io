Title: Unix domain sockets are files
Date: 2011-12-31 17:48
Category: SELinux
Slug: unix-domain-sockets-are-files

Probably not a first for many seasoned Linux administrators, and
probably not correct accordingly to more advanced users than myself, but
I just found out that Unix domain sockets are files. Even when they're
not.

I have been looking at a weird SELinux denial I had occuring on my
system:

    avc:  denied  { read write } for  pid=10012 comm="hostname"   
   path="socket:[318867]" dev=sockfs ino=318867   
   scontext=system_u:system_r:hostname_t   
   tcontext=system_u:system_r:dhcpc_t   
   tclass=unix_stream_socket

I had a tough time trying to figure out why in earth the **hostname**
application was trying to read/write to a *socket* that was owned by
**dhcpcd**. Even more, I didn't see a *connectto* attempt, and there is
nothing in my policy that would allow the `hostname_t` domain to connect
to a unix\_stream\_socket of `dhcpc_t`. But moreover I was intrigued why
the given path was no real path, even though it has an inode.

So I dug up **lsof**, which returned the following on this socket:

    # lsof -p 10017
    COMMAND   PID USER   FD      TYPE             DEVICE SIZE/OFF   NODE NAME
    ...
    dhcpcd  10017 root    3u     unix 0x0000000000000000      0t0 318867 socket
    dhcpcd  10017 root    4w      REG              252,3        6 268749 /var/run/dhcpcd-eth1.pid
    dhcpcd  10017 root    5u     unix 0x0000000000000000      0t0 318869 socket

Still no luck in figuring out what that is. And even `/proc/net/unix`
didn't give anything back:

    # grep 318867 /proc/net/unix
    Num               RefCount Protocol Flags    Type St Inode Path
    0000000000000000: 00000002 00000000 00000000 0001 01 318867

So I started looking at Unix domain sockets, what they are, how they are
used, etc. And I learned that

-   Unix domain sockets are just files. Well, most of the time. To use a
    socket (from server-perspective), a programmer first calls
    `socket()` to create a socket descriptor, which is a special type of
    file descriptor. It then `bind()`'s the socket to a (socket)file on
    the file system, `listen()`'s for incoming connections and
    eventually `accept()`'s them. Clients also use `socket()` but then
    call `connectto()` to have its socket connected to a (socket)file
    and eventually `read()` and `write()` (or `send()` and `recv()`).
-   Linux supports an abstract namespace for sockets, so not all of
    these are actually bound/connected to a file. Instead, they connect
    to a "name" instead, which cannot be traced back to a file. For
    those interested, looking at `/proc/net/unix` or `netstat -xa` shows
    the abstract ones starting with an `@` sign.
-   Not all Unix sockets (actually almost the majority of sockets on
    my system) can be traced back to either a file or abstract name.

And this latter is eating me up. I assume that these sockets were
originally created on a file system, but immediately after they were
`bind()`'ed, the file is unlinked, making it harder (impossible?) to
find what the socket file was called to begin with. I first thought it
were sockets that were not `bind()`'ed to, but many of them have the
state `CONNECTED` displayed (in the **netstat -xa** output) so that's
not a likely scenario. In any case, if you know how these sockets can
have an inode without a known path, please let me know.

But what has this to do with my previous investigation? Well, because
the sockets are descriptors, they are passed when a process uses
`fork()` and `execve()`. And looking at the source code of dhcpcd, I
noticed that it does not close its file descriptors when it calls its
hook scripts (through the `exec_script()` function of its sources). As a
result, the open file descriptors (including the sockets) are passed on
to the hook scripts - one of them calling **hostname**.

So what I saw in the AVC denials was a leaked socket (so there was no
`connectto` originating from the `hostname_t` domain since the
connection was made by **dhcpc** in the `dhcpc_t` domain) that is for
some reason being read/written to. A leaked unix stream socket.
