Title: The pleasures of having DTAP
Date: 2021-12-30 12:00
Category: Architecture
Tags: DTAP,environments,zoning,development,test,acceptance,production
Slug: the-pleasures-of-having-DTAP
Status: published

No, not Diphtheria, Tetanus, and Pertussis (vaccine), but *Development,
Test, Acceptance, and Production (DTAP)*: different environments that,
together with a well-working release management process, provide a way to
get higher quality and reduced risks in production. DTAP is an important
cornerstone for a larger infrastructure architecture as it provides
environments that are tailored to the needs of many stakeholders.

<!-- PELICAN_END_SUMMARY -->

**What are these four environments?**

Let's go over the four environments one by one with a small introduction
to their purpose. I'll cover more specific use cases further down in this
post.

The *Development* environment is a functionally complete environment on
which the development of products or code is done. It should have the same
technologies in place and very similar setups (deployments) so that
developers are not facing a too different environment. Too much difference
might imply different behavior, which is contra-productive. The environment
is accessible by developers and testers, and is mainly development-oriented.

Products or code that are being developed will be visible and used in this
environment. Developers and engineers hardly have any threshold to reach for
deploying or modifying code here.

The *Testing* environment is used when the development has reached a phase
where the product or code has passed a minimum of quality. Unit tests
succeed, the code builds fine, and the developer has indicated that the
code or product is ready for wider testing (hence the name).

A testing environment generally applies a multitude of tests, most of
them (hopefully) automated, but with a strong dependency on testers
(also known as Quality Assurance engineers or QA engineers) to find issues.

The automated tests focus on integrations, regression testing, security
testing, etc., and provide insights into the new builds or products which the
development team can take up and iterate over to improve the product.

The *Acceptance* environment is a production-like environment, not
just for one product, but for the entire business or business unit: the same
setup, the same infrastructure, the same foundations, the same application
portfolio, the same integrations, etc. This environment intends to 
validate that the product is fully ready to be released. It is often
also abbreviated as the *User Acceptance Testing (UAT)* environment.

While the testing environment is generally approached by QA engineers, the
acceptance environment should be more tailored to business testers. When
developers or engineers introduce a feature, the stakeholders that
requested that feature use the acceptance environment to accept if the
coming release fulfills their request or not.

As the environment is production-like in its entirety (and not just for
a single product), it is a prime target for executing performance tests
as well. Cross-product dependencies and processes (like migrations) are
validated here too.

The *Production* environment is the environment in which the product or
code "goes live", where the customers use it. That does not mean that
a product put in production is immediately accessible for the customers:
there is still a difference between deployment (bring to production),
activation (enable usage), and release (use by customers).

While DTAP is well-known in larger organizations, there are some challenges
or misconceptions that I would like to point out, and which I discuss
further down:

- Environments are more than just the systems where the code is deployed to.
  Each environment has production services associated with it.
- A prime challenge to implementing DTAP is the cost associated with it. But
  it does not need to be as expensive as you think, and DTAP implementations
  often have a positive business case.
- Agile methodologists might find DTAP to be old-style. They are correct
  that many implementations are prohibitive towards fast deployment and
  release strategies, but that isn't because DTAP is conceptually wrong.
- Not all environments need the same data. On the contrary, a proper DTAP
  design likely uses separate datasets in each environment to deal with 
  the security and regulatory requirements.

**Conceptual environments still require production services**

The purpose of each environment is strongly tied to the 'phase' in which
the code or the product resides in the development lifecycle. That means
that these environments have a strong focus on that product or code, and
not on the services that are needed.

Indeed, a development environment also entails services that are already
'in production', like a usable workstation, development services like
code repositories and build systems, ticketing services, and more. A testing
environment requires test automation engines, regression test frameworks,
security tools, and more. All these services are production-ready - and they
often have their own DTAP environments as well.

It is a common misconception that a development-oriented system or service
has a lower SLA or lower risk profile than production, and infrastructure
architecture should make clear that there is a difference between the
systems that host the products or code under review and the systems that
facilitate the functionality needed within the environment.

**Static cost is a major inhibitor for implementing DTAP**

Smaller companies or organizations might be hesitant to introduce DTAP
environments as it might be cost-prohibitive. While it is true
that, from a 'static' view, a DTAP environment costs more than a
production-only environment, you need to consider the impact of implementing
DTAP in the processes.

The main purpose of DTAP is not to make your CFO angry, but to improve the
quality of your production environment (and usage). Ask yourself: how costly
is it when your production systems go down, or when your customers complain
and you need to fix things... Do you update code directly on the server(s)?
What if a security patch is rolled out and suddenly prevents your
customer-facing application from working?

While DTAP mentions four environments, some companies settle with three, and
others with five or more. Perhaps your testing and acceptance are done by the
same people, and you do not have many automated testing facilities at hand.
Splitting your pre-production environments into multiple environments doesn't
make sense yet, and you might first want to focus on improving your testing
maturity in general.

If you want to make the case for DTAP, consider the use cases or scenarios that
have visibly disrupted your business and how/where the environments would have
helped. In many cases, you'll notice that there is a positive business case
for a step-wise move towards DTAP.

Furthermore, a proper design of these environments will facilitate an
economical view towards DTAP. 

- You can use pay-as-you-use environments (as is commonly the case in the 
  public cloud) which you only activate when you do your testing. If you have
  a 24/7 customer-facing service in production, that doesn't mean that your
  acceptance environment has to be 24/7. Yes, it should be as much
  production-like as possible, but if it isn't doing anything outside
  business hours, then you don't need it running outside business hours.
- Commercial products often have distinct terms and conditions for
  non-production usage. You can have databases in production with a
  premium, gold service level agreement, while having the same database in
  the other environments with a low, bronze service level agreement
  towards that vendor: cheaper, but technically the same.
- Abstraction and virtualization technologies allow for better control
  of the resources that are being used. For instance, you can have
  an acceptance environment that is only at 20% of the resources
  of production for day-to-day validation, and then increase its resources
  to 100% for load testing periods. If these environments are not in a
  pay-as-you-use model, shifting resources from one environment to
  another allows for controlling the costs.
- Security controls in these environments might be different as well,
  assuming that these environments have different data needs: if you
  use fictitious data in development and testing, and anonymized data
  in acceptance, then the investments on, say, data leakage controls
  might be different for these environments.

Hence, while DTAP is at first glance a costly approach, the actual case is
that it is positive for the company.

**DTAP is not inefficient, but some implementations are**

In a world where "Release fast, release often" is the norm, having a rigid
DTAP strategy might be contra-productive. However, this is more an
implementation concern than a conceptual one. If I consider the downsides
that [Christiaan Verwijs](https://medium.com/the-liberators/want-to-be-agile-drop-your-dtap-pipeline-7dcb496fe9e3)
mentions in his post, I feel that I can safely state that this is not due
to the lifecycle of the code or product, but rather the choices that a
company has made while assessing and implementing a release strategy.

There is no need to bundle and make bulk releases with DTAP. You can
perfectly design an environment where DevOps teams can release easily
to production. More so, the bulk release strategy is frequently the result
of an application design constraint, not a deployment constraint.

Development methodologies and DTAP environments do need to be tailored
to each other. The purpose of DTAP is to facilitate the quality of products
and code, and thus should be tailored towards efficient and qualitative
development processes. In many environments, DTAP is synonymous with
"infrastructure operations" and that's a wrong approach. 
Operations-oriented teams (like *Site Reliability Engineers (SREs)*),
development-oriented teams, and DevOps teams all have the same benefits from
DTAP.

Some might state that an acceptance environment is no longer suitable in
the modern age, as they can deploy products and code to production without
losing the benefits of the acceptance environment. With blue/green
deployments or canary releases, you can enable business testers and
stakeholders to validate new features or code before releasing it
to the wider public.

To accomplish this properly, however, the platform that is used will
balance resources accordingly, and you're conceptually implementing an
(albeit temporary) acceptance environment in an automated way. This is
an implementation choice and has to be balanced against the requirements
that the organization has.

For instance, if you work with sensitive data, you might not be allowed
to use this data during testing. In Europe, the *General Data Protection
Regulation (GDPR)* is a strong regulatory requirement for dealing with
sensitive data. It isn't a playbook though: companies need to evaluate
how and where data is used, and perhaps the balance made by the company
allows, if not with explicit consent, to use data unmodified for
acceptance testing. But if that isn't the case and your acceptance tests
need to use sanitized data, then having separate environments is likely
more sensible (although different implementations exist that allow
for anonymization in production as well - they're, however, not as easy
to implement).

Plus, DTAP does not imply that production is doing everything in a single
unit of work: Deploy, Activate and Release. You can still perfectly position
those tasks in production while having an explicit acceptance environment.

**Separate datasets in each environment make sense**

For regulated companies and organizations, security officers might want
to use the DTAP distinction to focus on data minimization strategies as well.
As mentioned before, the GDPR is a strong regulatory requirement whose
alignment can be facilitated by a well-designed DTAP approach.

You can use fictitious data in development and testing, with development
using datasets that developers use for validating the specific functionality
they are working on (and preferably share and put alongside the code
and products), whereas testing uses a coherent but still fictitious
dataset. I use "coherent" here as an indication that the data should
be functionally correct and integer: a (fictitious) person record in the
customer database in the testing environment should be mapped to the
(fictitious) calls or other interactions that are stored in the support
database (also in the testing environment) and the (fictitious) portfolio
that this (fictitious) person has in the product database (in the testing
environment).

Don't underestimate how powerful, but also how challenging a good fictitious
dataset is.

For acceptance testing, perhaps the company decided that anonymized data
is to be used. Or it uses pseudonymized data (which is a weaker form)
with additional technical controls to prevent leakage and attacks (including
inference) that try to deduce the origin of the data.

Again, these are choices by the company or organization, which need to be
taken with the risk and business stakeholders.

**Conclusion**

DTAP is a sensible approach for improving quality in products and code.
While it isn't the holy grail for quality assurance, it has solid
foundations that many larger companies and organizations feel comfortable
with. The implementation details make or break how well-adjusted the DTAP
approach is for modern development processes and regulatory requirements.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](https://twitter.com/infrainsight/status/TODO).

