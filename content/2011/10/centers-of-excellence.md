Title: Centers of Excellence
Date: 2011-10-25 20:12
Category: Misc
Slug: centers-of-excellence

When dealing with software (I'll talk about software here, but the
information is applicable to most technologies, such as appliances and
operating systems) many organizations want to have "centers of
excellence" with respect to the software. These teams are responsible
for positioning the software within the organization, supporting the
software and if necessary, act as a link between the internal customer
and the software vendor.

The approach on these "centers of excellence" is often described as a
cost efficient way of handling the software within the organization.
Sadly, many organizations go to the extreme and try to put as much
support and services within those teams as possible, hoping that full
consolidation of all service matters would yield an even better
(financial) benefit.

Such further consolidation however has a negative side which is often
overlooked: *centralized teams are less aware of the internal customers'
requirements and situation*. Most internal customers probably have their
own IT teams that are much better informed about the criticality of the
customers' systems and the services that the customer requests. Those
teams are then responsible for getting the right services from those
"centers of excellence". And that is where the difficulty lies.

"Centers of excellence" are *based on products and technical services*.
They want to provide the best-in-class service with their products and
as such keep enhancing their services in the hope that they can serve
all internal customers. But by doing so, they are becoming more and more
of a product vendor. In the end, they either focus on the product
completely, or they focus on some frameworks and tooling that they have
designed and developed to support the integration of the product within
the organization. For the IT teams of the internal customer however, the
"centers of excellence" are less seen as part of the organization and
more as a vendor (or broker).

That doesn't mean that the concept of these "centers of excellence" is
wrong though, but they need to keep the organization itself in mind when
dealing with the product. The detail on services that they offer need to
be aligned with the organizations' strategy and weighted to provide a
cost efficient, yet qualitatively best-in-class service.

Of course, all that is easier said than done. So let me suggest an
approach on software service(s) within an organization.

The lowest service that the organization must support for any software
is **assistance in the installation, upgrade, tracking and eventual
removal of the software**. Such a service is always needed and can be
provided with little knowledge of the internal customer. A "center of
excellence" should provide the means to (semi)automatically install the
software - preferably using the organizations' standard software
deployment methods, upgrade the software (both for major releases, minor
releases as well as security patches), remove and (not to forget) track
where the software is installed. Especially when dealing with
proprietary software, tracking is almost mandatory for organizations to
keep track of the licenses needed.

This lowest service offering has almost only positive sides:

-   IT teams that need the software can easily (and without further
    assistance of other teams) install the software. If the installation
    method is automated, it can even be done in a fast manner, which is
    always to the liking of the customer.
-   The organization keeps its risks low by providing the security
    updates and product upgrades in a seem less manner.
-   By tracking deployments, the organization can keep track of licenses
    used (for instance, the "center of excellence" can provide regular
    reporting towards the financial departments) and, if the tracking is
    done right, can even suggest improvements in the architecture or
    deployments to further minimize license cost.
-   IT teams can freely focus on the solution that they are building for
    the customer without the need to duplicate software installation
    methods and different patching processes.

By providing these services from a "center of excellence", you
definitely reduce certain research & development costs - without this
offering, each team would need to develop processes to deploy software
and track its usage. This is independent of the internal customer and as
such, consolidation is a definite win here.

Once this service is offered, the "center of excellence" can focus on
the services that they can provide and which are **mandatory for all
internal customers** (not "usable", but mandatory) and for which little
flexibility (in design or development) is possible. There are not that
many cases here, and this is very specific to each technology and
organization in which the software is made available.

As a hypothetical example, consider an LDAP service. The "center of
excellence" might want to provide auditing (and alignment with an
organization standard auditing system) if the organization has a policy
that auditing is mandatory, regardless of the project for which LDAP is
used. Of course, if the "center of excellence" wants to stop at this
service offering (i.e. the previously mentioned installation/tracking,
and now auditing) then this is most likely a best practice document
geared towards the IT teams that need to implement it.

The benefit? The IT teams are in this case aware of the requirement
(auditing must be enabled) and do not need to investigate how to do this
anymore (it is already documented).

The third level of service offering that I see is the **reusable,
customer-independent services** that one wants to provide on the
software. For a database, this might mean alignment with the
organizations' backup infrastructure. For an LDAP, that might mean
getting feeds from a central source (be it a central LDAP
infrastructure, an Identity Management system, ...).

When you consider providing this service (which is usually the case in
larger environments), take special care that the service you want to
offer is flexible enough so that any IT team can work with it. A service
that is only applicable to 70% of your internal customers will not do
it. For an LDAP service, this might mean that you provide out-of-the-box
configuration templates, best practice information for its back-end
infrastructure (which includes backup/restore operations), ...

But make sure that you are not redesigning and re-developing what your
product already provides. I have seen numerous cases where teams develop
tools that should "shield the complexity" from the end user, but in
effect are creating additional layers of clouds and complexity instead.
If you want or need to abstract complexity from the user, make sure that
this is only a single layer that you are introducing. The moment you are
creating tools on top of previously written tools, you should reconsider
your actions.

Often, "centers of excellence" want to rewrite documentation for the end
users. They feel that the documentation available from the vendor is too
complex for IT teams to use. Although I can relate to that, they should
not underestimate the expertise within the IT teams. If the IT teams do
not want to gain the knowledge or experience through the product guides,
then they are less likely to properly maintain and troubleshoot the
product.

In such cases, I would wager that it is more beneficial for the
organization to look at their (human) resources and their relation to
the software. In times like these, where cloud solutions play an
important role, my suggestion would be to consolidate the software usage
towards a SaaS principle (**Software-as-a-Service**) managed by an
experienced team (or teams). This does not mean that the "center of
excellence" has to play this role, but it does sound like a logical step
for them. After all, if the "center of excellence" only defines
additional services without actually consuming them, they might lose
track of the product in real-case scenario's.

Take a web server for example - Apache. You might have a "center of
excellence" for Apache web servers, which provides easily deployable
packages. They might provide example configuration files as well as
pointers towards Apache's documentation (and best practices). They track
the deployments and ensure that security patches are available as soon
as possible. But they should guard over the rest of the services that
they want to offer.

Why would that team create a framework for auto-generating configuration
files? What is the benefit of this for the entire organization, for each
customer? If the IT team can take care of the configuration, let them
be. But if those IT teams would rather not manage these web servers
themselves, what is the point in creating additional frameworks to "hide
the complexity"? It is, imo, much more efficient to see if you cannot
provide web hosting services instead, and have the IT teams "buy" these
(internal) web hosting services.

There are many advantages to this: the web hosting environment is
managed by a team of experts, can be consolidated to keep the TCO low,
can provide default configurations that are fully aligned with the
organization but still offer the flexibility that individual customers
might require.

Same goes for other software products: java application servers (like
JBoss or IBM WebSphere AS), databases (Oracle, SQL Server, MySQL or
Postgresql), messaging systems, log servers, LDAP services, file share
services, ...

So what about you - how do you position "centre of excellence" teams?
Can you relate with such a "back to basics" approach, or would you
rather see a fully integrated, standardized solution roll-out where IT
teams only have experience with the organization-only frameworks?
