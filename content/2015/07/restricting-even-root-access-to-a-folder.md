Title: Restricting even root access to a folder
Date: 2015-07-11 14:09
Category: SELinux
Slug: restricting-even-root-access-to-a-folder

In a
[comment](http://blog.siphos.be/2014/01/private-key-handling-and-selinux-protection/comment-page-1/#comment-143323)
Robert asked how to use SELinux to prevent even root access to a
directory. The trivial solution would be not to assign an administrative
role to the root account (which is definitely possible, but you want
some way to gain administrative access otherwise ;-)

Restricting root is one of the commonly referred features of a MAC
(Mandatory Access Control) system. With a well designed user management
and sudo environment, it is fairly trivial - but if you need to start
from the premise that a user has direct root access, it requires some
thought to implement it correctly. The main "issue" is not that it is
difficult to implement policy-wise, but that most users will start from
a pre-existing policy (such as the reference policy) and build on top of
that.

<!-- PELICAN_END_SUMMARY -->

The use of a pre-existing policy means that some roles are already
identified and privileges are already granted to users - often these
higher privileged roles are assigned to the Linux root user as not to
confuse users. But that does mean that restricting root access to a
folder means that some additional countermeasures need to be
implemented.

**The policy**

But first things first. Let's look at a simple policy for restricting
access to `/etc/private`:

    policy_module(myprivate, 1.0)

    type etc_private_t;
    fs_associate(etc_private_t)

This simple policy introduces a type (`etc_private_t`) which is allowed
to be used for files (it associates with a file system). *Do not* use
the `files_type()` interface as this would assign a set of attributes
that many user roles get read access on.

Now, it is not sufficient to have the type available. If we want to
assign it to a type, someone or something needs to have the privileges
to change the security context of a file and directory to this type. If
we would just load this policy and try to do this from a privileged
account, it would fail:

    ~# chcon -t etc_private_t /etc/private
    chcon: failed to change context of '/etc/private' to 'system_u:object_r:etc_private_t:s0': Permission denied

With the following rule, the `sysadm_t` domain (which I use for system
administration) is allowed to change the context to `etc_private_t`:

    allow sysadm_t etc_private_t:{dir file} relabelto;

With this in place, the administrator can label resources as
`etc_private_t` without having read access to these resources
afterwards. Also, as long as there are no *relabelfrom* privileges
assigned, the administrator cannot revert the context back to a type
that he has read access to.

**The countermeasures**

But this policy is not sufficient. One way that administrators can
easily access the resources is to disable SELinux controls (as in, put
the system in permissive mode):

    ~# cat /etc/private/README
    cat: /etc/private/README: Permission denied
    ~# setenforce 0
    ~# cat /etc/private/README
    Hello World!

To prevent this, enable the *secure\_mode\_policyload* SELinux boolean:

    ~# setsebool secure_mode_policyload on

This will prevent any policy and SELinux state manipulation... including
permissive mode, but also including loading additional SELinux policies
or changing booleans. Definitely experiment with this setting without
persisting (i.e. do not use `-P` in the above command yet) to make sure
it is manageable for you.

Still, this isn't sufficient. Don't forget that the administrator is
otherwise a full administrator - if he cannot access the `/etc/private`
location directly, then he might be able to access it indirectly:

-   If the resource is on a non-critical file system, he can unmount the
    file system and remount it with a `context=` mount option. This will
    override the file-level contexts. Bind-mounting does not seem to
    allow overriding the context.
-   If the resource is on a file system that cannot be unmounted, the
    administrator can still reboot the system in a mode where he can
    access the file system regardless of SELinux controls (either
    through editing `/etc/selinux/config` or by booting with
    `enforcing=0`, etc.
-   The administrator can still access the block device files on which
    the resources are directly. Specialized tools can allow for
    extracting files and directories without actually (re)mounting
    the device.

A more extensive list of methods to potentially gain access to such
resources is iterated in [Limiting file access with SELinux
alone](http://blog.siphos.be/2013/12/limiting-file-access-with-selinux-alone/).

This set of methods for gaining access is due to the administrative role
already assigned by the existing policy. To further mitigate these risks
with SELinux (although SELinux will never completely mitigate all risks)
the roles assigned to the users need to be carefully revisited. If you
grant people administrative access, but you don't want them to be able
to reboot the system, (re)mount file systems, access block devices, etc.
then create a user role that does not have these privileges at all.

Creating such user roles does not require leaving behind the policy that
is already active. Additional user domains can be created and granted to
Linux accounts (including root). But in my experience, when you need to
allow a user to log on as the "root" account directly, you probably need
him to have true administrative privileges. Otherwise you'd work with
personal accounts and a well-designed `/etc/sudoers` file.
