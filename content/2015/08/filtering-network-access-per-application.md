Title: Filtering network access per application
Date: 2015-08-07 03:49
Category: SELinux
Tags: selinux, network, iptables
Slug: filtering-network-access-per-application

Iptables (and the successor nftables) is a powerful packet filtering system in
the Linux kernel, able to create advanced firewall capabilities. One of the 
features that it _cannot_ provide is per-application filtering. Together with
SELinux however, it is possible to implement this on a _per domain_ basis.

SELinux does not know applications, but it knows domains. If we ensure that each
application runs in its own domain, then we can leverage the firewall
capabilities with SELinux to only allow those domains access that we need.

<!-- PELICAN_END_SUMMARY -->

**SELinux network control: packet types**

The basic network control we need to enable is SELinux' packet types. Most
default policies will grant application domains the right set of packet types:

    ~# sesearch -s mozilla_t -c packet -A
    Found 13 semantic av rules:
       allow mozilla_t ipp_client_packet_t : packet { send recv } ; 
       allow mozilla_t soundd_client_packet_t : packet { send recv } ; 
       allow nsswitch_domain dns_client_packet_t : packet { send recv } ; 
       allow mozilla_t speech_client_packet_t : packet { send recv } ; 
       allow mozilla_t ftp_client_packet_t : packet { send recv } ; 
       allow mozilla_t http_client_packet_t : packet { send recv } ; 
       allow mozilla_t tor_client_packet_t : packet { send recv } ; 
       allow mozilla_t squid_client_packet_t : packet { send recv } ; 
       allow mozilla_t http_cache_client_packet_t : packet { send recv } ; 
     DT allow mozilla_t server_packet_type : packet recv ; [ mozilla_bind_all_unreserved_ports ]
     DT allow mozilla_t server_packet_type : packet send ; [ mozilla_bind_all_unreserved_ports ]
     DT allow nsswitch_domain ldap_client_packet_t : packet recv ; [ authlogin_nsswitch_use_ldap ]
     DT allow nsswitch_domain ldap_client_packet_t : packet send ; [ authlogin_nsswitch_use_ldap ]

As we can see, the `mozilla_t` domain is able to send and receive packets of
type `ipp_client_packet_t`, `soundd_client_packet_t`, `dns_client_packet_t`, 
`speech_client_packet_t`, `ftp_client_packet_t`, `http_client_packet_t`, 
`tor_client_packet_t`, `squid_client_packet_t` and `http_cache_client_packet_t`.
If the SELinux booleans mentioned at the end are enabled, additional packet
types are alloed to be used as well.

But even with this default policy in place, SELinux is not being consulted for
filtering. To accomplish this, `iptables` will need to be told to label the
incoming and outgoing packets. This is the [SECMARK](http://blog.siphos.be/2013/05/secmark-and-selinux/)
functionality that I've blogged about earlier.

**Enabling SECMARK filtering through iptables**

To enable SECMARK filtering, we use the `iptables` command and tell it to label
SSH incoming and outgoing packets as `ssh_server_packet_t`:

    ~# iptables -t mangle -A INPUT -m state --state ESTABLISHED,RELATED -j CONNSECMARK --restore
    ~# iptables -t mangle -A INPUT -p tcp --dport 22 -j SECMARK --selctx system_u:object_r:ssh_server_packet_t:s0
    ~# iptables -t mangle -A OUTPUT -m state --state ESTABLISHED,RELATED -j CONNSECMARK --restore
    ~# iptables -t mangle -A OUTPUT -p tcp --sport 22 -j SECMARK --selctx system_u:object_r:ssh_server_packet_t:s0

But be warned: the moment iptables starts with its SECMARK support, _all packets_
will be labeled. Those that are not explicitly labeled through one of the above
commands will be labeled with the `unlabeled_t` type, and most domains are not
allowed any access to `unlabeled_t`.

There are two things we can do to improve this situation:

1. Define the necessary SECMARK rules for all supported ports (which is something
   that [secmarkgen](https://www.linux.com/learn/tutorials/421152:using-selinux-and-iptables-together)
   does), and/or
2. Allow `unlabeled_t` for all domains.

To allow the latter, we can load a SELinux rule like the following:

```lisp
(allow domain unlabeled_t (packet (send recv)))
```

This will allow all domains to send and receive packets of the `unlabeled_t` type.
Although this is something that might be security-sensitive, it might be a good idea
to allow at start, together with proper auditing (you can use `(auditallow ...)` to
audit all granted packet communication) so that the right set of packet types can be
enabled. This way, administrators can iteratively improve the SECMARK rules and finally
remove the `unlabeled_t` privilege from the `domain` attribute.

To list the current SECMARK rules, list the firewall rules for the `mangle` table:

    ~# iptables -t mangle -nvL

**Only granting one application network access**

These two together allow for creating a firewall that only allows a single domain
access to a particular target.

For instance, suppose that we only want the `mozilla_t` domain to connect to the
company proxy (10.15.10.5). We can't enable the `http_client_packet_t` for this
connection, as all other web browsers and other HTTP-aware applications will have
policy rules enabled to send and receive that packet type. Instead, we are going
to create a new packet type to use.

```lisp
;; Definition of myhttp_client_packet_t
(type myhttp_client_packet_t)
(roletype object_r myhttp_client_packet_t)
(typeattributeset client_packet_type (myhttp_client_packet_t))
(typeattributeset packet_type (myhttp_client_packet_t))

;; Grant the use to mozilla_t
(typeattributeset cil_gen_require mozilla_t)
(allow mozilla_t myhttp_client_packet_t (packet (send recv)))
```

Putting the above in a `myhttppacket.cil` file and loading it allows the type
to be used:

    ~# semodule -i myhttppacket.cil

Now, the `myhttp_client_packet_t` type can be used in `iptables` rules. Also, 
only the `mozilla_t` domain is allowed to send and receive these packets,
effectively creating an application-based firewall, as all we now need to do
is to mark the outgoing packets towards the proxy as `myhttp_client_packet_t`:

    ~# iptables -t mangle -A OUTPUT -p tcp --dport 80 -d 10.15.10.5 -j SECMARK --selctx system_u:object_r:myhttp_client_packet_t:s0

This shows that it is _possible_ to create such firewall rules with SELinux. It
is however not an out-of-the-box solution, requiring thought and development of
both firewall rules and SELinux code constructions. Still, with some advanced
scripting experience this will lead to a powerful addition to a hardened
system.
