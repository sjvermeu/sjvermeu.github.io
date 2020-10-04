Title: Documenting configuration changes
Date: 2018-01-07 21:20
Category: Security
Tags: xccdf,scap,baseline
Slug: documenting-configuration-changes

IT teams are continuously under pressure to set up and maintain infrastructure services quickly, efficiently and securely. As an infrastructure architect, my main concerns are related to the manageability of these services and the secure setup. And within those realms, a properly documented configuration setup is in my opinion very crucial.
 
In this blog post series, I'm going to look into using the *Extensible Configuration Checklist Description Format (XCCDF)* as the way to document these. This first post is an introduction to XCCDF functionally, and what I position it for.
 
<!-- PELICAN_END_SUMMARY -->

**Documentation is a good thing**
 
With the ongoing struggle for time and resources, documenting configurations and architectures is often not top-of-mind. However, the lack of this information also leads to various problems: incidents due to misconfiguration, slow recovery timings due to incomprehensible setups, and not to forget: meetings. Yes, meetings, which are continuously discussing service aspects that influence one or more parameters, without any good traceability of past decisions.
 
Some technologies allow to keep track of some metadata regarding to configurations. In configuration management tools like [Puppet][puppet] or [Saltstack][saltstack] engineers define the target state of their infrastructure, and the configuration management tool enforces this state on the service. Engineers can add in historical information as comments into these systems, and use version control on the files to have traceability of the settings.
 
[puppet]: https://puppet.com
[saltstack]: https://saltstack.com
 
However, although in-line comments are very important, even for configuration sets, it is not a full documentation approach. In larger environments, where you are regularly audited for quality and security, or where multiple roles and stakeholders need to understand the settings and configuration of services, pointing to the code is not going to cut it.
 
Configuration items need to be documented not solely with the documentation rule itself, but with the motivation related to it, and additional fields of interest depending on how the organization deals with it. This documentation can then be referred to from the configuration management infrastructure (so engineers and technical stakeholders can trace back settings) but also vice-versa: the documentation can refer to the configuration management implementation (so other stakeholders can deduce how the settings are implemented or even enforced).
 
With a proper configuration document at hand, especially if it is supported through the configuration management tool(s) in the organization (regardless if it is one or multiple), it is much easier to have the necessary interviews with auditors, project leaders, functional and technical analysts, architects or even remote support teams.
 
**Two-part documentation hierarchy**
 
The first thing to decide upon is at which level a team will document the settings. Is a single document possible for all infrastructure services? Most likely not. I believe that settings should be documented on the technology level (as it is specific to a particular technology) and on the 'business service' level (as it is specific to a particular implementation).
 
On the technology level, we're talking about configuration documentation for "PostgreSQL", "Apache Knox" or "Nginx". At this level, the baseline is defined for a technology. The resulting document is then the *configuration baseline* for that component.
 
On the business service level, we're talking about configuration documentation for a particular service that is a combination of multiple implementations. For instance, a company intranet portal service is operationally implemented through a reverse proxy (HAProxy), an intelligent load balancer (Seesaw), next-gen firewall (pfSense), web server (Nginx), application server (Node.js), database (PostgreSQL), and operating systems (Linux). And more technologies come into play when we consider software deployment, monitoring, backup/restore, software-defined network, storage provisioning, archival solutions, license management services, etc.
 
Hence, a configuration document should be available on this service level ("company intranet portal") which defines the usage profile of a service (more about that later) and the specific parameters related to this service, but only when they either deviate from the configuration baseline, or take a particular value within a range defined in the configuration baseline. This document is the *service technical configuration*.
 
So, as an example, on the Nginx configuration baseline, a rule might state that the maximum file size per upload is 12M (through the `client_max_body_size` parameter). If the service has no problem with this rule, then it does not need to be documented on the service technical configuration. However, if this needs to be adapted (say that for the company portal the maximum file size is 64M) then it is documented.
 
Another example is a ranged setting, where the baseline identifies a set of valid values and the service technical configuration makes a particular selection. For instance, the Nginx configuration baseline might mention that there must be between 5 and 50 worker processes (through the `worker_processes` parameter). In the service technical configuration the particular value is then selected.
 
From an architecture and security point of view, the first example is a deviation which must consider the risks and consequences that are applicable to the rule. These are (or should be) documented in the configuration baseline, including where this deviation can be approved (assuming the organization has a decision body for such things). The second example is not a deviation and, as such, is free to be chosen by the implementation team. The configuration baseline will generally inform the implementation teams about how to pick a proper value.
 
**Service usage profiles**
 
I've talked about a *service usage profile* earlier up, but didn't expand on it yet. So, what are these service usage profiles?
 
Well, most technologies can be implemented for a number of targets and functional purposes. A database could be implemented as a dedicated service (one set of databases on a dedicated set of instances for a single business service) or a shared service (multiple databases, possibly on multiple instances for several business services). It can be tuned for online transactional purposes (OLTP) or online analytical processing (OLAP), often through data warehouse designs.
 
A service usage profile is part of the configuration baseline, with settings specific to that particular usage. So for a database the engineering team responsible for the database technology setup might devise that the following usage profiles are applicable to their component:
 
- Dedicated OLTP
- Shared OLTP
- Dedicated DWH
- Shared DWH
 
Each usage profile has a number of configuration settings (of which many, if not most, are shared across other usage profiles) and a range of valid values (fine-tuning for a service). The service technical configuration for a particular business service then selects the particular usage profile. For instance, the company intranet portal might use a Dedicated OLTP usage profile for its PostgreSQL database.
 
**How XCCDF supports this structure**
 
Until now, I've only spoken about the values related to configuration documentation, and a high-level introduction to the hierarchy on the configurations. But how does the [Extensible Configuration Checklist Description][xccdf] position itself in this?
 
[xccdf]: https://scap.nist.gov/specifications/xccdf/
 
A number of reasons why XCCDF is a valid choice for configuration documentation are given next.
 
- XCCDF allows technical writers to write the documentation in (basic) HTML while still linking the documentation to specific rules. Rather than having to use a tabular expression on all the valid configuration sets (like using a large spreadsheet table for all rules) and trying to force some documentation in it (Excel is not a text editor), XCCDF uses a hierarchical approach to structure documentation in logical sections (which it calls *Groups*) and then refers to the rules applicable to that section (using the *Rule* identifier).
 
- XCCDF has out-of-the-box support for service profiles (through *Profile* declarations). Fine-tuning and selecting profiles is called *tailoring* in XCCDF. This also includes support for ranged values.
 
- XCCDF is meant to (but does not have to) refer to the (automated or interview-based) validation of the rules as well. Automated validation of settings means that an engine can read the XCCDF document (and the referred statements) and check if an implementation adheres to the baseline. The standard for this is called *Open Vulnerability and Assessment Language (OVAL)*, and a popular free software engine for this is [OpenSCAP][openscap]. The standard for interview-based validation is *Open Checklist Interactive Language (OCIL)*. I have not played around with OCIL and supporting tooling, so comments on this are always welcome.
 
[openscap]: https://www.open-scap.org
 
- XCCDF is an XML-based format, so its "source code" can easily be versioned in common version control systems like Git. This allows organizations to not only track changes on the documentation, but also have an active development lifecycle management on the configuration documentation.
 
- XCCDFs schema implies a set of metadata to be defined during various declarations. It includes support for the [Dublin core metadata][dmci] terms for content, references to link other resources structurally, and most importantly has a wide set of supporting entities for rules (which is the level on which configuration items are documented). This includes the rationale (why is the rule defined as is), fix text (human readable), fix (machine readable), rule role (is it security-sensitive and as such must be taken up in a security assessment report or not), severity (how bad is it if this rule is not followed), and many more. This both forces the user to consider the consequences of the rule, as well as guide the writer into properly structured documentation.
 
[dmci]: http://www.dublincore.org/specifications/
 
- XCCDF also suggests a number of classes for the documentation to standardize certain information types. This includes warnings, critical text, examples, and instructions. Such semantic declarations allow for a more uniform set of documentation.
 
However, a few constraints exist that you need to be aware of when approaching XCCDF.
 
- XCCDF is an XML-based document format, and although NIST offers the necessary XML Schema definitions, writing proper XML has always been a challenge for many people. Also, no decent GUI or WYSIWYG tool that manages XCCDF files exists in my opinion. Yes, we have the [SCAP Workbench][scap-workbench] and the [eSCAPe editor][escape], but I feel that they are not as effective as they should be. As a result, the team or teams that write the baselines should either be XML-savvy, or you need to provide supporting infrastructure and services for it. However, YMMV.
 
[scap-workbench]: https://www.open-scap.org/tools/scap-workbench/
[escape]: https://www.g2-inc.com/scap.html
 
- If the organization is not interested in compliance checks themselves (i.e. automated validation of adherence to the configuration baseline and service technical configuration) then XCCDF will entail too much overhead versus just having a template or approach (such as documenting items in a wiki). However, with some support (and perhaps automation) writing and maintaining XCCDF based configuration baselines becomes much easier.
 
**More resources**
 
In the past I've [blogged about XCCDF][xccdfblog] already, but that was with a previous blog technology and the migration wasn't as successful as I originally thought. XML snippets were all removed, and I'm too lazy to go back to my backups from 2013 and individually correct blogs.
 
[xccdfblog]: http://blog.siphos.be/tag/xccdf/
 
A good resource on XCCDF is the [NIST IR-7275 publication (PDF)][nistir-7275] which covers the XCCDF standard in much detail.
 
[nistir-7275]: https://csrc.nist.gov/CSRC/media/Publications/nistir/7275/rev-4/final/documents/nistir-7275r4_updated-march-2012_clean.pdf
 
The Center for Internet Security (CISecurity) maintains more than a hundred [CIS Benchmarks][cisbenchmarks], all available for free as PDFs, and are often based on XCCDF (available to subscribed members).
 
[cisbenchmarks]: https://www.cisecurity.org/cis-benchmarks/
 
In the next blog post, I'll talk about the in-document structure of a good configuration baseline.

