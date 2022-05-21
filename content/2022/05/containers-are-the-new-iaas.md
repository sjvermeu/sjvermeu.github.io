Title: Containers are the new IaaS
Date: 2022-05-21 13:00
Category: Architecture
Tags: kubernetes,container,iaas,infrastructure,virtual-machine
Slug: containers-are-the-new-iaas
Status: published

At work, as with many other companies, we're actively investing in new
platforms, including container platforms and public cloud. We use Kubernetes
based container platforms both on-premise and in the cloud, but are also very
adamant that the container platforms should only be used for application
workload that is correctly designed for cloud-native deployments: we do not
want to see vendors packaging full operating systems in a container and
then shouting they are now container-ready.

Sadly, we notice more and more vendors abusing containerization to wrap their
products in and selling it as 'cloud-ready' or 'container-ready'. For many
vendors, containers allow them to bundle everything as if it were an
appliance, but without calling it an appliance - in our organization, we
have specific requirements on appliances to make sure they aren't just
pre-build systems that lack the integration, security, maintainability and
supportability capabilities that we would expect from an appliance.

Even developers are occasionally tempted to enlarge container images with a
whole slew of middleware and other services, making it more monolithic
solutions than micro-services, just running inside a container because they
can. I don't feel that this evolution is beneficial (or at least not yet),
because the maintainability and supportability of these images can be very
troublesome.

This evolution is similar to the initial infrastructure-as-a-service
offerings, where the focus was on virtual machines: you get a platform on top
of which your virtual machines run, but you remain responsible for the virtual
machine and its content. But unlike virtual machines, where many organizations
have standardized management and support services deployed for, containers are
often shielded away or ignored. But the same requirements should be applied to
containers just as to virtual machines.

Let me highlight a few of these, based on my [Process view of
infrastructure]({filename}/2021/09/process-view-of-infrastructure.md).

**Cost and licensing**

Be it on a virtual machine or in a container, the costs and licensing of the
products involved must be accounted for. For virtual machines, this is often
done through license management tooling that facilitates tracking of software
deployments and consumption. These tools often use agents running on the
virtual machines (and a few run at the hypervisor level so no in-VM agents are
needed).

Most software products also use licensing metrics that are tailored to
(virtual) hardware (like processors) or deployments (aka nodes, i.e. a
per-operating-system count). Software vendors often have the right to audit
software usage, to make sure companies do not abuse their terms and
conditions. 

Now let's tailor that to a container environment, where platforms like
Kubernetes can dynamically scale up the number of deployments based on the
needs. Unlike more static virtual machine-based deployments, we now have a
more dynamic environment. How do you measure software usage here? Running
software license agents inside containers isn't a good practice. Instead, we
should do license scanning in the images up-front, and tag resources
accordingly. But not many license management tooling is already
container-aware, let alone aligned with a different way of working.

But "our software license management tooling is not container-ready yet" is
not an adequate answer to software license audits, nor will the people in the
organization that are responsible for license management be happy with such
situations.

**Product lifecycle**

Next to the licensing part, companies also want to track which software
versions are being used: not just for vulnerability management purposes, but
also to make sure the software remains supported and fit for purpose.

On virtual machines, regular software scanning and inventory setup can be done
to report on the software usage. And while on container environments this can
be easily done at the image level (which software and versions are available in
which containers) this often provides a pre-deployment view, and doesn't tell
us if a certain container is being used or not, nor if additional deployments
have been triggered since the container is launched.

Again, deploying in-container scanning capabilities seems to be
contra-productive here. Having an end-to-end solution that detects and
registers software titles and products based on the container images, and then
provides insights into runtime deployments (and history) seems to be a better match.

**Authorization management (and access control)**

When support teams need to gain access to the runtime environment (be it for
incident handling, problem management, or other operational tasks) most
companies will already have a somewhat finer-grained authorization system in
place: you don't want to grant full system administrator rights if they aren't
needed.

For containers, this is often not that easy to accomplish: the design of
container platforms is tailored to situations where you don't want to
standardize on in-container access: runtimes are ephemeral, and support is
handled through logging and metric, with adaptation to the container images
and rolling out new versions. If containers are starting to get used for more
classical workloads, authorization management will become a more active field
to work out.

Consider a database management system within the container alongside the
vendor software. Managing this database might become a nightmare, especially
if it is only locally accessible (within the container or pod). And before you
yell how horrible such a setup would be for a container platform... yes, but
it is still a reality for some.

**Auditing**

Auditing is a core part of any security strategy, logging who did what, when,
from where, on what, etc. For classical environments, audit logging, reporting
and analysis are based upon static environment details: IP addresses,
usernames, process names, etc.

In a container environment, especially when using container orchestration,
these classical details are not as useful. Sure, they will point to the
container platform, but IP addresses are often shared or dynamically assigned.
Usernames are dynamically generated or are pooled resources. Process
identifiers are not unique either.

Auditing for container platforms needs to consider the container-specific
details, like namespaces. But that means that all the components involved in
the auditing processes (including the analysis frameworks, AI models, etc.)
need to be aware of these new information types.

In the case of monolithic container usage, this can become troublesome as the
in-container logging often has no knowledge of the container-specific nature,
which can cause problems when trying to correlate information.

**Conclusion**

I only touched upon a few processes here. Areas such as quality assurance and
vulnerability management are also challenges for instance, as is data
governance. None of the mentioned processes are impossible to solve, but
require new approaches and supporting services, which make the total cost of
ownership of these environments higher than your business or management might
expect.

The rise of monolithic container usage is something to carefully consider. In
the company I work for, we are strongly against this evolution as the enablers
we would need to put in place are not there yet, and would require significant
investments. It is much more beneficial to stick to container platforms for
the more cloud-native setups, and even in those situations dealing with ISV
products can be more challenging than when it is only for internally developed
products.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](https://twitter.com/infrainsight/status/TODO).

<!-- PELICAN_END_SUMMARY -->
