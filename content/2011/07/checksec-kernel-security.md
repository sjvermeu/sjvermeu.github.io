Title: checksec kernel security
Date: 2011-07-24 00:18
Category: Security
Slug: checksec-kernel-security

I have
[blogged](http://blog.siphos.be/2011/07/high-level-explanation-on-some-binary-executable-security/)
about [checksec.sh](http://www.trapkit.de/tools/checksec.html) earlier
before. Jono, one of the \#gentoo-hardened IRC-members, kindly pointed
me to its `--kernel` option. So I feel obliged to give its options a
stab as well. So, here goes the next batch of OPE-style (One Paragraph
Explanations).

    ~# checksec.sh --kernel
    * Kernel protection information:

      Description - List the status of kernel protection mechanisms. Rather than
      inspect kernel mechanisms that may aid in the prevention of exploitation of
      userspace processes, this option lists the status of kernel configuration
      options that harden the kernel itself against attack.

      Kernel config: /proc/config.gz

      GCC stack protector support:            Enabled
      Strict user copy checks:                Enabled
      Enforce read-only kernel data:          Disabled
      Restrict /dev/mem access:               Enabled
      Restrict /dev/kmem access:              Enabled

    * grsecurity / PaX: Custom GRKERNSEC

      Non-executable kernel pages:            Enabled
      Prevent userspace pointer deref:        Disabled
      Prevent kobject refcount overflow:      Enabled
      Bounds check heap object copies:        Enabled
      Disable writing to kmem/mem/port:       Enabled
      Disable privileged I/O:                 Enabled
      Harden module auto-loading:             Enabled
      Hide kernel symbols:                    Enabled

    * Kernel Heap Hardening: No KERNHEAP

      The KERNHEAP hardening patchset is available here:
        https://www.subreption.com/kernheap/

In-kernel **GCC stack protector support** is the same as the **Canary**
explanation I gave earlier, but now for the kernel code. Memory used by
the stack (which contains both function variables as well as return
addresses) is "interleaved" with specific data (canaries) which are
checked before using a return address that is on the stack. If the
canary doesn't match, you'll see a nice kernel panic. This is to prevent
buffer overflows that might influence the in-kernel activity flow or
overwrite data.

When talking about **Strict user copy checks**, one can compare this
with the **FORTIFY\_SOURCE** explanation given earlier. Although not the
same implementation-wise (since the latter is gcc/glibc bound, whereas
the Linux kernel does not use glibc) this too enables the compiler to
detect function calls with variable length data arguments to an extend
that it can predict the (should-be) length of the argument. If this is
the case, the function is switched with a(nother in-kernel) function
that either continues the call, or break in case of a length mismatch.
This is to prevent buffer overflows that might corrupt the stack (or
other data locations).

**Enforce read-only kernel data** marks specific kernel data sections as
read-only to prevent accidental (or malicious) manipulations.

When selecting **Restrict /dev/mem access**, the kernel does not allow
applications (even those running as root) to access all of memory.
Instead, they are only allowed to see device-mapped memory (and their
own process memory). The same goes for **Restrict /dev/kmem access**,
which is specifically for kernel memory.

**Non-executable kernel pages** is similar to the **NX** explanation
given earlier. It makes sure that pages marked as holding data can not
contain executable code (and will as such never be "jumped" in) and
pages marked as holding code will never be written to.

To explain **Prevent userspace pointer deref**, first you need to
understand the difference between a *userland address* and a *kernel
address*. Each application holds its own, private virtual address space.
Part of that virtual address space is "reserved" for most of the kernel
data (in other words, the kernel data is available in each process'
virtual address space), the rest is for the application. When
interaction with the kernel occurs, a userland address is given to the
kernel, which needs to translate it to a proper address (and treat it as
data). With **Prevent userspace pointer deref**, specific checks are
made to ensure that the kernel doesn't directly use userspace pointers,
because that could be exploited by (malicious) software to trick the
kernel into doing things it shouldn't.

Reference counters in the Linux kernel are used to track users of
specific objects or resources. A "popular" way to mistreat reference
counters (or any counter per se) is to increment them that much until
they overflow and wrap around, setting the counter to zero (or a
negative number), leading to unexpected results (such as freeing memory
that is in use). The **Prevent kobject refcount overflow** detects this
for kobject resources and ensures that no wrap-around happens.

The **Bounds check heap object copies** checks if particular memory
copies use memory fragments within proper bounds. If the memory copy is
for a fragment that crosses that bound (for instance because the
fragment is too large) the copy fails. This offers some support against
overflows, similar to (but not the same as) the use of the stack
protector mentioned above.

**Disable writing to kmem/mem/port** is similar to the **Restrict
/dev/(k)mem access** settings, plus disable `/dev/port` from being
opened.

By selecting **Disable privileged I/O**, access to the kernel through
functions like ioperm and iopl is prohibited. These functions are
sometimes used by applications that need direct device access, like
Xorg, but if you do not have such applications, it is wise to disable
privileged I/O access. If not, any vulnerability in such an application
might result in malicious code tampering with your devices.

When **Harden module auto-loading** is set, processes that do not run as
root will not be able to have particular kernel modules auto-loaded.
Although this seems strange, it isn't. Suppose you have an application
that wants to perform some IPv6 actions. Such applications can call
`request_module` to ask the Linux kernel to load in a particular
service. If the kernel supports IPv6 through a module, then it will load
IPv6 support (you might have seen traces in your logs about `net-pf-10`
- well, that's the IPv6 support). You can disable auto-loading
completely, but that might not be what you want. With this setting
enabled, auto-loading is supported but only for root-running
applications.

The added security of **Hide kernel symbols** is not to prevent
activities, but to prevent information to be leaked and (ab)used by
malicious users. Kernel symbols are string representations of functions
or variables that the kernel offers to kernel users (such as kernel
modules and drivers). This is needed because the location of these
functions/variables in memory cannot be provided in advance (this is no
different from symbols used as explained in the **RELRO** security
setting in my previous posting). By hiding these symbols from any user
without sufficiently high privileges (and limit the exposure for high
privileged process to well-known locations so these too can be protected
by other means) it is far more difficult for malicious users to find out
about available functions/variables on your system.

Finally, **Kernel Heap Hardening** enhances the in-kernel dynamic memory
allocator with additional hardening features (double-free protection,
use-after-free protection, ...). It tries to ensure proper use of the
allocated memory segments and protect against improper access.

From reading all this, you probably imagine why this isn't all enabled
by default. Well, many of the settings have implications on how the
system behaves. Some restrict functionalities to the root user only
(making it sometimes less user-friendly), some disable functionalities
that are needed (like the I/O access) or are (ab)used (like the user
space pointer deref which is used by many virtualization solutions)
while others add some additional overhead (the more you check, the
longer an action takes before it completes).

To help users select the proper settings, Gentoo Hardened tries to
differentiate settings based on *workstation* and *virtualization*
usage. So you get most security settings for "No Workstation, No
Virtualization" and less for each of those you enable. But of course,
like always, Gentoo supports custom settings too so you don't have to
follow the differentiation we suggest ;-)

Find something incorrect in the above paragraphs? Or too much
sales-speak and too little explanation? Give me a shout (and prove me
wrong) ;-)
