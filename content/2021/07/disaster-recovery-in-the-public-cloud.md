Title: Disaster recovery in the public cloud
Date: 2021-07-30 20:00
Category: Architecture
Tags: architecture,cloud,DRP
Slug: disaster-recovery-in-the-public-cloud
Status: published

The public cloud is a different beast than an on-premise environment, and that
also reflects itself on how we (should) look at the processes that are
actively steering infrastructure designs and architecture. One of these
is the business continuity, severe incident handling, and the
hopefully-never-to-occur disaster recovery. When building up procedures
for handling disasters ([DRP = Disaster Recovery Procedure or Disaster 
Recover Planning](https://en.wikipedia.org/wiki/Disaster_recovery)),
it is important to keep in mind what these are about.

<!-- PELICAN_END_SUMMARY -->

**What is a disaster**

Disasters are major incidents that have wide-ranging consequences to the
regular operations of the business. What entails a disaster can be different
between organizations, although they are commonly tied to the size of the
infrastructure and the organizational and infrastructural maturity. I'll get
back to the size dependency later when covering public cloud.

A small organization that only has a few systems can declare a
disaster when all those systems are unreachable because their network
provider's line is interrupted. A larger organization probably has
redundancy of the network in place to mitigate that threat. And even
without the redundancy, organizations might just not depend that much
on those services.

The larger the environment becomes though, the more the business depends
on the well-being of the services. And while I can only hope that high
availability, resiliency and appropriate redundancy are taken into account
as well, there are always threats that could jeopardize the availability
of services.

When the problem at hand is specific to one or a manageable set of services,
then taking appropriate action to remediate that threat is generally not a
disaster. It can be a severe incident, but in general it is taken up
by the organization as an incident with a sufficiently small yet
efficient and well organized coordination: the teams involved are 
low in numbers, and the coordination can be done accurately.

However, when the problem is significant or has a very wide scope, then
depending on the standard incident coordination will be insufficient. You
need to coordinate across too many teams, make sure communication is done
correctly, business is continuously involved/consulted, and most of all - 
you want to make sure that the organization doesn't independently try
to resolve issues when they don't have a full view on the situation
themselves.

The latter is a major reason in my opinion why a DRP is so important
to have (the plan/procedure, not an actual disaster). If there is no
proper, well-aligned plan of action, teams will try to get in touch
with other teams, polluting communication and only getting incomplete
information. They might take action that other teams should know about
(but won't) or are heavily impacted by (e.g. because they are at that
time trying to do activities themselves). It can make the situation
much worse.

Because we have to make a distinction between incident management
and disaster management, an organization has to formally declare
a problem as a disaster, and communicate that singular fact ("we
are now in disaster mode") so that all teams know how to respond: 
according to the Disaster Recovery Plan (DRP).

**Disasters are not just 'force majeure'**

Disasters aren't extraordinary events or circumstances beyond the
control of the organization. Depending on the business needs, you
might very well take precautionary actions against situations you've
never encountered before and will never encounter. We've recently had
a disastrous weather in Belgium (and other countries in Western Europe)
with floods happening in large areas. But that doesn't mean that
for an organization a flood event will trigger a disaster declaration
within a company (the disastrous weather was a disaster from a
human side, with several dozen deaths and millions of damage, so it
feels somewhat incorrect to consider the threat from a theoretical
standpoint here).

If you're located in a flood-sensitive environment, you can still take
precautionary actions and assess what to do in case of a flood event. 
Depending on the actions taken, a flood event (threat) will not manifest
into availability concerns, data and infrastructure destruction, people
unavailability, etc. It is only when the threat itself turns into an
unforeseen (or non-remediated) situation that we speak of a disaster.

This is why disasters depend on organizations, and how risk averse
the organization (and business) is. Some businesses might not want to
take precautionary actions against situations that in the past only
occur once every 100 years, especially if the investment they would
have to do is too significant compared to the losses they might have.

Common disaster threats (sometimes also called catastrophic events)
that I'm used to evaluate from an infrastructure point of view, with a
company that has four strategic data centers, multiple headquarter
locations and a high risk averse setting (considering the financial
market it plays in) are cyberattacks, local but significant infrastructure
disruptions (data center failures or destruction), people-oriented
threats (targetting key personnel), critical provider outages,
disgruntled employees, and so forth. Searching for risk matrices
online can give you some interesting pointers, such as the European
Commission's [Overview of Natural and Man-made Disaster Risks the
European Union may
face](https://ec.europa.eu/echo/sites/default/files/swd_2017_176_overview_of_risks_2.pdf).

**Public cloud related events**

In case of public cloud, the catastrophic events that might occur are
different, and it would be wrong to just consider the same events and
with the same action plan. A prime example, and the one I really want
people to focus on, is regional outages.

If your current company considers region-wide failures (for
instance because you have two data centers but within the same
region) more from a reactive point of view rather than preventive
(e.g. the DRP in case of region-wide failures is to approach
the reconstruction within the region whenever possible, rather
than fail over to a different region), it might feel the same about
public cloud region failures.

That would be wrong though. Whereas it is likely that a region-wide
failure for a company is not going to happen in its lifetime, a public
cloud provider is so much more massive in size, that the likelihood
of region-wide failures is higher. If you do a quick search for
region-wide failures in AWS or Azure, you'll find plenty of examples.
And while the failures themselves might be considered 'incidents' from
the public cloud provider point of view, they might be disasters for
the companies/customers that rely on them.

For me, tackling disaster recovery when dealing with public cloud strongly
focuses on region failures and (coordinated) recovery from region failures.
Beyond region failures, I also strongly recommend to look into the dependencies
that the public cloud consumption has with services outside of the public cloud.
Some of these dependencies might also play a role in certain catastrophic
events. Say that you depend on Azure AD for your authentication and
authorization, and Microsoft is suddenly facing not just a world-wide
Azure AD outage, but also has to explain to you that they cannot restore its
data.

Preparing for disasters is about preparing for multiple possible catastrophic
events, and in case of public cloud, you're required to think at massive scales.
And that includes designing for region-wide failures as well.

**Impact of public cloud disasters to the organization**

Generally, if your organization has a decent maturity in dealing with disaster
recovery planning, they will be using Service Level Agreements with the
business to help decide what to do in case of disasters. Important
non-functionals that are included here are RTO (Recovery Time Objective), RPO
(Recovery Point Objective), and MTD (Maximum Tolerable Downtime). There are
others possibly listed in the SLA as well, but let me focus on these three.
If you want to learn more about contigency planning in general, I recommend
to go through the [NIST Special Publication 800-34 Rev.1, "Contingency Planning
Guide for Federal Informatino
Systems"](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-34r1.pdf).

With the RTO, we represent the time it is allowed to take to recover a service
to the point that it functions again. This might include with reduced capacity
or performance degradation. The RTO can be expressed in hours, days, weeks
or other arbitrary value. It is a disaster-oriented value, not availability!
As long as no disaster is declared, the RTO is not considered.

The RPO identifies how much data loss is acceptable by the business in case of
a disaster. Again, this is disaster-oriented: the business can very well take
extra-ordinary steps to ensure full transactional consistency outside of 
disaster situations, yet allow for a "previous day" RPO in case of a disaster.

The MTD is most often declared not on a single service, but at business service
level, and explains how long unavailability of that service is tolerated before
it seriously impacts the survivability of the business. It is related to the
RTO, as most services will have an RTO that is more strict/lower value than the
overall MTD, whereas the MTD is near non-negotiable.

Now, what does public cloud disasters have to do with this? Well, in theory
nothing, as this model and process of capturing business requirements is quite
sensible and maps out perfectly as well. However (and here's the culprit),
an organization that sets up new services on a frequent basis might get
accustomed to certain values, and these values might not be as easy to approach
in a public cloud environment. Furthermore, the organization might not be
accustomed to different disaster scenario's for the SLA: having different sets
of RTO/RPO depending on the category of disaster.

Let's get back to the region-wide disasters. A company might have decided not
to have region-wide proactive measures in place, and fixate their SLA
non-functionals on local disasters: a data center failure is considered a threat
that still requires proactive measures, whereas regional failures are treated
differently.  The organization decides to only have one SLA set defined, and
includes RTO and RPO values based on the current, local threat matrix. They
might decide that a majority of applications or services has a RPO of "last
transaction", meaning the data has to be fully restored at the latest situation
in case of a disaster.

This generally implies synchronous replication as an infrastructural
solution. If the organization is used to having this method available (for
instance through SAN replication, cluster technologies, database recovery,
etc.) then they won't sweat at all if the next dozen services all require
the same RPO.

But now comes the public cloud, and a strong point of attention is region-wide
failures. Doing synchronous replication across regions is not a proper tactic
(as it implies significant performance degradation) and especially not sensible
to do at the same scale as with local replication (e.g. between availability
zones in the same region). Now you have to tell your business that this RPO
value is not easily attainable in the public cloud. The public cloud, which
solves all the wonders in the world. The public cloud, which has more maturity
on operations than your own company. Yet you can't deliver the same SLA?

Apples and pears. The disasters are different, so your offering might be
different. Of course, you should explain that your 'on premise' disaster
scenarios do not include region-wide failures, and that if you include
the same scenarios for 'on premise' that that RPO value would not be
attainable on premise either.

**Conclusions**

The public cloud provides many capabilities, and has to deal with a
significantly larger environment than companies are used to. This also means
that disasters that are considered 'extremely unlikely' are now 'likely' (given
the massive scale of the public cloud), and that the threats you have to
consider while dealing with disaster recovery have to be re-visited for public
cloud enabled scenarios.

My recommendation is to tackle the disaster-oriented non-functional requirements
by categorizing the disasters and having different requirements based on the
disaster at hand. Mature your cloud endeavours so that regional outages
are not a problem anymore (moving them away from the 'disaster' board), and 
properly map all dependencies you have through the public cloud exercises so
that you can build up a good view on what possible threats exist that would
require a well-coordinated approach to tackle the event.

