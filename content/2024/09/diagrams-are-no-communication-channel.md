Title: Diagrams are no communication channel
Date: 2024-09-05 22:00
Category: Architecture
Tags: architecture
Slug: diagrams-are-no-communication-channel
Status: published

IT architects generally use architecture-specific languages or modeling
techniques to document their thoughts and designs. [ArchiMate](https://www.opengroup.org/archimate-forum/archimate-overview),
the framework I have the most experience with, is a specialized enterprise
architecture modeling language. It is maintained by The Open Group, an organization
known for its broad architecture framework titled TOGAF.

My stance, however, is that architects should not use the diagrams from their
architecture modeling framework to convey their message to every stakeholder
out there...

<!-- PELICAN_END_SUMMARY -->

**An enterprise framework for architects**

Certainly, using a single modeling language like ArchiMate is important.
It allows architects to use a common language, a common framework,
in which they can convey their ideas and designs. When collaborating on
the same project, it would be unwise to use different modeling techniques
or design frameworks among each other.

By standardizing on a single framework *for a particular purpose*, a company
can optimize their efforts surrounding education and documentation. If several 
architecture frameworks are used for the same purpose, inefficiencies arise.
Supporting tooling can also be selected (such as 
[Archi](https://www.archimatetool.com/)), which has specialized features to support
this framework.  The more architects are fluent in a common framework, the less
likely ambiguity or misunderstandings occur about what certain architectures or
designs want to present.

Now, I highlighted "*for a particular purpose*", because that architecture
framework isn't the goal, it's a means.

**Domain-specific language, also in architecture**

In larger companies, you'll find architects with different specializations
and focus areas. A common set is to have architects at different levels
or layers of the architecture:

- enterprise architects focus on the holistic and strategic level, 
- domain architects manage the architecture for one or more domains (a means of splitting the complexity
of a company, often tied to business domains), 
- solution or system architects focus on the architecture for specific projects or solutions, 
- security architects concentrate on the cyber threats and protection measures, 
- network architects look at the network design, flows and flow controls,
etc.

Architecture frameworks are often not meant to support all levels. ArchiMate
for instance, is tailored to enterprise and domain level in general. It also
supports solution or system architecture well when it focuses
on applications. Sure, other architecture layers can be expressed as well, but
after a while, you'll notice that the expressivity of the framework lacks the
details or specifics needed for those layers.

It is thus not uncommon that, at a certain point, architects drop one framework 
and start using another. Network architecture and design is expressed differently
than the ICT domain architecture. Both need to 'plug into each other',
because network architects need to understand the larger picture they operate
in, and domain architects should be able to read network architecture design
and relate it back to the domain architecture.

Such a transition is not only within IT. Consider city planning and
housing units, where architects design new community areas and housing.
These designs need to be well understood by the architects, who are
responsible for specific specializations such as utilities, transportation,
interior, landscaping, and more. They use different ways of designing, but
make sure it is understandable (and often even standardized) by the others.

**Your schematic is not your presentation**

I've seen architects who are very satisfied with their architectural
design: they want nothing more than to share this with their
(non-architect) stakeholders in all its glory. And while I do agree that lead
engineers, for instance, should be able to understand architecture drawings, the
schematics themselves shouldn't be the presentation material.

And definitely not towards higher management.

When you want to bring a design to a broader community, or to stakeholders
with different backgrounds or roles, it is important to tell your story
in an easy-to-understand way. Just like building architects would create
physical mock-ups at scale to give a better view of a building, IT
architects should create representative material to expedite
presentations and discussions.

Certainly, you will lose a lot of insight compared to the architectural
drawings, but you'll get much better acceptance by the community.


