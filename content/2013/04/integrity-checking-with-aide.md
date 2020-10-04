Title: Integrity checking with AIDE
Date: 2013-04-11 17:02
Category: Documentation
Tags: aide, integrity
Slug: integrity-checking-with-aide

As to at least do some progress in the integrity part of Gentoo Hardened
(a subproject I'd like to extend towards greater heights), I dediced to
write up a [small guide](https://wiki.gentoo.org/wiki/AIDE) on how to
work with [AIDE](http://aide.sourceforge.net). The tool is simple enough
(and it allowed me to test its SELinux policy module a bit) so you'll
get by fairly quickly.

However, what I'd like to know a bit more about is on how to use AIDE on
a hypervisor level, scanning through the file systems of the guests,
without needing in-guest daemons. I wrote a small part in the guide, but
I need to test it more thoroughly. In the end, I'd like to have a
configuration that AIDE is running on the host, mounting the guest file
systems, scanning the necessary files and sending out reports, all one
at a time (snapshot, mount, scan+report, unmount, destroy snapshot,
next).

If anyone has pointers towards such a setup, it'd be greatly
appreciated. It provides, in my opinion, a secure way of scanning
systems even if they are completely compromised (in other words you
couldn't trust anything running inside the guest or running with the
libraries or software within the guest).
