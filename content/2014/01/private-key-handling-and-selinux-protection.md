Title: Private key handling and SELinux protection
Date: 2014-01-02 04:00
Category: SELinux
Tags: ca, certcli, policy, selinux
Slug: private-key-handling-and-selinux-protection

In this post I'll give some insight in a *possible* SELinux policy for a
script I wrote.

The script is a certificate authority handling script, in which I can
generate a private key (and certificate assigned to it), sign the
certificate either by itself (for the root CA key) or by another
previously created key (for subkeys), create certificates (such as user
certificates or device certificates) and sign them, sign certificate
requests, and revoke certificates.

``` {lang="bash"}
export KEYLOC="/var/db/ca"
# Create a root CA key for "genfic"
# (openssl questions and other output not shown)
certcli.sh -r genfic
# Create a subkey, signed by the "genfic" key, for users
certcli.sh -p genfic -c genfic-user
# Create a user certificate
certcli.sh -p genfic-user -R /var/db/ca/myUserId
# Sign a certificate
certcli.sh -p genfic-user -s /var/db/ca/requests/someUser.csr
# Revoke a certificate
certcli.sh -p genfic-user -x myuser@genfic.com
```

From a security point of view, I currently focus on two types:

-   `ca_private_key_t` is for the private key and should not be
    accessible by anyone, anywhere, anytime, except through the
    management script itself (which will run as `ca_cli_t`).
-   `ca_misc_t` is for the other related files, such as certificates,
    revocation lists, serial information, etc. If this would be "for
    real" I'd probably make a bit more types for this depending on the
    accesses, but for this post this suffices.

In order to provide the necessary support policy-wise, the following
types also are declared:

-   `ca_cli_exec_t` as the entrypoint for the script
-   `ca_misc_tmp_t` as the temporary file type used by OpenSSL when
    handling certificates (it is not used for the private key afaics,
    but it should still be sufficiently - and perhaps even equally
    well - protected like the private key

So let's start with this.

``` {lang="perl"}
policy_module(ca, 1.0.0)

# CA management script and domain
type ca_cli_t;
type ca_cli_exec_t;
domain_base_type(ca_cli_t)
fs_associate(ca_cli_exec_t)
```

Above, I declared the two types `ca_cli_t` and `ca_cli_exec_t`. Then,
two non-standard approaches were followed.

Normally, application domains are granted through `application_type()`,
`application_domain()` or even `userdom_user_application_domain()`.
Which interface you use depends on the privileges you want to grant on
the domain, but also which existing privileges should also be applicable
to the domain. Make sure you review the interfaces. For instance:

``` {lang="bash"}
# seshowif application_domain
interface(`application_type',`
        gen_require(`
                attribute application_domain_type;
        ')

        typeattribute $1 application_domain_type;

        # start with basic domain
        domain_type($1)
')
```

This means that the assigned domain (`ca_cli_t` in our example) would be
assigned the `application_domain_type` attribute, as well as the
`domain` attribute and other privileges. If we really want to prevent
any access to the `ca_cli_t` domain for handling the certificates, we
need to make sure that the lowest possible privileges are assigned.

The same is true for the file type `ca_cli_exec_t`. Making it through
`files_type()` interface would assign the `file_type` attribute to it,
and other domains might have access to `file_type`. So all I do here is
to allow the type `ca_cli_exec_t` to be associated on a file system.

Similarly, I define the remainder of file types:

``` {lang="perl"}
type ca_private_key_t;
fs_associate(ca_private_key_t)

type ca_misc_tmp_t;
fs_associate(ca_misc_tmp_t)
fs_associate_tmpfs(ca_misc_tmp_t)

type ca_misc_t;
fs_associate(ca_misc_t)
```

Next, grant the CA handling script (which will run as `ca_cli_t`) the
proper access to these types.

``` {lang="perl"}
allow ca_cli_t ca_misc_t:dir create_dir_perms;
manage_files_pattern(ca_cli_t, ca_misc_t, ca_misc_t)

allow ca_cli_t ca_private_key_t:dir create_dir_perms;
manage_files_pattern(ca_cli_t, ca_private_key_t, ca_private_key_t)
```

This of course heavily depends on the script itself. Mine creates a
directory "private", so needs the proper rights on the
`ca_private_key_t` type for directories as well. The "private" directory
is created in a generic directory (which is labeled as `ca_misc_t`) so I
can also create a file transition. This means that the SELinux policy
will automatically assign the `ca_private_key_t` type to a directory,
created in a directory with label `ca_misc_t`, if created by the
`ca_cli_t` domain:

``` {lang="perl"}
filetrans_pattern(ca_cli_t, ca_misc_t, ca_private_key_t, dir, "private")
```

Now, `ca_cli_t` is a domain used for a shell script, which in my case
also requires the following permissions:

``` {lang="perl"}
# Handling pipes between commands
allow ca_cli_t self:fifo_file rw_fifo_file_perms;
# Shell script...
corecmd_exec_shell(ca_cli_t)
# ...which invokes regular binaries
corecmd_exec_bin(ca_cli_t)
# Allow output on the screen
getty_use_fds(ca_cli_t)
userdom_use_user_terminals(ca_cli_t)
```

Now I still need to mark `ca_cli_exec_t` as an entrypoint for
`ca_cli_t`, meaning that the `ca_cli_t` domain can only be accessed
(transitioned to) through the execution of a file with label
`ca_cli_exec_t`:

``` {lang="perl"}
allow ca_cli_t ca_cli_exec_t:file entrypoint;
allow ca_cli_t ca_cli_exec_t:file { mmap_file_perms ioctl lock };
```

Normally, the above is granted through the invocation of the
`application_domain(ca_cli_t, ca_cli_exec_t)` but as mentioned before,
this would also assign attributes that I explicitly want to prevent in
this example.

Next, the `openssl` application, which the script uses extensively, also
requires additional permissions. As the `openssl` command just runs in
the `ca_cli_t` domain, I extend the privileges for this domain more:

``` {lang="perl"}
# Read access on /proc files
kernel_read_system_state(ca_cli_t)
# Access to random devices
dev_read_rand(ca_cli_t)
dev_read_urand(ca_cli_t)
# Regular files
files_read_etc_files(ca_cli_t)
miscfiles_read_localization(ca_cli_t)
# /tmp access
fs_getattr_tmpfs(ca_cli_t)
```

Also, the following file transition is created: when OpenSSL creates a
temporary file in `/tmp`, this file should immediately be assigned the
`ca_misc_tmp_t` type:

``` {lang="perl"}
# File transition in /tmp to ca_misc_tmp_t
files_tmp_filetrans(ca_cli_t, ca_misc_tmp_t, file)
```

With this in place, the application works just fine - all I need to do
is have an initial location marked as `ca_misc_t`. For now, none of the
users have the rights to do so, so I create three additional interfaces
to be used against other user domains.

The first one is to allow user domains to use the CA script. This is
handled by the `ca_role()` interface. In order to support such an
interface, let's first create the `ca_roles` role attribute in the `.te`
file:

``` {lang="perl"}
attribute_role ca_roles;
role ca_roles types ca_cli_t;
```

Now I can define the `ca_role()` interface:

``` {lang="bash"}
interface(`ca_role',`
  gen_require(`
    attribute_role ca_roles;
    type ca_cli_t, ca_cli_exec_t;
    type ca_misc_t;
  ')

  # Allow the user role (like sysadm_r) the types granted to ca_roles
  roleattribute $1 ca_roles;

  # Read the non-private key files and directories
  allow $2 ca_misc_t:dir list_dir_perms;
  allow $2 ca_misc_t:file read_file_perms;

  # Allow to transition to ca_cli_t by executing a ca_cli_exec_t file
  domtrans_pattern($2, ca_cli_exec_t, ca_cli_t)

  # Look at the process info
  ps_process_pattern($2, ca_cli_t)

  # Output (and redirect) handling
  allow ca_cli_t $2:fd use;
')
```

This role allows to run the command, but we still don't have the rights
to create a `ca_misc_t` directory. So another interface is created,
which is granted to *regular* system administrators (as the `ca_role()`
might be granted to non-admins as well, who can invoke the script
through `sudo`).

``` {lang="bash"}
interface(`ca_sysadmin',`
  gen_require(`
    type ca_misc_t;
    type ca_private_key_t;
  ')

  # Allow the user relabel rights on ca_misc_t
  allow $1 ca_misc_t:dir relabel_dir_perms;
  allow $1 ca_misc_t:file relabel_file_perms;

  # Allow the user to label /to/ ca_private_key_t (but not vice versa)
  allow $1 ca_private_key_t:dir relabelto_dir_perms;
  allow $1 ca_private_key_t:file relabelto_file_perms;

  # Look at regular file/dir info
  allow $1 ca_misc_t:dir list_dir_perms;
  allow $1 ca_misc_t:file read_file_perms;
')
```

The `ca_sysadmin()` interface can also be assigned to the `setfiles_t`
command so that relabel operations (and file system relabeling) works
correctly.

Finally, a real administrative interface is created that also has
relabel *from* rights (so any domain granted this interface will be able
- if Linux allows it and the type the operation goes to/from is allowed
- to change the type of private keys to a regular file). This one should
*only* be assigned to a rescue user (if any). Also, this interface is
allowed to label CA management scripts.

``` {lang="bash"}
interface(`ca_admin',`
  gen_require(`
    type ca_misc_t, ca_private_key_t;
    type ca_cli_exec_t;
  ')

  allow $1 { ca_misc_t ca_private_key_t }:dir relabel_dir_perms;
  allow $1 { ca_misc_t ca_private_key_t }:file relabel_file_perms;

  allow $1 ca_cli_exec_t:file relabel_file_perms;
')
```

So regular system administrators would be assigned the `ca_sysadmin()`
interface as well as the `setfiles_t` domain; CA handling roles would be
granted the `ca_role()` interface. The `ca_admin()` interface would only
be granted on the rescue (or super-admin).

``` {lang="perl"}
# Regular system administrators
ca_sysadmin(sysadm_t)
ca_sysadmin(setfiles_t)
# Certificate administrator
ca_role(certadmin_r, certadmin_t)
# Security administrator
ca_admin(secadm_t)
```
