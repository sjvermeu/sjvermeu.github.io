Title: "Gentoo in production?" Oh no, not again...
Date: 2011-01-21 21:59
Category: Gentoo
Slug: gentoo-in-production-oh-no-not-again

I think it is that time of the year again, where people get some crazy
ideas. Again I discussed the what must be the gazillion-th time I've
been asked "Do you think Gentoo is ripe for use in production?".
Honestly, I always tell myself to ignore those discussions but I've
never managed to actually do that - ignore, that is. So to give me some
leverage the gazillion-th plus one time I get that same question, let me
vent my opinion about the subject right here and allow me to hurdle the
permalink to whomever tries to start another heated discussion.

**Your question is wrong**. It is never about a technology being "ripe
enough" or "stable enough". What you need to ask yourself (or get
acquainted with) is what you, your organization or your company expects
from a technology to be introduced in your (organization/company)
infrastructure. This includes, but is not limited to:

-   What kind of *bugfixing* and *security fixing* support do you want
    for the technology?
-   What kind of *knowledge support* do you want for the technology?
-   How important is *certification* of (other) technologies with
    respect to the technology or operating system?
-   How far do you implement an operating systems' *release cycle*?
-   What level of experience do you expect from your *internal support
    team* (or yourself)?

As you can see, the questions are not about technology itself or pretty
features. It is about how you work with that technology. And one
shouldn't look at these questions as having a single phrase as answer.
To properly answer the first question alone, you'll need to take a look
at delivery times (how fast do you want a bug to be fixed), follow-up
(how fast does the technology issue security announcements, do they
follow CVE closely, ...), responsibilities, eventual legal or
contractual obligations you might need to cover your \_\_\_, the ability
of the provider to reproduce issues etc.

Internal experience is also not to be underestimated. How quick do you
(organization/company) want to be able to resolve problems? How
experienced are you with analyzing logs? How well are you able to
integrate a technology within your existing architecture? What auditing
does you(r organization/company) require and do you know how to get that
from the technology?

I mean, come on, you're talking about "production". That's not the same
as saying "I've installed it for my parents".
