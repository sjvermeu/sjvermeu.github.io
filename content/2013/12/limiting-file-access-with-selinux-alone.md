Title: Limiting file access with SELinux alone?
Date: 2013-12-31 21:18
Category: SELinux
Tags: access, acl, file access, Gentoo, selinux
Slug: limiting-file-access-with-selinux-alone

While writing a small script to handle simple certificate authority
activities using OpenSSL, I considered how to properly protect the files
that OpenSSL uses for these activities. As you are probably aware, a
system that hosts the necessary files for CA activities (like signing
certificate requests) should be very secure, and the private key used to
sign (and the private subkeys) should be very well protected.

Without the help of an [Hardware Security Module
(HSM)](https://en.wikipedia.org/wiki/Hardware_security_module) these
private keys are just plain text files on the file system. Access to
this file system should therefor be very well audited and protected.

It of course starts with proper Discretionary Access Control (DAC)
protections on Linux. The private key should only be accessible by the
(technical) user used to operate the CA activities. Next, access to this
user should also be properly protected - if the CA activities are not
done through the root account, make sure that all users who can get root
access on the system and to the (technical) user used to perform the CA
activities are trusted.

Sometimes however this isn't sufficient, or you want to protect it even
more. With SELinux, we can implement a Mandatory Access Control (MAC)
policy to further restrict access to the private key. The idea is to
only allow the application (in my case the script) that performs the CA
activities access to the private key, and nothing more. Even users who
can get root access, but do not have the privileges SELinux-wise to
execute the CA management script (with the proper domain transition)
should not have any access to the private key.

I'll discuss a sample policy for that later, but for now I want to focus
on what that would mean - not allowing other users access.

When users log on on a SELinux-enabled system, they (well, the process
that starts the user session) get assigned a security context. This
security context defines what the user is allowed to do on the system.
And although it is "easy" to disallow a domain read access to a
particular file, we must consider all other activities that the user can
perform.

*First risk: direct file access*

Assume that a user is logged on with the `unconfined_t` domain (an
entire context is more than just the domain, but let's stick to this for
now). The `unconfined_t` domain is an extremely powerful domain -
basically, SELinux will not prevent much. That doesn't mean that SELinux
is disabled, but rather that the `unconfined_t` domain is granted many
privileges. So if a user is in the `unconfined_t` domain *and* is not
prevented by the standard Linux access controls (for instance because he
is root), he can do basically everything.

SELinux-wise, we can still create a new type that `unconfined_t` has no
immediate access to. By creating a new type (say `ca_private_key_t`) and
not assign it any attributes that the `unconfined_t` domain has
privileges towards, the user would still not be able to access the file
directly. The same is true for the `sysadm_t` domain (a still
privileged, yet slightly more restricted user domain designed for system
administrators). However, such users could still access the file
indirectly.

*Second risk: indirect access through new SELinux policies*

An important privilege that these users have is that they can load a new
SELinux policy, or disable SELinux (actually switch it to permissive
mode) if the Linux kernel has this enabled. By allowing users to load a
new policy, they can basically create a SELinux policy module that
grants them the necessary accesses towards the file:

``` {lang="bash"}
allow sysadm_t ca_misc_file_t:file manage_file_perms;
allow sysadm_t ca_misc_file_t:dir manage_dir_perms;
```

So in order to prevent this, we have to make sure that these users can
either not manipulate the SELinux policy - or make sure users on the
system do not get access to these domains to begin with. Preventing
loading new policies can be handled by the Linux kernel itself
(`CONFIG_SECURITY_SELINUX_DEVELOP` should not be set then) and through
SELinux booleans (`secure_mode_policyload` should be set to `on` and
toggling the boolean off again should be prohibited). Still, it makes
more sense to restrict people with access to these roles - something
I'll definitely come back to at a later point.

*Third risk: indirect access through attributes*

Another privilege that needs to be watched for is the ability to change
the context of a file. If the `ca_private_key_t` type would not be
declared properly, then the type might be assigned an attribute that
domains have privileges against. Consider the `file_type` attribute,
granted to file types (at least the name makes sense ;-)

``` {lang="bash"}
# seinfo -tca_private_key_t -x
  ca_private_key_t
    file_type
```

The moment a domain has been granted read access to the `file_type`
files, then it has read access to the `ca_private_key_t` type. In other
words, while designing the policy, make sure that all granted
permissions are accounted for.

*Fourth risk: "raw" file system (or memory) access*

So if SELinux itself would not allow access to the file(s) anymore, are
we done yet? Of course not. In the end, the keys are stored on the file
system, which is located on partitions or disks, accessible by
privileged users. Someone with direct read access to the block devices
can still obtain the file directly, so even that should be properly
governed.

This even extends towards memory access, because the private key might
be cached in buffers (by the kernel) or even mapped in memory (even for
a short while) and made accessible through direct memory access.

Such accesses might not be available to many users, but don't forget
that on the system other applications are running as well. Some daemons
might have the necessary privileges to access file systems directly, or
the memory. Some users might have the rights to execute commands that
have direct file system access (or memory). Making sure that *all*
domains that have these accesses are properly audited (including the
access to those domains) will already be quite a challenge.

For a system that acts as a certificate handling system, it makes sense
to limit exposure to a bare minimum as that makes the above auditing a
bit less daunting.

</p>
Ok ok, let's assume the security administrator has thought of all those
things and SELinux policy-wise properly prevents any access. That's
enough, right?

*Fifth risk: authentication and authorization access*

Of course not. Some processes or users might have access to the
authentication files on the system (and I'm not only talking about the
`/etc/shadow` and `/etc/passwd` files, but also the `/etc/pam.d/*`
files, or the libraries used by the PAM modules in `/lib/security`, or
modify rights on binaries likely executed by administrators who do have
rights we want - there might always be a "recovery user" enabled just in
case things really go wrong, but such "recovery users" imply that rights
are still granted somewhere.

When modify access is granted to any of the authentication or
authorization services, then users can grant them privileges you don't
want to give them. So not only should access to `ca_private_key_t`,
`memory_device_t`, `device_node` and `fixed_disk_device_t` be properly
governed - also `etc_t` (as this is the default for PAM files - this
really should be worked on) and `lib_t` are important types, and these
are very, very open (many domains have write access to those by
default).

Fine. Let's "hypothetically" consider that the security engineer has
thought about all SELinux accesses and made a perfect policy. Happy now?

*Sixth risk: system boot privileges*

Actually no... first of all, some users might be able to reboot the
system with updated boot parameters, or even with a different kernel.
With this at hand, they can disable SELinux and still access the file.
So make sure that rebooting the system still happens securely (you can
use secure boot, signed kernels, ... or at least focus on boot loader
password protection and console access). The
[Integrity](https://wiki.gentoo.org/wiki/Project:Integrity) subproject
of the [Gentoo Hardened](https://wiki.gentoo.org/wiki/Project:Hardened)
project will focus on these matters more (just waiting for an
EFI-enabled system to properly start documenting things). In the mean
time, make sure that the Linux system itself is properly secured.

*Seventh risk: direct system access*

Yet having a secured boot also doesn't protect us completely. If there
is access to the system physically, users can still mount the disk on
their system and access the files. So one might want to consider
encrypting the partition on which the keys are stored. But the
encryption key for the partition should still be available somewhere,
because regular administration might need to reboot the system.

A reasonably secure system would keep the encryption key in a HSM device
(which we don't have - see beginning of this post) or only have it
decrypted in a secure environment (like a TPM chip on more modern
systems). Handling TPM and securing keys is definitely also something to
focus on further in the Integrity subproject.

*Eighth risk: backups*

And if you take backups (which we of course all do) then those backups
should be properly protected as well. We might want to create encrypted
backups (meaning that the CA script should allow for encrypting and
decrypting the private key) and *not store the encryption key with the
backup*. And before asking me why I've emphasized this - I've seen it
before, and I'll probably see it again in the future. Don't laugh.

Almost starts sounding like a nightmare, right? There might even be more
risks that I haven't covered here (and I haven't even discussed
potential vulnerabilities in the CA management script itself, or even in
OpenSSL or other tools like the [let's hear the encryption
key](http://it.slashdot.org/story/13/12/18/2122226/scientists-extract-rsa-key-from-gnupg-using-sound-of-cpu)
attack). Welcome to the world of security ;-)

In any case, in the next post I'll focus on the SELinux policy I wrote
up for the simple script I created. But all the above is just to show
that SELinux is not the answer - it is merely a part in an entire
security architecture. A flexible, powerful part... but still a part.
