Title: Structuring a configuration baseline
Date: 2018-01-17 09:10
Category: Security
Tags: xccdf,scap,baseline
Slug: structuring-a-configuration-baseline

A good configuration baseline has a readable structure that allows all stakeholders to quickly see if the baseline is complete, as well as find a particular setting regardless of the technology. In this blog post, I'll cover a possible structure of the baseline which attempts to be sufficiently complete and technology agnostic.
 
If you haven't read the blog post on [documenting configuration changes][prevblog], it might be a good idea to do so as it declares the scope of configuration baselines and why I think XCCDF is a good match for this.
 
[prevblog]: {filename}/2018/01/documenting-configuration-changes.md
 
<!-- PELICAN_END_SUMMARY -->

**Chaptered documentation**
 
As mentioned previously, a configuration baseline describes the configuration of a particular technological service (rather than a business service which is an integrated set of technologies and applications). To document and maintain the configuration state of the technology, I suggest the following eight chapters (to begin with):
 
1. Architecture
2. Operating system and services
3. Software deployment and file system
4. Technical service settings
5. Authentication, authorization, access control and auditing
6. Service specific settings
7. Cryptographic services
8. Data and information handling
 
Within each chapter, sections can be declared depending on how the technology works. For instance, for database technologies one can have a distinction between system-wide settings, instance-specific settings and even database-specific settings. Or, if the organization has specific standards on user definitions, a chapter on "User settings" can be used. The above is just a suggestion in an attempt to cover most aspects of a configuration baseline.
 
With the sections of the chapter, rules are then defined which specify the actual configuration setting (or valid range) applicable to the technology. But the rule goes further than just a single-line configuration setting description.
 
Each rule should have a *unique identifier* so that other documents can reliably link to the rules in the document. Although XCCDF has a convention for this, I feel that the XCCDF way here is more useful for technical referencing while the organization is better off with a more human addressable approach. So while a rule in XCCDF has the identifier `xccdf_com.example.postgresql_rule_selinux-enforcing` the human addressable identifier would be `postgresql_selinux-enforcing` or even `postgresql-00001`. In the company that I work for, we already have a taxonomy for services and a decision to use numerical identifiers on the configuration baseline rules.
 
Each rule should be properly described, documenting what the rule is for. In case of a ranged value, it should also document how this range can be properly applied. For instance, if the number of worker threads is based on the number of cores available in the system, document the formula.
 
Each rule should also document the risk that it wants to mitigate (be it a security risk, or a manageability aspect of the service, or a performance related tuning parameter). This aspect of the baseline is important whenever an implementation wants an exception to the rule (not follow it) or a deviation (different value). Personally, to make sure that the baseline is manageable, I don't expect engineers to immediately fill in the risk in great detail, but rather holistically. The actual risk determination is then only done when an implementation wants an exception or deviation, and then includes a list of potential mitigating actions to take. This way, a 300+ rule document does not require all 300+ rules to have a risk determination, especially if only a dozen or so rules have exceptions or deviations in the organization.
 
Each rule should have sources linked to it. These sources help the reader understand what the rule is based on, such as a publicly available secure configuration baseline, an audit recommendation, a specific incident, etc. If the rule is also controversial, it might benefit from links to meeting minutes.
 
Each rule might have consequences listed as well. These are known changes or behavior aspects that follow the implementation of the rule. For instance, a rule might state that TLS mutual authentication is mandatory, and the consequence is that all interacting clients must have a properly defined certificate (so proper PKI requirements) as well as client registration in the application.
 
Finally, and importantly as well, each rule identifies the scope at which exceptions or deviations can be granted. For smaller groups and organizations, this might not matter that much, but for larger organizations, some configuration baseline rules can be "approved" by a small team or by the application owner, while others need formal advise of a security officer and approval on a decision body.
 
**Finding a balanced approval hierarchy**
 
The exception management for configuration baselines should not be underestimated. It is not viable to have all settings handled by top management decision bodies, but some configuration changes might result in such a huge impact that a formal decision needs to be taken somewhere, with proper accountability assigned (yes, this is the architect in me speaking).
 
Rather than attempting to create a match for all rules, I again like to keep the decision here in the middle, just like I do with the risk determination. The maintainer of the configuration baseline can leave the "scope" of a rule open, and have an intermediate decision body as the main decision body. Whenever an exception or deviation is asked, the risk determination is made and filled in, and with this documented rule now complete a waiver is asked on the decision body. Together with the waiver request, the maintainer also asks this decision body if the rule in the future also needs to be granted on that decision body or elsewhere.
 
The scope is most likely tied to the impact of the rule towards other services. A performance specific rule that only affects the application hosted on the technology can be easily scoped as being application-only. This means that the application or service owner can decide to deviate from the baseline. A waiver for a rule that influences system behavior might need to be granted by the system administrator (or team) as well as application or service owners that use this system. Following this logic, I generally use the following scope terminology:
 
- tbd (to be determined), meaning that there is no assessment done yet
- application, meaning that the impact is only on a single application and thus can be taken by the application owner
- instance, meaning that the impact is on an instance and thus might be broader than a single application, but is otherwise contained to the technology. Waivers are granted by the responsible system administrator and application owner(s)
- system, meaning that the impact is on the entire system and thus goes beyond the technology. Waivers are granted by the responsible system administrator, application owner(s) and with advise from a security officer
- network, meaning that the impact can spread to other systems or influence behavior of other systems, but remains technical in nature. Waivers are granted by an infrastructure architecture board with advise from a security officer
- organization, meaning that the impact goes beyond technical influence but also impacts business processes. Waivers are granted by an architecture board with advise from a security officer and senior service owner, and might even be redirected to a higher management board.
- group, meaning that the impact influences multiple businesses. Waivers are granted by a specific management board
 
Each scope also has a "-pending" value, so "network-pending". This means that the owner of the configuration baseline suggests that this is the scope on which waivers can be established, but still needs to receive formal validation.
 
The main decision body is then a particular infrastructure architecture board, which will redirect requests to other decision bodies if the scope goes beyond what that architecture board handles.
 
**Architectural settings**
 
The first chapter in a baseline is perhaps the more controversial one, as it is not a technical setting and hard to validate. However, in my experience, tying architectural constraints in a configuration baseline is much more efficient than having a separate track for a number of reasons.
 
For one, I strongly believe that architecture deviations are like configuration deviations. They should be documented similarly, and follow the same path as configuration baseline deviations. The scope off architectural rules are also all over the place, from application-level impact up to organization-wide.
 
Furthermore, architectural positioning of services should not be solely an (infrastructure) architecture concern, but supported by the other stakeholders as well, and especially the responsible for the technology service.
 
For instance, a rule could be that no databases should be positioned within an organizations *DeMilitarized Zone (DMZ)*, which is a network design that shields off internally positioned services from the outside world. Although this is not a configuration setting, it makes sense to place it in the configuration baseline of the database technology. There are several ways to validate automatically if this rule is followed, depending for instance the organization IP plan.
 
Another rule could be that web applications that host browser-based applications should only be linked through a reverse proxy, or that a load balancer must be put in front of an application server, etc. This might result in additional rules in the chapter that covers access control as well (such as having a particular IP filter in place), but these rules are the consequence of the architectural positioning of the service.
 
**Operating system and services**
 
The second chapter covers settings specific to the operating system on which the technology is deployed. Such settings can be system-wide settings like Linux' sysctl parameters, services which need to be enabled or disabled when the technology is deployed, and deviations from the configuration baseline of the operating system.
 
An example of the latter depends of course on the configuration baseline of the operating system (assuming this is a baseline for a technology deployed on top of an operating system, it could very well be a different platform). Suppose for instance that the baseline has the `squashfs` kernel module disabled, but the technology itself requires squashfs, then a waiver is needed. This is the level where this is documented.
 
Another setting could be an extension of the SSH configuration (the term "services" in the chapter title here focuses on system services, such as OpenSSH), or the implementation of additional audit rules on OS-level (although auditing can also be covered in a different section).
 
**Software deployment and file system**
 
The third chapter focuses on the installation of the technology itself, and the file system requirements related to the technology service.
 
Rules here look into file ownership and permissions, mount settings, and file system declarations. Some baselines might even define rules about integrity of certain files (the *Open Vulnerability and Assessment Language (OVAL)* supports checksum-based validations) although I think this is better tackled through a specific integrity process. Still, if such an integrity process does not exist and automated validation of baselines is implemented, then integrity validation of critical files could be in scope.
 
**Technical service settings**
 
In the fourth chapter, settings are declared regarding the service without being service-specific. A service-specific setting is one that requires functional knowledge of the service, whereas technical service settings can be interpreted without functionally understanding the technology at hand.
 
Let's take PostgreSQL as an example. A service-specific setting would be the maximum number of non-frozen transaction IDs before a VACUUM operation is triggered (the `autovacuum_freeze_max_age` parameter). If you are not working with PostgreSQL much, then this makes as much sense as [Prisencolinensinainciusol][gibberishsong]. It sounds like English, but that's about as far as you get.
 
[gibberishsong]: https://en.wikipedia.org/wiki/Prisencolinensinainciusol
 
A technical service setting on PostgreSQL that is likely more understandable is the runtime account under which the database runs (you don't want it to run as root), or the TCP port on which it listens. Although both are technical in nature, they're much more understandable for others and, perhaps the most important reason of all, often more reusable in deployments across technologies.
 
This reusability is key for larger organizations as they will have numerous technologies to support, and the technical service settings offer a good baseline for initial secure setup. They focus on the runtime account of the service, the privileges of the runtime account (be it capability-based on Linux or account rights on Windows), the interfaces on which the service is reachable, the protocol or protocols it supports, etc.
 
**Authentication, authorization, access control and auditing**
 
The next chapter focuses on the *Authentication, Authorization and Accounting (AAA)* services, but slightly worded differently (AAA is commonly used in networking related setups, I just borrow it and extend it). If the configuration baseline is extensive, then it might make sense to have separate sections for each of these security concepts.
 
Some technologies have a strong focus on user management as well. In that case, it might make sense to first describe the various types of users that the technology supports (like regular users, machine users, internal service users, shared users, etc.) and then, per user type, document how these security services act on it.
 
**Service specific settings**
 
The next chapter covers settings that are very specific to the service. These are often the settings that are found in the best practices documentation, secure deployment instructions of the vendor, performance tuning parameters, etc.
 
I tend to look first at the base configuration and administration guides for technologies, and see what the main structure is that those documents follow. Often, this can be borrowed for the configuration baseline. Next, consider performance related tuning, as that is often service specific and not related to the other chapters.
 
**Cryptographic services**
 
In this chapter, the focus is on the cryptographic services and configuration.
 
The most well-known example here is related to any TLS configuration and tuning. Whereas the location of the private key (used for TLS services) is generally mentioned in the third chapter (or at least the secure storage of the private key), this section will focus on using this properly. It looks at selecting proper TLS version, making a decent and manageable set of ciphers to support, enabling *Online Certificate Status Protocol (OCSP)* on web servers, etc.
 
But services often use cryptographic related algorithms in various other places as well. Databases can provide transparent data file encryption to ensure that offline access to the database files does not result in data leakage for instance. Or they implement column-level encryption.
 
Application servers might support crypto related routines to the applications they host, and the configuration baseline can then identify which crypto modules are supported and which ones aren't.
 
Services might be using cryptographic hashes which are configurable, or could be storing user passwords in a database using configurable settings. OpenLDAP for instance supports multiple hashing methods (and also supports storing in plain-text if you want this), so it makes sense to select a hashing method that is hard to brute-force (slow to compute for instance) and is salted (to make certain types of attacks more challenging).
 
If the service makes use of stored credentials or keytabs, document how they are protected here as well.
 
**Data and information handling**
 
Information handling covers both the regular data management activities (like backup/restore, data retention, archival, etc.) as well as sensitive information handling (to comply with privacy rules).
 
The regular data management related settings look into both the end user data handling (as far as this is infrastructurally related - this isn't meant to become a secure development guide) as well as service-internal data handling. When the technology is meant to handle data (like a database or LDAP) then certain related settings could be both in the service specific settings chapter or in this one. Personally, I tend to prefer that technology-specific and non-reusable settings are in the former, while the data and information handling chapter covers the integration and technology-agnostic data handling.
 
If the service handles sensitive information, it is very likely that additional constraints or requirements were put in place beyond the "traditional" cryptographic requirements. Although such requirements are often implemented on the application level (like tagging the data properly and then, based on the tags, handle specific fine-grained access controls, archival and data retention), more and more technologies provide out-of-the-box (or at least reusable) methods that can be configured.
 
**An XCCDF template**
 
To support the above structure, I've made an [XCCDF template][template] that might be a good start for documenting the configuration baseline of a technology. It also structures the chapters a bit more with various sections, but those are definitely not mandatory to use as it strongly depends on the technology being documented, the maturity of the organization, etc.
 
[template]: {static}/static/2018/xccdf-template.xml
 
