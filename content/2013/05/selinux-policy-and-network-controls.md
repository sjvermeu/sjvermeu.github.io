Title: SELinux policy and network controls
Date: 2013-05-11 03:50
Category: SELinux
Tags: networking, policy, selinux
Slug: selinux-policy-and-network-controls

Let's talk about how SELinux governs network streams (and how it
reflects this into the policy).

When you don't do fancy stuff like SECMARK or netlabeling, then the
classes that you should keep an eye on are *tcp\_socket* and
*udp\_socket* (depending on the protocol). There used to be *node* and
*netif* as well, but the support (enforcement) for these have been
[removed a while ago](http://lists.openwall.net/netdev/2009/03/27/144)
for the "old style" network control enforcement. The concepts are still
available though, and I believe they take effect when netlabeling is
used. But let's first look at the regular networking aspects.

The idea behind the regular network related permissions are that you
define either daemon-like behavior (which "binds" to a port) or
client-like behavior (which "connects" to a port). Consider an FTP
daemon (domain `ftpd_t`) versus FTP client (example domain `ncftp_t`).

In case of a daemon, the policy would contain the following (necessary)
rules:

    corenet_tcp_bind_generic_node(ftpd_t) # Somewhat legacy but still needed
    corenet_tcp_bind_ftp_port(ftpd_t)
    corenet_tcp_bind_ftp_data_port(ftpd_t)
    corenet_tcp_bind_all_unreserved_ports(ftpd_t) # In case of passive mode

This gets translated to the following "real" SELinux statements:

    allow ftpd_t node_t:tcp_socket node_bind;
    allow ftpd_t ftp_port_t:tcp_socket name_bind;
    allow ftpd_t ftp_data_port_t:tcp_socket name_bind;
    allow ftpd_t unreserved_port_type:tcp_socket name_bind;

I mention that *corenet\_tcp\_bind\_generic\_node* as being somewhat
legacy. When you use netlabeling, you can define different nodes (a
"node" in that case is a label assigned to an IP address or IP subnet)
and as such define policy-wise where daemons can bind on (or clients can
connect to). However, without netlabel, the only node that you get to
work with is `node_t` which represents any possible node. Also, the use
of passive mode within the ftp policy is governed through the
*ftpd\_use\_passive\_mode* boolean.

For a client, the following policy line would suffice:

    corenet_tcp_connect_ftp_port(ncftp_t)
    # allow ncftp_t ftp_port_t:tcp_socket name_connect;

Well, I lied. Because of how FTP works, if you use active connections,
you need to allow the client to bind on an unreserved port, and allow
the server to connect to unreserved ports (cfr code snippet below), but
you get the idea.

    corenet_tcp_connect_all_unreserved_ports(ftpd_t)

    corenet_tcp_bind_generic_node(ncftp_t)
    corenet_tcp_bind_all_unreserved_ports(ncftp_t)

In the past, policy developers also had to include other lines, but
these have by time become obsolete (*corenet\_tcp\_sendrecv\_ftp\_port*
for instance). These methods defined the ability to send and receive
messages on the port, but this is no longer controlled this way. If you
need such controls, you will need to look at SELinux and SECMARK (which
uses packets with the *packet* class) or netlabel (which uses the *peer*
class and peer types to send or receive messages from).

And that'll be for a different post.
