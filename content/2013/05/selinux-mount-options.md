Title: SELinux mount options
Date: 2013-05-01 03:50
Category: SELinux
Tags: mount, selinux
Slug: selinux-mount-options

When you read through the [Gentoo Hardened SELinux
handbook](http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml),
you'll notice that we sometimes update `/etc/fstab` with some
SELinux-specific settings. So, what are these settings about and are
there more of them?

First of all, let's look at a particular example from the installation
instructions so you see what I am talking about:

    tmpfs  /tmp  tmpfs  defaults,noexec,nosuid,rootcontext=system_u:object_r:tmp_t  0 0

What the *rootcontext=* option does here is to set the context of the
"root" of that file system (meaning, the context of `/tmp` in the
example) to the specified context *before* the file system is made
visible to the userspace. Because we do it soon, the file system is
known as `tmp_t` throughout its life cycle (not just after the mount or
so).

Another option that you'll frequently see on the Internet is the
*context=* option. This option is most frequently used for file systems
that do not support extended attributes, and as such cannot store the
context of files on the file system. With the *context=* mount option
set, all files on that file system get the specified context. For
instance, *context=system\_u:object\_r:removable\_t*.

If the file system does support extended attributes, you might find some
benefit in using the *defcontext=* option. When set, the context of
files and directories (and other resources on that file system) that do
not have a SELinux context set yet will use this default context.
However, once a context is set, it will use that context instead.

The last context-related mount option is *fscontext=*. With this option,
you set the context of the "filesystem" class object of the file system
rather than the mount itself (or the files). Within SELinux,
"filesystem" is one of the resource classes that can get a context.
Remember the `/tmp` mount example from before? Well, even though the
files are labeled `tmp_t`, the file system context itself is still
`tmpfs_t`.

It is important to know that, if you use one of these mount options,
*context=* is mutually exclusive to the other options as it "forces" the
context on all resources (including the filesystem class).
