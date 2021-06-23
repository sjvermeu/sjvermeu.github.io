Title: An IT services overview
Date: 2021-06-14 17:30
Category: Architecture
Tags: architecture,overview,service,landscape,catalog,capability
Slug: an-it-services-overview
Status: published

My current role within the company I work for is “domain architect”, part
of the enterprise architects teams. The domain I am accountable for is 
“infrastructure”, which can be seen as a very broad one. Now, I’ve been
maintaining an overview of our IT services before I reached that role, 
mainly from an elaborate interest in the subject, as well as to optimize
my efficiency further.

Becoming a domain architect allows me to use the insights I’ve since
gathered to try and give appropriate advice, but also now requires me to
maintain a domain architecture. This structure is going to be the starting
point of it, although it is not the true all and end all of what I would
consider a domain architecture.

<!-- PELICAN_END_SUMMARY -->

**A single picture doesn’t say it all**

To start off with my overview, I had a need to structure the hundreds of
technology services that I want to keep an eye on in a way that I can 
quickly find it back, as well as present to other stakeholders what 
infrastructure services are about. This structure, while not perfect, 
currently looks like in the figure below. Occasionally, I move one or
more service groups left or right, but the main intention is just to
have a structure available.

![Overview of the IT services]({static}/images/202106/it_service_overview.png)

Figures like these often come about in mapping exercises, or capability models.
A capability model that I recently skimmed through is the
[IF4IT Enterprise Capability Model](https://www.if4it.com/SYNTHESIZED/MODELS/ENTERPRISE/enterprise_capability_model.html).
I stumbled upon this model after searching for some reference architectures
on approaching IT services, including a paper titled
[IT Services Reference Catalog](https://www.researchgate.net/publication/238620971_IT_Services_Reference_Catalog)
by Nelson Gama, Maria do Mar Rosa, and Miguel Mira da Silva.

Capability models, or service overviews like the one I presented, do not fit
each and every organization well. When comparing the view I maintain with
others (or the different capability and service references out there), I
notice two main distinctions: grouping, and granularity.

- Certain capabilities might be grouped one way in one reference, and use a
  totally different grouping in another. A database system might be part of
  a “Databases” group in one, a “Data Management” group in another, or even
  “Information Management” in a third. Often, this grouping also reveals the
  granularity that the author wants to pursue.  
  Grouping allows for keeping things organized and easier to explain, but has
  no structural importance. Of course, a well-chosen grouping also allows you
  to tie principles and other architectural concerts to the groups themselves,
  and not services in particular. But that still falls under the explainability
  part.

- The granularity is more about how specific a grouping is. In the example
  above, “Information Management” is the most coarse-grained grouping, whereas
  “Databases” might be a very specific one. Granularity can convey more insights
  in the importance of services, although it can also be due to historical
  reasons, or because an overview started from one specific service and expanded
  later. In that case, it is very likely that the specific service and its
  dependencies are more elaborately documented.

In the figure I maintain, the grouping is often based both on the extensiveness 
of a group (if a group contains far too many services, I might want to see if I
can split up the group) as well as historical and organizational choices. For
instance, if the organization has a clear split between network oriented
teams and server oriented teams, then the overview will most likely convey
the same message, as we want to have the overview interpretable by many
stakeholders - and those stakeholders are often aware of the organizational
distinctions.

**Services versus solutions**

I try to keep track of the evolutions of *services* and *solutions* within this
overview. Now, the definition of a “service” versus “solution” does warrant
a bit more explanation, as it can have multiple meanings. I even use “service”
for different purposes depending on the context.

For domain architecture, I consider an “_infrastructure service_” as a product
that realizes or supports an IT capability. It is strongly product oriented
(even when it is internally developed, or a cloud service, or an appliance)
and makes a distinction between products that are often very closely related.
For instance, Oracle DB is an infrastructure service, as is the Oracle
Enterprise Manager. The Oracle DB is a product that realizes a “relational
database” capability, whereas OEM is a “central infrastructure management”
capability.

The reason I create distinct notes for these is because they have different
life cycles, might have different organizational responsible teams, different
setups, etc. Hence, components (parts of products) I generally do not consider
as separate, although there are definitely examples where it makes sense to
consider certain components separate from the products in which they are
provided.

The several hundred infrastructure services that the company is rich in are
all documented under this overview.

Alongside these infrastructure services I also maintain a solution overview.
The grouping is exactly the same as the infrastructure services, but the
intention of solutions is more from a full internal offering point of view.

Within _solution architectures_, I tend to focus on the choices that the
company made and the design that follows it. Many solutions are considered
‘platforms’ on top of which internal development, third party hosting or
other capabilities are provided. Within the solution, I describe how the
various infrastructure services interact and work together to make the
solution reality.

A good example here is the mainframe platform. Whereas the mainframe itself
is definitely an infrastructure service, how we internally organize the
workload and the runtimes (such as the LPARs), how it integrates with the
security services, database services, enterprise job scheduling, etc. is
documented in the solution.

**Not all my domain though**

Not all services and solutions that I track are part of ‘my’ domain though.
For instance, at my company, we make a distinction between the
infrastructure-that-is-mostly-hosting, and
infrastructure-that-is-mostly-workplace. My focus is on the ‘mostly hosting’
orientation, whereas I have a colleague domain architect responsible for
the ‘mostly workplace’ side of things.

But that’s just about accountability. Not knowing how the other solutions
and services function, how they are set up, etc. would make my job harder,
so tracking their progress and architecture is effort that pays off.

In a later post I’ll explain what I document about services and solutions
and how I do it when I have some time to spend.

