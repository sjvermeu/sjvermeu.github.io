Title: Defining what an IT asset is
Date: 2022-01-13 10:00
Category: Architecture
Tags: asset-management,cobit,itil
Slug: defining-what-an-it-asset-is
Status: draft

One of the main IT processes that a company should strive to have in place
is a decent IT asset management system. It facilitates knowing what assets
you own, where they are, who the owner is, and provides a foundation for
plenty of other IT processes.

However, when asking "what is an IT asset", it gets kinda fuzzy...

**Searching for a definition**

When I went on to search for a definition of an "IT asset", my first
thought was to check on the more common reference frameworks out there.
Surely, if they tout the benefits of a well-functioning IT asset management
system and process, they'll declare what an IT asset is, right?

While many of these frameworks aren't publically readable, they do have
enough material online to hopefully provide me with the necessary insights.

The first focus I had was on ITIL, formerly known as the Information
Technology Infrastructure Library but nowadays just existing as its own
term. There are quite a few articles on the [ITIL Docs](https://www.itil-docs.com/blogs/asset-management)
site on IT asset management, but while they do have some breadcrumbs,
they do not offer a full definition:

* as financial management of IT assets is an important sub-process,
  I can derive that assets are either expected to have a financial
  value, or that such economical assets are a large subset of the
  IT assets in general
* assets always have a lifecycle to follow (although I am not certain
  if this will truly help in deriving a definition)
* assets support the IT in the strategic and financial decision making

I found a [Terms and Definitions](https://itil.it.utah.edu/downloads/ITILv2_Terms_and_Definitions_r2.0_0808.pdf)
extract that has an asset defined as:

> "Component of a business process. Assets can include people, accomodation
> (facilities), computer systems, networks, paper records, fax machines, etc."

Of course, that definition is too broad for IT asset management.

The [NIST 1800-5 IT Asset Management publication](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.1800-5.pdf)
focuses on technologies that are needed to ensure a smooth business operation,
and includes: computers, mobile devices, operating systems, applications,
data, and network resources. It later on mentions that IT assets include items
such as servers, desktops, laptops, and network appliances. And when it
touches upon the value of IT asset management, it too mentions that it is
about informed business-driven decision making.

TODO Add CObIT blurb

[Techopedia](https://www.techopedia.com/definition/16946/it-asset) has it
defined as "a piece of software or hardware within an information technology
environment".

**Deriving my own definition**

From the search, I think I have some grasp of what an IT asset is. Or at
least, how I look at it. I think there are two main attributes that define
if something in an IT environment is an asset or not.

First, it has to offer or realize an IT value to the environment. In many
cases, IT value is seen as automating a business process, or a part of a
business process.

Second, the asset has to have a value of its own. That value contributes to the
company's worth. This is generally an economical value, but can also be 
intangible like intellectual property.

Through these two attributes, I would create the following definition:

TODO Definition

Furthermore, in some processes, a dinstinction is made between regular
IT assets and more critical or important assets. In most cases, I read that
it focuses on the impact that a defect or unavailability of the asset has
to the organization. So, a critical IT asset gets the following definition:

TODO Definition

**Classifying the assets**

Now, while this does provide some definition of what an IT asset is, this is
merely the start of an IT asset management approach. The next thing that,
in my opinion, should take place, is to classify for your own organization
what you consider to be IT assets (and thus want/need to follow the IT
asset management processes for). We've had examples mentioned earlier, like
software, operating systems, servers. But there are plenty more assets
out there.

For instance, a leased line you have between yourself and a third party.
Leased lines are network lines with a certain quality associated with them and
which you lease from a network provider. Quality includes line performance, 
expected availability, recovery capabilities, etc. Such lines have economical
value, and they offer support to the IT processes that use that network.

To create a classification, you might want to start from the conceptual
data model that I've [shared previously](TODO), or rather take from existing
classification models. The [United Nations Standard Products and Services
Code (UNSPSC)](https://www.ungm.org/Public/UNSPSC) has a class list 
published which you can use to tailor your own classification.

Now, the classification to use shouldn't limit itself to IT asset management.
It is often better to first work out this model for the company in general
(including for other processes like solution build and configuration
management), and then derive what classes should be part of the IT asset
management process.

A well maintained classification will also make it easier for the company
to work out how to improve the asset management processes, as they then
have more tangible solutions to focus on.

**Conclusions**

While there does not seem to be a common definition of what an IT asset is,
even working out our own definition is only a first step. After the definition,
building out a good classification system helps out to make IT asset management
more tangible for the organization. And most online resources use such classes
(like servers, desktops, operating systems, ...) to clarify what they consider
as IT assets anyway, rather than attempting to derive a workable definition.

TODO Closure
