Title: Creating a poor man central SCAP system
Date: 2013-09-24 13:35
Category: Free Software
Slug: creating-a-poor-man-central-scap-system

A few weeks ago, I was asked to give some explanation about how SCAP
content can be used in companies to improve their infrastructure
knowledge. The focus back then was to look at benchmarks (secure states)
and violations, but other functionality should not be ignored. I'm not
going to talk about how SCAP can be used in various cases - that'll be
for later - but one of the remarks came how SCAP can be used in larger
environments. The question was not all that weird, as I explained the
functionality through [Open-SCAP](http://www.open-scap.org) which
currently uses a local scanning approach, and for larger environments
you want to have remote scanning capabilities.

There are many commercial products available that provide remote
scanning (so you centrally manage the SCAP content and it is "played"
against remote systems), but as a free software advocate I want to see
how this can be achieved in free software. There is
[spacewalk](http://spacewalk.redhat.com/), the upstream project of the
RedHat Network Sattelite project, but that looked a bit too complex for
"just" handling SCAP content on remote systems. That, and I'm wondering
if it would be that usable for non-RedHat systems.

So I decided to make a quick prototype of how I would approach handling
SCAP content in a larger environment. I pushed the result to a
[github](https://github.com/sjvermeu/pmcs) project, called *poor man
central SCAP*. Or, in abbreviated form, *pmcs*.

The idea is simple: have a central configuration repository that defines
the SCAP content to be played on the remote systems, and have the remote
systems pull this information, evaluating the SCAP content and sending
it to a central reporting repository (which of course can be the same
target where the central configuration is stored). After a few hours of
coding and writing documentation, I have a workable solution with some
nice features.

-   pmcs supports a local-configuration-less approach on the
    target systems. The only thing you need to do is schedule the pmcs
    agent (currently only available as a shell script, but I'll be
    working on a perl or python equivalent soon so that I can support
    other platforms than Unix) with one URL - which is where the
    configuration is stored. No need for local configuration files.
-   pmcs uses local SCAP scanning software (that needs to be available
    on the target platforms) but has no strict requirements to that
    software other than that it has to be triggered command-line. This
    allows us to leverage the existing knowledge and features available
    in tools like open-scap or
    [ovaldi](http://sourceforge.net/projects/ovaldi/) or
    [jOVAL](http://joval.org/).
-   By using a somewhat hierarchical configuration structure and
    keywording support, administrators can fine-tune which SCAP content
    is evaluated on which systems
-   pmcs also supports a "daemonized" approach where administrators can
    ask for the immediate evaluation of some SCAP content. This allows
    admins to quickly obtain system information using OVAL/XCCDF.

For more information, consult the
[README](https://github.com/sjvermeu/pmcs/blob/master/README.md) or
[DESIGN](https://github.com/sjvermeu/pmcs/blob/master/docs/DESIGN.md)
document. I'm working on a [use
case](https://github.com/sjvermeu/pmcs/blob/master/docs/USES.md)
document as well. The tool hardly contains much coding (thanks to the
available KISS tools on many Unix/Linux systems) and is GPL-3.
