Title: SELinux Gentoo/Hardened state 2011-12-19
Date: 2011-12-19 18:04
Category: Gentoo
Slug: selinux-gentoohardened-state-2011-12-19

On december 14th, the [Gentoo Hardened](http://hardened.gentoo.org)
project had its monthly [online
meeting](http://archives.gentoo.org/gentoo-hardened/msg_6ee74d905f217b47446ace08da32a921.xml)
to discuss the current state of affairs of its projects and subprojects.
Amongst them, the updates on the SELinux-front were presented as well.

Since last meeting, the follow topics passed the revue.

-   [sec-policy/selinux-base-policy](http://packages.gentoo.org/package/sec-policy/selinux-base-policy),
    which is the "master" of our SELinux policies and contains those
    SELinux modules that are somewhat indivisible (hence the name,
    "base"), is now at revision 8. I tend to describe the changes on the
    gentoo-hardened mailinglist, and this is [not different for rev
    8](http://archives.gentoo.org/gentoo-hardened/msg_b11ef32142076034abd0616e373361da.xml).
    I haven't stabilized the rev 6 one yet although I promised too, I'll
    try to find some time to do that this evening.
-   We had a
    [regression](https://bugs.gentoo.org/show_bug.cgi?id=375475) with
    **newrole** for some time. Luckily, Jory "Anarchy" Pratt found
    the issue. Drop the setuid bit from the binary, and the application
    works again as it should. This will be included in the next
    [policycoreutils](http://packages.gentoo.org/package/sys-apps/policycoreutils) bump.
-   The last available
    [sudo](http://packages.gentoo.org/package/app-admin/sudo) package
    now builds with native SELinux support as well, which allows users
    to add ROLE= and TYPE= information in the `sudoers` file. As such,
    users do not need to call **newrole** when they need to transition
    to a specific role for just a single command - sudo can now take
    care of that.
-   The older `selinux/v2refpolicy/*` profiles have been deprecated. If
    you want to use a SELinux-enabled profile, you need to use a profile
    that ends with `/selinux`, such as
    `default/linux/amd64/10.0/selinux` or
    `hardened/linux/amd64/selinux`. Of course we prefer you to use a
    hardened profile ;-)
-   Documentation-wise,
    </p>
    -   the [Gentoo Hardened SELinux
        Handbook](http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml)
        has been updated to reflect the profile changes
    -   the [SELinux bugreporting
        guide](http://www.gentoo.org/proj/en/hardened/selinux-bugreporting.xml)
        has been put online to inform users what kind of information is
        needed for us to fix issues or denials that they might see
    -   the [SELinux
        FAQ](http://www.gentoo.org/proj/en/hardened/selinux-faq.xml) has
        been updated with the questions [Applications do not transition
        on a nosuid
        partition](http://www.gentoo.org/proj/en/hardened/selinux-faq.xml#nosuid)
        and [Why do I always need to re-authenticate when operating init
        scripts?](http://www.gentoo.org/proj/en/hardened/selinux-faq.xml#auth-run_init).

That's about it. Not a too busy month but progress anyhow.
