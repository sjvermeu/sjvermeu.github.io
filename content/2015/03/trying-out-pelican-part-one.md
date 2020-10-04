Title: Trying out Pelican, part one
Date: 2015-03-06 20:02
Category: Gentoo
Tags: blog, Gentoo, haskell, pandoc, pelican, wordpress
Slug: trying-out-pelican-part-one

One of the goals I've set myself to do this year (not as a new year
resolution though, I \*really\* want to accomplish this ;-) is to move
my blog from Wordpress to a statically built website. And
[Pelican](http://docs.getpelican.com/en/3.5.0/) looks to be a good
solution to do so. It's based on Python, which is readily available and
supported on Gentoo, and is quite readable. Also, it looks to be very
active in development and support. And also: it supports taking data
from an existing Wordpress installation, so that none of the posts are
lost (with some rounding error that's inherit to such migrations of
course).

Before getting Pelican ready (which is available through Gentoo btw) I
also needed to install [pandoc](http://johnmacfarlane.net/pandoc/), and
that became more troublesome than expected. While installing `pandoc` I
got hit by its massive amount of dependencies towards `dev-haskell/*`
packages, and many of those packages really failed to install. It does
some internal dependency checking and fails, informing me to run
`haskell-updater`. Sadly, multiple re-runs of said command did not
resolve the issue. In fact, it wasn't until I hit a [forum post about
the same
issue](http://forums.gentoo.org/viewtopic-p-7712250.html?sid=7707e62264dadf8bad4b8a1273b19f77)
that a first step to a working solution was found.

It turns out that the `~arch` versions of the haskell packages are
better working. So I enabled `dev-haskell/*` in my
`package.accept_keywords` file. And then started updating the
packages... which also failed. Then I ran `haskell-updater` multiple
times, but that also failed. After a while, I had to run the following
set of commands (in random order) just to get everything to build fine:

    ~# emerge -u $(qlist -IC dev-haskell) --keep-going
    ~# for n in $(qlist -IC dev-haskell); do emerge -u $n; done

It took quite some reruns, but it finally got through. I never thought I
had this much Haskell-related packages installed on my system (89
packages here to be exact), as I never intended to do any Haskell
development since I left the university. Still, I finally got `pandoc`
to work. So, on to the migration of my Wordpress site... I thought.

> This is a good time to ask for stabilization requests (I'll look into
> it myself as well of course) but also to see if you can help out our
> arch testing teams to support the stabilization requests on Gentoo! We
> need you!

I started with the [official docs on
importing](http://docs.getpelican.com/en/latest/importer.html). Looks
promising, but it didn't turn out too well for me. Importing was okay,
but then immediately building the site again resulted in issues about
wrong arguments (file names being interpreted as an argument name or
function when an underscore was used) and interpretation of code inside
the posts. Then I found Jason Antman's [converting wordpress posts to
pelican
markdown](http://blog.jasonantman.com/2014/02/converting-wordpress-posts-to-pelican-markdown/)
post to inform me I had to try using markdown instead of restructured
text. And lo and behold - that's much better.

The first builds look promising. Of all the posts that I made on
Wordpress, only one gives a build failure. The next thing to investigate
is theming, as well as seeing how good the migration goes (it isn't
because there are no errors otherwise that the migration is successful
of course) so that I know how much manual labor I have to take into
consideration when I finally switch (right now, I'm still running
Wordpress).
