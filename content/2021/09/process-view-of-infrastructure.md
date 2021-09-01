Title: Process view of infrastructure
Date: 2021-09-01 11:20
Category: Architecture
Tags: architecture,process
Slug: process-view-of-infrastructure
Status: published

In my [previous post]({filename}/2021/08/component-view-of-infrastructure.md),
I started with the five different views that would support a good view of
what infrastructure would be. I believe these views (component, location,
process, service, and zoning) cover the breadth of the domain. The post also
described the component view a bit more and linked to previous posts I made (one
for [services]({filename}/2021/06/an-it-services-overview.md), another for
[zoning]({filename}/2017/06/structuring-infrastructural-deployments.md)).

The one I want to tackle here is the most elaborate one, also the most
enterprise-ish, and one that always is a balance on how much time and
effort to put into it (as an architect), as well as hoping that the processes
are sufficiently standardized in a flexible manner so that you don't need
to cover everything again and again in each project.

So, let's talk about processes...

**Six process groups**

There are plenty of process frameworks out there. I've covered many of these
in a previous article ([What is the infrastructure domain?]({filename}/2021/07/what-is-the-infrastructure-domain.md)), with [ITIL](https://www.axelos.com/best-practice-solutions/itil)
and [CObIT](https://www.isaca.org/resources/cobit) being my main resources.

Companies often select a mature framework to align their IT on. After all, why
invent everything over and over again if a popular framework with all its
resources exists. But just like how companies like to use commercially available
resources, they also like to adjust and nudge it left and right to fit
the organization better. And that's fine.

I'm going to give a spin to it and combine processes with non-functionals, as
infrastructure is often about non-functionals. That doesn't mean that frameworks
like ITIL or CObIT are not good, but explaining them easily is sometimes a
challenge, and I'm not versed enough in the intricacies of these frameworks
to use them as a starting point, rather as a reference.

The six groups that I feel cover the infrastructure domain sufficiently are:

* *Governance & Organization*, which is about the company and the organization
  used within the company.
* *Consumers & Suppliers*, which is about the interaction (and supporting needs)
  with the consumers of our services, as well as with the providers.
* *Research & Development*, which is about preparing updates on the services
  and architecture
* *Risk & Security*, which enables risk reduction strategies and facilitates
  secure integrations of services
* *Custodianship*, which is about facilitating maintenance and support
  improvements that are more environment-wide
* *Engineering & Operations*, which focuses on the operational control and
  support of the services.

In some ugly visualization, these groups (and the processes or non-functionals
that are within) can be represented as follows:

![Six process groups for infrastructure]({static}/images/202109/six-process-groups.png)

Let's go through each of the groups in a bit more detail.

**Governance and Organization**

The first group is titled *Governance & Organization* and covers the company
specifics. It has five processes or non-functionals in it:

* Strategy and Innovation
* Enterprise Architecture
* Organizational Efficiency
* Separation of Concerns
* Formalization

The *strategy* of a company is an important starting point for larger changes,
as architects need to make sure that the changes they want to guide, coach, or
support are aligned with the company strategy. Most companies will have a
hierarchy of strategies, with the main strategy being translated to specific
strategies or strategic objectives, which are then further formalized down.

Alongside supporting the company strategy in general, domain architects might
need to plan the strategy for their domain as well (as I had to do for the
infrastructure domain). This, again, is a translation of the overall strategy,
showing how infrastructure will support the strategic objectives.

For the *innovation* part, the infrastructure domain needs to make clear how to
support innovative ideas and suggestions in the organization. Often,
the infrastructure and operations field is considered to be protective, and
might be perceived as obstructing innovative ideas. That's not a correct view -
while the operations field often has a more conservative view of the
infrastructure to make sure the production environment is available and secure,
it also has a viewpoint on how to deal with innovation. For instance, the
delivery of sandbox environments in which innovations can play a role, or
prototype environments that have limited, secured integration possibilities
toward the rest of the environment.

Innovation is not only limited to technological innovation. Innovative ideas on
governance and organization (such as when agile development practices were
being formulated) are also important to track, as they influence many
other processes and non-functional attributes.

The *enterprise architecture* part covers abstracting and guiding the
organization, the business, the product development, etc. in a coherent and
well-documented manner. It lays the foundations for an effective and efficient,
collaborative, large organization. Domain architects ensure that their domain
architecture is related to the enterprise architecture (and contributes to the
enterprise architecture directly).

*Organizational efficiency* focuses more on how the organization functions.
Does the organization use DevOps teams, for instance, or is it more traditional
in the development versus operations part? Does the organization have vertical
technology-oriented teams, or more horizontal, solution-driven teams, or a
mixture? Knowing how the company organizes its IT is important to properly
structure and present changes. Domain architects also provide input towards
reorganizations, as they can easily define how such shifts in responsibilities
will affect the organization and its efficiency.

With the *segregation of duties*, I focus on which roles can be shared and which
ones can't. Knowing which segregation applies in the organization (such as
the different security officer focus, the segregation between risk officers and
audit officers, the exclusivity between domain administrators (in Active
Directory terms) and regular server administrators) is an important driver
for architecting. Architects can suggest introducing additional segregations or
suggest methods for removing the need to segregate these duties (as often those
are inspired by historical events and assessed on older capabilities). I've
mentioned DevOps before, and those who supported a DevOps transition will know
about the historical segregation between development and operations.

Finally, *formalization* is about how to have formal evidence of decisions.
While this is often just part of a company's 'governance', I focus on it
specifically, as it is always balancing efficiency and effectiveness. When
formal evidence is expected by the organization, it is wise to keep track of why
this is. Often, formalization can be optimized further without reducing the
benefits or impacting the requirements.

**Consumers and Suppliers**

Whereas the first group focused on the company itself, the group on consumers
and suppliers focuses on the users of the infrastructure services that are
offered (which often, but not always, are internal customers) and the suppliers
for the various services the organization consumes.

It covers the following four processes and non-functionals:

* Cost & Licensing
* Portfolio
* Agreements & Support
* Incidents & Problems

The *cost and licensing* part is often a large time-consumer. I include
chargeback and showback here as well, although I must be very clear that actual
costs and chargeback-reported costs are not the same. For the services
infrastructure offers internally, knowing the costs (showback) and charging the
costs through to the internal customers (chargeback) are hard processes to
tackle, requiring intensive thoughts on what is and isn't allowed, how the
company looks at the services, etc.

While looking at the suppliers, an important part is to understand and optimize
the licensing. Each product and service that you consume costs money one way or
another. I've had the "pleasure" of being an Oracle license manager (as in,
responsible within my company for tracking, reporting, and optimizing the costs
associated with all Oracle products we consumed) for a while, and being part of
the Microsoft license management team (with responsibility for data center
oriented products). Knowing the license requirements, the terms and conditions,
the contractual obligations (and deviations that a company negotiated), etc. is
very useful.

The *portfolio* is about knowing what you consume (from vendors) and offer
internally, and how you intend to track and evolve it. For infrastructure
services, for instance, you want to make sure you have a decent catalog (which
is part of the portfolio) that your internal customers can consume. Designing
the catalog is an important first step in assessing and deriving the domain
architecture if it isn't available yet.

With *agreements and support* I look not just at the contractual agreements
related to service consumption (as in, the terms and conditions related to the
licensing), but also towards agreements on areas such as support (Can we call
the vendor any time of the day? How much time does the vendor contractually
have before they 'pick up the phone'? Is the service agreement conforming to
market expectations?). The same is true for the service agreements offered
internally - something that is best aligned with the portfolio.

Deriving decent service level agreements (SLA), and ensuring they can be
tracked and asserted, can be important if the vendor isn't all that
trustworthy, as well as to show your internal customers that you care about
reaching and keeping the SLAs.

Support is also about how to reach and interact with the support organization.
From an infrastructure point of view, that isn't always as easy as it sounds.
Some vendors require specific applications to interact with their support
organization, and your company might not allow those applications. Or, certain
metrics need to be sent out to a cloud service, but that cloud service isn't
easily identified as being secure and compliant enough with the regulations you
have to cover.

The *incidents and problems* item covers the standard incident and problem
resolution processes, and how these are handled in the organization. It is
about standardizing what incidents are, how to react to them, how to derive
problems from the observations, prioritizing work related to incidents and
problems, and more. A decent incident and problem tracking solution is a must,
but the solution itself is just part of the setup. A good tool does not give
you an efficient and effective organization.

**Research & Development**

The next group is about evolving the service offerings. I consider the following
four processes and non-functionals as part of this group:

* Architecture
* Design
* Product Lifecycle
* Quality Control

With *architecture*, I focus on the solution architecture, and how the solutions
interact with the domain architecture. The domain architecture is generally
part of the enterprise architecture, whereas the solution architecture is
something that regularly needs updates based on the changes that are being
planned. Most of this architecture is done by the system architects with
the support or coaching of the domain architect.

The *design* is the next phase of a development cycle and is more detailed
than the solution architecture. Designs are often handled by the
engineering teams themselves, with the support of the system architects. For
domain architects, knowing where the designs are and to read them/understand
them is vital for a good collaboration between architects and engineering teams.

The *product life-cycle* focuses on the entire life-cycle of a product, starting
with innovative ideas and research, prototypes, towards supporting the
development of the product, and even after deployment towards end-of-life
support/tracking, or in case of bought products the end-of-sale,
end-of-premier-support, extended support, custom support, and whatnot.

Balancing the product life-cycles against each other is a common occurrence for
architects and product owners, as it is always a puzzle about when to make which
changes, release what versions, etc. If you don't track the life-cycle of a
product continuously, you might face situations where you need to
purchase older products because your reinvestment wasn't planned yet, but
capacity limits require an increase anyway.

Finally, *quality control* is about ensuring the quality of the products is 
according to expectations. This includes support for different environments
(pre-production), specific quality testing (which I'll discuss later as well),
supporting QA teams (if you have those), and the processes for reporting
defects, etc. It also includes quality assurance on products purchased from
third parties.

**Risk & Security**

A major part of my work is to assess the risk exposure and ensuring a secure
and reliable infrastructure. Hence, it shouldn't come as a surprise that it is
an entire group by itself.

While security is a large domain (with lots of focus on processes and
assurance), the following processes and non-functionals are strongly
represented in the infrastructure domain:

* Crypto
* Authentication
* Authorization
* Privacy
* Access Control
* Audit & Compliance

For *crypto*, a major challenge is not only to ensure cryptographic services or
protocols are used where it makes sense (or better said, not used where it
makes sense) but also to understand the intricate details of the cryptographic
services, knowing what service is used for which purpose, etc. I could make an
entire article purely to discuss the sense and nonsense of transparent
encryption on file systems or databases...

The *authentication* processes (and the closely related identity processes) are
to support assurance on the identity of a user, process, system, device, or
any other type of subject. Knowing how the authentication is handled, which
authentication protocols are used, the landscape in case of federated
authentication, etc. can take up several days to know. Authentication is no
longer based on user IDs and passwords. We have OpenID Connect, SAML, Kerberos,
TACACS, RADIUS, NTLM, and more, which all have their quirks. And those are just
the protocols to handle authentication: they don't talk about user management,
the processes you will need to support in case of account abuse, etc.

*Authorization*, while often combined with the authentication phase, is about
knowing what a (freshly authenticated) identity may do (authorized). Here, we
have the challenges of coarse-grained authorization versus fine-grained
authorizations, dynamic authorizations, transient authorizations, or
authorizations that are inherited from others. Often, architects will need to
design the authorization granularity and approach based on the organizational
and security requirements.

The *privacy* controls are about ensuring confidential or strictly confidential
data (if those are the terms used by the organization) are properly protected.
Data can be anonymized, pseudonymized, redacted, tokenized, encrypted, and/or
de-identified. Architects should know which control is possible where, which
services can be used, what the impact is of the controls, as well as what the
organizational data requirements are.

The *access control* part is closely related to the authorization part. In
effect, it should be what enforces the authorizations. Access control is a wide
domain with many, many products and services working with (or against
apparently) each other. Especially in more modern architectures where zero
trust plays a role, you'll notice that access control is a challenging beast,
with dynamic and contextual controls becoming primary services rather than the
standard, relatively static (role-based) access controls.

The last part is the *audit and compliance*, where audit focuses on obtaining
traceability of all events (what has happened where, when, by whom), whereas
compliance looks at assuring current state and processes are according to
expectations. Compliance can be about assuring adherence to the organizational
processes and standards, but also that a system's configuration is accurate and
still in effect. So, yes, it is more than what a "compliance" department would
focus on.

**Custodianship**

In custodianship, I group processes and non-functionals that often play a more
active role after having a successful deployment, or after a project is
finished. While these do not imply that they are to be implemented by different
teams (that's the organizational efficiency which has to decide on this), I
notice that they are challenging to keep up properly for a large organization.

In it, I cover the following processes and non-functionals:

* Data Governance
* Rationalization
* Reporting & Insights

*Data governance* is about defining and tracking data, data flows, data
definitions, as well as their purpose. You need proper data governance to know
which privacy measures to apply, as one of its measures is the retention of the
data.

*Rationalization* is the effort to rationalize existing infrastructure usage
and services. While major rationalization exercises are company-wide
initiatives, there are many benefits to achieve with small, incremental
rationalization exercises. Most of the time, rationalization exercises are
about cost reduction, but that doesn't always need to be the case. Of course,
eventually, everything is about finances nowadays.

With *reporting and insights*, I consider the means to report on various areas
(such as capacity, cost, performance, and SLA breaches), as well as gain
insights from the data at hand.

**Engineering & Operations**

The final group covers the disciplines that I see on the engineering and
operations side:

* Configuration
* Orchestration
* Testing
* Change Management
* Operational Control
* Monitoring

The *configuration* part is to ensure that the systems and services are
properly configured and that the life-cycle of the configuration items is
guaranteed as well. 

With *orchestration*, the focus is on ensuring larger environments are optimally
used and the appropriate abstractions are in place. Kubernetes is a good
example of an orchestration that requires close attention and support. But
others exist as well, such as those in the Hadoop ecosystem.

*Testing* focuses on the various testing strategies that enable us to trust the
final product and services and help in ensuring no regressions are
creeping in. Testing on the infrastructure side is about load and performance
testing, smoke testing, regression testing, destructive testing, etc.

The *change management* process is about properly staging the changes,
communicating the changes, following up on the changes, etc. It is not just
about preparing a deployment and then hitting a button: you want to validate
that the change is successful, track the performance to ensure nothing is acting
strangely, etc.

With *operational control*, I consider the systems that drive the operational
systems autonomously. Self-driving and self-healing are the two non-functionals
I embed under this. Many cluster management systems are part of this, and
designing for self-driving and self-healing infrastructure comes up more and
more with modern systems.

Finally, *monitoring* covers tracking the telemetry of the systems, the logs
that are generated, and derive the right insights from it. I initially wanted
to call it "Observation" as that seems to be the term that comes up more and
more (monitoring too much resembles watching telemetry for thresholds, whereas
observation goes much beyond that) but monitoring seems to resound most amongst
users.

**A huge list that covers most of the requirements**

This list of processes and non-functional attributes covers most, if not all,
requirements that are related to the infrastructure domain. The component
view that I mentioned in a previous post, for instance, is part of the
architecture and design processes in the Research & Development group.

However, because they are still processes and non-functionals, they can often
seem to be less tangible. Sure, you have to manage the costs, but how do you do
that? What processes do you have in place to manage cost insights? How do you
deliver these insights? What tooling is used to support the organization? What
tooling is mandatory to use (like license management tools from larger vendors)?
Detailing this and making the right choices is part of being an architect.

In the next post, I will look at the location view. Unlike the process view,
which is often shared with other IT domains, the location view is something
that is often more exclusive for the infrastructure domain.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](https://twitter.com/infrainsight/status/1432996739846397957).

<!-- PELICAN_END_SUMMARY -->
