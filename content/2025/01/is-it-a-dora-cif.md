Title: Is IT a DORA CIF?
Date: 2025-01-27 21:10
Category: Regulation
Tags: dora
Slug: is-it-a-dora-cif
Status: published

Core to the [Digital Operational Resilience
Act]({filename}/2025/01/digital-operational-resilience-act.md) is the notion of
a *critical or important function*. When a function is deemed critical or
important, DORA expects the company or group to take precautions and measures
to ensure the resilience of the company and the markets in which it is active.

But what exactly is a function? When do we consider it critical or important?
Is there a differentiation between critical and important? Can an IT function
be a critical or important function?

**Defining functions**

Let's start with the definition of a *function*. Surely that is defined in the
documents, right? Right?

Eh... no. The [DORA
regulation](https://eur-lex.europa.eu/eli/reg/2022/2554/oj/eng) does not seem
to provide a definition for a function. It does however refer to the
definition of *critical function* in the [Bank Recovery and Resolution
Directive (BRRD), aka Directive
2014/59/EU](https://eur-lex.europa.eu/eli/dir/2014/59/oj/eng). That's one of
the regulations that focuses on the resolution in case of severe disruptions,
bankrupcy or other failures of banks at a national or European level. A
[Delegated regulation EU/
2016/778](https://eur-lex.europa.eu/eli/reg_del/2016/778/oj/eng) further
defines several definitions that inspired the DORA regulation as well.

In the latter document, we do find the definition of a *function*:

> ‘function’ means a structured set of activities, services or operations that
> are delivered by the institution or group to third parties irrespective from
> the internal organisation of the institution;
> 
> Article 2, (2), of Delegated regulation 2016/778

So if you want to be blunt, you could state that an IT function which is only
supporting the own group (as in, you're not insourcing IT of other companies)
is not a function, and thus cannot be a "critical or important function" in
DORA's viewpoint.

That is, unless you find that the definition of previous regulations do not
necessarily imply the same interpretation within DORA. After all, DORA does
not amend the EU 2016/778 regulation. It amends [EC
1060/2009](https://eur-lex.europa.eu/eli/reg/2009/1060/oj/eng), [EU
2012/648](https://eur-lex.europa.eu/eli/reg/2012/648/oj/eng), [EU
2014/600 aka MiFIR](https://eur-lex.europa.eu/eli/reg/2014/600/oj/eng), [EU
2014/909 aka CSDR](https://eur-lex.europa.eu/eli/reg/2014/909/oj/eng) and [EU
2016/1011 aka Benchmark
Regulation](https://eur-lex.europa.eu/eli/reg/2016/1011/oj/eng). But none of
these have a definition for 'function' at first sight.

So let's humor ourselves and move on. What is a *critical function*? Is that
defined in DORA? Not really, sort-of. DORA has a definition for *critical or
important function*, but let's first look at more distinct definitions.

In the BRRD regulation, this is defined as follows:

> ‘critical functions’ means activities, services or operations the
> discontinuance of which is likely in one or more Member States, to lead to
> the disruption of services that are essential to the real economy or to
> disrupt financial stability due to the size, market share, external and
> internal interconnectedness, complexity or cross-border activities of an
> institution or group, with particular regard to the substitutability of
> those activities, services or operations;
> 
> Article 2, (35), of BRRD 2014/59

This extends on the use of *function*, and adds in the evaluation if it is
crucial for the economy, especially when it would be suddenly discontinued.
The extension on the definition of *function* is also confirmed by guidance
that the [European Single Resolution
Board](https://www.srb.europa.eu/en/content/critical-functions) published,
namely that "the function is provided by an institution to third parties not
affiliated to the institution or group".

The preamble of the Delegated regulation also mentions that its focus is at
the safeguarding of the financial stability and the real economy. It gives
examples of potential critical functions such as deposit taking, lending and
loan services, payment, clearing, custody and settlement services, wholesale
funding markets activities, and capital markets and investments activities.

Of course, your IT is supporting your company, and in case of financial
institutions, IT is a very big part of the company. Is IT then not involved in
all of this?

It sure is... 

**Defining services**

The [Delegated regulation EU
2016/778](https://eur-lex.europa.eu/eli/reg_del/2016/778/oj/eng) in its
preamble already indicates that functions are supported by services:

> Critical services should be the underlying operations, activities and
> services performed for one (dedicated services) or more business units or
> legal entities (shared services) within the group which are needed to
> provide one or more critical functions. Critical services can be performed
> by one or more entities (such as a separate legal entity or an internal
> unit) within the group (internal service) or be outsourced to an external
> provider (external service). A service should be considered critical where
> its disruption can present a serious impediment to, or completely prevent,
> the performance of critical functions as they are intrinsically linked to
> the critical functions that an institution performs for third parties. Their
> identification follows the identification of a critical function.
>
> Preamble, (8), Delegated regulation 2016/778

IT within an organization is certainly offering services to one or more of the
business units within that financial institution. Once the company has defined
its critical functions (or for DORA, "critical or important functions"), then
the company will need to create a mapping of all assets and services that are
needed to realize that function.

Out of that mapping, it is very well possible that several IT services will be
considered *critical services*. I'm myself involved in the infrastructure side
of things, which are often shared services. The delegated regulation already
points to it, and a somewhat older guideline from the [Financial Stability
Board](https://www.fsb.org/2013/07/r_130716a/) has the following to say about
critical shared services:

> a critical shared service has the following elements:
> (i) an activity, function or service is performed by either an internal unit, a separate legal
> entity within the group or an external provider;
> (ii) that activity, function or service is performed for one or more business units or legal
> entities of the group;
> (iii) the sudden and disorderly failure or malfunction would lead to the collapse of or
> present a serious impediment to the performance of, critical functions.
> 
> FSB guidance on identification of critical functions and critical shared
> services

For IT organizations, it is thus most important to focus on the services they
offer.

**Definition of critical or important function**

Within [DORA](https://eur-lex.europa.eu/eli/reg/2022/2554/oj/eng), the
definition of *critical or important function* is as follows:

> (22) ‘critical or important function’ means a function, the disruption of
> which would materially impair the financial performance of a financial
> entity, or the soundness or continuity of its services and activities, or
> the discontinued, defective or failed performance of that function would
> materially impair the continuing compliance of a financial entity with the
> conditions and obligations of its authorisation, or with its other
> obligations under applicable financial services law;
>
> Article 3, (22), DORA

If we compare this definition with the previous ones about critical functions,
we notice that it is extended with an evaluation of the impact towards the
company - rather than the market. I think it is safe to say that this is the
*or important* part of the *critical or important function*: whereas a
function is critical if its discontinuance has market impact, a function is
important if its discontinuance causes material impairment towards the company
itself.

Hence, we can consider a critical or important function as being either market
impact (critical) or company impact (important), but retaining externally
offered (function).

This more broad definition does mean that DORA's regulation puts more
expectations forward than previous regulation, which is one of the reasons
that DORA is that impactful to financial institutions.

**Implications towards IT**

From the above, I'd wager that IT itself is not a "critical or important
function", but IT offers services which could be supporting critical or
important functions. Hence, it is necessary that the company has a good
mapping of the functions and their underlying services, operations and
systems. From that mapping, we can then see if those underlying services are
crucial for the function or not. If they are, then we should consider those as
critical or important systems.

This mapping is mandated by DORA as well:

> Financial entities shall identify all information assets and ICT assets,
> including those on remote sites, network resources and hardware equipment,
> and *shall map those considered critical*. They shall map the configuration of
> the information assets and ICT assets and the links and interdependencies
> between the different information assets and ICT assets.
> 
> Article 8, (4), DORA

as well as:

> As part of the overall business continuity policy, financial entities shall
> conduct a business impact analysis (BIA) of their exposures to severe
> business disruptions. Under the BIA, financial entities shall assess the
> potential impact of severe business disruptions by means of quantitative and
> qualitative criteria, using internal and external data and scenario
> analysis, as appropriate. The BIA shall consider the criticality of
> identified and mapped business functions, support processes, third-party
> dependencies and information assets, and their interdependencies. Financial
> entities shall ensure that ICT assets and ICT services are designed and used
> in full alignment with the BIA, in particular with regard to adequately
> ensuring the redundancy of all critical components.
> 
> Article 11, paragraph 2, DORA

In more complex landscapes, it is very well possible that the mapping is a
multi-layered view with different types of systems or services in between,
which could make the effort to identify services as being critical or
important quite challenging. 

For instance, it could be that the IT organization has a service catalog, but
that this service catalog is too broadly defined to use the indication of
critical or important. Making a more fine-grained service catalog will be
necessary to properly evaluate the dependencies, but that also implies that
your business (who has defined their critical or important functions) will
need to indicate which fine-grained service they are depending on, rather than
the high-level services.

In later posts, I'll probably dive deeper into this layered view.

Feedback? Comments? Don't hesitate to get in touch on
[Mastodon](https://discuss.systems/@infrainsight).

<!-- PELICAN_END_SUMMARY -->
