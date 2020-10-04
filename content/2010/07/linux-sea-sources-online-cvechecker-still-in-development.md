Title: Linux Sea sources online, cvechecker still in development
Date: 2010-07-23 20:59
Category: Security
Slug: linux-sea-sources-online-cvechecker-still-in-development

First of all, I've put the sources for [Linux
Sea](http://swift.siphos.be/linux_sea) online at
[GitHub](http://github.com/sjvermeu/Linux-Sea). Not only does that
safeguard any latest changes from not hitting my backup in time before
my laptop dies (it's terminal, but I can't let him go yet ;-) but it
also allows people who want to help with it (or translate it) to pull in
the sources.

Note that it is still not finished (no spelling and grammar check done
yet, still need to add some exercises, etc); once it is, I will tag the
sources appropriately.

On the [cvechecker](http://cvechecker.sf.net) state, it is also still
under development, but progress is going nicely. Most of the work now is
in updating the `versions.dat` file with information on how to obtain
the current version of a package/tool. It is an easy activity - most of
the work is in finding out how CVE entries would label a tool (what
vendor and product name would be chosen) and because I am too lazy, I am
currently only adding those that already have CVE entries assigned to
them (so I can just take a look at the correct values).

It is also my first attempt at using autotools. Quite some overkill for
such a small project, but why not. At least it allows me to try to do
some new things here ;-)
