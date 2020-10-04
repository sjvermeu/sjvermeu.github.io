Title: Network routing based on SELinux?
Date: 2013-08-21 19:43
Category: SELinux
Tags: ipsec, netlabel, networking, secmark, selinux
Slug: network-routing-based-on-selinux

Today we had a question on \#selinux if it was possible to route traffic
of a specific process using SELinux. The answer to this is "no",
although it has to be explained a bit in more detail.

SELinux does not route traffic. SELinux is a local mandatory access
control system; its purpose is to allow or deny certain actions, not
route traffic. However, Linux' NetFilter does support security markings
(SECMARK). I've [blogged about
it](http://blog.siphos.be/2013/05/secmark-and-selinux/) in the past, and
there are good tutorials elsewhere on the Internet, such as Dan Walsh'
[Using SELinux and iptables
together](http://www.linux.com/learn/tutorials/421152-using-selinux-and-iptables-together).

Linux support for security marking does allow for routing decisions -
but it does not "use" SELinux in this regard. To mark traffic with a
certain label, the administrator has to put in the rules himself using
**iptables** or **ip6tables** commands. And if you have to do that, then
you are already working with the routing commands so why not just route
immediately? Of course, the advantage of labeling the traffic is that
you can then use SELinux to allow or deny processes to send or receive
those packets - but SELinux is not involved with routing.

Another possibility is to use labeled networking, such as Labeled IPSec
or NetLabel/CIPSO support.

With labeled networking, all hosts that participate in the network need
to support the labeled networking technology. If that is the case, then
SELinux policy can be used to deny traffic from one host or another -
but again, not to route traffic. You can use SELinux to deny one process
to send out data to one set of hosts and allow it to send data to
another, but that is not routing. The advantage of Labeled IPSec is that
contexts are retained across the network - decisions that SELinux has to
take on one system can be made based on the context of the process on
the other system.

So no, SELinux cannot be used to route traffic, but it plays very nicely
with various networking controls to make proper decisions on its access
control enforcement.
