Title: cvechecker 0.2 released
Date: 2010-08-16 21:35
Category: Security
Slug: cvechecker-0-2-released

I've made version 0.2 available of
[cvechecker](http://cvechecker.sourceforge.net). It fixes some build
warnings and also supports the normal "make install" step. The
**pullcves** command now also pulls in the latest `versions.dat` file.
Special thanks to Per Andersson for reporting that the `./configure`
didn't fail if sqlite3 or libconfig wasn't available - that should be
fixed now as well.

In my [Gentoo overlay](http://github.com/sjvermeu/gentoo.overlay),
`cvechecker-0.2.ebuild` has been put available. Thanks there to
webkiller71 for helping out with a more sane approach to
`cvechecker-0.1.ebuild` - I hope I didn't screw up his changes in 0.2
too much ;-)
