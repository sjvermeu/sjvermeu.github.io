Title: Gentoo Hardened progress meeting of march 2013
Date: 2013-03-07 22:46
Category: Gentoo
Tags: Gentoo, grsecurity, hardened, kernel, pax, profiles, selinux, toolchain
Slug: gentoo-hardened-progress-meeting-of-march-2013

Another month has passed, so time for a new progress meeting...

**Toolchain**

GCC v4.7 has been unmasked, allowing a large set of users to test out
the new GCC. It is also expected that GCC 4.8-rc1 will hit the tree next
week. In the hardened-dev overlay, hardened support for x86, amd64 and
arm has been added (SPEC updates) and the remainder of architectures
will be added by the end of the week.

**Kernel and grSecurity/PaX**

Kernel 3.7.5 had a security issue (local root privilege escalation) so
3.7.5-r1 which held a fix for this was stabilized quickly. However,
other (non-security) problems have been reported, such as one with
dovecot, regarding the VSIZE memory size. This should be fixed in the
3.8 series, so these are candidate for a faster stabilization. This
faster stabilization is never fun, as it increases the likelihood that
we miss other things, but they are needed as the vulnerability in the
previous stable kernel was too severe.

Regarding XATTR\_PAX, we are getting pretty close to the migration. The
eclass is ready and will be announced for review on the appropriate
mailinglists later this week. A small problem still remains on
Paludis-using systems (Paludis does not record NEEDED.ELF.2 information
- linkage information - so it is hard to get all the linkage information
on a system). A different revdep-pax and migrate-pax toolset will be
built that detects the necessary linkage information, but much slower
than on a Portage-running system.

**SELinux**

The 11th revision of the policies are now stable, and work is on the way
for the 12th revision which will hit the tree soon. Some work is on the
way for setools and policycoreutils (one due to a new release - setools
- and the other one due to a build failure if PAM is not set). Both
packages will hit the hardened-dev overlay soon.

A new "edition" of the selinuxnode virtual image has been pushed to the
mirror system, providing a SELinux-enabled (enforcing) Gentoo Hardened
system with grSecurity and PaX, as well as IMA and EVM enabled.

**Profiles**

The 13.0 profiles have been running fine for a while at a few of our
developer systems. No changes have been needed (yet) so things are
looking good.

**System Integrity**

The necessary userland utilities have been moved to the main tree. The
documentation for IMA/EVM has been updated as well to reflec the current
state of IMA/EVM within Gentoo Hardened. IMA, even with the custom
policies, seems to be working well. EVM on the other hand has some
issues, so you might need to run with EVM=fix for now. Debugging on this
issue is on the way.

**Documentation**

Some of the user oriented documentation (integrity and SELinux) have
been moved to the Gentoo Wiki for easier user contributions and
simplified management. Other documents will follow soon.
