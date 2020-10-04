Title: Umounting IPv6 NFS(v4) mounts
Date: 2013-08-23 13:46
Category: Misc
Tags: ip6, ipv6, linux, nfs4, nfsv4, umount
Slug: umounting-ipv6-nfsv4-mounts

I had issues umounting my NFSv4 shares on an IPv6-only network. When
trying to umount the share, it said that it couldn't find the mount in
`/proc/mounts`:

    ~# umount /mnt/nfs/portage
    /mnt/nfs/portage was not found in /proc/mounts

The solution: copy `/proc/mounts` to `/etc/mtab`, and the umount works
correctly again.
