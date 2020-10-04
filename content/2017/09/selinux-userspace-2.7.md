Title: SELinux Userspace 2.7
Date: 2017-09-26 14:50
Category: SELinux
Tags: gentoo,selinux,userspace
Slug: selinux-userspace-2.7

A few days ago, [Jason "perfinion" Zaman][1] stabilized the 2.7 SELinux userspace on
Gentoo. This release has quite a [few new features][2], which I'll cover in later
posts, but for distribution packagers the main change is that the userspace
now has many more components to package. The project has split up the
policycoreutils package in separate packages so that deployments can be made
more specific.

[1]: http://blog.perfinion.com/
[2]: https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20170804/RELEASE-20170804.txt

Let's take a look at all the various userspace packages again, learn what their
purpose is, so that you can decide if they're needed or not on a system. Also,
when I cover the contents of a package, be aware that it is based on the deployment
on my system, which might or might not be a complete installation (as with Gentoo,
different USE flags can trigger different package deployments).

<!-- PELICAN_END_SUMMARY -->

**libsepol - manipulating SELinux binary policies**

The first package, known in Gentoo as `sys-libs/libsepol`, is the library that
enables manipulating the SELinux binary policies. This is a core library, and is
the first SELinux userspace package that is installed on a system.

It contains one command, `chkcon`, which allows users to validate if a specific
security context exists within a binary policy file:

```
~$ chkcon policy.29 user_u:user_r:mozilla_t:s0
user_u:user_r:mozilla_t:s0 is valid
```

The package does contain two manpages of old commands which are no longer available
(or I'm blind, either way, they're not installed and not found in the SELinux userspace
repository either) such as genpolusers and genpolbools.

**libselinux - the main SELinux handling library**

The libselinux library, known in Gentoo as `sys-libs/libselinux`, is the main SELinux
library. Almost all applications that are SELinux-aware (meaning they not only know SELinux
is a thing, but are actively modifying their behavior with SELinux-specific code) will
link to libselinux.

Because it is so core, the package also provides the necessary bindings for different
scripting languages besides the standard shared objects approach, namely Python (as
many SELinux related tooling is written in Python) and Ruby.

Next to the bindings and libraries, libselinux also offers quite a few executables
to query and manipulate SELinux settings on the system, which are shortly described
on the [SELinux userspace wiki][3] but repeated here for convenience. Most of these
are meant for debugging purposes, as they are simple wrappers toward the libselinux
provided functions, but some of them are often used by administrations.

[3]: https://github.com/SELinuxProject/selinux/wiki/Tools

* `avcstat` gives statistics about the in-kernel access vector cache, such as number
  of lookups, hits and misses
* `compute_create` queries the kernel security server for a transition decision
* `compute_av` queries the kernel security server for an access vector decision
* `compute_relabel` queries the kernel security server for a relabel decision
* `compute_member` queries the kernel security server for a labeling decision on a
  polyinstantiated object
* `getconlist` uses the `security\_compute\_user()` function, and orders the resulting
  list based on the `default\_contexts` file and per-user context files
* `getdefaultcon` is like `getconlist` but only returns the first context
* `compute_user` queries the kernel security server fo a set of reachable user contexts
  from a source context
* `getfilecon` gets the context of a file by path
* `getpidcon` gets the context of a process by PID
* `getseuser` queries the `seuser` file for the resulting SELinux user and contxt for a
  particular linux login and login context
* `getsebool` gets the current state of a SELinux boolean in the SELinux security server
* `matchpathcon` queries the active filecontext file for how a particular path should
  be labeled
* `policyvers` queries the kernel security server for the maximum policy version supported
* `getenforce` gets the enforcing state of the kernel access vector cache
* `sefcontext_compile` generates binary filecontext files, optimized for fast querying
* `selabel_lookup` looks up what the target default context is for various classes
  (supporting the X related SELinux types, database types, etc.)
* `selabel_digest` calculates the SHA1 digest of spec files, and returns a list
  of the specfiles used to calculate the digest. This is used by Android.
* `selabel_partial_match` determines if a direct or partial match is possible
  on a file path
* `selabel_lookup_best_match` obtains the best matching SELinux security context
  for file-based operations
* `selinux_check_securetty_context` checks whether a SELinux tty security context
  is defined as a securetty context
* `selinux_check_access` checks if the source context has the access permission
  for the specified class on the target context
* `selinuxexeccon` reports the SELinux context for an executable
* `selinuxenabled` returns if SELinux is enabled or not
* `setfilecon` sets the context of a path
* `setenforce` sets the enforcing state of the kernel access vector cache
* `togglesebool` toggles a SELinux boolean, but only runtime (so it does not
  persist across reboots)

**checkpolicy - policy compiler**

The checkpolicy package, known in Gentoo as `sys-apps/checkpolicy`, provides two
main applications, `checkpolicy` and `checkmodule`. Both applications are compilers
(unlike what the name implies) which build a binary SELinux policy. The main difference
between these two is that one builds a policy binary, whereas the other one builds a 
SELinux module binary.

Developers don't often call these applications themselves, but use the build scripts.
For instance, the `semodule_package` binary would be used to combine the binary policy
with additional files such as file contexts.

**libsemanage - facilitating use of SELinux overall**

The libsemanage library, known in Gentoo as `sys-libs/libsemanage`, contains SELinux
supporting functions that are needed for any regular SELinux use. Whereas libselinux
would be used everywhere, even for embedded systems, libsemanage is generally not for
embedded systems but is very important for Linux systems in overall.

Most SELinux management applications that administrators come in contact with will be
linked with the libsemanage library. As can be expected, the `semanage` application
as offered by the `selinux-python` package is one of them.

The only application that is provided by libsemanage is the `semanage_migrate_store`,
used to migrate the policy store from the `/etc/selinux` to the `/var/lib/selinux`
location. This was done with the introduction of the 2.4 userspace.

**selinux-python - Python-based command-line management utilities**

The selinux-python package, known in Gentoo as `sys-apps/selinux-python`, is one of
the split packages that originally where part of the `policycoreutils` package. It
contains the majority of management utilities that administrators use for handling
SELinux on their systems.

The most known application here is `semanage`, but it contains quite a few others
as well:

* `sepolgen` generates an initial SELinux policy module template, and is short for
  the `sepolicy generate` command
* `audit2why` translates SELinux audit messages into a description of why the access
  was denied. It is short for the `audit2allow -w` command.
* `audit2allow` generates SELinux policy allow/dontaudit rules from logs of denied
  operations
* `sepolgen-ifgen` generates an overview of available interfaces. This overview is used
  by `audit2allow` to guess the right interface to use when allowing or dontauditing certain
  operations.
* `sepolicy` is the SELinux policy inspection tool, allowing to query various aspects of
  a SELinux configuration (namely booleans, communication flows, interfaces, network information
  and transition information). It also provides the ability to generate skeleton policies (as
  described with `sepolgen`) and manual pages.
* `chcat` changes a file's SELinux security category
* `sepolgen-ifgen-attr-helper` generates an overview of attributes and attribute mappings.
  This overview is used by `audit2allow` to guess the right attribute to use when allowing
  or dontauditing certain operations.
* `semanage` is a SELinux policy management tool, allowing a multitude of operations
  against the SELinux policy and the configuration. This includes definition import/export,
  login mappings, user definitions, ports and interface management, module handling, 
  file contexts, booleans and more.

**semodule-utils - Developing SELinux modules**

The semodule-utils package, known in Gentoo as `sys-apps/semodule-utils`, is another split package
that originally was part of the `policycoreutils` package. In it, SELinux policy module
development utilities are provided. The package is not needed for basic operations such
as loading and unloading modules though.

* `semodule_expand` expands a SELinux base module package into a kernel binary policy file
* `semodule_deps` shows the dependencies between SELinux policy packages
* `semodule_link` links SELinux policy module packages together into a single SELinux policy
  module
* `semodule_unpackage` extracts a SELinux module into the binary policy and its associated
  files (such as file context definitions)
* `semodule_package` combines a modular binary policy file with its associated files (such
  as file context definitions) into a module package

**mcstrans - Translate context info in human readable names**

The mcstrans package, known in Gentoo as `sys-apps/mcstrans`, is another split package
that originally was part of the `policycoreutils` package. In it, the MCS translation
daemon is hosted. This daemon translates the SELinux-specific context ranges, like 
`s0-s0:c0.c1024` to a human-readable set, like `SystemLow-SystemHigh`.

This is a purely cosmetic approach (as SELinux internally always uses the sensitivity
and category numbers) but helps when dealing with a large number of separate categories.

**restorecond - Automatically resetting file contexts**

The restorecond package, known in Gentoo as `sys-apps/restorecond`, is another split
package that originally was part of the `policycoreutils` package. It contains the
`restorecond` daemon, which watches over files and directories and forces the right
SELinux label on it.

This daemon was originally intended to resolve a missing feature in SELinux (having
more fine-grained rules for label naming) but with the named file transition support, the
need for this daemon has diminished a lot.

**secilc - SELinux common intermediate language compiler**

The secilc package, known in Gentoo as `sys-apps/secilc`, is the CIL compiler which
builds kernel binary policies based on the passed on CIL code. Although the majority
of policy development still uses the more traditional SELinux language (and supporting
macro's from the reference policy), developers can already use CIL code for policy generation.

With `secilc`, a final policy file can be generated through the CIL code.

**selinux-dbus - SELinux DBus server**

The selinux-dbus package (not packaged in Gentoo at this moment) provides a SELinux DBus
service which systems can use to query and interact with SELinux management utilities
on the system. If installed, the `org.selinux` domain is used for various supported
operations (such as listing SELinux modules, through `org.selinux.semodule_list`).

**selinux-gui - Graphical SELinux settings manager**

The selinux-gui package (not packaged in Gentoo at this moment) provides the
`system-config-selinux` application which offers basic SELinux management support
in a graphical application. It supports boolean handling, file labeling, user mapping,
SELinux user management, network port definitions and module handling. As such, it can
be seen as the graphical helper utility for the `semanage` command.

**selinux-sandbox - Sandbox utility utilizing SELinux sandbox domains**

The selinux-sandbox package (not packaged in Gentoo at this moment) is a set of scripts
to facilitate the creation of SELinux sandboxes. With these utilities, which not only
use SELinux sandbox domains like `sandbox_t` but also Linux namespaces, end users can
launch applications in a restricted environment.

**policycoreutils - Core SELinux management utilities**

The policycoreutils package, known in Gentoo as `sys-apps/policycoreutils`, contains 
basic SELinux tooling which is necessary to handle SELinux in a regular environment.
Supported utilities are:

* `newrole` to switch a user session from one role to another
* `secon` to query the SELinux context of a file, program or user input
* `genhomedircon` to regenerate home directory context files, necessary when new users are
  defined on the system
* `setfiles` to set SELinux file security contexts on resources
* `semodule` to list, load and unload SELinux modules
* `run_init` to launch an init script in the right domain
* `open_init_pty` to run a program under a pseudo terminal with the right context set
* `sestatus` to query current policy status
* `setsebool` to set and, if wanted, persist a SELinux boolean value
* `selinuxconfig` to display the current active configuration paths
* `restorecon` to set SELinux file security contexts on resources
* `load_policy` to load the SELinux policy, generally called from initramfs systems if the
  init system is not SELinux-aware
* `restorecon_xattr` manages the `security.restorecon_last` extended attribute which is set
  by `setfiles` or `restorecon`

Gentoo also adds in two additional scripts:
* `rlpkg` to reset file contexts on files provided by a Gentoo package
* `selocal` to easily handle small SELinux rule additions to the active policy

**There are even more**

Attentive readers will notice that the `setools` package is not discussed here. This package
is not provided by the SELinux userspace project, but is an important package for SELinux
policy developers as it contains the `sesearch` command - an often used command to query
the active policy.

The above list is thus a picture of the SELinux userspace utilities, which is becoming
quite a big application set now that some functionality is split off from the `policycoreutils`
package.

