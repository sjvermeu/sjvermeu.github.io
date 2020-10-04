Title: Switching policy types in Gentoo/SELinux
Date: 2012-12-20 11:31
Category: Gentoo
Slug: switching-policy-types-in-gentooselinux

When you are running Gentoo with SELinux enabled, you will be running
with a particular policy type, which you can devise from either
`/etc/selinux/config` or from the output of the **sestatus** command. As
a user on our IRC channel had some issues converting his strict-policy
system to mcs, I thought about testing it out myself. Below are the
steps I did and the reasoning why (and I will update the docs to reflect
this accordingly).

Let's first see if the type I am running at this moment is indeed
strict, and that the mcs type is defined in the POLICY\_TYPES variable.
This is necessary because the *sec-policy/selinux-\** packages will then
build the policy modules for the other types referenced in this variable
as well.

    test ~ # sestatus
    SELinux status:                 enabled
    SELinuxfs mount:                /sys/fs/selinux
    SELinux root directory:         /etc/selinux
    Loaded policy name:             strict
    Current mode:                   enforcing
    Mode from config file:          enforcing
    Policy MLS status:              disabled
    Policy deny_unknown status:     denied
    Max kernel policy version:      28
     
    test ~ # grep POLICY_TYPES /etc/portage/make.conf
    POLICY_TYPES="targeted strict mcs"

If you notice that this is not the case, update the *POLICY\_TYPES*
variable and rebuild all SELinux policy packages using **emerge \$(qlist
-IC sec-policy)** first.

Let's see if I indeed have policies for the other types available and
that they are recent (modification date):

    test ~ # ls -l /etc/selinux/*/policy
    /etc/selinux/mcs/policy:
    total 408
    -rw-r--r--. 1 root root 417228 Dec 19 21:01 policy.27
     
    /etc/selinux/strict/policy:
    total 384
    -rw-r--r--. 1 root root 392168 Dec 19 21:15 policy.27
     
    /etc/selinux/targeted/policy:
    total 396
    -rw-r--r--. 1 root root 402931 Dec 19 21:01 policy.27

Great, we're now going to switch to permissive mode and edit the SELinux
configuration file to reflect that we are going to boot (later) into the
mcs policy. Only change the type - I will not boot in permissive mode so
the SELINUX=enforcing can stay.

    test ~ # setenforce 0
     
    test ~ # vim /etc/selinux/config
    [... set SELINUXTYPE=mcs ...]

You can run **sestatus** to verify the changes, but be aware that -
while the command does say that the mcs policy is loaded, this is not
the case. The mcs policy is just defined as the policy to load:

    test ~ # sestatus
    SELinux status:                 enabled
    SELinuxfs mount:                /sys/fs/selinux
    SELinux root directory:         /etc/selinux
    Loaded policy name:             mcs
    Current mode:                   permissive
    Mode from config file:          enforcing
    Policy MLS status:              disabled
    Policy deny_unknown status:     denied
    Max kernel policy version:      28

So let's load the mcs policy shall we?

    test ~ # cd /usr/share/selinux/mcs/
    test mcs # semodule -b base.pp -i $(ls *.pp | grep -v base | grep -v unconfined)

Next we are going to relabel all files on the file system, because the
mcs policy adds in another component in the context (a sensitivity label
- always set to 0 for mcs). We will also re-do the **setfiles** steps
done initially while setting up SELinux on our system. This is because
we need to relabel files that are "hidden" from the current file system
because other file systems are mounted on top of it.

    test mcs # rlpkg -a -r
    Relabeling filesystem types: btrfs ext2 ext3 ext4 jfs xfs
    Scanning for shared libraries with text relocations...
    0 libraries with text relocations, 0 not relabeled.
    Scanning for PIE binaries with text relocations...
    0 binaries with text relocations detected.
     
    test mcs # mount -o bind / /mnt/gentoo
    test mcs # setfiles -r /mnt/gentoo /etc/selinux/mcs/contexts/files/file_contexts /mnt/gentoo/dev
    test mcs # setfiles -r /mnt/gentoo /etc/selinux/mcs/contexts/files/file_contexts /mnt/gentoo/lib64
    test mcs # umount /mnt/gentoo

Finally, edit `/etc/fstab` and change all *rootcontext=* parameters to
include a trailing `:s0`, otherwise the root contexts of these file
systems will be illegal (in the mcs-sense) as they do not contain the
sensitivity level information.

    test mcs # vim /etc/fstab
    [... edit rootcontext's to now include ":s0" ...]

There ya go. Now reboot and notice that all is okay, and we're running
with the mcs policy loaded.

    test ~ # id -Z
    root:sysadm_r:sysadm_t:s0-s0:c0.c1023
    test ~ # sestatus
    SELinux status:                 enabled
    SELinuxfs mount:                /sys/fs/selinux
    SELinux root directory:         /etc/selinux
    Loaded policy name:             mcs
    Current mode:                   enforcing
    Mode from config file:          enforcing
    Policy MLS status:              enabled
    Policy deny_unknown status:     denied
    Max kernel policy version:      28
