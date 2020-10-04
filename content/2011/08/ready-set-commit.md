Title: Ready, set, commit!
Date: 2011-08-12 22:35
Category: Gentoo
Slug: ready-set-commit

Yesterday, I have entered the realms of Gentoo Development again. But as
it was getting late then, I had to wait before the first commits
happened. So this evening, things were done. The first couple of
documentation bugs (mostly related to OpenRC) have been committed to the
Gentoo CVS repository and I've also committed my first change on the
gentoo-x86 CVS repository (a small change for the SELinux eclass, needed
for the upcoming storm of packages.

So what does that mean for Gentoo and Gentoo Hardened? Well, that means
that I'll be taking on bugs myself now. You can ping me for
documentation changes as well as SELinux policy changes. Within the next
few hours, a little over 200 packages will be sent to the
[hardened-development](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-dev.git)
overlay, containing the *SELinux policy modules based on the upstream
2.20110726 release*. These will linger there for a while, since I had
some troubles getting them into the shape they are now - so some
additional testing doesn't hurt.

During the testing, most of the patches applied will also be submitted
upstream for verification and inclusion. Simultaneously, a second set of
patches will be prepared to squeeze out the remaining issues that are
either left, or that have been reported since the push (I am expecting
quite a few still, but luckily many users on \#gentoo-hardened are
helping out in testing SELinux).

While we are on the SELinux policy development, I'll also be handling a
few other documentation bugs. I'm hoping to take a stab at Gentoo's
[OpenLDAP HOWTO](http://www.gentoo.org/doc/en/ldap-howto.xml) since I've
been running a similar setup here for some time (including SELinux
support of course ;-)

Speaking about documentation, Anthony G. "blueness" Basile has pushed
some documentation updates that I made in the
[hardened-docs](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-docs.git)
repository to the main site. That means that users can now see how
*Gentoo Hardened supports MCS* (and even talks about MLS for the brave
ones out there). And since we now support MCS and have the latest
userspace utilities in our repository, we can finally see if we can
support SELinux sandboxing, a functionality that is already available in
Fedora/RedHat but not fully supported through the upstream channels yet.
