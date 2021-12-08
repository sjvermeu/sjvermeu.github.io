Ownership and responsibilities for infrastructure services

In a perfect world, using infrastructure or technology services would be
seamless, without impact, without risks. It would auto-update, tailor to
the user needs, detect when new features are necessary, adapt, etc. But
while this is undoubtedly what vendors are saying their product delivers,
the truth is way, waaaay different.

Managing infrastructure services implies that the company or organization
needs to organize itself to deal with all aspects of supporting a service.
What are these aspects? Well, let's go through those that are top-of-mind
for me...

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