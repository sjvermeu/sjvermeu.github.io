Title: Getting lost in the frameworks
Date: 2022-08-26 13:00
Category: Architecture
Tags: framework,CMMI,ISO
Slug: getting-lost-in-the-frameworks
Status: published

The IT world is littered with frameworks, best practices, reference
architectures and more. In an ever-lasting attempt to standardize IT,
we often get lost in too many standards or specifications. For consultants,
this is a gold-mine, as they jump in to support companies - for a fee, 
naturally - in adopting one or more of these frameworks or specifications.

While having references and specifications isn't a bad thing, there are
always pros and cons.

**The benefits of frameworks and specifications**

The main benefit in having a proper framework or specification, for whatever
task is ahead of you, is that you don't have to reinvent the wheel. If a
framework or specification is well-written, with a good scope aligned with
what you need, then using this will speed up implementations.

Some organizations will even require their outsourcing activities to be
according to a certain framework or specification. This will ensure that the
development results are aligned with how the organization works, improving
integration and validation.

The integration part is a major aspect of standardization as well. As we've
learned from the more physical equivalents (like paper standards, or standards
in construction) having standardized deliverables ensures for efficient
integration, economical comparisons, and more.

**The downsides of frameworks and specifications**

An often cited downside of standardization (and thus also reflecting the use
of frameworks or specifications) is that it stifles innovation, and if the
framework or specification addresses the end product itself, it might result
in the company struggling to find a unique selling proposal.

Frameworks are also often incomplete. Most of the time, that is by design, as
the framework's authors do not want to remove all of the organization's
inputs. I've talked about [ITIL](https://en.wikipedia.org/wiki/ITIL) and 
[CObIT](https://www.isaca.org/resources/cobit) in the past already. Both
are frameworks which leave implementation details open to the organization.
For some companies, that means the benefit of quick adoption and efficiency
might become more challenging to attain.

One of the issues I'm often facing is that there are too many frameworks and
specifications. While any decent one will try to show how it aligns with
other frameworks (while expressing its own benefits, of course), it is very
likely that an organization who adopted one framework will be confronted with
the need (be it through a merger and acquisition, market expansion, insourcing
and outsourcing endeavors or other) to adopt another one. Tailoring an
organization to multiple frameworks is a hassle, especially if there are
requirements for certifications.

Many companies also easily fall in the trap that they have to adhere to
a framework or specification completely and company-wide. This not only
jeopardizes innovation (as mentioned earlier) but also has the downside of
becoming the target by itself. Rather than focusing on attaining the benefits,
the company focuses on attaining alignment with the framework. This not only
impacts the responsiveness of the organization, but can also lead to employee
dissatisfaction.

Finally, plenty of frameworks or specifications can only be accessed after
paying serious amounts of money. For documents that are meant to provide
efficiency and improved integrations, this is a major nuisance.

**There are too damn many**

Let me elaborate a bit on the "too many frameworks". I'm currently working
on a resource (that I'll make public later, when it has a bit more body to it)
where I also consider including a maturity approach. Maturity, or maturity
levels, are a way for an organization to measure the current state of something
(in my case, of an IT process) as well as define where the organization wants
to be, and at what pace.

The maturity model approach that I grew up with is [ISACA's
CMMI](https://cmmiinstitute.com/) or *Capability Maturity Model Integration*.
CMMI prescribes five maturity levels:

- Incomplete (work may or may not be completed, no established goals, processes
  are only partially defined)
- Initial (unpredictable and reactive, work gets completed but often delayed
  and over budget)
- Managed (some management is applied, processes are planned, performed,
  measured and controlled, but there are still lots of issues to address)
- Defined (more proactive than reactive, there are organization-wide standards,
  and guidance exists across projects, programs and portfolios)
- Quantitatively managed (higher degree of measurement and control,
  using quantitative data to determine predictable processes)
- Optimizing (stable and flexible processes, constant state of improving)

While this framework also expresses other things than just the five maturity
levels, this seems to be the most common starting point for maturity
efforts.

But CMMI isn't the only one out there. Process maturity can also be evaluated
by OMG's [Business Process Maturity Model
(BPMM)](https://www.omg.org/spec/BPMM/1.0/About-BPMM/) which also defines
five maturity levels:

- Level 1 isn't explicitly defined further, let's keep it at *Initial*
- Managed
- Standardized
- Predictable
- Innovating

What about the [TMMi model](https://www.tmmi.org/tmmi-model/), which has - 
you guessed it - five maturity levels:

- Initial
- Managed
- Defined
- Measured
- Optimization

There are also frameworks that specialize for specific domains. Given that
this blog is about IT, I have to mention [ISO/IEC
33001](https://en.wikipedia.org/wiki/ISO/IEC_33001), which is a revision of
ISO/IEC 15504, aka the *Software Process Improvement and Capability
 Determination (SPICE)* methodology. It has five (well, six if you also
count the "you have not even started" level) maturity models for the
processes as well:

- Incomplete (level 0)
- Performed
- Managed
- Established
- Predictable
- Optimizing

ITIL also has a capability maturity model in it, which also is expressed in
five levels.

**Many frameworks are paywalled**

Many larger IT frameworks are also paywalled, making it harder for individuals
to easily get access to them. CMMI v2.0 for instance is not publicly accessible,
whereas its previous version seems to be. ISO is notorious for being hard to
find. ITIL and CObIT are also paywalled.

While there is plenty of information "out there" on all these standards, 
frameworks and specifications, you need to grab, collect and disseminate all
information separately which is a major nuisance. Many online resources are
also presented by companies (including consultancy firms) which means you
need to take care and know that these resources are opinionated.

Personally, I try to learn from the publicly available resources in the
following order:

1. Get access to as many public resources from the framework owner as possible.
   While this often only gives a general feeling on the framework, it is defined
   by the framework owner itself and the least opinionated (well, the framework
   itself is opinionated, but the resources about it will try to give a full
   feeling on what the framework is about).
2. Learn more from online resources that are attempting to combine knowledge
   from multiple sources (like Wikipedia), and from sources that are specialized
   in the domain itself without being commercially affiliated with one specific
   framework.
3. Learn more from academic research on the matter (through [Google
   Scholar](https://scholar.google.com)).
4. Read up on the matter in communities from people that are already
   knowledgeable in the matter.
5. Finish with resources available from commercially affiliated companies or
   consultants.

**It is not about the framework but about the benefits**

I want to conclude here with the notion that adherence to the frameworks
should be to attain the benefits. I'm currently very strongly involved in
IT asset management endeavors, and while ensuring that the IT asset management
process is as good as possible, I know that there are subdivisions in the 
company where this adherence with a highly optimized IT asset management
process isn't beneficial (especially when this subdivision is completely
separate from the rest and has a much more specific, specialized purpose).

The scope of the IT asset management process is also not something you want
to address for all possible assets. Some assets are much more involved in risk
processes and cost structures than others, so the "maturity" to attain is
also specific to the scope.

Always keep in mind what you want to reach and why. 

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](https://twitter.com/infrainsight/status/1563143657586585603).

<!-- PELICAN_END_SUMMARY -->
