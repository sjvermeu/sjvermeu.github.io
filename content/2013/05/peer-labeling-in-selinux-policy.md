Title: Peer labeling in SELinux policy
Date: 2013-05-12 03:50
Category: SELinux
Tags: cipso, ipsec, peer, policy, selinux
Slug: peer-labeling-in-selinux-policy

Allow me to start with an important warning: I don't have much hands-on
experience with the remainder of this post. Its based on the few
resources I found on the Internet and a few tests done locally which
I've investigated in my attempt to understand SELinux policy writing for
networking stuff.

So, with that out of the way, let's look into *peer labeling*. As
mentioned in my [previous
post](http://blog.siphos.be/2013/05/selinux-policy-and-network-controls/),
SELinux supports some more advanced networking security features than
the default socket restrictions. I mentioned SECMARK and NetLabel
before, but NetLabel is actually part of the family of *peer* labeling
technologies.

With this technology approach, all participating systems in the network
must support the same labeling method. NetLabel supports CIPSO
([Commerial IP Security
Option](https://tools.ietf.org/html/draft-ietf-cipso-ipsecurity-01))
where hosts label their network traffic to be part of a particular
"Domain of Interpretation". The labels are used by the hosts to identify
where a packet should be for. NetLabel, within Linux, is then used to
translate those CIPSO labels. SELinux itself labels the incoming sockets
based on the NetLabel information and the context of the listening
socket, resulting in a context that is governed policy-wise through the
*peer* class. Since this is based on the information in the packet
instead of defined on the system itself, this allows remote systems to
have a say in how the packets are labeled.

Another peer technology is the *Labeled IPSec* one. In this case the
labels are fully provided by the remote system. I think they are based
on the security association within the IPSec setup.

In both cases, in the SELinux policies, three definitions are important
to keep an eye out on: *interface* definitions, *node* definitions and
*peer* definitions.

Interface definitions allow users to (mainly) set the sensitivity that
is allowed to pass the interface. Using **semanage interface** this can
be controlled by the user. One can also assign a different context to
the interface - by default, this is `netif_t`. The permissions that are
checked on the traffic is *ingress* (incoming) and *egress* (outgoing)
traffic, and most policies set this through the following call (comment
shows the underlying SELinux rules, where *tcp\_send* and *tcp\_recv*
are - I think - obsolete):

    corenet_tcp_sendrecv_generic_if(something_t)
    # allow something_t netif_t:netif { tcp_send tcp_recv egress ingress };

Node definitions define which targets (nodes, which can be IP addresses
or subnets) traffic meant for a particular socket is allow to originate
from (*recvfrom*) or sent to (*sendto*). Again, users can define their
own node types and manage them using **semanage node**. The default node
I already covered in the previous post (`node_t`) and is allowed by most
policies by default through the following call (where the *tcp\_send*
and *tcp\_recv* are probably deprecated as well):

    corenet_tcp_sendrecv_generic_node(something_t)
    # allow something_t node_t:node { tcp_send tcp_recv sendto recvfrom };

Finally, peer definitions are based on the labels from the traffic. If
the system uses NetLabel, then the target label will always be
`netlabel_peer_t` since the workings of CIPSO are mainly (only?) mapped
towards sensitivity labels (in MLS policy). As a result, SELinux always
displays the peer as being `netlabel_peer_t`. In case of Labeled IPSec,
this isn't the case as the peer label is transmitted by the peer itself.

For NetLabel support, policies generally include two methods - one is to
support unlabeled traffic (only needed the moment you have support for
labeled traffic) and one is to allow the NetLabel'ed traffic:

    corenet_all_recvfrom_unlabeled(something_t)
    # allow something_t unlabeled_t:peer recv;
    corenet_all_recvfrom_netlabel(something_t)
    # allow something_t netlabel_peer_t:peer recv;

In case of IPSec for instance, the peer will have a provided label, as
is shown by the call for accepting hadoop traffic:

    hadoop_recvfrom(something_t)
    # allow something_t hadoop_t:peer recv;

However, this alone is not sufficient for labeled IPSec. We also need to
allow the domain to be allowed to send anything towards an IPSec
security association. There is an interface called
*corenet\_tcp\_recvfrom\_labeled* that takes two arguments which,
amongst other things, enables *sendto* towards its association.

    corenet_tcp_recvfrom_labeled(some_t, thing_t)
    # allow { some_t thing_t} self:association sendto;
    # allow some_t thing_t:peer recv;
    # allow thing_t some_t:peer recv;
    # corenet_tcp_recvfrom_netlabel(some_t)
    # corenet_tcp_recvfrom_netlabel(thing_t)

This interface is usually called within a *\*\_tcp\_connect()* interface
for a particular domain, like with the *mysql\_tcp\_connect* example:

    interface(`mysql_tcp_connect',`
            gen_require(`
                    type mysqld_t;
            ')

            corenet_tcp_recvfrom_labeled($1, mysqld_t)
            corenet_tcp_sendrecv_mysqld_port($1) # deprecated
            corenet_tcp_connect_mysqld_port($1)
            corenet_sendrecv_mysqld_client_packets($1)
    ')

When using peer labeling, the domain that is allowed something is based
on the socket context of the application. Also, the rules when using
peer labeling are *in addition to* the rules mentioned before
("standard" networking control): *name\_bind* and *name\_connect* are
always checked.

For more information, make sure you check [Paul Moore's
blog](http://paulmoore.livejournal.com), such as the
[egress/ingress](http://paulmoore.livejournal.com/2128.html?nojs=1)
information. And if you know of resources that show this in a more
practical setting (above is mainly to work with the SELinux policy) I'm
all ears.
