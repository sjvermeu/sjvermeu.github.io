Title: Scale is a cloud threat
Date: 2021-09-28 17:00
Category: Architecture
Tags: cloud,vulnerability
Slug: scale-is-a-cloud-threat
Status: published

Not that long ago, a vulnerability was found in [Microsoft Azure Cosmos
DB](https://docs.microsoft.com/en-us/azure/cosmos-db/), a NoSQL SaaS database
within the Microsoft Azure cloud. The vulnerability, which is dubbed
[ChaosDB](https://chaosdb.wiz.io/) by the [Wiz Research
Team](https://twitter.com/wiz_io), uses a vulnerability or misconfiguration in
the [Jupyter Notebook
feature](https://docs.microsoft.com/en-us/azure/cosmos-db/cosmosdb-jupyter-notebooks)
within Cosmos DB. This vulnerability allowed an attacker to gain access to
other's Cosmos DB credentials. Not long thereafter, a second vulnerability
dubbed
[OMIGOD](https://www.wiz.io/blog/omigod-critical-vulnerabilities-in-omi-azure)
showed that cloud security is not as simple as some vendors like you to believe.

These vulnerabilities are a good example of how scale is a cloud threat. Companies
that do not have enough experience with public cloud might not assume this in
their threat models.

<!-- PELICAN_END_SUMMARY -->

**Perimeter controls and isolation domains**

Before tackling the scale of a cloud service, let's consider an on premise
service. Services that run on premise for a company are often built up
specifically for that company, and have no relationship with other customers of
the same service. Taking the NoSQL example, companies can perfectly run NoSQL
database services on premise that have no internet presence. Moreover, these
services are also often not directly exposed to the internet.

Running services within your own premises reduces the likelihood that attackers
exploit vulnerabilities of that service. Attackers that are not particularly
eyeballing your company might not know you have that service on premise. Even if
they do know, having proper protections in place should prevent direct access to
those services.

![On premise services]({static}/images/202109/cloud-scale-on-premise.png)

Some situations do require services to expose themselves to the internet. This
exposure increases the *attack surface* for the service significantly.
However, these services are still part of a rather isolated deployment that I
call an **isolation domain**: a logical aggregation of services that share
one or more integrations and interactions, broadening the scope of
potential vulnerabilities and misconfigurations.

Separate isolation domains imply that vulnerabilities or misconfigurations
that rely on information from the domain cannot spread. This is not the same as
separate deployments or environments, as those often do share certain
integrations. For instance, all NoSQL databases within a company might use that
company's identity provider for federated authentication. But NoSQL databases
exposed to the internet from two completely different companies are often in
separate isolation domains.

The Cosmos DB vulnerability exploited the fact that all Cosmos DB deployments
are part of the same isolation domain.

**Perimeter and isolation domain challenges for public cloud**

Public cloud platform services, like Cosmos DB, are often lacking these two
attributes: they have different perimeter protections in place, and share the
same isolation domain.

I do not want to imply that public cloud providers do not provide perimeter
protections against their services. They most definitely do, but the scope of
the perimeter is different from what a company would apply. Whereas a company
gains some measurable security by hiding services or ensuring those services are
not reachable from unauthorized contexts, public cloud platform services need to
be easily accessible for the public cloud to become successful. Security
paradigms like [Zero
Trust](https://www.nist.gov/publications/zero-trust-architecture) are needed to
raise the security posture of these services. Companies that are building
solutions within the public cloud will find that this requires a different
mindset, and that these environments are not comparable with the traditional
on-premise designs.

For the Cosmos DB vulnerability, the FAQ mentions that instances that are not
internet facing are still somewhat impacted (as the credentials could have been
leaked) but accessing the database (by using the credentials) will not be
possible without additional vulnerabilities or misconfigurations being
addressed. This is comparable to an administrator password leakage for your
properly isolated on-premise database: while your database might not be
immediately accessible by attackers, you're still going to change the password
as soon as possible to prevent it from being used in later attacks.

![Public cloud platform services]({static}/images/202109/cloud-scale-public-cloud.png)

The isolation domain is a bigger hurdle to take though, as this is almost always
by design. Platform services always share interactions or integrations across
all the customers of the public cloud. Even though you have your own logical
deployment (or even ask for your own physical deployment), the main interface to
access your service is shared. The service you use to authenticate users or
systems is shared (even when it will eventually use federated authentication to
your own identity provider, the initial service is still the same).

This shared isolation domain makes each public cloud service a fantastic target
for attackers (and luckily also security researchers). Exploits might not just
reveal data or insights from one customer, but from thousands of customers all
over the world. And the bigger the cloud provider, the bigger the impact.

**Shared control planes also imply sharing the isolation domain**

This problem of using a shared isolation domain is not restricted to public
cloud platform services only. Even on premise deployments that use a public
control plane are taking part in the same isolation domain as all other
customers of the same service.

![Control plane also implies sharing isolation domains]({static}/images/202109/cloud-scale-control-plane.png)

Suppose you set up a big data platform on premise, but use your vendor's SaaS
service as a control plane to manage this big data platform. This SaaS service
is also used by the other customers of that vendor, so your deployment is part
of the same isolation domain.

While such setups have benefits (such as using the same control plane for
multiple deployments across different environments and even hosting setups, and
not having to manage and maintain the control services yourself) they do
increase the risk exposure in a not dissimilar fashion from the pure public
cloud services.

**How to tackle these concerns**

Knowing about these increased risks (reachability/exposure, and the shared
isolation domain) is the foremost important part that this article wants to
address. Once these risks are considered, companies can start taking
precautions. I've mentioned the zero trust model as a way to address the
reachability/exposure risk. To address the shared isolation domain, reducing the
impact of a successful exploit can be done through proper architecture and
design that uses the "it is not if, but when" principle for cyberattacks.

For instance, the data within the databases can use application-level encryption
(meaning the encryption is not done by or through the database, but by the
front-end application that interacts with the database) to reduce the impact of
data leakage through such vulnerabilities. Proper data governance processes
should also be in place to remove any data that is no longer needed on that
database. Active security validations on log data should exist to detect
deviating access patterns, and access controls should be in place to prevent
unauthorized access even from succesfully authenticated users or systems.

In the Cosmos DB case, the vulnerability was possible through a selectable
feature: deployments that do not have the Jupyter Notebook feature active would
not leak the credentials. Hence, proper configuration management of services and
disabling features that are not going to be used is paramount for cloud
services.

**Conclusions**

If architects are sufficiently aware of the added risks of public cloud
services, they can properly balance these risks against the benefits of the
public cloud, and make appropriate adjustments to the architecture and design of
the solutions. The main challenge here is to make sure this awareness is raised,
and that this awareness is not only reaching the architects, but also the
engineers and other stakeholders. If not, architects risk that they will be seen
as "innovation inhibitors" if they would recommend changes and improvements to
tackle these risks.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](https://twitter.com/infrainsight/status/1442867880639401989).

