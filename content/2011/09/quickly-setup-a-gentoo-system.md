Title: Quickly setup a Gentoo system
Date: 2011-09-24 15:34
Category: Gentoo
Slug: quickly-setup-a-gentoo-system

In order to verify if the installation instructions in the Gentoo
Handbook are still valid, and to allow me to quickly seed new Gentoo
installations in a virtual environment, I wrote a *very ugly* (really)
script to automatically "stage" a Gentoo Linux installation in a KVM
guest. This is **not** my intention to make this an "unattended"
installation script, it is merely one of the many scripts out there to
help some poor developer in working a bit more agile.

I decided to [document
gensetup](http://dev.gentoo.org/~swift/docs/gensetup-guide.xml) as a
first step (cfr my earlier [Catching
up](http://blog.siphos.be/2011/09/catching-up/) post) in my quest to
document how to setup a virtual Gentoo Hardened (with SELinux) virtual
architecture. The **gensetup** tool is just to provide a (semi)automated
way to install Gentoo according to the instructions in the Gentoo
Handbook. Later, I'll add documentation for the `setup_*.sh` scripts
that I use to upgrade such a base installation to a specific
server/service.

You want a probably better working installation script, check out
[Andrew Gaffney's Quickstart for
Gentoo](http://www.agaffney.org/quickstart.php). And if you know of
other such scripts, I would be glad to hear from them, if not just to
keep track of the various similar projects out there.

*Edit:* The quickstart application does not seem to be maintained
anymore. My bad. However, suggestions are made in the comments for more
up-to-date systems ;-)
