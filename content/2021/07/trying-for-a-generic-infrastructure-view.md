Title: Trying for a generic infrastructure view
Date: 2021-07-14 18:30
Category: Architecture
Tags: architecture,pattern
Slug: trying-for-a-generic-infrastructure-view
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
just don't fit the situation that I am currently faced with.

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

TODO

**Department of Defense Architecture Framework (DoDAF)**

TODO (refer to AGATE and MODAF)

**Sherwoord Applied Business Security Architecture (SABSA)**

TODO more security origin but widely applicable

<!-- PELICAN_END_SUMMARY -->
