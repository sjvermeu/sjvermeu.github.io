Title: Easy documentation updates thanks to the many contributions
Date: 2011-08-22 23:01
Category: Gentoo
Slug: easy-documentation-updates-thanks-to-the-many-contributions

As mentioned previously, I took a stab at the [Gentoo Guide to OpenLDAP
Authentication](http://www.gentoo.org/doc/en/ldap-howto.xml), updating
its configuration settings as well as give an introduction to its
replication mechanism. Although I am no OpenLDAP guru at all, I set up a
similar architecture for testing some SELinux policy changes. This test
environment grew (okay, it's all KVM guests, so the only thing that grew
was my resource consumption) and is currently entailing over 24 systems,
ranging from BIND (in master/slave) to Apache/Nginx setups, reverse
proxies to database clusters and what not.

I'm hoping that I can manage the scripts I use to create those images
(perform unattended installations of all these softwares as well as
configuration aspects) and eventually provide some more documents for
Gentoo on these matters. But until then, I'll focus more on fixing and
helping the publication of documentation (a small list of changes
contributed by various people are in the [Gentoo
Handbook](http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml)
which finally mentions ext4, has seen a whole slew of OpenRC fixes and
updated kernel configuration information, or the [Gentoo Guide to
Mutt](http://www.gentoo.org/doc/en/guide-to-mutt.xml) which has been
rewritten from scratch). If you notice any errors or needs for
corrections on Gentoo documentation, don't hesitate to [file a
bugreport](http://bugs.gentoo.org) or drop by on IRC's \#gentoo-doc
channel.

Speaking of documentation, the [SELinux
Handbook](http://www.gentoo.org/proj/en/hardened/selinux/selinux-handbook.xml)
has seen a few updates as well, and I have also started pushing some
module-specific information (for instance on
[Portage](http://www.gentoo.org/proj/en/hardened/selinux/modules/portage.xml)).
This might help some users with their quest to get a particular software
title to work on their system with the SELinux policies in place.

Next to the documentation, you'll also find the SELinux policy modules
based on the 2.20110726 version of the reference policy in the
[hardened-dev](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-dev.git;a=summary)
overlay. The base policy is currently in revision 2 with revision 3 on
the way (asterisk, mutt and mozilla fixes). It now uses a cleaner
patching process, something that is also part of the updated
[selinux-policy-2.eclass](http://devmanual.gentoo.org/eclass-reference/selinux-policy-2.eclass/index.html).
I'm also hoping that I can introduce delivery of the SELinux policy
interface documentation (a nicely formatted set of HTML pages showing
which kind of interfaces - calls or privilege "bundles" if you like -
are available), of course based on the availability of USE="doc".

Once this has been accomplished, I'll see that the new policy modules
are migrated from the hardened-dev overlay to the main tree. Also, the
majority of changes made to the policy are since revision 2 of the base
policy in a more manageable format, allowing for faster pushing of the
changes to the upstream reference policy.
