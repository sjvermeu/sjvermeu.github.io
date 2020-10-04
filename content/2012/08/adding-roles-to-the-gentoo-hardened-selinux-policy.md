Title: Adding roles to the Gentoo Hardened SELinux policy
Date: 2012-08-14 20:39
Category: Gentoo
Slug: adding-roles-to-the-gentoo-hardened-selinux-policy

I [wrote a small
section](http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml?part=2&chap=5#doc_chap4)
on how to create additional roles to the SELinux policy offered by
Gentoo Hardened. Whereas the default policy that we provide only offers
a few basic roles, any policy administrator can provide additional roles
for the system.

By using additional roles, you can grant users administrative rights to
particular services without risking having them elevate their privileges
to root (+ sysadmin). You should even allow them to get a root shell
while remaining confined within their domain (and role).
