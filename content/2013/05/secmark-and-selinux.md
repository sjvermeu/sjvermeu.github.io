Title: SECMARK and SELinux
Date: 2013-05-13 03:50
Category: SELinux
Tags: policy, secmark, selinux
Slug: secmark-and-selinux

When using SECMARK, the administrator configures the **iptables** or
**netfilter** rules to add a label to the packet data structure (on the
host itself) that can be governed through SELinux policies. Unlike peer
labeling, here the labels assigned to the network traffic is completely
locally defined. Consider the following command:

    # iptables -t mangle -A INPUT -p tcp --src 192.168.1.2 --dport 443
      -j SECMARK --selctx system_u:object_r:myauth_packet_t

With this command, packets that originate from the *192.168.1.2* host
and arrive on port 443 (typically used for HTTPS traffic) are marked as
`myauth_packet_t`. SELinux policy writers can then allow domains to
receive this type of packets (or send) through the *packet* class:

    # Allow sockets with mydomain_t context to receive packets labeled myauth_packet_t
    allow mydomain_t myauth_packet_t:packet recv;

The SELinux policy modules enable this through the
*corenet\_sendrecv\_&lt;type&gt;\_{client,server}\_packets* interfaces:

    corenet_sendrecv_http_client_packets(mybrowser_t)
    # allow mybrowser_t http_client_packet_t:packet { send recv };

As a common rule, packets are marked as client packets or server
packets, depending on the role of the *domain*. In the above example,
the domain is a browser, so acts as a web client. So, it needs to send
and receive `http_client_packet_t`. A web server on the other hand would
need to send and receive `http_server_packet_t`. Note that the packets
that are sent over the wire do not have any labels assigned to them -
this is all local to the system. So even when the source and destination
use SELinux with SECMARK, on the source server the packets might be
labeled as `http_client_packet_t` whereas on the target they are seen as
`http_server_packet_t`.

As far as I know, when you want to use SECMARK, you will need to set the
contexts with **iptables** yourself (there is no default labeling), so
knowing about the above convention is important.

Again, Paul Moore has [more
information](http://paulmoore.livejournal.com/4281.html) about this.
