Title: Virtualization vs abstraction
Date: 2021-06-03 10:10
Category: Architecture
Tags: architecture,virtualization,abstraction
Slug: virtualization-vs-abstraction
Status: published

When an organization has an extensively large, and heterogeneous
infrastructure, infrastructure architects will attempt to make itless
complex and chaotic by introducing and maintaining a certain degree of
standardization. While many might consider standardization as a
rationalization (standardizing on a single database technology, single
vendor for hardware, etc.), rationalization is only one of the many ways
in which standards can simplify such a degree of complexity.

In this post, I'd like to point out two other, very common ways to
standardize the IT environment, without really considering a
rationalization: abstraction and virtualization.

<!-- PELICAN_END_SUMMARY -->

**Abstraction: common and simplified interfaces**

The term "abstraction" has slightly different connotations based on the
context in which the term is used. Generally speaking, an abstraction
provides a less detailed view on an object and shows the intrinsic qualities
upon which one looks at that object. Let's say we have a PostgreSQL database
and a MariaDB database. An abstract view on it could find that it has a lot
of commonalities, such as tabular representation of data, a network-facing
interface through which their database clients can interact with the
database, etc.

We then further generalize this abstraction to come to the generalized
"relational database management system" concept. Furthermore, rather than
focusing on the database-specific languages of the PostgreSQL database and
the MariaDB database (i.e. the commands that database clients send to the
database), we abstract the details that are not shared across the two, and
create a more common set of commands that both databases support.

Once you standardize on this common set of commands, you get more freedom in
exchanging one database technology for the other. This is exactly what
happened several dozen years ago, and resulted in the SQL standard
(ISO/IEC 9075). This standard is a language that, if all your relational
database technologies support it, allows you - as an organization - to work
with a multitude of database technologies while still having a more efficient
and standardized way of dealing with it.

Now, the SQL language standard is one example. IT is filled with many other
examples, some more formally defined as standards than others. Let's look at
a more recent example, within the area of application containerization.

**CRI and OCI are abstraction implementations**

When the Docker project, now supported through the Docker company, started
with enabling application containerization in a more efficient way, it leaned
upon the capabilities that the Linux kernel offered on hiding information and
isolating resources (namespaces and control groups) and expanded on it to
make it user friendly. It was an immediate hit, and has since then resulted
in a very competitive market.

With Docker, applications could be put in more isolated environments and run
in parallel on the same system, without these applications seeing the other
ones. Each application has its own, private view on the system. With these
containers, the most important service that is still shared is the kernel,
with the kernel offering only those services to the containers that it can
keep isolated.

![Container runtime abstraction]({static}/images/202106/container-runtimes.jpg)
*Source: [https://merlijn.sebrechts.be/blog/2020-01-docker-podman-kata-cri-o/](https://merlijn.sebrechts.be/blog/2020-01-docker-podman-kata-cri-o/)*

Now, while Docker can be easily attributed to bringing this to the wider
public, other initiatives quickly followed suit. Multiple container
technologies were coming to life, and started to bid for a place in the
containerization market. To be able to compete here, many of these attempted
to use the same interfaces (be it system calls, commands or other) as Docker
used, so the users can more easily switch. But while trying to copy and
implement the same interfaces is a possible venue, it is still strongly
controlled by the evolution that Docker is taking.

Since then, larger projects like Kubernetes have started introducing an
abstraction between the container runtime (which implements the actual
containerization) and the container definitions and management (which uses
the containerization). Within Kubernetes for instance, this is through the
Common Runtime Interface (CRI), and the Open Container Interface (OCI) is
used to link the container runtime management with the underlying container
technologies.

Introducing such an abstraction is a common way to establish a bit more
foothold in the market. Rather than trying to copy the market leader
verbatim, you create an intermediate layer, with immediate implementation
for the market leader as well, but with the promise that anyone that uses
the intermediate layer will be less tied to a single vendor or project: it
abstracts that vendor or project specifics away and shows mainly the
intrinsic qualities needed.

If that abstraction is successful, other implementations for this abstraction
layer can easily come in and replace the previous technology.

**Abstraction is not virtualization**

The introduction of abstraction layers, abstract technologies or abstract
languages should not be misunderstood for virtualization. Abstraction does
not hide or differently represent the resources beneath. It does not represent
itself as something else, but merely leaves out details that might make
interactions with the different technologies more complex.

Virtualization on the other hand takes a different view. Rather than removing
the specific details, it represents a resource as something that it isn't
(or isn't completely). Hypervisors like KVM create a virtual hardware view,
and translates whatever calls towards the virtual hardware into calls to the
actual hardware - sometimes to the same type of hardware, but often towards
the CPU or resources that simulate the virtualized hardware further.

Abstraction is a bit like classification, and defining how to work with a
resource through the agreed upon interfaces for that class. If you plug in
a USB device like a USB stick or USB keyboard or mouse, operating systems
will be able to interact with it regardless of its vendor and product,
because it uses the abstraction offered by the device classes: the USB mass
storage device class for the USB stick, or the USB human interface device
class for the keyboard and mouse. It abstracts away the complexity of
dealing with multiple implementations, but the devices themselves still
need to be classified as such.

On hypervisors, you can create a virtual USB stick which in reality is just
a file on the hypervisor host or on a network file share. The hypervisor
virtualizes the view towards this file as if it is a USB stick, but in reality
there is no USB involved at all. Again, this doesn't have to be the case,
the hypervisor might as well enable virtualization of the USB device and
still eventually interact with an actual USB device.

**VLANs are virtualized networks**

Another example of a virtualization is network virtualization through the
use of VLANs. In a virtual local area network (VLAN), all systems that
interact with this VLAN will see each other on the network as if they are
part of the same broadcast domain. Well, they are part of the same broadcast
domain. But if you look at the physical network implementation, this does not
imply that all these systems are attached to the same switch, and that no
routers are put in between to facilitate the communication.

In larger enterprises, the use of VLANs is ubiquitous. Network virtualization
enables the telco teams and departments to optimize the actual physical
network without continuously impacting the configurations and deployments of
the services that use the network. Teams can create hundreds or thousands of
such VLANs while keeping the actual hardware investments under control, and
even be able to change and manage the network without impacting services.

This benefit is strongly tied to virtualization, as we see the same in
hardware virtualization for server and workstation resources. By offering
virtualized systems, the underlying hardware can be changed, replaced or
switched without impact on the actual software that is running within the
virtualized environment. Well, mostly without impact, because not all
virtualization technologies or implementations are creating a full
virtualized view - sometimes shortcuts are created to improve efficiency
and performance. But in general, it works Just Fine (tm).

Resource optimization and consolidation is easily accomplished when using
virtualization. You need far fewer switches in a virtualized network, and
you need far fewer servers for a virtualized server farm. But, it does come
at a cost.

**Virtualization introduces different complexity**

When you introduce a virtualization layer, be it for network, storage,
hardware or application runtimes, you introduce a layer that needs to be
actively managed. Abstraction is often much less resource intensive, as it
is a way to simplify the view on the actual resources while still being 100%
aligned with those underlying resources. Virtualization means that you need
to manage the virtualized resources, and keep track of how these resources
map to the actual underlying resources.

![vSphere services]({static}/images/202106/vsphere.png)
*Source: [https://virtualgyaan.com/vmkernel-components-and-functionality/](https://virtualgyaan.com/vmkernel-components-and-functionality/)*

Let's look at virtualized hardware for servers. On top of it, you have to
run and maintain the hypervisor, which represents the virtual hardware to
the operating systems. Within those (virtually running) operating systems,
you have a virtual view on resources: CPU, memory, etc. The sum of all
(virtual) CPUs is often not the same as the sum of all (actual) CPUs
(depending on configuration of course), and in larger environments the
virtual operating systems might not even be running on the same hardware
as they did a few hours ago, even though the system has not been restarted.

Doing performance analysis implies looking at the resources within (virtual)
as well as mapped on the actual resources, which might not be of the same
type. A virtual GPU representation might be mapped to an actual GPU (and if
you want performance, I hope it is) but doesn't have to be. I've done
investigations on a virtual Trusted Platform Module (TPM) within a virtual
system running on a server that didn't have a TPM.

**Assessing which standardization to approach**

When I'm confronted with an increase in IT complexity, I will often be
looking at a certain degree of standardization to facilitate this in the
organization. But what type of standardization to approach depends strongly
on the situation.

Standardization by rationalization is often triggered by cost optimization
or knowledge optimization. An organization that has ten different relational
database technologies in use could benefit of a rationalization in the number
of technologies to support. However, unless there is also sufficient
abstraction put in place, this rationalization can be intensive. Another
rationalization example could be on public cloud, where an organization
chooses to only focus on a single or two cloud providers but not more.

While rationalization is easy to understand and explain, it does have adverse
consequences: you miss the benefits of whatever you're rationalized away,
and unless another type of standardization is put in place, it will be hard
to switch later on if the rationalization was ill-advised or picked the
wrong targets to rationalize towards.

Standardization by abstraction focuses more on simplification. You are
introducing technologies that might have better interoperability through
this abstraction, but this can only be successful if the abstraction is
comprehensive enough to still use the underlying resources in an optimal
manner.

My own observation on abstraction is that it is not commonly accepted by
engineers and developers at face value. It requires much more communication
and explanation than rationalization, which is often easy to put under "cost
pressure". Abstraction focuses on efficiency in a different way, and thus
requires different communication. At the company I currently work for,
we've introduced the Open Service Broker (OSB) API as an abstraction for
service instantiation and service catalogs, and after even more than a
year, including management support, it is still a common endeavor to
explain and motivate why we chose this.

Virtualization creates a highly efficient environment and supports resource
optimizations that aren't possible in other ways. Its benefits are much easier
to explain to the organization (and to management), but has a downside that
is often neglected: it introduces complexity. Hence, virtualization should
only be pursued if you can manage the complexity, and that it isn't much
worse than the complexity you want to remove. Virtualization requires
organizational support which is more platform-oriented (and thus might be
further away from the immediate 'business value' IT often has to explain),
in effect creating a new type of technology within the ever increasing
catalog of IT services.

**Software-defined infrastructure**

While virtualization has been going around in IT for quite some time (before
I was born), a new kid on the block is becoming very popular: software-defined
infrastructure. The likes of Software Defined Network (SDN), Compute (SDC) and
Storage (SDS) are already common or becoming common. Other implementations,
like the Software Defined Perimeter, are getting jabbed by vendors as well.

Now, SDI is not its own type of standardization. It is a way of managing
resources through code, and thus is a way of abstracting the infrastructure.
But unlike using a technology-agnostic abstraction, it pulls you into a
vendor-defined abstraction. That has its pros and cons, and as an architect
it is important to consider how to approach infrastructure-as-code, as SDI
implementations are not the only way to accomplish this.

Furthermore, SDI does not imply virtualization. Certainly, if a technology
is virtualized, then SDI will also easily interact with it, and help you
define and manage the virtualized infrastructure as well as its underlay
infrastructure. But virtualization isn't a prerequisite for SDI.

**Conclusion**

When you're confronted with chaos and complexity, don't immediately start
removing technologies under the purview of "rationalization". Consider your
options on abstraction and virtualization, but be aware of the pros and cons
of each.


