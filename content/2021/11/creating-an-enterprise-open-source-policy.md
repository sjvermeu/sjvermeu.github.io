Title: Creating an enterprise open source policy
Date: 2021-11-20 15:00
Category: Architecture
Tags: opensource,enterprise,legal,compliance
Slug: creating-an-enterprise-open-source-policy
Status: published

Nowadays it is impossible to ignore, or even prevent open source from being
active within the enterprise world. Even if a company only wants to use
commercially backed solutions, many - if not most - of these are built with, and
are using open source software.

However, open source is more than just a code sourcing possibility. By having a
good statement within the company on how it wants to deal with open source, what
it wants to support, etc. engineers and developers can have a better
understanding of what they can do to support their business further.

In many cases, companies will draft up an *open source policy*, and in this post
I want to share some practices I've learned on how to draft such a policy.

<!-- PELICAN_END_SUMMARY -->

**Assess the current situation**

When drafting a policy, make sure you know what the current situation already
is. Especially when the policy might be very restrictive, you might be facing a
huge backlash from the organization if the policy is not reflecting the reality.
If that is the case, and the policy still needs to go through, proper
communication and grooming will be needed (and of course, the "upper management
hammer" can help out as well).

Often, higher management is not aware of the current situation either. They
might think that open source is hardly in use. Presenting them with facts and
figures not only makes it more understandable, it will also support the need for
a decent open source policy.

When you have a good view on the current usage, you can use that to track where
you want to go to. For instance, if your company wants to adopt open source more
actively, and pursue open source contributions, you might want to report on the
currently detected contributions, and use that for follow-up later.

**Get HR and compliance involved**

Before you embark on the journey of developing a decent open source policy, make
sure you have management support on this, as well as people from HR and your
compliance department (unless your policy will be extremely restrictive, but
let's hope that is not the case).

You will need (legal &) compliance involved in order to draft and assess the
impact of internal developers and engineers working on open source projects, as
well as the same people working on open source projects in their free time. Both
are different use cases but have to be assessed regardless.

HR is generally involved at a later stage, so they know how the company wants to
deal with open source development. This could be useful for recruitment, but
also for HR to understand what the policy is about in case of issues.

An important consideration to assess is how the company, and the contractual
obligations that the employees have, deals with intellectual property. In some
companies, the contract allows for the employees to retain the intellectual
property rights for their creations outside of company projects. However, that
is not always the case, and in certain sectors intellectual property might be
assumed to be owned by the company whenever the creation is something in which
the company is active. And that might be considered very broadly (such as
anything IT related for employees of an IT company).

The open source policy that you develop should know what the contractual
stipulations say, and clarify for engineers and developers how the company
considers the intellectual property ownership. This is important, as it defines
who can decide to contribute something to open source.

**Understand and simplify license requirements**

Many of the decisions that the open source policy has to clarify will be related
to the open source licenses in use. Moreover, it might even be relevant to
define what open source is to begin with.

A good source to use is the [Open Source Definition](https://opensource.org/osd)
as published and maintained by the [Open Source Initiative
(OSI)](https://opensource.org/). Another definition is the one by the [Free
Software Foundation](https://www.fsf.org/) titled "[What is free software and
why is it so important for society](https://www.fsf.org/about/what-is-free-software)".

The license is the agreement that the owner of the software puts out that
declares how users can use that software. Most, if not all software that a
company uses, will have a license - open source or not. But most commercial
software titles have specific licenses that you need to go through for each
specific product, as the licenses are not reused. In the open source world,
licenses are reused so that end users do not need to go through product-specific
terms.

The OSI organization has a list of [approved
licenses](https://opensource.org/licenses). However, even amongst these
licenses, you will find different types of licenses out there. While they are
commonly grouped into [copyleft](https://en.wikipedia.org/wiki/Copyleft) and
[permissive](https://fossa.com/blog/all-about-permissive-licenses/) open source
licenses, there are two main categories within the copyleft licenses that you
need to understand:

* strong copyleft licenses that require making all source code available upon
  distribution, or sometimes even disclosure of the application base
* "scoped" copyleft licenses that require making only the source code available of the
  modules or libraries that use the open source license (especially if you
  modified them) without impacting the entire application

While the term "strong copyleft" is something that I think is somewhat generally
accepted (such as in the Snyk article "[Open Source Licenses: Types and
Comparison](https://snyk.io/learn/open-source-licenses/)" or in [Wikipedia's
article](https://en.wikipedia.org/wiki/Copyleft)), I do not like to use its
opposite "weak" term, as the licenses themselves do not reduce the open source
identity from the code. Instead, they make sure the scope of the license is
towards a particular base (such as a library) and not the complete application
that uses the license.

Hence, open source policies might want to focus on those three license types for
each of the use cases:

* permissive licenses, like Apache License 2.0 or MIT
* scoped copyleft licenses, like LGPL or EPL-2.0
* strong copyleft licenses, like GPL or AGPL

**Differentiate on the different open source use cases**

There are several use cases that the policy will need to tackle. These are, in
no particular order:

* Using off-the-shelf, ready-to-use open source products
* Using off-the-shelf libraries and modules for development
* Using open source code
* Contributing to open source projects for company purposes
* Contributing to open source projects for personal/private purposes
* Launching and maintaining open source projects from the company

Each of these use cases might have their specific focuses. Combine that with the
license categories listed earlier, and you can start assessing how to deal with
these situations.

For instance, you might want to have a policy that generally boils down to the
following:

* When using off-the-shelf, ready-to-use open source products, all types of
  products are allowed, assuming the organization remains able to support the
  technologies adopted. Furthermore, the products have to be known by the
  inventory and asset tooling used by the company.
* When using libraries or modules in development projects, only open source
  products with permissive or scoped copyleft licenses can be used. Furthermore,
  the libraries or modules have to be well managed (kept up-to-date) and known
  by the inventory and asset tooling used by the company.
* When using open source code, only code that is published with a permissive
  license can be used. At all times, a reference towards the original author
  has to be retained.
* When contributing to open source projects for company purposes, approval has
  to be given by the hierarchical manager of the team. Contributions have to be
  tagged appropriately as originating from the company (e.g. using the company
  e-mail address as author). Furthermore, employees are not allowed to
  contribute code or intellectual property that is deemed a competitive
  advantage for the company.
* When contributing to open source projects for personal/private purposes,
  employees are prohibited to use code from the company or to do contributions
  using their company's e-mail address. However, the company does not claim
  ownership on the contributions an employee does outside the company's projects
  and hours.
* When creating new projects or publishing internal projects as open source,
  sufficient support for the project has to be granted from the company, and the
  publications are preferentially done within the same development services
  (like version control) under management of the company. This ensures
  consistency and control over the company's assets and liability. Projects have
  to use a permissive license (and perhaps even a single, particular license).

Or, if the company actively pursues an open source first strategy:

* Off-the-shelf, ready-to-use open source products are preferred over
  propriatary products. Internal support teams must be able to deal with
  general maintenance and updates. The use of commercially backed products is
  not mandatory, but might help when there is a need for acquiring short-term
  support (such as through independent consultants).
* Development projects must use projects that use permissive or scoped copyleft
  licenses for the libraries and dependencies of that project. Only when the
  development project itself uses a strong copyleft license are dependencies
  with (the same) strong copyleft license allowed. Approval to use a strong
  copyleft license is left to the management board.
* Engineers and developers retain full intellectual property rights to their
  contributions. However, a Contributor License Agreement (CLA) is used to grant
  the company the rights to use and distribute the contributions under the
  license mentioned, as well as initiate or participate in legal actions related
  to the contributed code.

**Clarify what is allowed to be contributed and what not**

In the above example I already indicated a "do not contribute code that is
deemed a competitive advantage" statement. While it would be common sense,
companies will need to clarify this (if they follow this principle) in their
policies so they are not liable for problems later on.

A competitive advantage primarily focuses on a company's crown jewels, but can
be extended with code or other intellectual property (like architectural
information, documentation, etc.) that refers to indirect advantageous
solutions. If a company is a strong data-driven company that gains massive
insights from data, it might refuse to share its artificial intelligence related
code.

There are other principles that might decide if code is contributed or not. For
instance, the company might only want to contribute code that has received all
the checks and controls to ensure it is secure, it is effective and efficient,
and is understandable and well-written. After all, when such contributions are
made in name of the company, the quality of that code reflects upon the company
as well.

I greatly suggest to include examples in the open source policy to clarify or
support certain statements.

**Assess the maturity of an open source product**

When supporting the use of open source products, the policy will also have to
decide which open source products can be used and which ones can't. Now, it is
it possible to create an exhaustive list (as that would defeat the purpose of an
open source policy). Instead, I recommend to clarify how stakeholders can assess
if an open source product can be used or not.

Personally, I consider this from a "maturity" point of view. Open source
products that are mature are less likely to become a liability within a larger
company, whereas products that only have a single maintained (like my own
[cvechecker](https://github.com/sjvermeu/cvechecker) project) are not to be used
without understanding the consequences.

So, what is a mature open source project? There are online resources that could
help you out (like the Qualipso-originated [Open Source Maturity Model
(OSMM)](https://en.wikipedia.org/wiki/OpenSource_Maturity_Model)), but
personally I tend to look at the following principles:

* The project has an active development, with more than 5 active contributors in
  the last three months.
* The project is visibly used by several other projects or products.
* The project has well-maintained documentation, both for developers and for
  users. This can very well be a decent wiki site.
* The project has an active support community, with not only an issue system,
  but also interactive services like forums, IRC, Slack, Discord, etc.
* The project supports more than one major version in parallel, and has a clear
  lifecycle for its support (such as "major version is supported up to at least
  1 year after the next major version is released").
* The project publishes its artefacts in a controlled and secure manner.

**A policy is just the beginning, not the end**

As always, there will be situations where a company wants to allow a one-off
case to deviate from the policy. Hence, make clear how deviations can be
targeted.

For instance, you might want to position an architecture review board to support
deviations from the license usage. When you do, make sure that this governance
body knows how to deal with such deviations - understanding what licenses are,
what the impact might be towards the organization, etc.

Furthermore, once the policy is ready to be made available, make sure you have
support for that policy in the organization, as well as supporting tools and
processes.

You might want to include an internal community to support open source/free
software endeavors. This community can help other stakeholders with the
assessment of a product's maturity, or with the license identification.

You might want to make sure you can track license usage in projects and
deployments. For software development projects, there are plenty of commercial
and free services that scan and present license usage (and other details) for a
project. Inventory and asset management utilities often also include
identification of detected software. Validate that you can report on open source
usage if the demand comes up, and that you can support development and
engineering teams in ensuring open source usage is in line with the company's
expectations.

The company might want to dedicate resources in additional leakage detection and
prevention measures for the open source contributions. While the company might
already have code scanning techniques in place in their on-premise version
control system, it might be interesting to extend this service to the public
services (like [GitHub](https://github.com/) and
[GitLab](https://about.gitlab.com/)). And with that, I do not want to imply
using the same tools and integrations, but more on a functional level.

**Finishing off**

A few companies, and most governmental organizations, publish their open source
policies online. The [TODO Group](https://todogroup.org/) has graceously drafted
a [list of examples and templates](https://github.com/todogroup/policies) to
use. They might be a good resource to use when drafting up your own.

Having a clear and understandable open source policy simplifies discussions, and
with the appropriate support within the organization it might jumpstart
initiatives even further. Assuming the policy is sufficiently supportive of open
source, having it published might eliminate the fear of engineers and developers
to suggest certain open source projects.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](https://twitter.com/infrainsight/status/1462043477835976705).

