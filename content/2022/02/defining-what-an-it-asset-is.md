Title: Defining what an IT asset is
Date: 2022-02-13 13:00
Category: Architecture
Tags: asset-management,cobit,itil
Slug: defining-what-an-it-asset-is
Status: published

One of the main IT processes that a company should strive to have in place
is a decent IT asset management system. It facilitates knowing what assets
you own, where they are, who the owner is, and provides a foundation for
numerous other IT processes.

However, when asking "what is an IT asset", it gets kind off fuzzy...

**Searching for a definition**

When I went on to search for a definition of an "IT asset", my first
thought was to check on the more common reference frameworks out there.
Surely, if they tout the benefits of a well-functioning IT asset management
system and process, they will declare what an IT asset is, right?

Many of these frameworks do not have their resources publicly available. They do have
enough material online to provide me with the necessary insights.

The first focus I had was on ITIL, formerly known as the Information
Technology Infrastructure Library. There are quite a few articles on the [ITIL
Docs](https://www.itil-docs.com/blogs/asset-management) site on IT asset
management, but while they do have some breadcrumbs, they do not offer a full
definition:

* as financial management of IT assets is an important sub-process,
  I can derive that assets are either expected to have a financial
  value, or that such economical assets are a large subset of the
  IT assets in general
* assets always have a lifecycle to follow (although I am uncertain
  if this will help in deriving a definition)
* assets support the IT in the strategic and financial decision-making

I found a [Terms and Definitions](https://itil.it.utah.edu/downloads/ITILv2_Terms_and_Definitions_r2.0_0808.pdf)
extract that has an asset defined as:

> "[An IT asset is a] component of a business process. Assets can include
> people, accommodation (facilities), computer systems, networks, paper records,
> fax machines, etc."

Of course, that definition is too broad for IT asset management.

The [NIST 1800-5 IT Asset Management publication](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.1800-5.pdf)
focuses on technologies that ensure a smooth business operation.
It includes computers, mobile devices, operating systems, applications,
data, and network resources. It later mentions that IT assets include items
such as servers, desktops, laptops, and network appliances. And when it
touches upon the value of IT asset management, it too mentions that it is
about informed business-driven decision-making.

In [ISACA's CObIT](https://www.isaca.org/resources/cobit), IT assets are
frequently mentioned. Here as well, there is a strong indication that they
relate to a financial part and a value delivery part. For instance, in the
objective "Ensured Benefits Delivery", we find:

> "Create and maintain portfolios of I&T-enabled investment programs, IT
> services and IT assets, which form the basis for the current IT budget and
> support the I&T tactical and strategic plans"

There is an entire objective called "Managed Assets" which covers the bulk of
the IT asset management practice. It again refers to the assets, but focuses
less on the definition of what an IT asset is, and more on what it supports.
For instance:

> "Manage I&T assets [...] to make sure that their use delivers value at optimal
> cost, they remain operational (fit for purpose), and they are accounted for
> and physically protected."

In the practice of managing an inventory, the references are towards IT assets
that are "required to deliver services and that are owned or controlled by the
organization with an expectation of future benefit".

[Techopedia](https://www.techopedia.com/definition/16946/it-asset) has it
defined as "a piece of software or hardware within an information technology
environment."

On [Wikipedia's "Asset (computer
security)"](https://en.wikipedia.org/wiki/Asset_(computer_security)) page, 
the definition refers to the ISO/IEC 13335-1:2004 publication, and summarizes it
as "any data, device, or other component of the environment that supports
information-related activities." It also refers to an older ENISA page
(archived), and looking at the current [ENISA
Glossary](https://www.enisa.europa.eu/topics/threat-risk-management/risk-management/current-risk/risk-management-inventory/glossary)
it covers the following definition:

> "[An IT asset is] anything that has value to the organization, its business
> operations and their continuity, including Information resources that support
> the organization's mission."

ENISA appears to quote ISO/IEC PDTR 13335-1 as well.

**Deriving a definition**

From the search, I think I have some grasp of what an IT asset is. Or at
least, how I look at it. Two main attributes exist that define if something in
an IT environment is an asset or not.

First, it has to offer or realize an IT value to the environment. Often, 
IT value is about automating (a part of a) business process.

Second, the asset has to have a value of its own. That value is typically 
economical, but can also be intangible, like intellectual property.

Through these two attributes, I would create the following definition:

> An IT asset is anything that provides visible IT value towards the
> organization, and has an intrinsic value on its own. A visible IT value is
> generally in support of IT automation. An intrinsic value can be economical,
> but also a capital asset like intellectual property tied to the IT asset
> itself.

Some processes make a distinction between regular IT assets and more critical
(or important) assets. In most cases, I read that it focuses on the impact that
a defect or unavailability of the asset has on the organization. So, a critical
IT asset gets the following definition:

> A critical (or important) IT asset is an IT asset that directly realizes a
> (business or IT) service, where the business impact (in case of exploited risk
> or unavailability) is non-trivial.

This distinction is visible in CObIT for instance, which is the framework that
I'm most used to working with. CObIT has different activities related to
critical/important IT assets compared to general IT assets. A computer mouse
might be an IT asset, but it is not a critical/important asset. Or, at least, I
hope your company isn't going to feel it if one mouse is malfunctioning.

While having a definition to work with is essential to confirm the scope for
the activities a company needs to attend to, the next step isn't to run off
and tag everything that seems to fit the definition. Instead, I recommend
first starting by classifying the IT assets.

**Classifying the assets**

Next you want to classify for your organization what you consider to be IT
assets. This clarifies which types you want to follow the IT asset management
processes for. We've had examples mentioned earlier, like software, operating
systems, servers, but there are plenty more assets out there.

For instance, a leased line you have between yourself and a third party is an IT
asset. Leased lines are network lines with a certain quality associated with
them and which you lease from a network provider. Their quality attributes
include line performance, expected availability, recovery capabilities, etc.
Such lines have economical value, and they offer support to the IT processes
that use that network.

To create a classification, you might want to start with the conceptual
data model that I've [shared
previously]({filename}/2022/01/an-it-conceptual-data-model.md). You can, of
course, also use an existing classification model. The [United Nations Standard
Products and
Services Code (UNSPSC)](https://www.ungm.org/Public/UNSPSC) has a class list
published which you can use to tailor your classification.

The classification shouldn't limit itself to IT asset management.
It is often better to work out this model for the company in general first
(including requirements from other processes like solution build and
configuration management) and then derive what classes should be part of the IT
asset management process.

A well-maintained classification will also make it easier for the company
to work out how to improve the asset management processes. It enables the search
for more tangible solutions, a more structured analysis of the current
situation, and easier discussions with the stakeholders.

**Conclusions**

While there does not appear to be a commonly accepted definition of what an IT
asset is, most frameworks do have similar concepts attributed to IT assets.
Common concepts are the value the assets deliver to the organization, and the
value the assets hold themselves. Trying to create a good definition helps in
trying to grasp at what level an IT asset should exist.

Yet, working out a definition is only a first step. After the definition,
building out a good classification system helps to make IT asset management
more tangible for the organization. Most online resources use such classes
(like servers, desktops, operating systems, ...) to clarify what they consider
as IT assets, rather than attempting to derive a workable definition.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](TODO).

<!-- PELICAN_END_SUMMARY -->
