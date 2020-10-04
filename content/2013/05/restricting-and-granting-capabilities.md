Title: Restricting and granting capabilities
Date: 2013-05-03 03:50
Category: Security
Tags: capabilities, linux
Slug: restricting-and-granting-capabilities

As
[capabilities](http://blog.siphos.be/2013/05/capabilities-a-short-intro)
are a way for running processes with some privileges, without having the
need to grant them root privileges, it is important to understand that
they exist if you are a system administrator, but also as an auditor or
other security-related function. Having processes run as a non-root user
is no longer sufficient to assume that they do not hold any rights to
mess up the system or read files they shouldn't be able to read.

The [grsecurity](https://grsecurity.net/) kernel patch set, which is
applied to the Gentoo hardened kernel sources, contains for instance
`CONFIG_GRKERNSEC_CHROOT_CAPS` which, as per its documentation,
"restrcts the capabilities on all root processes within a chroot jail to
stop module insertion, raw i/o, system and net admin tasks, rebooting
the system, modifying immutable files, modifying IPC owned by another,
and changing the system time." But other implementations might even use
capabilities to restrict the users. Consider
[LXC](http://lxc.sourceforge.net/) (Linux Containers). When a container
is started, `CAP_SYS_BOOT` (the ability to shutdown/reboot the
system/container) is removed so that users cannot abuse this privilege.

You can also grant capabilities to users selectively, using `pam_cap.so`
(the Capabilities Pluggable Authentication Module). For instance, to
allow some users to ping, instead of granting the `cap_net_raw`
immediately (*+ep*), we can assign the capability to some users through
PAM, and have the **ping** binary inherit and use this capability
instead (*+p*). That doesn't mean that the capability is in effect, but
rather that it is in a sort-of permitted set. Applications that are
granted a certain permission this way can either use this capability if
the user is allowed to have it, or won't otherwise.

    # setcap cap_net_raw+p anotherping

    # vim /etc/pam.d/system-login
    ... add in something like
    auth     required     pam_cap.so

    # vim /etc/security/capability.conf
    ... add in something like
    cap_net_raw           user1

The logic used with capabilities can be described as follows (it is not
as difficult as it looks):

            pI' = pI
      (***) pP' = fP | (fI & pI)
            pE' = pP' & fE          [NB. fE is 0 or ~0]

      I=Inheritable, P=Permitted, E=Effective // p=process, f=file
      ' indicates post-exec().

So, for instance, the second line reads "The permitted set of
capabilities of the newly forked process is set to the permitted set of
capabilities of its executable file, together with the result of the AND
operation between the inherited capabilities of the file and the
inherited capabilities of the parent process."

As an admin, you might want to keep an eye out for binaries that have
particular capabilities set. With **filecap** you can list which
capabilities are in the effective set of files found on the file system
(for instance, *+ep*).

    # filecap 
    file                 capabilities
    /bin/anotherping     net_raw

Similarly, with **pscap** you can see the capabilities set on running
processes.

    # pscap -a
    ppid  pid   name        command           capabilities
    6148  6152  root        bash              full

It might be wise to take this up in the daily audit reports.
