Title: Added "predictable network interface" info into the handbook
Date: 2013-05-07 03:50
Category: Documentation
Tags: documentation, gdp, Gentoo, udev
Slug: added-predictable-network-interface-info-into-the-handbook

Being long overdue - like many of our documentation-reported bugs :-( I
worked on [bug 466262](https://bugs.gentoo.org/show_bug.cgi?id=466262)
to update the [Gentoo Handbook](http://www.gentoo.org/doc/en/handbook/)
with information about [Network Interface
Naming](http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=4&chap=2#doc_chap4).
Of course, the installation instructions have also seen the necessary
updates to refer to this change.

With some luck (read: time) I might be able to fix various other
documentation-related ones soon. I had some problems with the new
SELinux userspace that I wanted to get fixed before, and then I worked
on the new SELinux policies as well as trying to figure out how SELinux
deals with network related aspects. Hence I saw time fly by at the speed
of a neutrino...

BTW, the 20130424 policies are in the tree.
