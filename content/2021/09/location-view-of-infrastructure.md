Title: Location view of infrastructure
Date: 2021-09-07 18:00
Category: Architecture
Tags: architecture,location,network,virtualization,protocol
Slug: location-view-of-infrastructure
Status: published

In this last post on the infrastructure domain, I cover the fifth and final
viewpoint that is important for an infrastructure domain representation, and
that is the *location view*. As mentioned in previous posts, the viewpoints I
think are most representative of the infrastructure domain are:

* [process view]({filename}/2021/09/process-view-of-infrastructure.md)
* [service view]({filename}/2021/06/an-it-services-overview.md)
* [component view]({filename}/2021/08/component-view-of-infrastructure.md)
* [zoning view]({filename}/2017/06/structuring-infrastructural-deployments.md)
* location view

Like with the component view, the location view is a layered approach. While I
initially wanted to call it the network view, "location" might be a broader
term that matches the content better. Still, it's not a perfect name, but the
name is less important than the content, not?

![Location view representation]({static}/images/202109/location-view.png)

Let's go through the layers from bottom to top.

**Easiest to represent: geographic location and facilities**

The geographic location is the least IT-specific view out there, as it
represents where everything is in the world. These views are popular not only to
scope projects better (like data center locations) but also to support getting
important infrastructural metrics.

WAN latency, for instance, is limited by the distance (you can't outsmart
physics), and by knowing the path between two points, you can calculate the
throughput and latency (such as through the [Wintelguy WAN Latency
Estimator](https://wintelguy.com/wanlat.html)). When designing redundant network
connections between separate locations, you might depend on multiple line
providers. To ensure there are no chokepoints where both providers have their
lines go through the same location, you can ask for the fiber path details to
validate this.

![A10's DDoS Threat Intelligence
map]({static}/images/202109/a10-ddos-threat-intelligence.jpg)
*Source: [A10 Networks](https://www.a10networks.com/), through their [DDoS
Threat Intelligence
Service](https://www.a10networks.com/products/network-security-services/threat-intelligence-service/)*

Using geographic locations also facilitates understanding by other stakeholders,
even if it has a less technological impact on the case at hand. For instance,
while undergoing active DDoS attacks, a geographic representation of where they
come from helps to get more understanding from management, even though on
network-level you're more interested in the Autonomous System (AS) networks that
are involved. Those are very large groups of networks that cover the main
global-wide routing of data.

If we drill down from a geographic location, the next view is the
facility-related one. Here, the view focuses on building design and
infrastructure (such as HVAC and power distribution in data rooms or data
centers), as well as the location of individual devices (floor plans, rack
spaces). Facility views help not just with initial network designs where you
want to onboard a new headquarter location, but also with capacity management
within data centers (identifying hotspots), dealing with wireless networks and
their impact on the surroundings, cable management for networks, ensuring the
resilience of infrastructure services and more.

A decent facility view is very helpful when dealing with operational technology
environments (IoT), and can be dynamically generated. A while ago, I was at a
conference where they showed people's movement based on the data received from
their smartphones. They used the view to see which areas were too crowded (it
was pre-COVID times), as well as to see if there are sudden movements that might
indicate problems or threats.

**Foundations for networks: connectivity, underlay, and virtualization**

The next three layers in the location view focus on the foundations for a
company's network. They are strongly IT oriented with the main stakeholders
being the telco- and infrastructure related teams and roles. Unlike the higher
level viewpoints, the foundations require more thought in their design as errors
are harder to correct.

The connectivity focuses on the cabling and other connections made between
devices. This includes backplane-related connectivity, something that is
relevant when using enclosures or pre-engineered systems. Connectivity and
cabling seem rudimentary, but are critical for the proper functioning of a
network. Remember the science report about possible faster-than-light
neutrino's? Well, a [faulty connection was partially to
blame](http://blogs.nature.com/news/2012/02/faster-than-light-neutrino-measurement-has-two-possible-errors.html).

The network underlay is the network view that network engineers have on their
network. For small environments, the network view from the engineering point of
view might be the same as the view from the application side, but for larger
environments, I often see a distinction between the two. And when that occurs,
the underlay view is less of a concern for application engineers and business
stakeholders (unless of course there are major issues with the underlay design),
but that does not make it less important. People are often not aware of how our
electricity net works, but if it fails, we're all affected. Similarly, if the
network underlay is badly designed, the higher networks will see troubles too.

The network virtualization stack is a technology component that supports
building virtual networks on top of the underlay environment. So while the
underlay is like the foundation on top of which all networks are hosted, the
virtualization makes this possible. In that sense, it is similar to the
hypervisor level on the component view (and perhaps is less of a location view
than a component one, although network virtualization technologies do require a
common understanding of the full network to function properly).

Companies use different virtualization technologies and concepts. A simple
network virtualization technology is the VLAN (Virtual LAN), which presents
itself as a single broadcast domain to the participating systems, even though
these systems might not be physically connected to the same switch or switch
environment. It is even possible to stretch VLANs across wide areas.

But virtualization can go further. Technologies such as Cisco ACI or VMware NSX
don't just focus on the LAN level, but also virtualize the network on the
addressing and routing part. And with Network Functions Virtualization (NFV), we
also include firewalls and traffic control. However, do not consider NFV to just
be the next phase beyond Software Defined Networks (SDN), as NFV and SDN are
different beasts.

**View from application and system side: topology and protocols**

The highest levels in the location view focus on the network as it is seen by
the business applications and systems that a company hosts.

The network topology is the view on segregation, segments/subnets, and the
network functions that take part in the overall environment (such as DNS/DHCP/IP
address management, firewall functionality, proxies, and other gateways). This
is the view that is probably going to change the most, as it constantly evolves
based on business demand and IT evolutions. Topology views are not just
one-of-a-kind: depending on the scope you want to address, multiple views might
be needed to convey the message you want to tell.

One type of view within the topology is the [zoning
view]({filename}/2017/06/structuring-infrastructural-deployments.md) which I've
covered before, and which is very expressive towards the other stakeholders: it
covers the entire company's environment while abstracting enough of the details
so that it remains understandable.

If we were to zoom in further on the network topology, you get into the specific
interactions that are made between systems, which are standardized in protocols.
But while the network (and application) protocols are often very standardized,
they are also very challenging to understand.

The main challenge is that there are so many protocols out there, with so many
options and implementation choices, that you need to be an expert to
troubleshoot issues if they arise. Web applications aren't just disclosed over
the HTTP protocol: you have channel encryption (TLS), might be using WebSockets,
or even the QUIC protocol. And if you think you understand HTTP, do you
understand HTTP/2?

**Conclusions**

The past few posts (with a few historical ones) make up what I consider being 
the infrastructure domain, and how to structurally approach changes within. Of
course, these are not the only views out there, and based on the project ahead,
different viewpoints might come up. But for a holistic view of the
infrastructure domain, I think these five cover it well.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](TODO).

<!-- PELICAN_END_SUMMARY -->
