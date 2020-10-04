Title: Overview of Linux capabilities, part 3
Date: 2013-05-06 03:50
Category: Security
Tags: capabilities, capsh, libcap, linux
Slug: overview-of-linux-capabilities-part-3

In [previous](http://blog.siphos.be/2013/05/capabilities-a-short-intro/)
[posts](http://blog.siphos.be/2013/05/restricting-and-granting-capabilities/)
[I](http://blog.siphos.be/2013/05/overview-of-linux-capabilities-part-1/)
[talked](http://blog.siphos.be/2013/05/overview-of-linux-capabilities-part-2/)
about capabilities and gave an introduction to how this powerful
security feature within Linux can be used (and also exploited). I also
covered a few capabilities, so let's wrap this up with the remainder of
them.

CAP\_AUDIT\_CONTROL
:   Enable and disable kernel auditing; change auditing filter rules;
    retrieve auditing status and filtering rules

CAP\_AUDIT\_WRITE
:   Write records to kernel auditing log

CAP\_BLOCK\_SUSPEND
:   Employ features that can block system suspend

CAP\_MAC\_ADMIN
:   Override Mandatory Access Control (implemented for the SMACK LSM)

CAP\_MAC\_OVERRIDE
:   Allow MAC configuration or state changes (implemented for the
    SMACK LSM)

CAP\_NET\_ADMIN
:   Perform various network-related operations:
    </p>
    -   interface configuration
    -   administration of IP firewall, masquerading and accounting
    -   modify routing tables
    -   bind to any address for transparent proxying
    -   set type-of-service (TOS)
    -   clear driver statistics
    -   set promiscuous mode
    -   enabling multicasting
    -   use *setsockopt()* for privileged socket operations

CAP\_NET\_BIND\_SERVICE
:   Bind a socket to Internet domain privileged ports (less than 1024)

CAP\_NET\_RAW
:   Use RAW and PACKET sockets, and bind to any address for transparent
    proxying

CAP\_SETPCAP
:   Allow the process to add any capability from the calling thread's
    bounding set to its inheritable set, and drop capabilities from the
    bounding set (using *prctl()*) and make changes to the
    *securebits* flags.

CAP\_SYS\_ADMIN
:   Very powerful capability, includes:
    </p>
    -   Running quota control, mount, swap management, set hostname, ...
    -   Perform *VM86\_REQUEST\_IRQ vm86* command
    -   Perform *IPC\_SET* and *IPC\_RMID* operations on arbitrary
        System V IPC objects
    -   Perform operations on `trusted.*` and `security.*` extended
        attributes
    -   Use *lookup\_dcookie*

    <p>
    and many, many more. **man capabilities** gives a good overview
    of them.

CAP\_SYS\_BOOT
:   Use *reboot()* and *kexec\_load()*

CAP\_SYS\_CHROOT
:   Use *chroot()*

CAP\_SYS\_MODULE
:   Load and unload kernel modules

CAP\_SYS\_RESOURCE
:   Another capability with many consequences, including:
    </p>
    -   Use reserved space on ext2 file systems
    -   Make *ioctl()* calls controlling ext3 journaling
    -   Override disk quota limits
    -   Increase resource limits
    -   Override `RLIMIT_NPROC` resource limits

    <p>
    and many more.

CAP\_SYS\_TIME
:   Set system clock and real-time hardware clock

CAP\_SYS\_TTY\_CONFIG
:   Use *vhangup()* and employ various privileged *ioctl()* operations
    on virtual terminals

CAP\_SYSLOG
:   Perform privileged *syslog()* operations and view kernel addresses
    exposed with `/proc` and other interfaces (if `kptr_restrict`
    is set)

CAP\_WAKE\_ALARM
:   Trigger something that will wake up the system

Now when you look through the manual page of the capabilities, you'll
notice it talks about *securebits* as well. This is an additional set of
flags that govern how capabilities are used, inherited etc. System
administrators don't set these flags - they are governed by the
applications themselves (when creating threads, forking, etc.) These
flags are set on a per-thread level, and govern the following behavior:

SECBIT\_KEEP\_CAPS
:   Allow a thread with UID 0 to retain its capabilities when it
    switches its UIDs to a nonzero (non-root) value. By default, this
    flag is *not* set, and even if it is set, it is cleared on an
    *execve* call, reducing the likelihood that capabilities
    are "leaked".

SECBIT\_NO\_SETUID\_FIXUP
:   When set, the kernel will not adjust the capability sets when the
    thread's effective and file system UIDs are switched between
    zero (root) and non-zero values.

SECBIT\_NOROOT
:   If set, the kernel does not grant capabilities when a setuid-root
    program is executed, or when a process with an effective or real UID
    of 0 (root) calls *execve*.

Manipulating these bits requires the `CAP_SETPCAP` capability. Except
for the `SECBIT_KEEP_CAPS` security bit, the others are preserved on an
*execve()* call, and all bits are inherited by child processes (such as
when *fork()* is used).

As a user or admin, you can also see capability-related information
through the `/proc` file system:

     # grep ^Cap /proc/$$/status
    CapInh: 0000000000000000
    CapPrm: 0000001fffffffff
    CapEff: 0000001fffffffff
    CapBnd: 0000001fffffffff

    $ grep ^Cap /proc/$$/status
    CapInh: 0000000000000000
    CapPrm: 0000000000000000
    CapEff: 0000000000000000
    CapBnd: 0000001fffffffff

The capabilities listed therein are bitmasks for the various
capabilities. The mask `1FFFFFFFFF` holds 37 positions, which match the
37 capabilities known (again, see `uapi/linux/capabilities.h` in the
kernel sources to see the values of each of the capabilities). Again,
the **pscap** can be used to get information about the enabled
capabilities of running processes in a more human readable format. But
another tool provided by the `sys-libs/libcap` is interested as well to
look at: **capsh**. The tool offers many capability-related features,
including decoding the `status` fields:

    $ capsh --decode=0000001fffffffff
    0x0000001fffffffff=cap_chown,cap_dac_override,cap_dac_read_search,
    cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,
    cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,
    cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,
    cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,
    cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,
    cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,
    cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,
    cap_syslog,35,36

Next to fancy decoding, **capsh** can also launch a shell with reduced
capabilities. This makes it a good utility for jailing chroots even
more.
