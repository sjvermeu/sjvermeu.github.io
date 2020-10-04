Title: Upgrading old Gentoo installations
Date: 2013-12-29 14:18
Category: Gentoo
Tags: Gentoo, portage, snapshot, upgrade
Slug: upgrading-old-gentoo-installations

Today I got "pinged" on [bug
\#463240](https://bugs.gentoo.org/show_bug.cgi?id=463240) about the
difficulty of upgrading a Gentoo Linux deployment after a long time of
inactivity on the system. We already have an [Upgrading
Gentoo](https://wiki.gentoo.org/wiki/Upgrading_Gentoo) article on the
Gentoo wiki that describes in great detail how upgrades can be
accomplished. But one of the methods I personally suggest most is to do
small, incremental upgrades.

Say you have a system from early 2009. Not too long ago, but also not
that recent anymore. If you would upgrade that system using the regular
approach, your system would probably be using a non-existing profile
(the `/etc/make.profile` symlink would point to a non-existing
location), and if you switch the profile to an existing one, you might
have to deal with problems like the profile requiring certain features
(or EAPI version) that the software currently available on your system
doesn't support.

This problem is mentioned in the upgrade guide through the following:

> Make sure your Portage is updated before performing any profile
> changes.

However, it does not tell how to update Portage. In my opinion the best
way forward is to install an older Portage tree snapshot (somewhat more
recent than your own deployment) and upgrade *at least* portage, perhaps
also the packages belonging to the *system* set. So for a system that
has not been updated since January 2009, you might want to try the
portage tree snapshot of July 2009, then January 2010, then July 2010,
etc. until you have a recent deployment again.

All that is left for you to do is to find such a snapshot (as the
Portage tree snapshots from the mirrors are cleaned out after a few
months). I try to keep a set of [Portage tree snapshots
available](http://dev.gentoo.org/~swift/snapshots/) with a 2-month
period which should be sufficient for most users to gradually upgrade
their systems.

Considering I've used this method a few times already I'm going to add
them to the [upgrading
instructions](https://wiki.gentoo.org/wiki/Upgrading_Gentoo) as well.
