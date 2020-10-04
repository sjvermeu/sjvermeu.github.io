Title: Where does CIL play in the SELinux system?
Date: 2015-06-13 23:12
Category: SELinux
Tags: cil, selinux, userspace
Slug: where-does-cil-play-in-the-selinux-system

SELinux policy developers already have a number of file formats to work
with. Currently, policy code is written in a set of three files:

-   The `.te` file contains the SELinux policy code (type
    enforcement rules)
-   The `.if` file contains functions which turn a set of arguments into
    blocks of SELinux policy code (interfaces). These functions are
    called by other interface files or type enforcement files
-   The `.fc` file contains mappings of file path expressions towards
    labels (file contexts)

These files are compiled into loadable modules (or a base module) which
are then transformed to an active policy. But this is not a single-step
approach.

<!-- PELICAN_END_SUMMARY -->

**Transforming policy code into policy file**

For the Linux kernel SELinux subsystem, only a single file matters - the
`policy.##` file (for instance `policy.29`). The suffix denotes the
binary format used as higher numbers mean that additional SELinux
features are supported which require different binary formats for the
SELinux code in the Linux kernel.

With the 2.4 userspace, the transformation of the initial files as
mentioned above towards a policy file is done as follows:

![SELinux transformation diagram](http://dev.gentoo.org/~swift/blog/201506/formats_selinux.png)

When a developer builds a policy module, first `checkmodule` is used to
build a `.mod` intermediate file. This file contains the type
enforcement rules with the expanded rules of the various interface
files. Next, `semodule_package` is called which transforms this
intermediate file, together with the file context file, into a `.pp`
file.

This `.pp` file is, in the 2.4 userspace, called a "high level language"
file. There is little high-level about it, but the idea is that such
high-level language files are then transformed into `.cil` files (CIL
stands for *Common Intermediate Language*). If at any moment other
frameworks come around, they could create high-level languages
themselves and provide a transformation engine to convert these HLL
files into CIL files.

For the current `.pp` files, this transformation is supported through
the `/usr/libexec/selinux/hll/pp` binary which, given a `.pp` file,
outputs CIL code.

Finally, all CIL files (together) are compiled into a binary `policy.29`
file. All the steps coming from a `.pp` file towards the final binary
file are handled by the `semodule` command. For instance, if an
administrator loads an additional `.pp` file, its (generated) CIL code
is added to the other active CIL code and together, a new policy binary
file is created.

**Adding some CIL code**

The SELinux userspace development repository contains a `secilc` command
which can compile CIL code into a binary policy file. As such, it can
perform the (very) last step of the file conversions above. However, it
is not *integrated* in the sense that, if additional code is added, the
administrator can "play" with it as he would with SELinux policy
modules.

Still, that shouldn't prohibit us from playing around with it to
experiment with the CIL language construct. Consider the following CIL
SELinux policy code:

    ; Declare a test_port_t type
    (type test_port_t)
    ; Assign the type to the object_r role
    (roletype object_r test_port_t)

    ; Assign the right set of attributes to the port
    (typeattributeset defined_port_type test_port_t)
    (typeattributeset port_type test_port_t)

    ; Declare tcp:1440 as test_port_t
    (portcon tcp 1440 (system_u object_r test_port_t ((s0) (s0))))

The code declares a port type (`test_port_t`) and uses it for the TCP
port 1440.

In order to use this code, we have to build a policy file which includes
all currently active CIL code, together with the test code:

    ~$ secilc -c 29 /var/lib/selinux/mcs/active/modules/400/*/cil testport.cil

The result is a `policy.29` (the command forces version 29 as the
current Linux kernel used on this system does not support version 30)
file, which can now be copied to `/etc/selinux/mcs/policy`. Then, after
having copied the file, load the new policy file using `load_policy`.

And lo and behold, the port type is now available:

    ~# semanage port -l | grep 1440
    test_port_t           tcp      1440

To verify that it really is available and not just parsed by the
userspace, let's connect to it and hope for a nice denial message:

    ~$ ssh -p 1440 localhost
    ssh: connect to host localhost port 1440: Permission denied

    ~$ sudo ausearch -ts recent
    time->Thu Jun 11 19:35:45 2015
    type=PROCTITLE msg=audit(1434044145.829:296): proctitle=737368002D700031343430006C6F63616C686F7374
    type=SOCKADDR msg=audit(1434044145.829:296): saddr=0A0005A0000000000000000000000000000000000000000100000000
    type=SYSCALL msg=audit(1434044145.829:296): arch=c000003e syscall=42 success=no exit=-13 a0=3 a1=6d4d1ce050 a2=1c a3=0 items=0 ppid=2005 pid=18045 auid=1001 uid=1001 gid=1001 euid=1001 suid=1001 fsuid=1001 egid=1001 sgid=1001 fsgid=1001 tty=pts0 ses=1 comm="ssh" exe="/usr/bin/ssh" subj=staff_u:staff_r:ssh_t:s0 key=(null)
    type=AVC msg=audit(1434044145.829:296): avc:  denied  { name_connect } for  pid=18045 comm="ssh" dest=1440 scontext=staff_u:staff_r:ssh_t:s0 tcontext=system_u:object_r:test_port_t:s0 tclass=tcp_socket permissive=0
