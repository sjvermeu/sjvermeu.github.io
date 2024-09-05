Title: Diagrams are no communication channel
Date: 2024-09-05 22:00
Category: Architecture
Tags: architecture
Slug: diagrams-are-no-communication-channel
Status: draft

IT architects generally use architecture-specific languages or modeling
techniques to document their thoughts and designs. One of these is [ArchiMate](https://www.opengroup.org/archimate-forum/archimate-overview),
 an enterprise architecture modeling language by The Open Group. However,
architects should not use the diagrams from this language as a means
to convey their message to each and every stakeholder out there...

**An enterprise framework for architects**

Certainly, using a single modeling language like ArchiMate is important
as it allows for architects to use a common language, a common framework,
in which they can convey their ideas and designs. When collaborating on
the same project, it would be unwise to use different modeling techniques
or design frameworks between each other.

By standardizing on a single framework *for a particular purpose*, a company
can also focus attention on education and documentation aligned with this
framework. Supporting tooling can also be selected (such as
[Archi](https://www.archimatetool.com/)).  The more architects are fluent in a
common framework, the less likely ambiguity or misunderstandings occur about
what certain architectures or designs want to present.

Now, I highlighted "*for a particular purpose*", because that architecture
framework isn't the goal, it's a means.

**Domain specific language, also in architecture**

In larger companies, you'll find architects with different specializations
and different focus areas. A common set is to have enterprise architects
focusing on the holistic and strategic level, domain architects managing
the architecture for one or more domains (a means of splitting the complexity
of a company, often tied to business domains), solution or system architects
focusing on the architecture for specific projects or solutions, security
architects focusing on the cyber threats and protection measures, network
architects look at the network design, flows and flow controls, etc.

Architecture frameworks are often not meant to support all levels. ArchiMate
for instance is tailored to enterprise and domain level in general,
and with support for solution or system architecture mostly when it focuses
on applications. Sure, others can be expressed as well, but after a while
you'll notice that the expressivity of the framework lacks the details
or specifics.

It is thus not uncommon that, at a certain point, one framework is dropped
and another is used. It is not uncommon to have network architecture and
design expressed differently than the ICT domain architecture. However,
both need to 'plug into each other', because network architects need to
understand in which larger picture they operate, and domain architects
should be able to read network architecture design and relate it back
to the domain architecture.

Such a transition is not only within IT. Consider city planning and
housing units, where architects design new community areas and housing.
These designs need to be well understood by the architects that are
responsible for specific specializations such as utilities, transportation,
interior, landscaping, and more. Yet they use different ways of architecting
and designing, but make sure it is understandable (and often even
standardized) amongst each other.

**Your schematic is not your presentation**

I've seen architects who are very satisfied with their architectural
design, and want nothing more than to share this with their
(non-architect) stakeholders. And while I do agree that lead engineers
for instance should be able to understand architecture drawings (as it
would be a reference when focusing on the low-level design and technical
implementations), the schematics themselves shouldn't be the presentation
material itself.

And definitely not towards higher management.

When you want to bring a design to a broader community, or to stakeholders
with different backgrounds or roles, it is important to tell your story
in an easy to understand method. Just like building architects would create
physical mock-ups at scale to give a better view on a building, IT
architects should create representative material to facilitate
presentations and discussions.

Certainly, you will lose a lot of insights compared to the architectural
drawings, but you'll get much better acceptance by the community.


<!-- PELICAN_END_SUMMARY -->
