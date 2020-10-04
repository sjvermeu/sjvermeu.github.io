Title: SELinux enforcing for console activity
Date: 2010-10-30 21:30
Category: SELinux
Slug: selinux-enforcing-for-console-activity

I'm now able to boot into my system with SELinux in enforcing mode
(without unconfined domains), do standard system administration tasks as
root / sysadm\_r (including the relevant Portage activities) and work as
a regular user as long as I don't want to run in Xorg. I'm not going to
focus on Xorg pretty soon now as there is a bunch of other things to do
(like other applications, writing policies, patching etc.), but here is
a very quick summary on the activities I had to do (apart from those in
the [Gentoo Hardened SELinux
Handbook](http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml)):

-   Use a more recent reference policy to start from. I fiddled with a
    live ebuild first, but am now falling back to the latest reference
    policy release of [Tresys](http://oss.tresys.com), versioned
    `2.20100524`. The implementing package
    (`sec-policy/selinux-base-policy`) can be found in my
    [overlay (sjvermeu)](http://github.com/sjvermeu/gentoo.overlay).
-   I use a meta package `sec-policy/selinux-policy` which pulls in the
    base policy as well as policies that you definitely need, but seem
    to work well when loaded as a module. Currently, that only includes
    `sec-policy/selinux-portage` but others may follow later. The main
    reason is that I like the modular approach and this way, I can
    update/patch these modules without requiring a base rebuild/reload
-   Speaking of patching, the `sec-policy/selinux-portage` ebuild
    contains a patch for those who have `/tmp` and/or `/var/tmp` as a
    tmpfs filesystem
-   I had to update `/lib64/rcscripts/addons/lvm-start.sh` so that the
    lvm locks are placed in `/etc/lvm/lock` rather than `/dev/.lvm`
-   I also had to update `/lib/dhcpcd/dhcpcd-hooks/50-dhcpcd-compat` to
    put the `*.info` files in `/var/lib/dhcpcd` rather than `/var/lib`.
-   Many binaries in /bin (part of `sys-apps/net-tools`) are hard links
    (same inode) but different name. This gives issues with SELinux'
    file contexts. Quick fix is to copy rather than hardlink (for
    instance, **cp hostname hostname.old**). After this, I ran **rlpkg
    net-tools**.
-   Many packages need to be unmasked (from `~amd64`) as the current
    stable packages either don't work or are too old. The "unstable"
    ones seem to work pretty well though.

I know much development is being put in the SELinux state of Gentoo
Hardened (just visit \#gentoo-hardened if you have questions) so I'm
sure things will be improving soon.
