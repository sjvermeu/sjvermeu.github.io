Title: devops - how hard can it/it can be
Date: 2010-09-04 09:17
Category: Free Software
Slug: devops-how-hard-can-itit-can-be

Dieter made a good reference to [devops and the open source
community](http://dieter.plaetinck.be/what_the_open_source_community_can_learn_from_devops)
and (correctly) points out that, even in a more collaborative scene such
as the free software communities', there is still distinction between
development and operations. And it isn't hard to see commonalities
between enterprise organizations and free software communities in that
respect.

But is the comparison correct? If you look at a distribution as an
enterprise, then surely the distinction between upstream (project
development) and "downstream" (distribution) should be compared with the
relations between an enterprise and its ISVs, not its internal
development / operational divisions. If we look at internal divisions,
then distributions tend to provide better integration between (internal)
projects and the distribution. I cannot talk for every distribution, but
in those I do know, the infrastructure team ("operations") has a firm
grip on the infrastructure, yet leaves out sufficient space for
development to do their releases/production activity: uploading files,
changing documentation, ...

This works, if the provided interface does not allow for developers to
harm the principles that infrastructure has. This is what many
(enterprise) organizations are still lacking, but there is no simple
solution for this. Often, the operations team has principles that are
difficult to match with the goals of development. Finding the correct
balance between development and operations in that respect is quite a
challenge - usually, free software communities can get there faster,
often because their mass is sufficiently low. With a total 'employee'
count of a few hundreds it is statistically easier to find a balance
than within enterprises of a few thousand employees.

I believe that both teams should write down their principles, policies
and standards, and see if they can find matches (which is good) and
mutually exclusive distinctions (which is challenging) where more
investigation can be done. Both teams should be allowed to question
decisions made by the other (but without pretending to know better) and
make suggestions. This should lead to the emergence of interfaces where
a team has sufficient freedom to get to their own goals autonomously.

With such interfaces, people will start thinking that devops is growing
apart (after all, they're starting to work autonomously and
independently of each other). That isn't true. In my opinion, devops is
about interacting on a high level (which is less time-delimited) so that
interactions on a low level (which is very time-limited and focused on
releasing, releasing, releasing) aren't necessary. Less interaction
means that the teams that are responsible for getting to a specific,
short time-framed goal, can cooperate closely and have a better grip on
resources and requirements.
