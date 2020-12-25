Title: Working on infra strategy
Date: 2020-10-04 13:20
Category: Architecture
Tags: 
Slug: working-on-infra-strategy

After a long hiatus, I'm ready to take up blogging again on my public blog.
With my day job becoming more intensive and my side-job taking the remainder
of the time, I've since quit my work on the Gentoo project. I am in process
of releasing a new edition of the SELinux System Administration book, so I'll
probably discuss that more later.

Today, I want to write about a task I had to do this year as brand new domain
architect for infrastructure.

<!-- PELICAN_END_SUMMARY -->

**Transitioning to domain architect**

While I have been an infrastructure architect for quite some time already, my
focus then was always on specific areas within infrastructure (databases,
scheduling, big data), or on general infrastructure projects or challenges
(infrastructure zoning concept, region-wide disaster recovery analysis and
design). As one of my ex-colleagues and mentors put it, as infrastructure
architects you are allowed to piss on each other's area: you can (and perhaps
should) challenge the vision and projects of others, of course in a
professional way.

I heeded the advice of this person, and was able to get a much better grip on
all our infrastructure services, their designs and challenges. I mentioned
earlier on that my day job became more intensive: it was not just the direct
responsibilities that I had that became more challenging, my principle to learn
and keep track of all infrastructure evolutions were a large part of it as
well. This pays off, as feedback and advice within the architecture review
boards is more to the point, more tied to the situation.

Furthermore, as an architect, I still try to get my hands dirty on everything
bouncing around. When I was focusing on big data, I learned Spark and
pySpark, I revisited my Python knowledge, and used this for specific cases
(like using Python to create reports rather than Excel) to make sure I get a
general feel of what engineers and developers have to work with. When my focus
was on databases, I tried to get acquainted with DBA tasks. When we were
launching our container initiative, I set up and used Kubernetes myself (back
then this was also to see if SELinux is working properly with Kubernetes and
during the installation).

While this does not make me anything near what our engineers and experts are
doing, I feel it gives me enough knowledge to be able to talk and discuss
topics with these colleagues without being that "ivory tower" architect,
and better understand (to a certain level) what they are going through when
new initiatives or solutions are thrown at them.

End of 2019, the company decided that a reorganization was due, not only on
department and directorate level, but also on the IT and Enterprise
Architecture level. One of the areas that improved was to make sure the
infrastructure in general was also covered and supported by the EA team.
Part of that move, two of my infrastructure architect colleagues and
myself joined the EA team. One colleague is appointed to tackle a strategic
theme, another is now domain architect for workplace/workforce,
and I got the task of covering the infrastructure domain. Well, it is called
infrastructure, but focus on the infrastructure related to hosting of
applications and services: cloud hosting, data center, network, compute,
private cloud, container platform, mainframe, integration services,
middleware, etc. Another large part of what I consider "infrastructure" is
part of the workplace domain, which my colleague is pushing forward.

While I was still handing over my previous workload, coaching the new colleague
that got thrown in to make sure both him and the teams involved are not left
with a gap, the various domain enterprise architects got a first task: draft
up the strategy for the domain… and don't wait too long ;-)

**Tackling a domain strategy**

Now, I've drafted infrastructural strategies quite a few times already,
although those have most focus on the technology side. The domain view
goes beyond just the technological means: to be able to have a well-founded
strategy, I also have to tackle the resources and human side of things, the
ability of the organization to deal with (yet another?) transformation, the
processes involved, etc.

Unlike the more specific area focus I had in the past, where the number of
direct stakeholders is limited, the infrastructure domain I now support has
many more direct stakeholders involved. If I count the product managers, system
architects, product owners (yes we are trying the Scaled Agile approach in our
organization) and the managerial roles within the domain, I have 148 people to
involve, spread across 7 Agile Release Trains with different directorate
steering. The consumers of the infrastructure services (which are more part of
business delivery services rather than on IT level) are even much larger than
that, and are the most important ones (but also more difficult) to get in touch
with.

Rather than just asking what the main evolutions are in the several areas of
the domains, I approached this more according to practices I read in books like
"Good Strategy, Bad Strategy" by Richard Rumelt. I started with interviews of
all the stakeholders to get to learn what their challenges and problems are.
I wanted our strategy to tackle the issues at hand, not focus on technological
choices. Based on these interviews, I grouped the issues and challenges to see
what are the primary causes of these issues.

Then I devised what action domains I need to focus on in the strategy. An
action domain was an area that more clearly describes the challenges ahead:
while I had close to 200 challenges observed from the interviews, I can assign
the huge majority of them to one of two action domains: if we tackle these
domains then we are helping the organization in most of their challenges.
After validating that these action domains are indeed covering the needs of
the organization, I started working on the principles how to tackle these
issues.

Within the principles I want to steer the evolution within the infrastructure
domain, without already focusing on the tangible projects to accomplish that.
The principles should map to both larger projects (which I wanted to describe
in the strategy as well) as well as smaller or more continuity-related
projects. I eventually settled with four principles:
  - one principle covering how to transform the environment,
  - one principle covering what we offer (and thus also what we won't be
    offering anymore),
  - one principle which extends our scope with a major area that our internal
    customers are demanding, and
  - one principle describing how we will design our services

Four principles are easy enough to remember for all involved, and if they are
described well, they are steering enough for the organization to take up in
their solutions. But with principles alone the strategy is not tangible enough
for everyone, and many choices to be made are not codified within those
principles. The next step was to draw out the vision for  infrastructure, based
upon current knowledge and the principles above, and show the major areas of
work that lays ahead, as well as give guidance on what these areas should
evolve to.

I settled for eight vision statements, each worked out further with high level
guidance, as well as impact information: how will this impact the organization?
Do we need specific knowledge or other profiles that we miss? Is this a vision
that instills a cultural change (which often implies a slower adoption and the
need for more support)? What are the financial consequences? What will happen
if we do not pursue this vision?

Within each vision, I collaborated with the various system architects and other
stakeholders to draft out epics, changes that support the vision and are ready
to be taken up in the Scaled Agile approach of the organization. The epics that
would be due soon were fully expanded, with a lean business case (attempt) and
phasing. Epics that are scheduled later (the strategy is a 5-year plan) are
mainly paraphrased as expanding those right now provides little value.

While the epics themselves are not fully described in the strategy (the visions
give the rough approach), drafting these out is a way to verify if the vision
statements are feasible and correct, and is a way to check if the organization
understands and supports the vision.

From the moment I got the request to the final draft of the strategy note,
around 2 months have passed. The first draft was slideware and showed the
intentions towards management (who wanted feedback within a few weeks after
the request), after which the strategy was codified in a large document, and
brought for approval on the appropriate boards.

That was only the first hurdle though. Next was to communicate this strategy
further…

**Communication and involvement are key**

The strategic document was almost finalized when COVID-19 struck. The company
moved to working at home, and the way of working changed a lot. This also
impacted how to approach the communication of the strategy and trying to get
involvement of people. Rather than physically explaining the strategy, watching
the body language of the people to see if they understand and support it or
not, I was facing digital meetings where we did not yet have video.
Furthermore, the organization was moving towards a more distributed approach
with smaller teams (higher agility) with fewer means of bringing out
information to larger groups.

I selected a few larger meetings (such as those where all product managers and
system architects are present) to present and discuss the strategy, but also
started making webinars on this so that interested people could get informed
about it. I even decided to have two webinars: a very short one (3 minutes)
which focuses on the principles alone (and quickly summarizes the vision
statements), and an average one (20-ish minutes) which covers the principles
and vision statements.

I also made recordings of the full explanations (e.g. those to management
team), which take 1 hour, but did not move those towards a webinar (due to
time pressure). Of course, I also published the strategy document itself for
everyone, as well as the slides that accompany it.

One of the next steps is to translate the strategy further towards the
specific agile release trains, drafting up specific roadmaps, etc. This will
also allow me to communicate and explain the strategy further. Right now, this
is where we are at - and while I am happy with the strategy content, I do feel
that the communication part received too little attention from myself, and is
something I need to continue to put focus on.

If a strategy is not absorbed by the organization, it fails as a strategy. And
if you do not have sufficient collaboration on the strategy after it was
'finalized' (not just communication but collaboration) then the organization
cannot absorb it. I also understand that the infrastructure strategy isn't
the only one guiding the organization: each domain has a strategy, and
while the domain architects do try to get the strategies aligned (or at least
not contradictory to each other), it is still not a single, company-wide
strategy.

Right now, colleagues are working on consolidating the various strategies on
architectural level, while the agile organization is using the strategies to
formulate their specific solution visions (and for a handful of solutions I'm
also directly involved).

We'll see how it pans out.

So, do you think this is a sensible approach I took? How did you tackle
communication and collaboration of such initiatives during COVID-19 measures? 


