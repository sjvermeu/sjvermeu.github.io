Title: Organizing service documentation
Date: 2021-07-08 09:20
Category: Architecture
Tags: architecture,documentation,structure,wiki
Slug: organizing-service-documentation
Status: published

As I mentioned in [An IT services overview]({filename}/2021/06/an-it-services-overview.md)
I try to keep track of the architecture and designs of the IT services and
solutions in a way that I feel helps me keep in touch with all the various
services and solutions out there. Similar to how system administrators try to
find a balance while working on documentation (which is often considered a
chore) and using a structure that is sufficiently simple and standard for the
organization to benefit from, architects should try to keep track of
architecturally relevant information as well.

So in this post, I'm going to explain a bit more on how I approach documenting
service and solution insights for architectural relevance.

**Why I tend to document some of it myself**

Within the company I currently work for, not all architecture and designs are
handled by a central repository, but that doesn't mean there is no architecture
and design available. They are more commonly handled through separate documents,
online project sites and the like. If we had a common way of documenting
everything in the same tool using the same processes and the same taxonomy, it
wouldn't make sense to document things myself... unless even then I would find
that I am missing some information.

It all started when I tried to keep track of past decisions for a service or
solution. Decisions on architecture boards, on risk forums, on department
steering committees and what not. *Historical insights* I call it, and it often
provides a good sense of why a solution or service came up, what the challenges
were, which principles were used, etc.

Once I started tracking the historical decisions and topics, I quickly moved on
to a common structure: an entry page with the most common information about the
service or solution, and then subpages for the following categories:

- Administration (processes, authorizations, procedures)
- Authentication
- Authorizationn
- Auditing and logging
- Configuration management
- Cost management
- Cryptography and privacy
- Data management (data handling, definitions, governance, lineage,
  backup/restore, ...)
- Deployment
- Design and development (incl. naming convention)
- Figures
- High availability and disaster recovery
- History
- Operations (actor groups, source systems & interactions/external interfacing)
- Organization (management, organisational structure within the company, etc.)
- Performance management
- Patterns
- Processes
- Quality assurance & reporting
- Roadmap and restrictions (incl. lifecycle)
- Risks and technical debt
- Runtime information
- Terminology

Now, I won't go in depth about all the different categories listed. Perhaps some
areas warrant closer scrutiny in later posts, but for now the names of the
categories should be sufficiently self-explanatory.

If there is an internal service (website or similar) that covers the
details properly, then I will of course not duplicate that information. Instead,
I will add a link to that resource and perhaps just document how to interpret
the information on that resource.

**The entry page**

The entry page of a service or solution always looks the same. It starts off
with a few attributes associated with the service:

- The taxonomy used within the company
- The main point of contact(s)
- The backlog where the responsible team tracks its progress and evolution
- A link to the main documentation resources
- The internal working name

The *taxonomy* is something I strongly appreciate in my current company. It is
a uniform identifier associated with the product, service or solution, and is
used for several of the operational processes the company has. This taxonomy
comes up in things like chargeback, service level agreements, responsibility
overviews, data classifications, enterprise architectural overviews, etc.

For instance, a managed macbook (asset) might have a taxonomy identifier of
`mmac`, or we have a service for exchanging internal company data identified as
`cd70` (it doesn't need to have an identifier that "reads" properly). Of course,
people don't just run around shouting the identifiers, but when we go through
the information available at the company, this identifier is often the primary
key so to speak to find the information.

For the *main points of contacts*, I usually just document the person that is
my go-to person to get some quick insights. The full list of all contacts (like
product owner, product manager, system architect, business analyst, release
manager, etc.) is managed in a central tool (and uses the taxonomy to quickly
find the right person), so I just have the few names that I quickly need listed
here.

The *backlog* is something I recently added to support any questions on "when
will we have feature XYZ". In the past, I had to contact the people to get this
information, but that often became cumbersome, especially when the team uses a
proper tool for tracking the work on the service.

The *main documentation* is often the most important part. It is a link to the
documentation that the team provides for end users, architects or other roles.
Some teams still have their information on a NAS, others in a document library
on SharePoint, others use a wiki, and there are teams that use a structured
document management system. Working for a big company has its consequences...

Finally, the *internal working name* is the name that a service or solution
receives the most. For infrastructure services, this is often the name of the
product from the time the product entered the organization. While the vendor has
switched the name of the product numerous times since, the old name sticks. For
instance, while I will document IBM's cloud offering as "IBMCloud" (its current
name) I will list its working name as "Bluemix" because that's how the company
internally often refers to it.

After the basic attributes, I have

- a few paragraphs for *description*
- a diagram or architecture view to give a *high level design*
- the *most important questions* surrounding the service or solution
- some *tips and titbits* for myself

The high level design is often a view that I maintain myself, which uses the
[abstraction]({filename}/2020/12/abstracting-infrastructure-complexity.md) that I
mentioned earlier in my blog. It is not covering everything, but to a sufficient
level that I can quickly understand the context of the service or solution and
how it is generally implemented.

The most important questions are mostly a refresher for questions that pop up
during discussions. For instance, for an API gateway, common questions might be
"What are the security controls that it enforces" or "Does the API GW perform
schema validation on JSON structures?".

**The history of a service**

Below the entry page, the various categories come up. As I mentioned, it all
started with the historical insights on the service. By having a chronological
overview of all decisions and related material per service, I can quickly find
the most important information in many cases.

Want to know the latest architecture for a service? Let's look in the history
when the last architectural review was, and at which decision body or board it
came up. Once found, I just need to go to the meeting minutes or case details to
find it.

Want to know why the decision was taken to allow a non-standard integration?
Take a look at the history where this decision was taken, and consult its
meeting minutes.

Need to ask for a continuance for something but you're just new in the team and
don't know why or how it was approved in the past? No worries, I'll share with
you the history of the service, where you can find the information, and coach
you a bit through our organization.

Having the history for services and solutions available has been a massive
efficiency gain for myself and my immediate stakeholders. Of course, I would
have loved if the organization tracked this themselves, but as long as they
don't (especially since organization changes more often than technology) I will
put time and effort to track it myself (at least for the services and solutions
that I am interested in).

The historical information I track myself is not a copy/paste of the meeting
minutes of those entries. I try to use a single paragraph explaination, like so:

```
ARB  2020/12/05		"Switch of PostgreSQL authentication provider to PAM+sssd"
	Approval to switch the authentication provider of the PostgreSQL
	database assets from the internal authentication to a PAM-supported
	method, and use the RHEL sssd solution as a facilitator. Link with
	Active Directory.
```

The `ARB` is the name of the decision body (here it could be the *Architecture
Review Board*) and tells me where I can find more details if needed. I don't
really bother with trying to add actual links, because that takes time and often
the links become invalid after we switch from one solution to another.

Since then, I also started adding information related to the service that isn't
just decision body oriented:

```
Incident	2021/06/08	"Fastly major outage"
	A major outage occurred on Fastly, a widely used cloud edge provider,
	between 09:47 UTC and 12:35 UTC. This impacted service ABC and DEF.
```

Incidents can be internal or external, and if they are internal I'll document
the incident and root cause analysis numbers associated with the incident as
well.

It also doesn't need to be about problems. It can be announcements from the
vendor as well, as long as the announcement is or can be impactful for my work.

**How complete is this overview**

My overview is far, far, far from complete. It is also not my intention to make
it a complete overview, but instead use it as a quick reference when needed.
Services that are commonly discussed (for instance because they have wide
implications on other domain's architectures) are documented more in depth than
services that are barely influential to my meetings and projects. And that
doesn't mean that the services themselves are not important.

Furthermore, the only areas that I truly want to have up-to-date, is the entry
page and the history. For all the other information I always hope to be able to
link to existing documentation that is kept up-to-date by the responsible teams.

But in case the information isn't available, using the same structure for noting
down what insights that I gather helps out tremendously.

I also don't want my overview to become a critical asset. It is protected from
prying eyes (as there is occasionally confidential information inside) and I am
coaching the organization to take up a lot of the information gathering and
documentation in a structured way. For instance, for managing EOL information,
we are publishing this in a standard way for all internal stakeholders to see
(and report on). The roadmap and strategy for the services within the domain are
now being standardized within the backlog tool as well, so that everybody can
clearly document when they expect to work on something, when certain investments
are needed, etc.

In the past, architects often had to scramble all that information together
(hence one of my categories on *Roadmap*) whereas we can now use the backlog
tools of the teams themselves to report on it.

**Which tool to use?**

Personally, I use a wiki-alike service for this, so that I can search through
the pages, move and merge information, use tagging and labels and what not. I
also think that, unless the company already has a central tool for this, a well
maintained wiki with good practices and agreements on how to use it would do
wonders.

I've been playing around in my spare time with several wiki technologies.
[Dokuwiki](https://www.dokuwiki.org/dokuwiki) is still one of my favorites due
to its simplicity, whereas [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki)
is one of my go-to's for when the organization really wants to pursue a scalable
and flexible organization-wide wiki. However, considering that I try to
structure the information in a hierarchical way, I am planning to play around
with [BookStack](https://www.bookstackapp.com/) a bit more.

But while having a good tool is important, it isn't the critical part of
documenting information. Good documentation, in my opinion, comes from a good
structure and a coherent way of working. If you do it yourself, then of course
it is coherent, but it takes time and effort to maintain it. If you collaborate
on it, you have to make sure everybody follows the same practices and agreements
- so don't make them too complex.

<!-- PELICAN_END_SUMMARY -->
