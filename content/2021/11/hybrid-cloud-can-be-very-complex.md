Title: Hybrid cloud can be very complex
Date: 2021-11-08 20:00
Category: Architecture
Tags: hybrid,cloud
Slug: hybrid-cloud-can-be-very-complex
Status: published

I am not an advocate for hybrid cloud architectures. Or at least, not the
definition for hybrid cloud that assumes one (cloud or on premise) environment
is just an extension of another (cloud or on premise) environment. While such
architectures seem to be simple and fruitful - you can easily add some capacity
in the other environment to handle burst load - they are a complex beast to
tame.

**Hybrid cloud complexity starts with the definition**

The first thing that I've already learned is not to use "hybrid cloud" without
defining what I mean. And if somebody else uses it (or a research article), I
will frantically try to get a definition on what the person or article implies
with the term.

[Microsoft](https://azure.microsoft.com/en-us/overview/what-is-hybrid-cloud-computing/)
for instance defines hybrid cloud as "a computing environment that combines an
on-premises datacenter with a public cloud, allowing data and applications to
be shared between them."

This definition isn't unambiguous. What does Microsoft mean with "sharing"? If
I expose an application and/or its data through APIs that are shielded and
independently managed in each environment, and allow for interaction between
those APIs, does that still entail a hybrid cloud architecture? Because if that
is the case, then I want to know what other cloud interaction architectures
Microsoft thinks exist besides hybrid cloud.

I do think that the intention of Microsoft's definition is that the cloud
hosting environments are considered as "similar enough" to the on premise
environment, and managed in the same way (some cloud specifics
notwithstanding), as inspired by their claim that hybrid cloud allow
"businesses [to] use the cloud to instantly scale capacity up or down to handle
excess capacity" and that organizations using hybrid cloud architectures "are
able to use many of the same security mreasures that they use in their existing
on-premises infrastructure".

[Gartner](https://www.gartner.com/en/information-technology/glossary/hybrid-cloud-computing)
defines hybrid cloud computing as "policy-based and coordinated service
provisioning, use and management across a mixture of internal and external
cloud services." That doesn't narrow things down, and in [(paywalled) research
articles](https://www.gartner.com/document/3956442), Gartner does express that
"hybrid cloud is a vague term that does not allow enough granularity for
implementation planning by cloud and infrastructure professionals".

[Forrester](https://go.forrester.com/blogs/13-08-02-cloud_management_in_a_hybrid_cloud_world/)
follows a definition that is very generic, as "a cloud service connected to any
other corporate resource" makes it a hybrid cloud service. Regardless of how it
is infrastructurally or application-wise integrated.

[IBM](https://www.ibm.com/cloud/learn/hybrid-cloud) declares hybrid cloud as
"integrates public cloud services, private cloud services and on-premises
infrastructure and provides orchestration, management and application
portability across all three. The result is a single, unified and flexible
distributed computing environment [...]"

This definition does seem to imply an architecture that considers all hosting
environments as infrastructurally equal (as they see the sum of all
environments as a single, unified environment).

[Wikipedia](https://en.wikipedia.org/wiki/Cloud_computing#Hybrid_cloud)
mentions that hybrid cloud "is a composition of a public cloud and a private
environment [...] that remain distinct entities but are bound together,
offering the benefits of multiple deployment models." Such a definition leaves
the implementation details open, as it boils down to any architecture where you
mix such hosting environments.

For me, a **hybrid cloud on infrastructure level** implies that the different
environments are similarly or equally managed, using the same processes,
principles and most often even tooling, and that application teams have little
impact on where their application (or application components) are hosted.

**The promise of hybrid cloud towards business**

When business decision makers hear (or are confronted with) hybrid cloud, they
are often told that it a perfect way to deal with capacity management. Whereas
a pure on-premise deployment model requires you to purchase and deploy enough
capacity to deal with your maximum workload (and even more, if you need to
consider disaster recovery situations), a hybrid cloud could simply "add more
resources as needed, without requiring the application to be refactored for
cloud-native or cloud hosting".

Let's make this more tangible with an example: a simple ticket sales service,
which consists out of a website (frontend) and an API (which is backend-alike).

![Ticket sales service overview]({static}/images/202111/hybridcloud-ticketsales-overview.png)

The company that manages this ticket sales application is currently fully
on-premise, with a simple deployment model where the front and backend are
hosted on a web application hosting cluster (which could be a Kubernetes
cluster), and the backend also uses a database.

![Ticket sales high level infrastructure]({static}/images/202111/hybridcloud-ticketsales-hlinfra.png)

Ticket sales are seasonally bound, and often ticket sales platforms are
services offered to the specific events. Suppose a major event wants to sell
its tickets through this ticket sale application, and you are afraid that the
website part will not be able to deal with the load, then you could use a
hybrid cloud setup to enable bursting on the front-end side.

![Ticket sales high level bursting]({static}/images/202111/hybridcloud-ticketsales-burstfrontend.png)

Of course, this is just one of many target architectures that might solve the
capacity challenge, and there is no reason to believe the API itself wouldn't
be overloaded as well. But let's stick to this simple example.

From a business perspective, this all sounds very fun and promising. There
seems to be no initial investment needed, and the capacity of the cloud is
limitless, not?

**Network investments needed for such hybrid cloud**

Well, as always, the devil is in the details. If we were to pursue this
architecture, we need to have the public cloud and the on premise environment
properly connected. You don't want to use regular Internet access, because the
intention is to see these environments as a single, unified environment, and
you don't open up your internal systems directly to the Internet either do you?

So you need to architect the public cloud usage to be as private as possible,
and then connect that environment with your on premise network, preferably
through a high speed private link. Sure, you can use VPN over internet, but
with a private link you have more guarantees on the latency for instance, and
for many cloud environments such private link interactions are also bringing
benefits for data ingress/egress (cheaper for you). They also generally have
better SLAs (although larger environments will have very high internet-related
SLAs) and do not require the same security protection measures (like anti-DDoS
protection).

![Ticket sales network connectivity]({static}/images/202111/hybridcloud-ticketsales-connectivity.png)

In the design, we assume that the end users still first go through your on
premise environment, as the perimeter protections you have in place for
instance still need to apply. Perimeter protections are not just simple
firewall capabilities. It includes

* anti-DDoS measures
* context gathering for, and applying coarse-grained access controls
* intrusion detection and prevention
* anti-malware protection
* application attack prevention
* network traffic filtering

A perimeter is meant to act as a first line of defense. However, when
integrating networks from external sites, you still need some protection
measures applied (shown as external site protection in the diagram), as you are
handing off some ownership to other parties and thus want to have some
safeguards in place.

Because we still have all traffic through the perimeter, burst loads can still
jeopardize the service offering itself. If the perimeter, internet line, or the
load balancer that spreads the load across the frontends is saturated, then
your service will go down. The hybrid cloud setup used in this example wont
help out here.

Second, the high speed private link will need to be able to deal with not only
the load of the user to the frontend (and back), but also between the frontend
and backend. And if you were to support bursting the backend application to the
public cloud as well, then it needs to deal with the load between this
application and the database.

The link is also often not something you set up yourself between you and the
public cloud. You will need intermediate parties to support this, as often this
first requires you to have private links to certain larger networks, and then
have this larger network set up a private link to the point of presence where
you want to 'attach' to that public cloud environment.

**Management complexity rises with hybrid cloud**

The investments do not stop just at the network connectivity. You will need to
look into managing the web application (such as deployment and releases),
servers (bootstrapping, updating, maintaining), and other network areas.

![Hybrid cloud management complexity]({static}/images/202111/hybridcloud-ticketsales-management.png)

Let's start with the web application management. Your existing management
systems will now need to deal with the public cloud as well. Your application
needs to be deployed on multiple clusters, and you will need to reconfigure the
load balancers in front to know where these clusters are. Unlike the
pre-installed environments on premise, public cloud is more dynamic (you want
to use it for bursting after all), so the target IP addresses might change (or
you set up fixed IP addresses, but that costs money even when you don't use
them).

You will need to deal with deployments that can succeed left and fail right, or
vice-versa. While this is not impossible to deal with, the current way of
working might not support that yet because, you know, you never had to deal
with it.

What about tracking performance and user experience? Your application
management suite might not know about public cloud setups yet, and once
included, it might find that there is latency impact. But can you just use this
APM suite in the public cloud? Perhaps your company has a site license which
does not include other locations. Or it requires per-node licenses, and require
each node to be assigned a license for 30 days at least. In case of burst
situations, you might only have these systems up for a few hours, and with the
next action, these will be new nodes with new licenses.

Also on the server management level you might find many obstacles. Your on
premise system might use a certain hypervisor integration (e.g. using VMware
vCenter API) which you don't have in the public cloud. So you need to adapt the
management system anyway, which means you need to develop your management
systems to create a hybrid cloud, rather than reap the benefits of hybrid cloud
directly.

Your servers might use many control systems that have the same licensing issues
as mentioned earlier. Or they are latency-bound, causing either reachability
issues, or requiring you to adapt the infrastructure architecture of these
management systems to be aware of the public cloud.

Also on network management level it isn't just about connectivity. Your
firewall management might not see the public cloud firewalls automatically (or
doesn't support it), or your current network design doesn't allow for the
bursting of network environments (subnets) in a sufficient dynamic manner.

The more you consider this hybrid cloud situation, the more you find out that
you will need to revisit all management, support and control systems for this
setup. And you know what is hard to do in an IT environment? Reassessing *all*
management, support and control systems. You are effectively redesigning your
entire IT environment, and that is exactly what the promise of "hybrid cloud"
wanted to take away. Or at least, the promise that is done to certain decision
makers.

**Vendors know that it is complex (and are happy because of it)**

Most of the IT vendors that are related to the management, support and control
of your infrastructure, will say that management in hybrid cloud is hard: [Red
Hat](https://www.redhat.com/en/blog/operating-hybrid-architecture-and-managing-complexity)
for instance mentions in its container-related article that "Saying that
Kubernetes makes it possible to build a cross-environment management layer
doesn't mean it's easy". [Aruba
Networks](https://blogs.arubanetworks.com/solutions/easing-the-complexity-of-hybrid-cloud/)
(part of PHE) mentions that "the major drawback is complex management of these
platforms". Consulting firms concur as well, with for instance David Linthicum,
Chief Cloud Strategy Officer of Deloitte Consulting, mentioning in [4 things
you need to know about managing complex hybrid
clouds](https://techbeacon.com/enterprise-it/4-things-you-need-know-about-managing-complex-hybrid-clouds)
that "hybrid clouds are usually complex, hard to build, and hard to manage".

Of course, IT vendors will be happy to tell you that it is hard (and for once I
concur), because they will then follow up with how their shiny tool supports
hybrid cloud much better than your existing ones. IT vendors know that an
infrastructural hybrid cloud means a redesign of (many parts of) your IT
architecture, so there is big money involved.

Hence, it is important that hybrid cloud endeavours are assessed completely,
and that your business decision makers hold off with the decision until the
full scope of this exercise is known (or at least, you have a decent ballpark
estimate on the impact, not just financially, but also time-to-market). 

So, what are all the areas you need to consider? That's difficult to state, but
hopefully the list below can help you out:

* How are your servers bootstrapped (initial deployment)? Can this interact
  with the cloud APIs to do the same in the cloud, or will you need to adapt
  your processes?
* Once your server is bootstrapped, how do you add software, libraries and
  other artefacts to it?
* What security services do you need on your systems? Anti-malware? Behavior
  analytics? Intrusion detection and prevention? Privileged access management
  utilities? 
* How do your engineers and administrators follow-up on the systems? Monitoring
  approaches? Application performance management? Trace capabilities? Logging?
* Are there any control systems in place that manage the infrastructure? Are
  these control systems latency-sensitive?
* How do you deal with applicative releases? If you have CI/CD infrastructure
  in place, how would it deal with a burst environment? Does it have any
  dynamical detection capabilities?
* Can your support systems deal with more ephemeral infrastructure (capacity that
  is added for a few hours and then removed again)?
* Can your processes deal with ephemeral infrastructure?

Perhaps your current environment is already capable of dealing with such hybrid
clouds. While the situations I am confronted with at work support my view that
we need to apply a different 'hybrid' approach than the 'seamless
infrastructure' one (I like to see the environments progress more
independently, gradually move towards a [zero
trust](https://www.nist.gov/publications/zero-trust-architecture) model), I do
believe that such hybrid cloud setups can work in certain situations.

**Conclusions and feedback**

If you do come across an intention declaration to move to a hybrid cloud (which
follows the infrastructural 'seamless' setup as implied in this post), make
sure you inform the stakeholders of the consequences. Show that a majority of
management, support and control systels are not designed nor capable of dealing
with this bursting out-of-the-box, and that this will require a significant IT
investment which might not be visible to the decision maker currently.

If you have the time and resources, try to already build up the arguments for
it by focusing on your management, support and control systems, validating how
ready they would be, and what types of investments would be needed. Compare
this with a setup where the infrastructure side of the hybrid cloud still uses
separate environments, and where you manage each environment using the
strengths of that environment.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](https://twitter.com/infrainsight/status/TODO).

<!-- PELICAN_END_SUMMARY -->
