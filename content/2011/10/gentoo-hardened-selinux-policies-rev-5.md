Title: Gentoo Hardened SELinux policies, rev 5
Date: 2011-10-13 18:30
Category: Gentoo
Slug: gentoo-hardened-selinux-policies-rev-5

I've pushed out `selinux-base-policy` version 2.20110726-r5 to the
[hardened-dev](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-dev.git;a=summary)
overlay. It does not hold huge changes, most of them are rewrites or
updates on pre-existing patches (on the SELinux policies) to make them
conform the refpolicy naming conventions and other guidelines. It
includes preliminary support for the [XDG
Specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html)
although changes there are still going to occur (as the policy is still
under development). Other updates are primarily on the policies for user
applications (pan, mozilla, skype), portage and asterisk.

In related news, the [Gentoo Hardened SELinux
FAQ](http://hardened.gentoo.org/selinux-faq.xml) is updated with two
entries:

1.  [Portage fails to label files because "setfiles" does not work
    anymore](http://www.gentoo.org/proj/en/hardened/selinux-faq.xml#recoverportage),
    and
2.  [Applications do not transition on a nosuid-mounted
    partition](http://www.gentoo.org/proj/en/hardened/selinux-faq.xml#nosuid)

