Title: Sometimes I forget how important communication is
Date: 2014-12-10 20:38
Category: Gentoo
Tags: communication, developer, Gentoo, selinux, time
Slug: sometimes-i-forget-how-important-communication-is

Free software (and documentation) developers don't always have all the
time they want. Instead, they grab whatever time they have to do what
they believe is the most productive - be it documentation editing,
programming, updating ebuilds, SELinux policy improvements and what not.
But they often don't take the time to communicate. And communication is
important.

For one, communication is needed to reach a larger audience than those
that follow the commit history in whatever repository work is being
done. Yes, there are developers that follow [each
commit](http://news.gmane.org/gmane.linux.gentoo.cvs), but development
isn't just done for developers, it is also for end users. And end users
deserve frequent updates and feedback. Be it through blog posts, Google+
posts, tweets or instragrams (well, I'm not sure how to communicate a
software or documentation change through Instagram, but I'm sure people
find lots of creative ways to do so), telling the broader world what has
changed is important.

Perhaps a (silent or not) user was waiting for this change. Perhaps he
or she is even actually trying to fix things himself/herself but is
struggling with it, and would really benefit (time-wise) from a quick
fix. Without communicating about the change, (s)he does not know that no
further attempts are needed, actually reducing the efficiency in
overall.

But communication is just one-way. Better is to get feedback as well. In
that sense, communication is just one part of the feedback loop - once
developers receive feedback on what they are doing (or did recently)
they might even improve results faster. With feedback loops, the wisdom
of the crowd (in the positive sense) can be used to improve solutions
beyond what the developer originally intended. And even a simple "cool"
and "I like" is good information for a developer or contributor.

Still, I often forget to do it - or don't have the time to focus on
communication. And that's bad. So, let me quickly state what things I
forgot to communicate more broadly about:

-   A [new
    developer](http://comments.gmane.org/gmane.linux.gentoo.project/4129)
    joined the Gentoo ranks: Jason Zaman. Now developers join Gentoo
    more often than just once in a while, but Jason is one of
    my "recruits". In a sense, he became a developer because I was tired
    of pulling his changes in and proxy-committing stuff. Of course,
    that's only half the truth; he is also a very active contributor in
    other areas (and was already a maintainer for a few packages through
    the proxy-maintainer project) and is a tremendous help in the Gentoo
    Hardened project. So welcome onboard Jason (or perfinion as he calls
    himself online).
-   I've started with [copying the Gentoo handbook to the
    wiki](https://wiki.gentoo.org/wiki/Project:Documentation/HandbookDevelopment).
    This is still an on-going project, but was long overdue. There are
    many reasons why the move to the wiki is interesting. For me
    personally, it is to attract a larger audience to update
    the handbook. Although the document will be restricted for editing
    by developers and trusted contributors only (it does contain the
    installation instructions and is a primary entry point for
    many users) that's still a whole lot more than when just a handful
    (one or two actually) developers update the handbook.
-   The [SELinux
    userspace](https://github.com/SELinuxProject/selinux/wiki/Releases)
    (2.4 release) is looking more stable; there are no specific
    regressions anymore (upstream is at release candidate 7) although I
    must admit that I have not implemented it on the majority of test
    systems that I maintain. Not due to fears, but mostly because I
    struggle a bit with available time so I can do without testing
    upgrades that are not needed. I do plan on moving towards 2.4 in a
    week or two.
-   The [reference
    policy](https://github.com/TresysTechnology/refpolicy/wiki) has
    released a new version of the policy. Gentoo quickly followed
    through (Jason did the honors of creating the ebuilds).

So, apologies for not communicating sooner, and I promise I'll try to
uplift the communication frequency.
