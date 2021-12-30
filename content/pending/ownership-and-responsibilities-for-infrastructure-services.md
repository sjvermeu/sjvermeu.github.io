Title: Ownership and responsibilities for infrastructure services
Date: 2021-12-08 20:00
Category: Architecture
Tags: RACI,responsibilities
Slug: ownership-and-responsibilities-for-infrastructure-services
Status: draft

In a perfect world, using infrastructure or technology services would be
seamless, without impact, without risks. It would auto-update, tailor to
the user needs, detect when new features are necessary, adapt, etc. But
while this is undoubtedly what vendors are saying their product delivers,
the truth is way, waaaay different.

Managing infrastructure services implies that the company or organization
needs to organize itself to deal with all aspects of supporting a service.
What are these aspects? Well, let's go through those that are top-of-mind
for me...

<!-- PELICAN_END_SUMMARY -->

**Operational support**

When you have a service running, then you need to ensure operational
support is in place in case there are issues. Be it to resolve a
malfunction, a security issue, or a performance degradation - you need
(human) resources to ensure that the service remains running adequately.

In many organizations, this is handled in a three- or sometimes 
even four-level support structure:

- First line is generally a call center that procedurally validates if
  an issue is service bound, or if they can assist the user in correctly
  or better use the service. First line often does not require any
  knowledge of the customer base nor target infrastructure, and is strongly
  procedure oriented. They do not have operational duties on the services
  themselves, and are an important part to weed out unstructured or invalid
  service requests. They then escalate the issues to second line.
- Second line is an organization that has knowledge on the customer
  base and the services themselves. They are also often the last line
  that has a wide view on all services within the company, as subsequent
  support levels are more specialized. Second line has the ability to
  take actions on the services themselves (like restarting services)
  if this is agreed upon in the past with the main stakeholders, and when
  this is executed in a controlled manner. If second line isn't able to
  resolve an issue, it moves to the third line.
- Third line support is generally the team that is operationally involved
  in the service itself. If the problem lays with a customer portal for
  instance, then third line support is often the team that maintains the
  customer portal. They know the service and its usage in detail, and are
  in many organizations the last line of support.

Some organizations even continue this layering, with a fourth line of
support being a technical expert in a particular component used by the
service. If the customer portal has problems, and it is within the database,
and the DBAs of the customer portal team do not have the knowledge to
resolve it, they might escalate further to a dedicated DBA team (which
is not assigned to any particular business service but specifically
organized to be experts in database and database administration).

Not all companies have a technology-oriented support team though, and
many companies will consider this as part of 3rd line support as well,
if not just to be more aligned with market terminology on support structure.
Still, organizing and optimizing this third line of support is often
something that infrastructure service support is heavily involved in.

Regardless of the structure approached by the organization, these teams
will need the knowledge and supporting tools and procedures to do their job.
You need people that can develop support procedures, simplified automation
(for second line to execute), and continuously update that information.
And if a vendor is involved, then the support line will need to have
knowledge on how to approach the vendor: what are the procedures and
processes for raising incidents, what is the priority queue like? Does
the vendor have certain SLAs that the team should know about?

The several layers of support will need continuous training, even if it
is just refreshing past information. It is also wise to involve these
support lines in information sharing, like when you know there is a growth
on database reliance in the business services, or when you know many
databases are being migrated from one technology to another. Second line
for instance might be able to use that information, together with their
cross-organizational knowledge, to better triage issues.

**Maintenance**

As mentioned in the support part, teams exist that are responsible for
the service itself, including patching and updates. This is part of the
maintenance requirement on services, and infrastructure services are not
different. Perhaps even more so than business services, infrastructure
services have a wider impact if they are hit with a bug or with
performance degradation, as many business services rely on the infrastructure
to be up and running, highly available, performant and secure.

Maintenance tasks for services include, alongside the participation in the
operational support:

- Executing security- and stability patch validation and roll-out (updates)
- Proactively assessing the state of the service to see if improvements
  or mitigations are needed, before these result in actual issues
- Ensuring sufficient capacity is available for now and in the immediate
  future
- Resolving performance issues, be it by increasing resources, moving
  services to different locations or hosts, fine-tuning configuration
  parameters, offloading workload to different services, etc.
- Executing planned maintenance activities, which can include upgrades
  to higher versions. When the service cannot be transparently upgraded,
  this will involve a thorough alignment with all stakeholders as part of
  the change management processes.
- In case of larger, wide spanning incidents (or even disasters), the teams
  play an active role in the orchestrated recovery together with all other
  teams.

**Designing and architecturing the integrations**

To ensure that the services are well supported and can be maintained in
an efficient manner, there is often a strong focus on proper design of
the infrastructure services and their role in the architecture. This
design does not just include pointing out which components exist where,
but also how the service integrates in the larger landscape:

- How are administration tasks executed? How do administrators authenticate
  themselves?
- Where are the monitoring metrics found and stored? Do you use trend analysis,
  and in which system?
- How are the assets related to the service tracked? What is the lifecycle for
  the individual assets, and how does that impact the maintainability of the
  service?
- What is the best way to use the service, and what will not be allowed?
- How are backups taken, and what does a restore procedure look like? Do you
  support both in-place restores, side restores, etc.
- What underlying resource requirements exist? Do you require certain
  tiered storage, or network performance requirements? If you allow your
  service to be instantiated by others (rather than maintain a platform
  yourself), what are the target resources that you allow? Are there
  minimal resource requirements?
- How do users interact with the service? Do they access it directly,
  or do you require intermediate gateways (like reverse proxies)?

Now, design and architecture goes beyond integrations. I focus strongly on
integrations here as it is a part of design and architecture that has strong
dependencies and relations with other teams and technologies. To work out
the integration side of a service, you can't do this autonomously without
assistance from the other service teams. Of course, if those teams have
everything well documented and architected, and easy to consume, then the
team responsible for the design and architecture can do a large part of the
work independently, but having a final validation or confirmation is always
beneficial.

One of the values of a proper integration design is a higher quality of the
service delivery. If integrations are missed, you'll find that a service 
might not be ready to be activated in production, and then suddenly there
is a stronger focus on timely delivery than on quality. Situations where
firewall rules need to be quickly pushed and opened up because a project
failed to assess their integrations, resulting in security risks, is
sadly enough all to common.

Larger organizations will often have architects and designers within the teams
or directorates to support this endeavour.

**Secure setup and deployment**

Given that some integrations might result in heightened risks, and
infrastructure services are often widely used or consumed, the organization
will need to make sure that the services are designed to be secure.

Security of a service is more than just ensuring it is up-to-date. You
will also need to make sure it is configured correctly (as misconfigurations
are a frequent occurrence of security incidents), that the authentication
and authorization is properly designed (and where needed or possible,
using multi-factor authentication), that the deployment considers the
placement and interactions (firewalls, zoning, etc.), that the service
provides functional (or perhaps even physical) segregation, that the
data governance is appropriate and aligned with regulatory and company
requirements, that the service is continuously validated by the security
tooling available (patch indications, vulnerability management, ...) etc.

As services also evolve when they are alive, secure setup and deployment
is not a one-off (but the initial thoughts and designs are not to be
underestimgated): the teams will need to assess the impact of new
insights (like security notifications, vulnerabilities, global changes
by the organization, new threats in the wider IT world) which implies
that the team has a continuous security and risk focus.

In many cases, there is even a coding and development component with
a service. Not many services can be installed and deployed without requiring
any integration scripting or even in-depth coding (such as custom plugins).
And when there is coding, there is the need for secure coding: following
a Secure Development LifeCycle (SDLC) approach to get assurance about
the secure state of the developed code.

When the deployment uses infrastructure-as-code methods, follows a
GitOps approach or similar, then there should also be sufficient attention
to the secure setup of these pipelines and the platforms on which they
run. The code (or configurations) hosted should also follow appropriate
security guidelines

**Robust and reliable services**

Designing for a trust-worthy, secure environment is one thing. The other
major focus area for infrastructure services is the availability,
robustness and resilience of the service. While not all services
require to be up and running 24/7, nowadays it is hard to imagine
many services to still have significant downtimes.

So, you often need to architecture and design for a resilient service,
which can take a beating if it has to. Organize load- and stress testing.
Organize disruptive testing if needed, and learn from the results to build
a better service. Design for a service that you can do technical maintenance
on without disrupting the customers themselves as much as possible - but
don't overshoot.

If the service is setup in multiple locations, make sure that there is
independence between these locations (often across different regions) so
that failures in one region do not affect the other regions. Consider a setup
as used in many public cloud environments: high availability across availability
zones in the same region, and regional independence while allowing for
cross-region usage scenarios for the customers.

Assess what can go wrong, and either try to update the architectures and
designs to be more resilient against these failures, or establish procedures
and processes to quickly recover. A common focus area here is to recover
from disasters (using so-called Disaster Recovery Procedures), and there 
are plenty of disasters to assess: data center failures, large Internet
outages, ransomware or other cyberattacks, world-wide epidemic outbreaks,
etc.

**Quality assurance at all stages**

To be able to provide secure and reliable services, it is vital to have
good change management processes and tooling in place so that you can
approach the various stages of quality assurance before reaching production.
In [The pleasures of having
DTAP]({filename}/pending/the-pleasures-of-having-DTAP.md) I mention
the benefits of having four environments for the various stages of a development
lifecycle (development, testing, acceptance and productionn) and that is
perfectly applicable to infrastructure services as well, even when the
environments for infrastructure services might be isolated from those of the
more business-oriented development stages: you want to make sure that the
business-oriented development has production-grade services for its processes,
and not the intermediate and possibly less reliable in-development infratructure
services.

Throughout these environments, testing can (should) be introduced to provide
guidance to the engineers and developers to improve on the service. Testing can
take several forms: unit testing within the frameworks, integration testing of
code in larger environments, integration testing of new products in those
environments, sanity testing with simple use cases to ensure nothing blows
up (figuratively... hopefully), regression tests to ensure no fixed defects
creep back in, acceptance tests for specific features or use cases, load
testing to ensure the product stays up under the expected loads (and the
individual components or services have the right performance profile), stress testing
to ensure the product is resilient against higher loads or bursts, destructive
tests to see the product behaves as expected when unauthorized usage is
performed, security testing and penetration testing to provide assurance
on the secure state of the product deployment, etc.

In many cases, the QA part is driven by organizational requirements, and not all
products require the same intensity on the tests and assurance levels. But, by
introducing the right automation, it is far easier to include multiple test
scenarios and test types in your pipeline.

Products then pass through the various stages according to the change
management principles and processes that are in effect in the organization.

**Strategy and roadmap**

The team responsible for an infrastructure service will also need to consider
the service in the long term: is the current technology (or set of products)
still state-of-the-art, mature, and following market practices? Or does the team
consider the technology to be relatively stale and in need of an update? When
would the right time be to address this update?

There is a distinction between the service (or better yet, "capability") that is
offered, versus the products and technologies that support and realize it.
Capabilities will be needed by the organization for a long, long time, whereas
the products that realize these capabilities can have much shorter timeframes.

The team will need to consider alternatives for the products, and see when those
alternatives make sense to address and implement. Perhaps the organization might
benefit from multiple implementations using different technologies because they
serve different usage scenarios, and the costs of keeping multiple technologies
in the air is less than the value it provides. Or perhaps an alternative needs
to be quickly realizable in case of a sudden exit scenario of the current
technology (or vendor). In that case, while the alternative doesn't need to be
up and running, the team must be able to address the change in due time.

The need to have a proper roadmap on the capability and products that are being
used also reflects in the relationship that that team has with the vendor. For
strategically important products, an organization might even want to participate
in that vendor's Customer Advisory Board (CAB) or equivalent programmes. The
team should have the time and resources to collaborate with that vendor to build
a partnership, participate in the conferences and other events, as that provides
input to the team on the progress and future of that product. Those insights are
primordial to properly design and organize an internal roadmap.

**More elaborate (internal) customer support**

The support for the infrastructure service often has to extend beyond the
operational support that I started with in this article. Teams that provide
certain capabilities within the organization don't do this as a vendor, but as
part of that organization. So when an internal customer needs help in migrating
away from a service, the team is still involved in this process.

Hence, more elaborate support such as migrations (both towards a new technology,
service or capability, as well as migration away from it), finding
suitable alternatives that are not properly handled by the capability (and thus
might be best provided by a different team), ... helps in building out the trust
that the wider organization has in IT.

**Cost, licenses and contractual obligations**

Many services have certain contractual obligations associated with them, often
known as the Terms and Conditions of the contract and product usage.
Infrastructure teams will need to make sure that these T&Cs are known and that
the organization adheres to them.

The cost of an infrastructure service usage also needs to be correctly devised
and accounted for. Teams have to make sure the product usage remains within the
allocated licenses (or, if there is no capping in place, that the usage is
sufficiently constrainted that the organization does not get any surprises), and
is often involved in defining a chargeback towards the rest of the organization.

I tend to make a distinction between showback (show the organization how much a
service costs to the company or usage group) and chargeback (a governance-driven
or tax-driven requirement for charging usage to the organization), as the latter
is more a company decision on how to approach this, whereas the showback is the
actual, factual cost. Showback is needed to support conscious decisions on next
steps or consumption patterns, whereas chargeback might be necessary for
tax-reasons in larger corporations where IT is considered as part of a different
legal entity.

Addressing cost, licenses and T&Cs is not to be underestimated. Many vendors
make this very difficult, as that allows for many interpretations during license
audits that can give a nice bonus to the vendor if he can show that his
interpretation is more appropriate than how you thought that the contract or
license was structured.

The cost of a product or technology is not just the cost of the purchase, and
even that cost is still somewhat variable: many things are open for negotiation,
and you also don't need to tackle this directly with the vendor, as there is a
large market of middle parties that facilitate purchasing technologies. These
can often provide better rates as they can bundle purchases of multiple
customers and thus negotiate better deals with the main vendor.

The cost also depends on the support contract associated with it, as well as
depending costs of other technologies (such as capacity requirements) that come
from its implementation. This is often neglected in SaaS purchases: even though
you have correctly negotiated a good price for the SaaS service, you might be
jeopardizing your internet connectivity and need to upgrade the bandwidth, the
anti-DDoS service, your firewall capabilities, etc. because the consumption of
that SaaS service is significant.

**Conclusions**

The responsibilities for managing and tracking infrastructure services are large
and not to be underestimated. It is not a matter of deploying a new service and
assuming everybody can deal with it, nor are all responsibilities equally
visible to the end user.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](https://twitter.com/infrainsight/status/TODO).

