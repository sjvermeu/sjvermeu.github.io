Title: Catching up, but stuff is piling...
Date: 2012-05-24 18:46
Category: Gentoo
Slug: catching-up-but-stuff-is-piling

Those that are frequent the \#gentoo-hardened chat channel know that I'm
currently trying to get the SELinux related utilities working under
Python 3. This has progressed quite far, but I'm still not there yet.
I'm now hitting a weird
[bug](https://bugs.gentoo.org/show_bug.cgi?id=416301) which seems to
come down to an incorrect free() on some memory (well, I don't know
this, this is my current assumption) but which seems hard to catch. So
I'm learning a lot (thanks to an active community) about debugging
Python and memory issues.

These past few weeks have been enlightening for me on the matter of
Python 2 to 3 conversions. Enough that I can fully understand Diego's
pain when dealing with Ruby upgrades ;-) I hope that, if Perl 6 ever
comes out (right now, Perl 6 is the future - now and in the future ;-),
that they think about the children... err, package maintainers.

Because it takes some time to work on these matters, other reported
SELinux issues have been piling up; I hope I can close down this Python
migration in the near future and work on the remainder of bugs...

Next to all this, I'm slowly going through some documentation related
bugs, but also mentoring [Devan
Franchini](http://twitch153-awesomecode.blogspot.com/) in his GSoC
project on a SELinux policy originator. And now that I linked his blog,
he's going to feel obliged to blog on his progress! ;-)
