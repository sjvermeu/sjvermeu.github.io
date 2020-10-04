Title: A bug please...
Date: 2013-09-30 21:53
Category: Gentoo
Tags: bugreport, bugs, bugzilla, Gentoo
Slug: a-bug-please

I know contacting me (or other developers) through IRC is often fast,
but having a bug report on our [bugzilla](https://bugs.gentoo.org) is
very important to me and other developers. Allow me to explain a bit
why.

First of all, *IRC is ephemeral*. If we are not immediately on IRC
noticing it, we might not notice it at all. Even with highlights on IRC
or in a separate `/QUERY` window we might still miss it, because the IRC
client might disconnect (for instance because the server on which we run
our chat client reboots for a kernel update, or because of some weird
issue where we decide quit/restart is better). That doesn't make IRC the
wrong method - it can be perfect to ask for some attention on a bug, and
if you are on IRC while we are tackling it, it is very easy to ask for
some feedback.

A second aspect is about the *completeness of the report*. On a bugzilla
report, you can (well, should) add in the necessary information that
developers need to troubleshoot it. Gentoo supports many setups, so the
output of `emerge --info` and other output that might be requested (like
build logs) are very important. On IRC, a "report" might seem as simple
as "package foo has a circular dependency", but without knowing with
which package the circular dependency is or with which versions, it
might be difficult to deduce. Dependencies can even be USE-driven, so
without knowing what the USE flags are, the circular dependency issue
might not be that obvious. Having a complete bugreport (with the
necessary attachments) makes for a much easier resolution development
lifecycle.

Third, and in my opinion **extremely important**, is that bug reports
are *searchable*. Other users might have the same problem you are
facing. By having a bugreport they can chime in (if the problem has not
been resolved yet), providing faster feedback (for instance, other users
give feedback on additional questions you ask while you are sleeping and
when you are back up the bug is resolved). Or, if the bug has been
resolved (but the change is still in `~arch`) they will find the
solution more easily. And often bugreports also document the workaround
(even if just as a way for the developer to confirm that the issue is
what it is) allowing other users to switch gears faster with the
problem.

Also, the entire communication chain between developer and reporter(s)
also gives a lot of interesting information. Some developers give a
lengthy explanation as to why the issue occurred (which is always useful
to know) or explain in which circumstances it would or wouldn't be
visible. Most developers also link the bug in the commits and ChangeLog
entries so that people who read through the changes can quickly find
more information about the change.

Bugreports also allow for tracking by people who are not on IRC (or
mailinglists) but that do want to help out. For instance, bugs assigned
to the SELinux alias on Gentoo's bugzilla are followed up by a handful
of non-developers who often give feedback much faster than I or another
developer can. If this would be reported on IRC only, you would miss the
opportunity to work with these excellent people (and thus get a faster
resolution).

Another advantage of bugreports is that dependencies between bugs can be
placed. A bug might only be resolved if another bug is resolved as well
- this dependency information is made part of bug reports to give a
clear view on the situation.

Bug reports on a bugzilla (or other bug tracking software) have other
advantages as well, but the above ones are my top reasons. So while I
don't mind if I can quickly fix things I notice on IRC (such as a
missing dependency), if you want to make sure I catch it, please use
bugzilla.
