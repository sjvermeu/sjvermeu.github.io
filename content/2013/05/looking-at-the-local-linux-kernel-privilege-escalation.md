Title: Looking at the local Linux kernel privilege escalation
Date: 2013-05-17 03:50
Category: Security
Tags: event, grsecurity, kernexec, linux, pax, perf, selinux, uderef, vulnerability
Slug: looking-at-the-local-linux-kernel-privilege-escalation

There has been a few posts already on the local Linux kernel privilege
escalation, which has received the
[CVE-2013-2094](https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2013-2094)
ID.
[arstechnica](http://arstechnica.com/security/2013/05/critical-linux-vulnerability-imperils-users-even-after-silent-fix/)
has a write-up with links to good resources on the Internet, but I
definitely want to point readers to the
[explanation](http://www.reddit.com/r/netsec/comments/1eb9iw/sdfucksheeporgs_semtexc_local_linux_root_exploit/c9ykrck)
that Brad Spengler made on the vulnerability.

In short, the vulnerability is an *out-of-bound* access to an array
within the Linux perf code (which is a performance measuring subsystem
enabled when `CONFIG_PERF_EVENTS` is enabled). This subsystem is often
enabled as it offers a wide range of performance measurement techniques
(see [its wiki](https://perf.wiki.kernel.org/index.php/Main_Page) for
more information). You can check on your own system through the kernel
configuration (**zgrep CONFIG\_PERF\_EVENTS /proc/config.gz** if you
have the latter pseudo-file available - it is made available through
`CONFIG_IKCONFIG_PROC`).

The public exploit maps memory in userland, fills it with known data,
then triggers an out-of-bound decrement that tricks the kernel into
decrementing this data (mapped in userland). By looking at where the
decrement occurred, the exploit now knows the base address of the array.
Next, it targets (through the same vulnerability) the IDT base
(Interrupt Descriptor Table) and targets the overflow interrupt vector.
It increments the top part of the address that the vector points to
(which is 0xffffffff, becoming 0x00000000 thus pointing to the
userland), maps this memory region itself with shellcode, and then
triggers the overflow. The shell code used in the public exploit
modifies the credentials of the current task, sets uid/gid with root and
gives full capabilities, and then executes a shell.

As Brad mentions, [UDEREF](https://grsecurity.net/~spender/uderef.txt)
(an option in a grSecurity enabled kernel) should mitigate the attempt
to get to the userland. On my system, the exploit fails with the
following (start of) oops (without affecting the system further) when it
tries to close the file descriptor returned from the syscall that
invokes the decrement:

    [ 1926.226678] PAX: please report this to pageexec@freemail.hu
    [ 1926.227019] BUG: unable to handle kernel paging request at 0000000381f5815c
    [ 1926.227019] IP: [] sw_perf_event_destroy+0x1a/0xa0
    [ 1926.227019] PGD 58a7c000 
    [ 1926.227019] Thread overran stack, or stack corrupted
    [ 1926.227019] Oops: 0002 [#4] PREEMPT SMP 
    [ 1926.227019] Modules linked in: libcrc32c
    [ 1926.227019] CPU 0 
    [ 1926.227019] Pid: 4267, comm: test Tainted: G      D      3.8.7-hardened #1 Bochs Bochs
    [ 1926.227019] RIP: 0010:[]  [] sw_perf_event_destroy+0x1a/0xa0
    [ 1926.227019] RSP: 0018:ffff880058a03e08  EFLAGS: 00010246
    ...

The exploit also finds that the decrement didn't succeed:

    test: semtex.c:76: main: Assertion 'i<0x0100000000/4' failed.

A second mitigation is that
[KERNEXEC](http://pax.grsecurity.net/docs/PaXTeam-H2HC12-PaX-kernel-self-protection.pdf)
(also offered through grSecurity) which prevents the kernel from
executing data that is writable (including userland data). So modifying
the IDT would be mitigated as well.

Another important mitigation is TPE - *Trusted Path Execution*. This
feature prevents the execution of binaries that are not located in a
root-owned directory and owned by a trusted group (which on my system is
10 = wheel). So users attempting to execute such code will fail with a
*Permission denied* error, and the following is shown in the logs:

    [ 3152.165780] grsec: denied untrusted exec (due to not being in trusted group and file in non-root-owned directory) of /home/user/test by /home/user/test[bash:4382] uid/euid:1000/1000 gid/egid:100/100, parent /bin/bash[bash:4352] uid/euid:1000/1000 gid/egid:100/100

However, even though a nicely hardened system should be fairly immune
against the currently circling public exploit, it should be noted that
it is not immune against the vulnerability itself. The methods above
mentioned make it so that that particular way of gaining root access is
not possible, but it still allows an attacker to decrement and increment
memory in specific locations so other exploits might be found to modify
the system.

Now out-of-bound vulnerabilities are not new. Recently (february this
year), a
[vulnerability](http://www.phoronix.com/scan.php?page=news_item&px=MTMxMTg)
in the networking code also provided an attack vector to get a local
privilege escalation. A mandatory access control system like SELinux has
little impact on such vulnerabilities if you allow users to execute
their own code. Even confined users can modify the exploit to disable
SELinux (since the shell code is ran with ring0 privileges it can access
and modify the SELinux state information in the kernel).

Many thanks to Brad for the excellent write-up, and to the [Gentoo
Hardened](http://www.gentoo.org/proj/en/hardened) team for providing the
grSecurity PaX/TPE protections in its `hardened-sources` kernel.
