Title: SELinux file contexts
Date: 2011-05-15 13:39
Category: SELinux
Slug: selinux-file-contexts

If you have been working with SELinux for a while, you know that file
contexts are an important part of the policy and its enforcement. File
contexts are used to inform the SELinux tools which type a file,
directory, socket, ... should have. These types are then used to manage
the policy itself, which is based on inter-type permissions.

When dealing with file contexts, you either use

-   **chcon** (mostly) if you are trying out stuff as a **chcon**-set
    security context doesn't stick after a file system relabel operation
    (customizable types notwithstanding, and even then)
-   **restorecon** if you want to reset the file context of a file or
    set of files
-   **semanage** through the **semanage fcontext -a -t your\_type
    "regular\_expression"** method, which enhances the SELinux known
    file contexts with the appropriate information so that relabel
    operations are survived
-   policy improvements by editing and enhancing the `*.fc` files that
    take part in the policy definition

When you look at the policy, or the output of **semanage fcontext -l**,
you'll notice that the policy uses regular expressions very often. Of
course, without regular expression support, the file context rules
themselves would be impossible to manage. However, it immediately brings
up the question about what SELinux does when two or more lines are
appropriate for a particular file. Let's look at a few lines for
configuration related locations...

    /etc/.*                     all files          system_u:object_r:etc_t
    /etc/HOSTNAME               regular file       system_u:object_r:etc_runtime_t
    /etc/X11/[wx]dm/Xreset.*    regular file       system_u:object_r:xsession_exec_t 
    /etc/X11/wdm(/.*)?          all files          system_u:object_r:xdm_rw_etc_t

In the above examples, you'll notice that there is quite some overlap.
To start, the first line already matches all other lines as well. So how
does SELinux handle this?

Well, SELinux uses the following logic to find the most specific match,
and uses the most specific match then (extract taken from a pending
update to the [Gentoo Hardened SELinux
FAQ](http://www.gentoo.org/proj/en/hardened/selinux-faq.xml)):

1.  If line A has a regular expression, and line B doesn't, then line B
    is more specific.
2.  If the number of characters before the first regular expression in
    line A is less than the number of characters before the first
    regular expression in line B, then line B is more specific
3.  If the number of characters in line A is less than in line B, then
    line B is more specific
4.  If line A does not map to a specific SELinux type, and line B does,
    then line B is more specific

So in case of `/etc/HOSTNAME`, the second line is most specific because
it does not contain a regular expression.

In case of `/etc/X11/wdm/Xreset.sh`, SELinux will use the
xdm\_rw\_etc\_t type and not the xsession\_exec\_t one. This is because
the first regular expression in the xsession\_exec\_t line (`[wx]`)
comes sooner than the first regular expression in the xdm\_rw\_etc\_t
line (`(/.*)?`). You can validate this - even if you do not have such
file - with **matchpathcon**:

    ~# matchpathcon /etc/X11/wdm/Xreset.sh
    /etc/X11/wdm/Xreset.sh   system_u:object_r:xdm_rw_etc_t

If you want to know which line in the **semanage fcontext -l** output is
used, you can use **findcon** to show which lines match. That together
with the output of matchpathcon can help you deduce which line is
causing the label to be set:

    ~# matchpathcon /etc/X11/wdm/Xreset.sh
    /etc/X11/wdm/Xreset.sh   system_u:object_r:xdm_rw_etc_t
    ~# findcon /etc/selinux/strict/contexts/files/file_contexts -p /etc/X11/wdm/Xreset.sh
    /.*             system_u:object_r:default_t
    /etc/.*         system_u:object_r:etc_t
    /etc/X11/[wx]dm/Xreset.*        --      system_u:object_r:xsession_exec_t
    /etc/X11/wdm(/.*)?              system_u:object_r:xdm_rw_etc_t

In many cases, the last output line of **findcon** is the line you are
looking for, but I have not find a source that confirms this behavior so
do not trust this.
