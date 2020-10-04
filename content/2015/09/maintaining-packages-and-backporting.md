Title: Maintaining packages and backporting
Date: 2015-09-02 20:33
Category: Gentoo
Tags: gentoo, ebuild, patching
Slug: maintaining-packages-and-backporting

A few days ago I committed a small update to `policycoreutils`, a SELinux related
package that provides most of the management utilities for SELinux systems. The
fix was to get two patches (which are committed upstream) into the existing
release so that our users can benefit from the fixed issues without having to
wait for a new release.

<!-- PELICAN_END_SUMMARY -->

**Getting the patches**

To capture the patches, I used `git` together with the commit id:

```shell-session
~$ git format-patch -n -1 73b7ff41
0001-Only-invoke-RPM-on-RPM-enabled-Linux-distributions.patch
~$ git format-patch -n -1 4fbc6623
0001-Set-self.sename-to-sename-after-calling-semanage_seu.patch
```

The two generated patch files contain all information about the commit. Thanks
to the `epatch` support in the `eutils.eclass`, these patch files are
immediately usable within Gentoo's ebuilds.

**Updating the ebuilds**

The SELinux userspace ebuilds in Gentoo all have [live ebuilds](http://blog.siphos.be/2015/06/live-selinux-userspace-ebuilds/)
available which are immediately usable for releases. The idea with those live
ebuilds is that we can simply copy them and commit in order to make a new release.

So, in case of the patch backporting, the necessary patch files are first moved
into the `files/` subdirectory of the package. Then, the live ebuild is updated
to use the new patches:

```diff
@@ -88,6 +85,8 @@ src_prepare() {
                epatch "${FILESDIR}/0070-remove-symlink-attempt-fails-with-gentoo-sandbox-approach.patch"
                epatch "${FILESDIR}/0110-build-mcstrans-bug-472912.patch"
                epatch "${FILESDIR}/0120-build-failure-for-mcscolor-for-CONTEXT__CONTAINS.patch"
+               epatch "${FILESDIR}/0130-Only-invoke-RPM-on-RPM-enabled-Linux-distributions-bug-534682.patch"
+               epatch "${FILESDIR}/0140-Set-self.sename-to-sename-after-calling-semanage-bug-557370.patch"
        fi

        # rlpkg is more useful than fixfiles
```

The patches themselves do not apply for the live ebuilds themselves (they are
ignored there) as we want the live ebuilds to be as close to the upstream
project as possible. But because the ebuilds are immediately usable for
releases, we add the necessary information there first.

Next, the new release is created:

```shell-session
~$ cp policycoreutils-9999.ebuild policycoreutils-2.4-r2.ebuild
```

**Testing the changes**

The new release is then tested. I have a couple of scripts that I use
for automated testing. So first I update these scripts to also try out
the functionality that was failing before. On existing systems, these
tests should fail:

```
Running task semanage (Various semanage related operations).
  ...
    Executing step "perm_port_on   : Marking portage_t as a permissive domain                              " -> ok
    Executing step "perm_port_off  : Removing permissive mark from portage_t                               " -> ok
    Executing step "selogin_modify : Modifying a SELinux login definition                                  " -> failed
```

Then, on a test system where the new package has been installed, the same
testset is executed (together with all other tests) to validate if the problem
is fixed.

**Pushing out the new release**

Finally, with the fixes in and validated, the new release is pushed out (into
~arch first of course) and the bugs are marked as `RESOLVED:TEST-REQUEST`. Users
can confirm that it works (which would move it to `VERIFIED:TEST-REQUEST`) or
we stabilize it after the regular testing period is over (which moves it to
`RESOLVED:FIXED` or `VERIFIED:FIXED`).

I do still have to get used to Gentoo using git as its repository now. The
[workflow](https://wiki.gentoo.org/wiki/Gentoo_git_workflow) to use is
documented though. Luckily, because I often get that the `git push` fails
(due to changes to the tree since my last pull). So I need to run `git
pull --rebase=preserve` followed by `repoman full` and then the push again
sufficiently quick after each other).

This simple flow is easy to get used to. Thanks to the existing foundation
for package maintenance (such as `epatch` for patching, live ebuilds that
can be immediately used for releases and the ability to just cherry pick
patches towards our repository) we can serve updates with just a few minutes
of work.

