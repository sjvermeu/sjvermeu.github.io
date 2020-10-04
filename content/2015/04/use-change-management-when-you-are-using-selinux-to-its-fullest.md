Title: Use change management when you are using SELinux to its fullest
Date: 2015-04-30 20:58
Category: SELinux
Tags: change management, policy, selinux
Slug: use-change-management-when-you-are-using-selinux-to-its-fullest

If you are using SELinux on production systems (with which I mean
systems that you offer services with towards customers or other parties
beyond you, yourself and your ego), please consider proper change
management if you don't do already. SELinux is a very sensitive security
subsystem - not in the sense that it easily fails, but because it is
very fine-grained and as such can easily stop applications from running
when their behavior changes just a tiny bit.

**Sensitivity of SELinux**

SELinux is a wonderful security measure for Linux systems that can
prevent successful exploitation of vulnerabilities or misconfigurations.
Of course, it is not the sole security measure that systems should take.
Proper secure configuration of services, least privilege accounts,
kernel-level mitigations such as grSecurity and more are other measures
that certainly need to be taken if you really find system security to be
a worthy goal to attain. But I'm not going to talk about those others
right now. What I am going to focus on is SELinux, and how sensitive it
is to changes.

An important functionality of SELinux to understand is that it
segregates the security control system itself (the SELinux subsystem)
from its configuration (the policy). The security control system itself
is relatively small, and focuses on enforcement of the policy and
logging (either because the policy asks to log something, or because
something is prevented, or because an error occurred). The most
difficult part of handling SELinux on a system is not enabling or
interacting with it. No, it is its policy.

The policy is also what makes SELinux so darn sensitive for small system
changes (or behavior that is not either normal, or at least not allowed
through the existing policy). Let me explain with a small situation that
I recently had.

**Case in point: Switching an IP address**

A case that beautifully shows how sensitive SELinux can be is an IP
address change. My systems all obtain their IP address (at least for
IPv4) from a DHCP system. This is of course acceptable behavior as
otherwise my systems would never be able to boot up successfully anyway.
The SELinux policy that I run also allows this without any hindrance. So
that was not a problem.

Yet recently I had to switch an IP address for a system in production.
All the services I run are set up in a dual-active mode, so I started
with the change by draining the services to the second system, shutting
down the service and then (after reconfiguring the DHCP system to now
provide a different IP address) reload the network configuration. And
then it happened - the DHCP client just stalled.

As the change failed, I updated the DHCP system again to deliver the old
IP address and then reloaded the network configuration on the client.
Again, it failed. Dumbstruck, I looked at the AVC denials and lo and
behold, I notice a `dig` process running in a DHCP client related domain
that is trying to do UDP binds, which the policy (at that time) did not
allow. But why now suddenly, after all - this system was running happily
for more than a year already (and with occasional reboots for kernel
updates).

I won't bore you with the investigation. It boils down to the fact that
the DHCP client detected a change compared to previous startups, and was
configured to run a few hooks as additional steps in the IP lease setup.
As these hooks were never ran previously, the policy was never
challenged to face this. And since the address change occurred a revert
to the previous situation didn't work either (as its previous state
information was already deleted).

I was able to revert the client (which is a virtual guest in KVM) to the
situation right before the change (thank you `savevm` and `loadvm`
functionality) so that I could work on the policy first in a
non-production environment so that the next change attempt was
successful.

**Change management**

The previous situation might be "solved" by temporarily putting the DHCP
client domain in permissive mode just for the change and then back. But
that is ignoring the issue, and unless you have perfect operational
documentation that you always read before making system or configuration
changes, I doubt that you'll remember this for the next time.

The case is also a good example on the sensitivity of SELinux. It is not
just when software is being upgraded. Every change (be it in
configuration, behavior or operational activity) might result in a
situation that is new for the loaded SELinux policy. As the default
action in SELinux is to deny everything, this will result in unexpected
results on the system. Sometimes very visible (no IP address obtained),
sometimes hidden behind some weird behavior (hostname correctly set but
not the domainname) or perhaps not even noticed until far later. Compare
it to the firewall rule configurations: you might be able to easily
confirm that standard flows are still passed through, but how are you
certain that fallback flows or one-in-a-month connection setups are not
suddenly prevented from happening.

A somewhat better solution than just temporarily disabling SELinux
access controls for a domain is to look into proper change management.
Whenever a change has to be done, make sure that you

-   can easily revert the change back to the previous
    situation (backups!)
-   have tested the change on a non-vital (preproduction) system first

These two principles are pretty vital when you are serious about using
SELinux in production. I'm not talking about a system that hardly has
any fine-grained policies, like where most of the system's services are
running in "unconfined" domains (although that's still better than not
running with SELinux at all), but where you are truly trying to put a
least privilege policy in place for all processes and services.

Being able to revert a change allows you to quickly get a service up and
running again so that customers are not affected by the change (and
potential issues) for long time. First fix the service, then fix the
problem. If you are an engineer like me, you might rather focus on the
problem (and a permanent, correct solution) first. But that's wrong -
always first make sure that the customers are not affected by it. Revert
and put the service back up, and then investigate so that the next
change attempt will not go wrong anymore.

Having a multi-master setup might give some more leeway into
investigating issues (as the service itself is not disrupted) so in the
case mentioned above I would probably have tried fixing the issue
immediately anyway if it wasn't policy-based. But most users do not have
truly multi-master service setups.

Being able to test (and retest) changes in non-production also allows
you to focus on automation (so that changes can be done faster and in a
repeated, predictable and qualitative manner), regression testing as
well as change accumulation testing.

**You don't have time for that?**

Be honest with yourself. If you support services for others (be it in a
paid-for manner or because you support an organization in your free
time) you'll quickly learn that service availability is one of the most
qualitative aspects of what you do. No matter what mess is behind it,
most users don't see all that. All they see is the service itself (and
its performance / features). If a change you wanted to make made a
service unavailable for hours, users will notice. And if the change
wasn't communicated up front or it is the n-th time that this downtime
occurs, they will start asking questions you rather not hear.

Using a non-production environment is not that much of an issue if the
infrastructure you work with supports bare metal restores, or
snapshot/cloning (in case of VMs). After doing those a couple of times,
you'll easily find that you can create a non-production environment from
the production one. Or, you can go for a permanent non-production
environment (although you'll need to take care that this environment is
at all times representative for the production systems).

And regarding qualitative changes, I really recommend to use a
configuration management system. I recently switched from Puppet to
Saltstack and have yet to use the latter to its fullest set (most of
what I do is still scripted), but it is growing on me and I'm pretty
convinced that I'll have the majority of my change management scripts
removed by the end of this year towards Saltstack-based configurations.
And that'll allow me to automate changes and thus provide a more
qualitative service offering.

With SELinux, of course.
