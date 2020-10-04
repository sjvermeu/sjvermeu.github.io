Title: Custom CIL SELinux policies in Gentoo
Date: 2015-09-10 07:13
Category: Gentoo
Tags: gentoo, cil, selinux, ebuild, eclass
Slug: custom-cil-selinux-policies-in-gentoo

In Gentoo, we have been supporting [custom policy packages](https://wiki.gentoo.org/wiki/SELinux/Tutorials/Creating_your_own_policy_module_file)
for a while now. Unlike most other distributions, which focus on binary packages,
Gentoo has always supported source-based packages as default (although 
[binary packages](https://wiki.gentoo.org/wiki/Binary_package_guide) are 
supported as well).

A recent [commit](https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=8f2aa45db35bbf3a74f8db09ece9edac60e79ee4)
now also allows CIL files to be used.

<!-- PELICAN_END_SUMMARY -->

**Policy ebuilds, how they work**

Gentoo provides its own SELinux policy, based on the [reference policy](https://wiki.gentoo.org/wiki/SELinux/Reference_policy), 
and provides per-module ebuilds (packages). For instance, the SELinux policy for
the [screen](https://packages.gentoo.org/package/app-misc/screen) package is
provided by the [sec-policy/selinux-screen](https://packages.gentoo.org/package/sec-policy/selinux-screen)
package.

The package itself is pretty straight forward:

```bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="screen"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for screen"

if [[ $PV == 9999* ]] ; then
        KEYWORDS=""
else
        KEYWORDS="~amd64 ~x86"
fi
```

The real workhorse lays within a [Gentoo eclass](https://devmanual.gentoo.org/eclass-writing/),
something that can be seen as a library for ebuilds. It allows consolidation of functions and
activities so that a large set of ebuilds can be simplified. The more ebuilds are standardized,
the more development can be put inside an eclass instead of in the ebuilds. As a result, some
ebuilds are extremely simple, and the SELinux policy ebuilds are a good example of this.

The eclass for SELinux policy ebuilds is called [selinux-policy-2.eclass](https://devmanual.gentoo.org/eclass-reference/selinux-policy-2.eclass/index.html)
and holds a number of functionalities. One of these (the one we focus on right now)
is to support custom SELinux policy modules.

**Custom SELinux policy ebuilds**

Whenever a user has a SELinux policy that is not part of the Gentoo policy repository,
then the user might want to provide these policies through packages still. This has
the advantage that Portage (or whatever package manager is used) is aware of the
policies on the system, and proper dependencies can be built in.

To use a custom policy, the user needs to create an ebuild which informs the eclass
not only about the module name (through the `MODS` variable) but also about the
policy files themselves. These files are put in the `files/` location of the ebuild,
and referred to through the `POLICY_FILES` variable:

```bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="oracle"
POLICY_FILES="oracle.te oracle.if oracle.fc"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for screen"

if [[ $PV == 9999* ]] ; then
        KEYWORDS=""
else
        KEYWORDS="~amd64 ~x86"
fi
```

The eclass generally will try to build the policies, converting them into `.pp`
files. With CIL, this is no longer needed. Instead, what we do is copy the `.cil`
files straight into the location where we place the `.pp` files.

From that point onwards, managing the `.cil` files is similar to `.pp` files.
They are loaded with `semodule -i` and unloaded with `semodule -r` when needed.

Enabling CIL in our ebuilds is a small improvement (after the heavy workload
to support the 2.4 userspace) which allows Gentoo to stay ahead in the SELinux
world.

