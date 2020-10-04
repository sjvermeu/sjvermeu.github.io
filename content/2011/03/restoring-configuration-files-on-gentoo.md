Title: Restoring configuration files on Gentoo
Date: 2011-03-19 16:32
Category: Gentoo
Slug: restoring-configuration-files-on-gentoo

If you work with Gentoo, you're probably aware of tools like
**etc-update** and **dispatch-conf**. If you use **dispatch-conf**, you
might know that it supports **rcs** for version control of the changes
it makes. But if you have enabled it, you might be wondering how to
actually restore configuration files with it.

Well, **dispatch-conf** stores its version control information in
`/etc/config-archive`. To restore a configuration file to a previous
version, first find out what versions there are in the version control
system:

    ~$ rlog -zLT /etc/config-archive/etc/protocols,v
    ...

The output of the **rlog** command should allow you to find the revision
you are interested in. The -zLT option displays date/time in the current
timezone (instead of UTC). Once you have found the revision you are
looking for, restore the file by redirecting the output of the **co**
command:

    ~$ co -p -r1.1.1 /etc/config-archive/etc/protocols,v > /etc/protocols
