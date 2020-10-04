Title: SELinux and noatsecure, or why portage complains about LD_PRELOAD and libsandbox.so
Date: 2011-04-22 21:00
Category: SELinux
Slug: selinux-and-noatsecure-or-why-portage-complains-about-ld_preload-and-libsandbox-so

If you're fiddling with SELinux policies, you will eventually notice
that the reference policy by default hides certain privilege requests
(which are denied). One of them is noatsecure. But what is noatsecure?
To describe noatsecure, I first need to describe what atsecure is. And
to describe what that is, we first need to give a small talk about ELF
auxiliary vectors.

As you probably know, when an application instantiates another
application, it calls the `execve` function right after fork'ing to load
the new application in memory. The actual task to load the new
application in memory is done by the C library, more specifically the
binary loader. For Linux, this is the ELF loader. Now, *ELF auxiliary
vectors* are parameters or flags that are set (or at least managed) by
the ELF loader to allow the application and program interpreter to get
some OS-specific information. Examples of such vectors are `AT_UID` and
`AT_EUID` (real uid and effective uid) and `AT_PAGESZ` (system page
size).

One of the vectors that glibc supports is `AT_SECURE`. This particular
parameter (which is either "0" (default) or "1") tells the ELF dynamic
linker to unset various [environment
variables](http://sourceware.org/git/?p=glibc.git;a=blob_plain;f=sysdeps/generic/unsecvars.h;hb=HEAD)
that are considered potentially harmful for your system. One of these is
`LD_PRELOAD` (I mention this one specifically because it was the source
of my small investigation). Normally, this environment sanitation is
done when a setuid/setgid application is called (to prevent the obvious
vulnerabilities). However, SELinux enhances the use of this
sanitation...

Whenever an application is called which triggers a domain transition in
SELinux (say `sysadm_t` to `mozilla_t` through a binary labelled
`mozilla_exec_t`), SELinux sets the `AT_SECURE` flag for the loaded
application (in the example, mozilla/firefox). In other words, every
time a domain transition occurs, the environment for this application is
sanitized.

As you can imagine now the `noatsecure` permission disables the
environment sanitation activity for a particular transition. You can do
this through the following allow statement (applied to the above
example):

    allow sysadm_t mozilla_t:process { noatsecure };

if every domain transition for which this permission isn't allowed would
log its denial, our audit logs would be filled with noise. That is why
the reference policy by default hides (`dontaudit`) these calls. But
knowing what they are for is important, because you might sometimes come
into contact with it, like I did:

    >>> Installing (1 of 1) net-dns/host-991529
    >>> Setting SELinux security labels
    ERROR: ld.so: object 'libsandbox.so' from LD_PRELOAD cannot be preloaded: ignored.

This error message is when Portage (running in `portage_t`) wants to
relabel the files that it just placed on the system through setfiles
(which will run in `setfiles_t`). As this involves a domain transition,
`AT_SECURE` is set for setfiles, but `LD_PRELOAD` was set as part of
Portage' sandboxing feature. This environment variable is disabled, and
the loader warns the user that it cannot preload `libsandbox.so`.

Although we can just set *noatsecure* here, it would open up a (small)
window for exploits (although they would need to be provided through
Portage, because when a user calls Portage, a domain transition is done
there as well so the user-provided environment variables are already
sanitized by then). By not allowing *noatsecure*, we are disabling a few
functionalities provided by the libsandbox.so library *for the file
labeling activity* (this is **very important** to understand: it does
not disable the sandboxing for the builds and merges, only for the file
relabeling). As we already run setfiles in its own, confined domain, I
believe that we are best served by keeping the secure environment
sanitation here. That does mean that the warning will stay as we cannot
control that from within SELinux.

If you want to allow *noatsecure* here, create a simple module and load
it:

    ~# cat > portage_noatsecure.te << EOF
    module portage_noatsecure 1.0;
    require {
      type portage_t;
      type setfiles_t;
      class process { noatsecure };
    }
    allow portage_t setfiles_t:process { noatsecure };
    EOF
    ~# checkmodule -m -o portage_noatsecure.mod portage_noatsecure.te
    ~# semodule_package -o portage_noatsecure.pp -m portage_noatsecure.mod
    ~# semodule -i portage_noatsecure.pp
