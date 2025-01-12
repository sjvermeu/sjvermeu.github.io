Title: Digital Operational Resilience Act
Date: 2025-01-12 22:12
Category: Regulation
Tags: dora
Slug: digital-operational-resilience-act
Status: published

One of the topics that most financial institutions are (still) currently
working on, is their compliance with a European legislation called
[DORA](https://eur-lex.europa.eu/eli/reg/2022/2554/oj/eng).  This abbreviation,
which stands for "Digital Operational Resilience Act", is a European
regulation. European regulations apply automatically and uniformly across all EU
countries. This is unlike another recent legislation called
[NIS2](https://eur-lex.europa.eu/eli/dir/2022/2555/oj/eng), the "Network and
Information Security" directive. As a EU directive, NIS2 requires the EU
countries to formulate the directive into local law. As a result, 
different EU countries can have a slightly different implementation.

The DORA regulation applies to the EU financial sector, and has some strict
requirements in it that companies' IT stakeholders are affected by. It doesn't
often sugar-coat things like some frameworks do. This has the advantage that
its "interpretation flexibility" is quite reduced - but not zero of course.
Yet, that advantage is also a disadvantage: financial entities might have
had different strategies covering their resiliency, and now need to adjust their
strategy.

**History of DORA**

Officially called the Regulation (EU) 2022/2554, DORA was proposed as a new
regulatory framework in September 2020. It aimied to further strengthen the
digital operational resilience of the financial sector. "Operational resilience"
here focuses strongly on cyber threat resilience and operational risks
like IT disasters. On January 16th 2023, the main DORA regulation
[entered into
force](https://www.esma.europa.eu/esmas-activities/digital-finance-and-innovation/digital-operational-resilience-act-dora) 
and will apply as of January 17th 2025. Yes, that's about now.

Alongside the main DORA text, additional standards are being developed too.
These are [Regulatory Technical
Standards](https://www.eba.europa.eu/regulation-and-policy/operational-resilience)
that detail requirements of one or more articles within DORA. The one I
currently come into contact with the most is the [RTS on ICT risk management
framework](https://www.eba.europa.eu/activities/single-rulebook/regulatory-activities/operational-resilience/regulatory-technical-standards-ict-risk-management-framework-and-simplified-ict-risk-management).
This RTS elaborates on various requirements close to my own expertise. However,
other RTS documents are also on my visor to read through, such as the technical
standard on [ICT services supporting critical or important functions provided by
ICT third-party service
providers](https://www.eba.europa.eu/activities/single-rulebook/regulatory-activities/operational-resilience/regulatory-technical-standards-policy-ict-services-supporting-critical-or-important-functions)
and [subcontracting ICT
services](https://www.eba.europa.eu/activities/single-rulebook/regulatory-activities/operational-resilience/joint-regulatory-technical-subcontracting).

During the development of the DORA regulation and these technical standards,
various stakeholders were consulted. The European Supervisory Authorities (ESAs) were 
of course primary stakeholders here, but other stakeholders could also provide
their feedback. This feedback, and the answers or reactions of it by the
legislative branch, help out in understanding parts of the regulation ("am I
reading this right") as well as conveying the understanding of the regulatory
branch about what is stated ("does the regular understand what they are
asking").

DORA is not a first of course. The moment you start reading the regulation, you
notice that it amends previous regulations. These were predecessors, so should
also be seen as part of the "history" of DORA:
- [Regulation (EC) No
  1060/2009](https://eur-lex.europa.eu/eli/reg/2009/1060/oj/eng), which
  regulates the credit rating agencies.
- [Regulation (EU) No
  648/2012](https://eur-lex.europa.eu/eli/reg/2012/648/oj/eng), covering
  regulation on derivatives, central counter parties, and trade repositories.
- [Regulation (EU) No
  600/2014](https://eur-lex.europa.eu/eli/reg/2014/600/oj/eng), regulating the
  markets in financial instruments.
- [Regulation (EU) No
  909/2014](https://eur-lex.europa.eu/eli/reg/2014/909/oj/eng), which focuses on
  securities settlements and central securities depositories.
- [Regulation (EU)
  2016/1011](https://eur-lex.europa.eu/eli/reg/2016/1011/oj/eng), focusing on
  benchmarks in financial instruments and financial contracts, and measuring
  performance of investment funds

Now, these are all market oriented regulations, and while many of these do
sporadically refer to an operational resilience aspect, they require a
significant understanding of that financial market to begin with, which isn't
the case for DORA. But DORA wasn't the first to be more IT oriented.

The first part of the DORA regulation provides context into the actual
legislative articles (which only start one-third into the document). It provides
references to previous publications or legislation that are more IT (or cyber
threat) oriented. This first part is called the "preamble" in EU legislation.

In this preamble, paragraph 15 references [Directive (EU)
2016/1148](https://eur-lex.europa.eu/eli/dir/2016/1148/oj/eng) as the
first broad cybersecurity framework enacted at EU level. It covers a high common
level of security of network and information systems. Yes, that's the "NIS" directive
that recently got a new iteration: [Directive (EU)
2022/2555](https://eur-lex.europa.eu/eli/dir/2022/2555/oj/eng), aka NIS2.
Plenty of other references exist as well. Sometimes these refer to the
legislation that covers certain markets, as listed before. Other references
focus on the supervisory bodies. Many references are towards other legislation
that provides definitions for the used terms.

**Structure of DORA**

The main DORA legislation (so excluding the regulatory technical standards)
covers 64 articles, divided into 9 chapters. But as mentioned earlier, it 
has a quite sizeable preamble that covers context, motivation and interpretation
details for the legislative text. This allows for improved interpretation
of the articles themselves.

More specifically, such a preamble covers the legal basis of the legislation,
and the objectives why the legislation came to be. I found [How to read EU
law](https://fabianbohnenberger.com/2024/04/10/how-to-read-eu-law/comment-page-1/)
by Fabian Bohnenberger to be a very good and quick-to-read overview of how an EU
legislative text is structured. The DORA preamble covers 106 paragraphs already,
and they're not even the actual legislative articles.

So, how are the legislative articles themselves structured like?

- _Chapter I - General provisions_ defines what the purpose of the legislation is
  and its structure (art 1), where the legislation applies to (art 2), 65
  definitions used throughout the legislation (art 3) and the notion that
  proportionality applies (art 4).

- _Chapter II - ICT risk management_ tells the in-scope markets and institutions
  how to govern and organize themselves to cover risk management (art 5), what
  the risk management framework should do (art 6), that they need to have
  fit-for-purpose tooling and procedures to cover risk management (art 7), that
  they need to properly identify risks towards their assets (art 8), need to
  take sufficient measures to protect themselves against various threats (art
  9), be able to detect anomalous activities (art 10), have a response and
  recovery process in place (art 11), have backup/restore processes in place
  (art 12), ensure knowledge of the employees is sound (art 13), be able to
  communicate properly (art 14) and follow regulatory technical standards for
  ICT risk management (art 15). In the end, art 16 covers the requirements for
  smaller financial institutions (as DORA differentiates requirements based on
  the impact, size and some other criteria).

- _Chapter III - ICT-related incident management, classification and reporting_
  describes how to handle ICT incidents (art 17), how to classify these
  incidents and threats (art 18), what reporting expectations exist (art 19),
  and the standardization on the reporting (art 20). The reported incidents are
  centralized (art 21), supervisors will provide answers to the reports (art
  22), and art 23 informs us for which incidents the above is all applicable.

- _Chapter IV - Digital operational resilience testing_ covers the testing of
  the operational resilience. First, general requirements are provided (art 24),
  after which DORA covers the testing of tools and systems (art 25), mandatory
  use of penetration testing (art 26), and how these threat-led penetration
  tests (TLPTs) are carried out (art 27).

- _Chapter V - Managing of ICT third-party risk_ further divulges in managing
  threats related to outsourcing and use of third parties. Art 28 covers the
  general principles, whereas art 29 covers the potential concentration risk
  (aka "if everyone depends on this third party, then..."). Contractual
  expectations are covered in art 30. Further, this chapter covers the
  introduction of an oversight framework for large, critical third-party service
  providers. Art 31 designates when a third-party service provider is deemed
  critical, art 32 covers the oversight structure, art 33 introduces the
  role of the Lead Overseer(s), their operational coordination (art 34), their
  power (art 35), and what their capabilities are outside of the EU (art 36).
  Art 37 covers how the overseer can receive information, if and how
  investigations take place (art 38), how inspections are handled (art 39), how
  this relates to existing oversights (art 40), how the conduct of oversight
  activities is handled (art 41), how authorities follow-up on overseer
  activities (art 42), who will pay for the oversight activities (art 43) and
  the international cooperation amongst regulatory/supervisory bodies (art 44).

- _Chapter VI - Information-sharing arrangements_ has a single article, art 45,
  on threat/intelligence information sharing amongst the financial institutions.

- _Chapter VII - Competent authorities_ assigns the appropriate authorities
  towards the various financial institutions (art 46), how these authorities
  cooperate with others (art 47), and how they cooperate amongst themselves (art
  48). Cross-sector exercises are covered in art 49, and the penalties and
  remedial measures are covered in art 50. Art 51 is how/when administrative
  penalties/measures are imposed, art 52 is when criminal liabilities where
  found. Art 53 requires EU member states to notify the EU institutions about
  related legislation/provisions, art 54 documents how administrative penalties
  are published. Art 55 confirms the professional secrecy of the authorities,
  and art 56 covers the data protection provisions for the authorities.

- _Chapter VIII - Delegated acts_ has one article (art 57) covering by whom this
  legislation is exercised (role of the Commission, Parliament, etc.)

- _Chapter IX - Transitional and final provisions_ is a "the rest" chapter. It
  covers a review of the law and implementations by January 17th 2028 (art 58),
  and then many amendments to existing regulations to make them aligned and
  consistent with the DORA legislation (art 59 - 63). The last article, art 64,
  describes when DORA comes into force and when it shall apply.

For me, chapters II (risk management), IV (resilience testing) and V (third
party risk) are the most interesting as they cover expectations for many IT
processes or controls.

**Regulatory Technical Standards**

Within the DORA legislation, references are made to regulatory technical
standards that need to be drafted up. The intention of the regulatory technical
standards is to further elaborate on the expectations and requirements of DORA.
These RTS documents also have legislative power (hence the "regulatory" in the 
name) and are important to track too.

The RTS that covers the ICT risk framework from article 15 is one that has a
strong IT orientation with it. Like the EU legislative texts, it holds 
a lot of context to begin with. The draft publications also cover the
feedback received and the answers/results from that feedback. It is unlikely
that these will be found in the final published RTS' though.

The current [JC 2023 76 - Final report on draft RTS on ICT Risk Management
Framework and on simplified ICT Risk Management
Framework](https://www.eba.europa.eu/sites/default/files/2024-01/bf5a2976-1a48-44f3-b5a7-56acd23ba55c/JC%202023%2086%20-%20Final%20report%20on%20draft%20RTS%20on%20ICT%20Risk%20Management%20Framework%20and%20on%20simplified%20ICT%20Risk%20Management%20Framework.pdf)
has the actual technical standard between pages 45 and 89. It too uses
chapters to split the text up a bit. After art 1, covering the overall risk
profile and complexity, we have:

- _Chapter I - ICT security policies, procedures, protocols, and tools_ contains
  significant input for various IT processes and domains. It is further subdivided
  into sections:

  - _Section I_ covers what should be in the ICT security policies (art 2),
  - _Section II_ describes the details of the ICT risk management framework (art 3), 
  - _Section III - ICT Asset Management_ covers the ICT asset management expectations (art
  4) and ICT asset management process (art 5), 
  - _Section IV - Encryption and cryptography_ covers cryptography expectations (art 6 and
  7), 
  - _Section V - ICT Operations Security_ handles the ICT operations policies
    (art 8), capacity and performance management (art 9), vulnerability and
    patch management (art 10), data and system security (art 11), logging
    expectations (art 12), 
  - _Section VI - Network security_ is about the network security expectations
    (art 13), and in-transit data protection measures (art 14),
  - _Section VII - ICT project and change management_ covers the ICT project
    management (art 15), ICT development and maintenance activities (art 16),
    and change management (art 17),
  - _Section VIII_ handles physical security measures (art 18)

- _Chapter II - Human Resources Policy and Access Control_ handles HR policies (art 19), identity management
  (art 20), access control (art 21).

- _Chapter III - ICT-related incident detection and response_ , incident management (art 22), anomalous
  activity detection and response (art 23), business continuity (art 24 and 25),
  ICT response and recovery (26)

As you can read from the titles, these are more specific. Don't think "Oh, it is
just a single article" about a subject. Some articles span more than a full
page. For instance, Article 13 on network security has 13 sub-paragraphs.

**DORA for architects**

I think that the DORA legislation is a crucial authority to consider when
you are developing internal policies for EU-based financial institutions. I've
mentioned the use of
[frameworks](https://blog.siphos.be/2022/08/getting-lost-in-the-frameworks/) in
the past, which can inspire companies in the development of their own policies.
Companies should never blindly copy these frameworks (or legislative
requirements) into a policy, because then your policy becomes a mess of
overlapping or sometimes even contradictory requirements. Instead, policies
should refer to these authorities when relevant, allowing readers to understand
which requirements are triggered by which source.

When you're not involved in the development of policies, having a read through
some of the DORA texts might be still sensible as it gives a grasp on what
requirements are pushed to your company. And while we're at it, do the same for
the NIS2 documents, because even if your company is in scope of DORA, NIS2 still
applies (DORA is a specialized law, so takes precedence over what NIS2 asks, but
if DORA doesn't cover a topic and NIS2 does, then you still have to follow
NIS2).

Feedback? Comments? Don't hesitate to get in touch on
[Mastodon](https://discuss.systems/@infrainsight).

<!-- PELICAN_END_SUMMARY -->
