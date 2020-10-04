Title: Capabilities, a short intro
Date: 2013-05-02 03:50
Category: Security
Tags: capabilities, linux, ping, selinux
Slug: capabilities-a-short-intro

Capabilities. You probably have heard of them already, but when you
start developing SELinux policies, you'll notice that you come in closer
contact with them than before. This is because SELinux, when
applications want to do something "root-like", checks the capability of
that application. Without SELinux, this either requires the binary to
have the proper capability set, or the application to run in root modus.
With SELinux, the capability also needs to be granted to the SELinux
context (the domain in which the application runs).

But forget about SELinux for now, and let's focus on capabilities.
Capabilities in Linux are flags that tell the kernel what the
application is allowed to do, but unlike file access, capabilities for
an application are system-wide: there is no "target" to which it
applies. Think about an "ability" of an application. See for yourself
through **man capabilities**. If you have no additional security
mechanism in place, the Linux root user has all capabilities assigned to
it. And you can remove capabilities from the root user if you want to,
but generally, capabilities are used to grant applications that tiny bit
more privileges, without needing to grant them root rights.

Consider the **ping** utility. It is marked setuid root on some
distributions, because the utility requires the (cap)ability to send raw
packets. This capability is known as `CAP_NET_RAW`. However, thanks to
capabilities, you can now mark the **ping** application with this
capability and drop the setuid from the file. As a result, the
application does not run with full root privileges anymore, but with the
restricted privileges of the user plus one capability, namely the
`CAP_NET_RAW`.

Let's take this **ping** example to the next level: copy the binary
(possibly relabel it as `ping_exec_t` if you run with SELinux), make
sure it does not hold the setuid and try it out:

    # cp ping anotherping
    # chcon -t ping_exec_t anotherping

Now as a regular user:

    $ ping -c 1 127.0.0.1
    PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
    64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.057 ms

    $ anotherping -c 1 127.0.0.1
    ping: icmp open socket: Operation not permitted

Let's assign the binary with the `CAP_NET_RAW` capability flag:

    # setcap cap_net_raw+ep anotherping

And tadaa:

    $ anotherping -c 1 127.0.0.1
    PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
    64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.054 ms

What **setcap** did was place an extended attribute to the file, which
is a binary representation of the capabilities assigned to the
application. The additional information (`+ep`) means that the
capability is *p*ermitted and *e*ffective.

So long for the primer, I'll talk about the various capabilities in a
later post.
