Title: Python 3 support for SELinux userland, tests and policy rev 10
Date: 2012-05-26 18:59
Category: Gentoo
Slug: python-3-support-for-selinux-userland-tests-and-policy-rev-10

In the last few hours I pushed my local changes on the SELinux userland
utilities towards the
[hardened-development](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-dev.git;a=tree)
overlay. The utilities not only include some bugfixes, but have now also
seen a first set of tests towards Python 3.2. In the past, I've made a
few attempts at making the tools support Python 3, but I failed
miserably. Although chances are still high that I failed, at least I got
quite a bit further.

To make testing a bit easier, I previously made quite a few scripts that
did all sorts of things, in order to catch regressions. However, along
the way, I've started noticing I had to put lots of effort in
streamlining these tests (cleanups), introducing dependency information
(test A before B, or cleanup before test, ...) and parallellism (after
all, if you have many, many tests, lots of cores but run in
single-thread/process mode, it'll take a while). So I started looking at
a good way to handle this for me. I switched my tests into a
Makefile-driven approach.

Why Makefiles? Well, first of all, Makefiles support *dependencies*. You
can define a target and then say which other targets need to be ran
first before this target can run. If you want to support these
dependencies in a run-independent manner, you can use trigger files but
I'm not going to do that yet. Another simple feature is that you can
tell make to not show output (*silent mode*) when not necessary. And of
course, with make, you can execute targets *concurrently*. By using a
simple, yet manageable directory structure and traverse the Makefiles in
them, I am able to easily add more tests and add them to the runqueue.

But I'd like to hear from you what infrastructural testing tools you use
because I can imagine Makefiles aren't the best solution here.

In the mean time, I also pushed the 10th revision of our SELinux
policies to the hardened-dev overlay. The most notable fix in it is to
improve support for those running \~arch systems (some fix on the
kdevtmpfs support).
