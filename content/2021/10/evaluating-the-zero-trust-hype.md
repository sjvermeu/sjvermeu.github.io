Title: Evaluating the zero trust hype
Date: 2021-10-05 00:00
Category: Architecture
Tags: zero trust,security,enterprise,network security
Slug: evaluating-the-zero-trust-hype
Status: published

Security vendors are touting the benefits of "zero trust" as the new way to
approach security and security-conscious architecturing. But while there are
principles within the zero trust mindset that came up in the last dozen years,
most of the content in zero trust discussions is tied to age-old security
propositions.

**What is zero trust**

In the zero trust hype, two sources are driving (or aggregating) most of the
content that exists for zero trust: [NIST's Zero Trust Architecture
publication](https://www.nist.gov/publications/zero-trust-architecture) (report
800-207) and [Google's BeyondCorp Zero Trust Enterprise
Security](https://cloud.google.com/beyondcorp/) resources.

The NIST publication is a "dry" consolidation of what zero trust entails, and
focuses on the architecture and design principles for a zero trust environment.
It defines a zero trust architecture as an architecture that "assumes there is
no implicit trust granted to assets or users accounts based solely on their
physical or network location". 

The principles that it applies are the following:

* All data sources and computing services are considered resources
* All communication is secured regardless of network location
* Access to individual enterprise resources is granted on a per-session basis
* Access to resources is determined by dynamic policy [...] and may include
  other behavioral and environmental attributes
* The enterprise monitors and measures the integrity and security posture of all
  owned and associated assets
* All resource authentication and authorization are dynamic and strictly
  enforced before access is allowed
* The enterprise collects as much information as possible about the current
  state of assets, network infrastructure, and communications, and uses it to
  improve its security posture

Within the publication, a common view is used to explain zero trust and the
components that take an active role within the architecture. This view is
happily shared by vendors to show where in the zero trust architecture their
component(s) are positioned.

![NIST core view on zero trust]({static}/images/202110/zerotrust-core.png)

The publication further evaluates a few possible architectural approaches (or
patterns if you will) for zero trust, with specific focus on the network side.
It ends with a chapter on migrating to a zero trust architecture.

The Google resources through its BeyondCorp publication are more loosely written
and have a stronger focus on the cultural and principle aspects of zero trust.
One could see these publications more as an introduction to the value that zero
trust provides to a company and its users, with the focus on exposing services
everywhere, providing dynamic access controls through proxy services, and
eliminating classical patterns like using Virtual Private Networks (VPN) to bind
everything together.

The main motivation beyond the zero trust principles in Google's publication is
to eliminate the perimeter-style protection where all controls are on the
perimeter, after which users have nearly free rein across the internally
exposed infrastructure.

The principles it applies are as follows:

* Access to services must not be determined by the network from which you
  connect
* Access to services is granted based on contextual factors from the user and
  their device
* Access to services must be authenticated, authorized, and encrypted

While these two main resources embody the bulk of what zero trust is, it does
not determine it completely. Many vendors and consultancy firms have
their view of zero trust, which largely coincides with the above, but often
has specific attention points or even foundations that are not part of the
previously mentioned resources.

The term "zero trust" implies a "trust nothing and nobody" approach to
architecture and design, which you can fill in and apply everywhere. Of course,
you eventually will need to apply some level of trust somewhere, and how this is
done can depend on so many factors that it is unlikely that we will ever settle
down in the zero trust hype on what is and isn't proper.

**Focus areas in zero trust**

While evaluating zero trust, I read through many other resources out there.
Besides the paywalled analyst resources from Gartner and Forrester, it also
included resources from vendors to learn how they see zero trust evolve.

In most of these resources, there are commonalities that everybody seems to
agree on:

* Approach authentication and authorization at all layers in the stack: device,
  operating system, network, communication path (next-hop), communication
  session, application, etc.
* Enforce high maturity in asset management and inventory management. Asset
  management is more than just devices (it also entails applications, cloud
  services, etc.) and you should not only focus on those you own, but also those
  that are associated with your architecture (such as Bring Your Own Device
  (BYOD) assets)
* Ensure data classification and data management are applied and continuously
  evaluated and updated.
* Contain workloads within sufficiently small logical bounds. This could be
  through micro-segmentation (but that is not the sole method out there).
* Expose services globally (as in, globally reachable), but that does not
  imply that all services are accessible by each and every one.
* Use dynamic access policies and policy enforcement. Dynamic includes
  context-based accesses (access decisions are taken by more than just the
  authentication side of things) as well as authorizations that can change as
  new insights are passed on (such as threat intelligence).
* Perform continuous monitoring, including behavioral assessments.
* Encrypt everything (or more soundly put, cryptographically protect resources
  at all layers of the stack).

The [Cybersecurity and Infrastructure Security Agency](https://www.cisa.gov) has
recently also released the first draft of its [Zero Trust Maturity
Model](https://www.cisa.gov/publication/zero-trust-maturity-model) that
companies can use to evaluate their posture against the zero trust principles.
It is strongly based upon the NIST explanation of zero trust, with attention to
five pillars (identity, device, network/environment, application workload, and
data) and three foundations (visibility and analytics, automation and
orchestration, and governance). Again, we observe some interpretation of what
zero trust could entail, in this particular case how the US government would
like to approach this towards its agencies.

**Why zero trust isn't exactly new**

Attentive readers will already understand that most of the principles or focus
areas in zero trust are not new. Let's take a few of the core components and
principles and see how novel these are.

One of the core components in the zero trust architecture is a policy
enforcement methodology, one that detaches enforcement from declaration.
Separating the mechanism from a policy isn't new. [Decentralized trust
management](https://ieeexplore.ieee.org/document/502679), published in 1996,
attempted to implement the necessary abstractions for it. The [Extensible Access
Control Markup
Language](https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=xacml),
published by OASIS in 2003, is an open standard for integrating the different policy
components.

The ability to perform authentication at all levels of a stack is also not new.
We can execute device authentication using the [Trusted Platform
Module](https://en.wikipedia.org/wiki/Trusted_Platform_Module) for instance,
whose first publication was in 2009. The use of certificates for authenticating
websites is common since [SSL v3 came
about](https://en.wikipedia.org/wiki/Transport_Layer_Security) in 1996.
Authenticating end users through passwords is as old as IT itself, and
multi-factor authentication has had plenty of research since 2005. It is very
popular nowadays since the introduction of the [Time-based One-time Password
(T-OTP)](https://datatracker.ietf.org/doc/html/rfc6238) as published in 2011.

Even the use of user profiling for security analytics isn't novel. In 2004, the
paper on [User profiling for computer
security](https://ieeexplore.ieee.org/abstract/document/1386699) was the start
of what became a very active market in cybersecurity nowadays: User Entity and
Behavior Analytics (UEBA).

The dismissal of the perimeter-only security architecture seems to be the most
specific 'new' principle, although the foundations for security have long been
to not just consider security from a network point of view: starting with the
layered architecture and requirement tracking by Peter G. Neumann's [Practical
Architectures for Survivable Systems and Networks](http://www.csl.sri.com/users/neumann/survivability.pdf)
published in 2000, we have seen the market take up more and more traction on
securing the different layers and assessing security not just based on the
perimeter.

**Personal observations**

Zero trust is energizing the cybersecurity ecosystem, allowing both active
research and commercial evolutions/improvements. With the further
digitization of our environment, the significant increase in exposed services (think
IoT), and users that are always online, companies should indeed ensure that their
services (both external-facing and internal ones) are secure. The
increase in attention through the "zero trust" hype is positive, but should not
be considered completely new. Instead, it is an aggregation of already existing
best practices and designs.

The lack of a common architecture (despite NISTs efforts) is to be expected, as
each company, organization or government has a different architecture and
vision. This, of course, means that decision-makers will need to understand that
"zero trust" is not a pattern to apply blindly. Vendors will attempt to
influence businesses, but without a good understanding of the current
environment and understanding the direction a company wants to go, these will
just be tools. And as the saying goes, "A fool with a tool is still a fool".

Many companies will already have started on their journey to "zero trust"
without having it named as such. Layered security, security in depth, and other
statements already contribute to the zero trust approach. If you want to
approach zero trust, it is wise to consider where you are at already, and what
main principles you want to address next. You can call it "zero trust" or your
"zero trust strategy" to get attention, but beware of external influences that
might want to inject complexity because you called it "zero trust". The benefit
is not in attaining a zero trust compliant architecture, but in ensuring the
company has a good security posture, including the flexibility to adjust as the
environment evolves.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](https://twitter.com/infrainsight/status/TODO).

<!-- PELICAN_END_SUMMARY -->
