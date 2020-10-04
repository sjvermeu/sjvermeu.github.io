Title: Matching packages with CVEs
Date: 2013-04-04 21:44
Category: Gentoo
Slug: matching-packages-with-cves

I've come across a few posts on forums (Gentoo and elsewhere) asking why
Gentoo doesn't make security-related patches on the tree. Some people
think this is the case because they do not notice (m)any GLSAs, which
are Gentoo's security advisories. However, it isn't that Gentoo doesn't
push out security fixes - it is a matter of putting the necessary human
resources against it to write down the GLSAs.

Gentoo is often quick with creating the necessary ebuilds for newer
versions of software. And newer versions often contain security fixes
that mitigate problems detected in earlier versions. So by keeping your
system up to date, you get those security fixes as well. But without
GLSA, it is difficult to really know which packages are necessary and
which aren't, let alone be aware that there are potential problems with
your system.

I already captured one of those needs through the
[cvechecker](http://cvechecker.sf.net) application, so I took a step
further and wrote an extremely ugly script (it's so ugly, it would
spontaneously become a joke of itself when published) which compiles a
list of *potential* CPEs (identifiers for products used in CVEs) from
the Gentoo package list (ugliness 1: it assumes that the package name is
the product name). It then tries to *assume* what the version of that
software is based on the ebuild version (ugliness 2: it just takes the
a.b.c number). Then, it lists the CVEs affiliated with a particular
package, and checks this list with the list of CVEs from an earlier
version (ugliness 3: it requires the previous, vulnerable version to
still be in the tree). If one of the CVEs has "disappeared", it will
report that the given package might fix that CVE. Oh, and if the CVE has
a CPE that contains more than just a version, the script ignores it
(ugliness 4). And it probably ignores a lot of other things as well
while not checking the input (ugliness 5 and higher).

But if we ignore all that, what does that give for the Gentoo portage
tree for the last 7 days? In other words, what releases have been made
on the tree that *might* contain security fixes (and that do comply with
the above ugliness)?

    app-editors/emacs-23.4-r5 might fix CVE-2010-0825
    app-editors/emacs-24.2-r1 might fix CVE-2012-0035
    app-editors/emacs-24.2-r1 might fix CVE-2012-3479
    dev-lang/python-2.6.8-r1 might fix CVE-2010-3492
    dev-lang/python-2.6.8-r1 might fix CVE-2011-1521
    dev-lang/python-2.6.8-r1 might fix CVE-2012-0845
    dev-lang/python-2.6.8-r1 might fix CVE-2012-1150
    dev-lang/python-2.6.8-r1 might fix CVE-2008-5983
    dev-php/smarty-2.6.27 might fix CVE-2009-5052
    dev-php/smarty-2.6.27 might fix CVE-2009-5053
    dev-php/smarty-2.6.27 might fix CVE-2009-5054
    dev-php/smarty-2.6.27 might fix CVE-2010-4722
    dev-php/smarty-2.6.27 might fix CVE-2010-4723
    dev-php/smarty-2.6.27 might fix CVE-2010-4724
    dev-php/smarty-2.6.27 might fix CVE-2010-4725
    dev-php/smarty-2.6.27 might fix CVE-2010-4726
    dev-php/smarty-2.6.27 might fix CVE-2010-4727
    dev-php/smarty-2.6.27 might fix CVE-2012-4277
    dev-php/smarty-2.6.27 might fix CVE-2012-4437
    media-sound/rhythmbox-2.97 might fix CVE-2012-3355
    net-im/empathy-3.6.3 might fix CVE-2011-3635
    net-im/empathy-3.6.3 might fix CVE-2011-4170
    sys-cluster/glusterfs-3.3.1-r2 might fix CVE-2012-4417
    www-client/seamonkey-2.17 might fix CVE-2013-0788
    www-client/seamonkey-2.17 might fix CVE-2013-0789
    www-client/seamonkey-2.17 might fix CVE-2013-0791
    www-client/seamonkey-2.17 might fix CVE-2013-0792
    www-client/seamonkey-2.17 might fix CVE-2013-0793
    www-client/seamonkey-2.17 might fix CVE-2013-0794
    www-client/seamonkey-2.17 might fix CVE-2013-0795
    www-client/seamonkey-2.17 might fix CVE-2013-0796
    www-client/seamonkey-2.17 might fix CVE-2013-0797
    www-client/seamonkey-2.17 might fix CVE-2013-0800

As you can see, there is still a lot of work to remove bad ones (and add
matches for non-default ones), but at least it gives an impression
(especially those that have CVEs of 2012 or even 2013 are noteworthy),
which is the purpose of this post.

It would be very neat if ebuilds, or the package metadata, could give
pointers on the CPEs. That way, it would be much easier to check a
system for known vulnerabilities through the (publicly) available CVE
databases as we then only have to do simple matching. A glsa-check-ng
(what's in a name) script would then construct the necessary CPEs based
on the installed package list (and the metadata on it), check if there
are CVEs against it, and if there are, see if a newer version of the
same package is available that has no (or fewer) CVEs assigned to it.

Perhaps someone can create a GSoC proposal out of that?
