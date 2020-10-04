Title: Mitigating DDoS attacks
Date: 2013-04-22 03:50
Category: Security
Tags: ddos, dns, mitigation, security
Slug: mitigating-ddos-attacks

Lately, DDoS attacks have been in the news more than I was hoping for.
It seems that the botnets or other methods that are used to generate
high-volume traffic to a legitimate service are becoming more and more
easy to get and direct. At the time that I'm writing this post (a few
days before its published though), the popular
[Reddit](http://www.reddit.com) site is undergoing a DDoS attack which I
hope will be finished (or mitigated) soon.

But what can a service do against DDoS attacks? After all, DDoS is like
gasping for air if you can't swim and are (almost) drowning: the air is
the legitimate traffic, but the water is overwhelming and your mouth,
pharynx and trachea just aren't made to deal with this properly. And
unlike specific Denial-of-Service attacks that use a vulnerability or
malcrafted URL, you cannot just install some filter or upgrade a
component to be safe again.

Methods for mitigating DDoS attacks (beyond increasing your bandwidth as
that is very expensive and the botnets involved can go [up to 130
Gbps](http://arstechnica.com/security/2013/04/fueled-by-super-botnets-ddos-attacks-grow-meaner-and-ever-more-powerful/),
not a bandwidth you are probably willing to pay for if legitimate
services on your site have enough with 10 Mbps) that come to mind are of
all sorts of "classes"...

Configure your servers and services that they **stay alive under
pressure**. Look for the sweet spot where performance of the services is
still stable where a higher load means performance degradation. If you
have some experience with load testing, you know that throughput on a
service initially goes up linearly with the load (first phase). Then, it
slows down (but still rises - phase 2) up to a point that, when you
increase the load even further just a bit, the service degrades (and
sometimes doesn't even get back to its feed when you remove the
additional load again - phase3). You need to look for the spot where
load and performance is stable (somewhere at the middle of the second
phase) and configure your systems so that additional load is dropped.
Yes, this means that the DDoS will be more effective, but also means
that your systems can easily get back up to their feet when the attack
has finished (and you get a more predictable load and consequences).

Investigate if you can have a **backup service** that has a higher
throughput ability (with reduced functionality). If the DDoS attack
focuses on the system resources rather than network resources involved,
such a backup "lighter" service can be used to still provide basic
functionality (for instance a more static website), but even in case of
network resource consumption it can have the advantage that the network
consumption that your servers are placing (while replying to the
requests) are lower.

Depending on the service you offer (and financial means you have at your
disposal) you can look at **redirecting traffic** to more specialized
services. Companies like [Prolexic](http://www.prolexic.com) have
systems that "scrub" the DDoS traffic from all traffic and only send
legitimate requests to your systems. There are several methods for
redirecting load, but a common one is to change the DNS records for your
service(s) to point to the addresses of those specialized services
instead. The lower the TTL (Time To Live) is of the records, the faster
the redirect might take place. If you want to be able to handle an
increase in load without specialized services, you might want to be able
to redirect traffic to cloud services (where you host your service as
well) which are generally capable of handling higher throughput than
your own equipment (but this too comes at an additional cost).

Some people mention that you can **switch IP address**. This is true
only if the DDoS attack is targeting IP addresses and not (DNS-resolved)
URIs. You could set up additional IP addresses that are not registered
in DNS (yet) and during the attack, extend the service resolving towards
the additional addresses as well. If you do not notice a load spread of
the DDoS attack towards the new addresses, you can remove the old
addresses from DNS. But again, this won't work generally - not only are
most DDoS attacks using DNS-resolved URIs, most of the time attackers
are actively involved in the attack and will quickly notice if such a
"failover" has occurred (and react against it).

Depending on your relationship with your provider or location service,
you can ask if the edge routers (preferably those of the ISP) can have
**fallback source filtering rules** available to quickly enable. Those
fallback rules would then only allow traffic from networks that you know
most (all?) of your customers and clients are at. This isn't always
possible, but if you have a service that targets mainly people within
your country, have the filter only allow traffic from networks of that
country. If the DDoS attack uses geographically spread resources, it
might be that the number of bots inside those allowed networks are low
enough that your service can continue.

**Configure your firewalls** (and ask that your ISP does the same) to
not accept (drop) traffic not expected. If the services on your
architecture do not use external DNS, then you can drop incoming DNS
response packets (a popular DDoS attack method is by using spoofed
addresses towards open DNS resolvers; called a DNS reflection attack).

And finally, if you are not bound to a single data center, you might
want to spread services across **multiple locations**. Although more
difficult from a management point of view, a dispersed/distributed
architecture allows other services to continue running while one is
being attacked.
