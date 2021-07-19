Title: What is the infrastructure domain?
Date: 2021-07-14 18:30
Category: Architecture
Tags: architecture,pattern
Slug: what-is-the-infrastructure-domain
Status: draft

In my job as domain architect for "infrastructure", I often come across
stakeholders that have no common understanding of what infrastructure means in
an enterprise architecture. Since then, I am trying to figure out a way to
easily explain it - to find a common, generic view on what infrastructure
entails. If successful, I could use this common view to provide context on the
many, many IT projects that are going around.

Of course, I do not want to approach this solely from my own viewpoint. There
are plenty of reference architectures and frameworks out there that could assist
in this. However, I still have the feeling that they are either too complex to
use for non-architect stakeholders, too simple to expose the domain properly, or
just don't fit the situation that I am currently faced with. And that's OK,
many of these frameworks are intended for architects, and from those frameworks
I can borrow insights left and right to use for a simple visualization, a
landscaping of some sort.

So, let's first look at the frameworks and references out there. Some remarks
though that might be important to understand the post:

- When I use "the infrastructure domain", I reflect on how I see it. Within the
  company that I work for, there is some guidance on what the scope is of the
  infratructure domain, and that of course strongly influences how I look at
  "the infrastructure domain". But keep in mind that this is still somewhat
  organization- or company oriented. YMMV.
- While I am lucky enough to have received the time and opportunity to learn
  about enterprise architecture and architecture frameworks (and even got a
  masters degree for it), I also learned that I know nothing. Enterprises are
  complex, enterprise architecture is not a single framework or approach, and
  the enterprise architecture landscape is continuously evolving. So it is very
  well possible that I am missing something (and I will gladly learn from
  feedback on this).

**The Open Group Architecture Framework (TOGAF)**

If you would ask for one common framework out there for enterprise architecture,
then [TOGAF](https://pubs.opengroup.org/architecture/togaf9-doc/arch/) is
probably it. It is a very exhaustive framework that focuses on various aspects
of enterprise architecture: the architecture development methodology, techniques
to use, the content of an architecture view (like metamodel descriptions), and the
capabilities that a mature organization should pursue.

A core part of TOGAF is the *Architecture Development Method* cycle, which has
several phases, including phases that are close to the infrastructure domain:
"Technology Architecture (D)" as well as areas of "Opportunities and Solutions
(E)" and "Information Systems Architectures (C)". Infrastructure is more than
'just' technology, but the core of it does fit within the technology part.

![TOGAF Cycle]({static}/images/202107/togaf-adm-cycle.png)
*The ADM cycle, taken from [The Open Group, TOGAF 9.2, Chapter 4](https://pubs.opengroup.org/architecture/togaf9-doc/arch/chap04.html)*

With TOGAF, you can support a full enterprise architecture view from the
strategy and vision up to the smallest change and its governance. However, the
key word here is *support*, as TOGAF will not really give you much food for
simply representing the scope of infrastructure.

I'm not saying it isn't a good framework, on the contrary. Especially with
[ArchiMate](http://www.opengroup.org/archimate-forum) as modeling language (also
from The Open Group), using TOGAF and its meta model is a good way to facilitate
a mature architecture practice and enterprise-wide view within the
organization. But just like how application architecture and design requires a
bit more muscle than [TOGAF's
metamodel](https://pubs.opengroup.org/architecture/togaf9-doc/arch/chap30.html)
supports, the same is true for infrastructure.

There are also plenty of other enterprise frameworks out there that can easily
be mapped to TOGAF. Most of these focus mainly on the layering (business,
information, application, technology), processes (requirement management and the
like) and viewpoints (how to visualize certain insights) and, if you're fluent
in TOGAF, you can easily understand these other frameworks as well. I will not
be going through those in detail, but I also do not want to insinuate that they
are not valid anymore if you compare them with TOGAF: TOGAF is very extensive
and has a huge market adoption, but sometimes an extensive and exhaustive
framework isn't what a company needs...

**TOGAF Technical Reference Model / Integrated Information Infrastructure
Reference Model**

As TOGAF is extremely extensive, it has parts that can be used to reference or
visualize infrastructure a bit better. In TOGAF 9.1, we had the *TOGAF Technical
Reference Model (TRM)* and *TOGAF Integrated Information Infrastructure
Reference Model (III-RM)* where you might feel that this is closer to what I
am seeking (for instance,
[III-RM](https://pubs.opengroup.org/architecture/togaf91-doc/arch/chap44.html)).

![TOGAF III-RM]({static}/images/202107/togaf-iii-rm.png)
*Focus of the III-RM, taken from [The Open Group, TOGAF 9.1, Chapter 44](https://pubs.opengroup.org/architecture/togaf91-doc/arch/chap44.html)*

While it does become a bit more tangible, TOGAF does not expand much on this
reference model. Instead, it is more meant as a starting point for organizations
to develop their own reference models.

**Information Technology Infrastructure Library (ITIL)**

[ITIL 4](https://www.axelos.com/best-practice-solutions/itil) is another very
common framework, this time owned by AXELOS Limited. The focus of ITIL is on
process support, with many processes (sorry,
'[practices](https://wiki.en.it-processmaps.com/index.php/ITIL_4)' as they are
called now) being very much close to what I consider to be part of the
infrastructure domain. The practices give a good overview of 'what things to
think about' when dealing with the infrastructure domain. Now, ITIL is not
exclusive to the infrastructure domain, and the company that I work for
currently considers many of these practices as processes that need to be tackled
across all domains.

![ITIL Practices]({static}/images/202107/itil-practices.jpg)
*ITIL 4 Practices, taken from [Value Insights, The ITIL 4 Practices Overview](https://valueinsights.ch/-the-itil-4-practices-overview/)*

Still, I do want to see some of the ITIL practices reflected in the generic
infrastructure view as they are often influencing the infrastructure domain and
the projects within. The ITIL practices make it possible to explain that it
isn't just about downloading and installing software or quickly buying an
appliance.

**Reference Model of Open Distributed Processing (RM-ODP)**

The [RM-ODP standard](http://www.rm-odp.net/) has a strong focus on distributed
processing (hence the name), which is a big part of what the infrastructure
domain is about. If we ignore the workplace environment for a bit, and focus on
hosting of applications, the majority of today's hosting initiatives are on
distributed platforms.

![RM-ODP Five Viewpoints]({static}/images/202107/rm-odp.png)
*Five viewpoints of RM-ODP, taken from [MDG Technology for ODP - UML for ODP, SparxSystems](https://sparxsystems.com/products/3rdparty/odp/index.html)*

Within RM-ODP guidance is given on how to handle requirement management, how to
document the processing semantics, how to identify the components, integrations
and limitations of the systems, and how to select the most appropriate
technology. The intention of RM-ODP is to be as precise and formal as possible,
and leave no room for interpretation. To accomplish that, RM-ODP uses an object
model approach.

Unlike the more business and information system oriented frameworks, RM-ODP has
a strong focus on infrastructure. Its viewpoints include engineering,
computational and technology for instance. The challenge that rises here
however is that it sticks to the more engineering oriented abstractions, which
make perfect sense for people and stakeholders involved in the infrastructure
domain, but is often Chinese for others.

Personally, I consider RM-ODP to be a domain-specific standard strongly
associated with the infrastructure domain.

**Department of Defense Architecture Framework (DoDAF)**

[DoDAF](https://dodcio.defense.gov/library/dod-architecture-framework/)
 is an architecture framework that has a strong focus on the definition
and visualization of the different viewpoints. It is less tangible than RM-ODP,
instead focusing on view definitions: what and how should something be
presented to the stakeholders. The intention of DoDAF is that organizations
develop and use an enterprise architecture that supports and uses the
viewpoints that DoDAF prescribes.

![DoDAF viewpoints]({static}/images/202107/dodaf-viewpoints.png)
*DoDAF viewpoints, taken from ["What is DoDAF Framework", Visual Paradigm](https://www.visual-paradigm.com/guide/enterprise-architecture/what-is-dodaf-framework/)*

Unlike broad scale architecture frameworks that look at an enterprise in its
entirety, my impression is that DoDAF is more towards product architecture.
That makes DoDAF more interesting for solution architectures, which often
require to be more detailed and thus hit closer to home when looking at the
infrastructure domain. However, it is not something I can 'borrow' from to
easily explain what infrastructure is about.

[NATO's Architecture Framework (NAF)](https://www.nato.int/cps/en/natohq/topics_157575.htm)
seems to play witin the same realm.

**Sherwood Applied Business Security Architecture (SABSA)**

The SABSA framework and methodology has a strong security focus, but covers the
requirements from full enterprise view up to the solutions themselves. One of
the benefits of SABSA is inherent to this security-orientation: you really need
to know and understand how things work before you can show that they are
secure. Hence, SABSA is a quite complete framework and methodology.

![SABSA Metamodel]({static}/images/202107/sabsa-metamodel.png)
*SABSA metamodel, taken from ["A Brief History of SABSA: Part 1", sabsa.org](https://sabsa.org/the-chief-architects-blog-a-brief-history-of-sabsa-21-years-old-this-year/)*

An important focus area in SABSA is the integration between services, which is
something I am frequently confronted with at work. Yet unlike the more solution
driven frameworks, SABSA retains its business-oriented top-down approach, which
places it alongside the TOGAF one in my opinion. Moreover, we can apply TOGAF's
development method while using SABSA to receive more direct requirements and
design focus.

Its risk and enabler orientation offers a help to not only explain how things
are set up, but also why. Especially in the sector I am currently active in
(financial sector) having a risk-based, security-conscious approach is a good
fit. The supporting list of attributes, metrics, security services, etc. allow
for defining more complete architectures.

**Control Objectives for IT (CObIT)**
 
In a similar area as ITIL, the [CObIT
framework](https://www.isaca.org/resources/cobit) focuses less on a complete
enterprise architecture framework and more on processes, process maturity, and
alignment of the processes within the organization. I am personally a fan of
CObIT as it is a more tangible framework, with more clear deliverables and
requirements, compared to others. But like with most frameworks, it has
received numerous updates to fit in continuously growing environments and
cultures which makes it heavy to use.

![CObIT Core Model]({static}/images/202107/cobit-core-model.jpg)
*The CObIT 2019 Core Model, taken from "[Using CObIT 2019 to plan and execute
an organization transformation strategy,
ISACA.org](https://www.isaca.org/resources/news-and-trends/industry-news/2020/using-cobit-2019-to-plan-and-execute-an-organization-transformation-strategy)"*

The framework is less about the content of infrastructure and technology, and
more about how to assess, develop, build, maintain, operate and control
whatever service is taken up. However, there are references to infrastructure
(especially when dealing with non-functionals) or controls that are actively
situated in infrastructure (such as backup/restore, disaster recovery, etc.)

**IT for IT (IT4IT)**

The Open Group has a similar framework like CObIT, called
[IT4IT](https://www.opengroup.org/it4it). It does have a reference architecture
view that attempts to group certain deliverables/services together to create a
holistic view on what IT should offer. But unlike the larger enterprise
frameworks it focuses strongly on service delivery and its dependencies.

![IT4IT Reference Architecture]({static}/images/202107/it4it-reference-architecture.png)
*IT4IT Reference Architecture, taken from [The Open Group IT4IT
Forum](https://www.opengroup.org/it4it-forum)*

Within the IT4IT reference architecture, a grouping is attempted that maps on a
value stream, starting from a strategy over the deployment up to the detection
and correction facilities. This value stream orientation is common across
frameworks, but often feels like the value is always to "add more", "deliver
more". In my opinion, rationalization exercises, decommissioning and
custodianship is too much hidden. Sure, it is part of the change management
processes and operational maintenance, but those are extremely valuable areas
that are not expressively visible in these frameworks. Compare that to the
attention that risk and security receives: while security consciousness should
be included at all phases of the value stream, security is always explicitly
mentioned.

**Vendor-specific visualizations**

Several vendors have their own visualization methodology that represents more
specific requirements from the domain(s) in which those vendors are active.
These are generally domain-specific visualizations, even with a vendor-specific
view. Such methodologies are nice to use when dealing with specific viewpoints,
but I do not believe these should be considered "architecture" frameworks. They
don't deal with requirement management, strategy alignment, and often lack
functional and non-functional insights. Still, they are a must to know in the
infrastructure areas.

If you are active in Amazon AWS for instance, then you've undoubtedly come
across drawings like the one visible in "[Wordpress: Best Practices on
AWS](https://aws.amazon.com/blogs/architecture/wordpress-best-practices-on-aws/)".
These drawings provide a deployment viewpoint that lists the main interactions
between AWS services.

When you are more network oriented, then you've been immersed in Cisco's network
diagrams, like the one visible in "[Verizon Business Assessment for: Cisco PCI
Solution for
Retail](https://www.cisco.com/c/en/us/td/docs/solutions/Verticals/PCI_Retail/roc.html)".
These network diagrams again focus on the deployment viewpoint of the network
devices and their main interactions.

There are probably plenty more of these specific visualizations, but the two
mentioned above are most visible to me currently.

**Conclusions**

There are plenty of frameworks out there to learn from, and some of these can be
used to find ways of explaining what the infrastructure domain is about.
However, they are often all very complete and require an architectural mindset
to start from, which is not obvious when trying to convey something to outside
or indirect stakeholders.

Few frameworks have a reference that is directly consumable by non-architect
stakeholders. The most tangible ones seem to be related to the IT processes, but
those still require an IT mindset to interpret.

<!-- PELICAN_END_SUMMARY -->
