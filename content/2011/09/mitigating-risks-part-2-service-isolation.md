Title: Mitigating risks, part 2 - service isolation
Date: 2011-09-09 23:12
Category: Security
Slug: mitigating-risks-part-2-service-isolation

> Internet: absolute communication, absolute isolation  
>  \~Paul Carvel

The quote might be ripped out of its context completely, since it wasn't
made when talking about risks and the assurance you might need to get in
order to reduce risks. But it does give a nice introduction to the
second part of this article series on *risk mitigation*. After all, if
the unsupported software is offering services to the Internet, you
really want to govern the communication and isolate the service.

When you are dealing with a product or software that is unsupported (be
it that it will not get any patches and updates from its authors or
vendor, or there is no time/budget to support the environment properly),
it is in my opinion wise to isolate the service from the rest. My [first
post](http://blog.siphos.be/2011/09/mitigating-risks-part-1/) on the
matter gave a high-level introduction on the risks that you might be
taking when you run unsupported (or out-of-support) systems. Service
isolation helps in reducing the risks that *others* have when you run
such software on a shared infrastructure (like in the same network or
even data centre).

By isolating the unsupported service from the rest, you create a sort-of
quarantine environment where sudden mishaps are shielded from
interfering with other systems. It provides **insurance for others**,
knowing that their (supported) services cannot be influenced or
jeopardized by issues with the unsupported ones. And if these services
need to interact with the isolated service, the interface used is known
and much more manageable (think about a well-defined TCP connection
versus local communication or even Inter-Process Communication). But it
goes beyond just providing insurance for others.

Isolation forces you to **learn about the application** and its
interaction with other services. It is this phase that makes it
extremely important in an environment, because not knowing how an
application works, behaves or interacts creates more problems later when
you need to debug issues, troubleshoot performance problems and more.
Integration failures, as described in my previous post, can only be
dealt with swiftly if you know how the service integrates with others.

Another advantage of proper service isolation is that you can fix its
dependencies more easily. Remember that I talked about upgrade
difficulties, where a necessary upgrade for one component impacted the
functionalities of the other (unsupported) component? With good
isolation, the **dependencies are more manageable** and controllable.
Not only are (sub)component upgrades easier to schedule, it is also a
lot easier to provide fall-back scenario's in case problems occur. After
all, the isolated service is the only user so you have little to fear if
you need to roll-back a change.

But what is proper service isolation?

-   First of all, it means that you focus on running the (unsupported)
    software alone on an operating system instance. *Do not run other
    services on the same OS*, not even if they too are unsupported. The
    only exception here is if the other services are tightly integrated
    with your service and cannot be installed on a separate OS. But
    usually, full service isolation is possible.
-   Next, *strip the operating system* so it only runs what you need for
    managing the service. Put primary focus on services that are
    accepting incoming connections ("listening") and secondary focus on
    allowed outgoing protocols/sessions (and the tools that
    initiate them).
-   See if you can *virtualize the environment*. In most cases, the
    service does not require many resources so it would be a waste
    running it on a dedicated system. However, in my opinion, a much
    better reason for virtualization is hardware abstraction. Sure, all
    operating systems tell you that they have some sort of Hardware
    Abstraction Layer in them and that they can deal with hardware
    changes without you noticing it. But if you are an administrator,
    you know this is only partially true. Virtualization offers the
    advantage that the underlying hardware is virtual and can remain the
    same, even if you move the virtualized system to a much more
    powerful host. Another advantage is that you might be able to
    offload certain necessary services from the OS (like backup) to the
    host (snapshotting).
-   Shield the operating system, network-wise, from other systems. Yes,
    that means putting *a firewall BEFORE the operating system guest*
    (and definitely not on the OS) which governs all traffic coming in
    and out of the environment. Only allow connections that are legit.
    If your organization has a huge network to manage, they might work
    with network segment filtering instead of IP-level filtering. See if
    you can get an exception to that - managing the rules should not
    give too much overhead since the system, being unsupported and all,
    is a lot less likely to get many connectivity updates.

But before finishing off, a hint about stripping an operating system.
Stripping is much more than just removing services that are not used. It
also means that you look for services that are needed, and see if you
can externalize them. Common examples here are logging (send your logs
to a remote system rather than keeping them local), e-mail (use simple
"direct-out" mail) and backup (use a locally scheduled backup tool, or
even offload to the host in virtualized systems), but many others exist.

Of course, service isolation is not unknown to most people. If you run a
large(r) network with Internet-facing services, you probably isolate
those in a DMZ environment. That is quite frankly (also) for the same
"risk mitigation" reason. In case of a security breach, service
unavailability or otherwise, you want to reduce the risk that this fault
spreads to other systems (be it getting to internal documents or putting
more services down).

Another aspect administrators do with systems in their DMZ is *system
hardening*, which I will talk about in the third part.
