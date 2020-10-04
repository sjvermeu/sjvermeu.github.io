Title: D-Bus and SELinux
Date: 2014-06-30 20:07
Category: SELinux
Tags: busconfig, d-bus, dbus, linux, policy, selinux
Slug: d-bus-and-selinux

After a [post about
D-Bus](http://blog.siphos.be/2014/06/d-bus-quick-recap/) comes the
inevitable related post about SELinux with D-Bus.

Some users might not know that D-Bus is an SELinux-aware application.
That means it has SELinux-specific code in it, which has the D-Bus
behavior based on the SELinux policy (and might not necessarily honor
the "permissive" flag). This code is used as an additional
authentication control within D-Bus.

Inside the SELinux policy, a *dbus* permission class is supported, even
though the Linux kernel doesn't do anything with this class. The class
is purely for D-Bus, and it is D-Bus that checks the permission
(although work is being made to [implement D-Bus in kernel
(kdbus)](https://lwn.net/Articles/580194/)). The class supports two
permission checks:

-   *acquire\_svc* which tells the domain(s) allowed to "own" a service
    (which might, thanks to the SELinux support, be different from the
    domain itself)
-   *send\_msg* which tells which domain(s) can send messages to a
    service domain

Inside the D-Bus security configuration (the `busconfig` XML file,
remember) a service configuration might tell D-Bus that the service
itself is labeled differently from the process that owned the service.
The default is that the service inherits the label from the domain, so
when `dnsmasq_t` registers a service on the system bus, then this
service also inherits the `dnsmasq_t` label.

The necessary permission checks for the `sysadm_t` user domain to send
messages to the dnsmasq service, and the dnsmasq service itself to
register it as a service:

    allow dnsmasq_t self:dbus { acquire_svc send_msg };
    allow sysadm_t dnsmasq_t:dbus send_msg;
    allow dnsmasq_t sysadm_t:dbus send_msg;

For the `sysadm_t` domain, the two rules are needed as we usually not
only want to send a message to a D-Bus service, but also receive a reply
(which is also handled through a *send\_msg* permission but in the
inverse direction).

However, with the following XML snippet inside its service configuration
file, owning a certain resource is checked against a different label:

```
<busconfig>
  <selinux>
    <associate
      own="uk.org.thekelleys.dnsmasq"
      context="system_u:object_r:dnsmasq_dbus_t:s0" />
  </selinux>
</busconfig>
  
```

With this, the rules would become as follows:

    allow dnsmasq_t dnsmasq_dbus_t:dbus acquire_svc;
    allow dnsmasq_t self:dbus send_msg;
    allow sysadm_t dnsmasq_t:dbus send_msg;
    allow dnsmasq_t sysadm_t:dbus send_msg;

Note that *only* the access for acquiring a service based on a name
(i.e. owning a service) is checked based on the different label. Sending
and receiving messages is still handled by the domains of the processes
(actually the labels of the connections, but these are always the
process domains).

I am not aware of any policy implementation that uses a different label
for owning services, and the implementation is more suited to "force"
D-Bus to only allow services with a correct label. This ensures that
other domains that might have enough privileges to interact with D-Bus
and own a service cannot own these particular services. After all, other
services don't usually have the privileges (policy-wise) to
*acquire\_svc* a service with a different label than their own label.
