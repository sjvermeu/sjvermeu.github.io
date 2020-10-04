Title: Why both chroot and SELinux?
Date: 2012-04-15 09:41
Category: Security
Slug: why-both-chroot-and-selinux

In my [previous
post](http://blog.siphos.be/2012/04/chrooted-bind-for-ipv6-with-selinux/),
a very valid question was raised by Alexander E. Patrakov: why still use
chroot if you have SELinux?

Both chroot (especially with the additional restrictions that grSecurity
enables on chroots that make it more difficult to break out of a chroot)
and SELinux try to isolate an application so it only has access to those
resources it needs. Chroot does this on file-level basis (and a bit more
with grSecurity), SELinux on more general resources. However, things
that make SELinux strong (flexible and detailed policy language,
fine-grained authorizations) are also its weakness (consolidating files
into groups having the same file label), and chroot does have an
advantage on this.

Suppose that a flaw exists in BIND through which an attacker can read
files on the host (through BIND). With SELinux, the domain in which BIND
runs is prohibited from accessing and reading files whose label is not
one of the labels that the policy thinks BIND should be able to read.
More specifically, the BIND policy in the reference policy (which is
what both Gentoo and RedHat base their policies on, and generally
policies are only enlarged, never really shrinked):

-   etc\_runtime\_t (read) means access to the files in /etc that are
    modified at runtime (like mtab, profile.env, gentoo's /etc/env.d)
-   named\_var\_run\_t (read) is access to /var/run/bind and
    /var/run/named (and a few other related locations)
-   named\_checkconf\_exec\_t (read/execute) is access to read and
    execute /usr/sbin/named-checkconf
-   named\_conf\_t (read) to read the BIND-related configuration files
-   dnssec\_t (read) to read the DNSSEC keyfiles
-   locale\_t (read) to access /etc/localtime, /usr/share/locale/\*,
    /usr/share/zoneinfo/\*
-   etc\_t (read) to read the general configuration files in /etc
    (including passwd, fstab, ...)
-   proc\_t (read), proc\_net\_t (read) and sysfs\_t (read) to access
    those pseudo filesystems
-   udev\_tbl\_t (read) to access /dev/.udev and /var/run/udev (but I
    have no idea yet why this is in)
-   named\_log\_t (read/write) for the log files of BIND
-   net\_conf\_t (read) to access /etc/hosts (including deny/allow),
    resolv.conf, ...
-   named\_exec\_t (read/execute) the BIND executables
-   named\_zone\_t (read) to access the zone files, also write access in
    case of slave system
-   cert\_t (read) to read certificate information
-   named\_cache\_t (read/write) to access its cache
-   named\_tmp\_t (read/write) to work with temporary files

Isolation provided by SELinux is as powerful as the width of its
labeling. For instance, by giving the named daemon read access to /etc
files like passwd, fstab, group, hosts, resolv.conf and more, a
malicious user who can exploit this hypothetical vulnerability can
obtain information that might help him in his further attempts. By
chrooting BIND, the files placed in the chroot itself should not offer
the information he might be looking for (for instance, the passwd file,
if needed at all, is limited to just the named and root accounts, etc.)

Chrooting, but not enabling SELinux, could lead to escalation. A chroot
cannot restrict what a process is allowed to do beyond the regular
access privileges that are given on the user. If a user can upload an
exploit through BIND and have BIND execute it, he can use this as an
attack vector for further activities. SELinux here prohibits BIND to
write stuff it can also execute (there is no write and execute privilege
defined here). It also ensures that the BIND daemon never exists his
security domain (transitioning towards another domain with perhaps other
privileges) as there are no transition rules from named\_t to any other
domain.

Another MAC system that would be better suited to fit both is
grSecurity's RBAC model. Iirc, it uses path definitions to say which
files are allowed to access and which not. The weakness SELinux here has
(aggregation into sets of files with the same label) doesn't exist for
grSecurity. This debate on path-based versus label-based access controls
have been going on for very long time now - just google it ;-)

So, Alexander, in short: chroot further limits the SELinux-allowed
privileges to a more fine-grained set of file system resources
(files/directories).
