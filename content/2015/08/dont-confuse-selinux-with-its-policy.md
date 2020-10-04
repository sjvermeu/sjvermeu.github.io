Title: Don't confuse SELinux with its policy
Date: 2015-08-03 01:49
Category: SELinux
Tags: selinux, policy, cil
Slug: dont-confuse-selinux-with-its-policy

With the increased attention that SELinux is getting thanks to its inclusion in
recent [Android](https://source.android.com/devices/tech/security/selinux/)
releases, more and more people are understanding that SELinux is not a singular
security solution. Many administrators are still disabling SELinux on their 
servers because it does not play well with their day-to-day operations. But
the Android inclusion shows that SELinux itself is not the culprit for this:
it is the policy.

<!-- PELICAN_END_SUMMARY -->

**Policy versus enforcement**

SELinux has conceptually segregated the enforcement from the rules/policy. 
There is an in-kernel enforcement (the SELinux subsystem) which is configured
through an administrator-provided policy (the SELinux rules). As long as 
SELinux was being used on servers, chances are very high that the policy that
is being used is based on the [SELinux Reference Policy](https://github.com/TresysTechnology/refpolicy/wiki)
as this is, as far as I know, the only policy implementation for Linux systems
that is widely usable.

The reference policy project aims to provide a well designed, broadly usable
yet still secure set of rules. And through this goal, it has to play ball with
all possible use cases that the various software titles require. Given the open
ecosystem of the free software world, and the Linux based ones in particular, 
managing such a policy is not for beginners. New policy development requires 
insight in the technology for which the policy is created, as well as knowledge
of how the reference policy works.

Compare this to the Android environment. Applications have to follow more
rigid guidelines before they are accepted on Android systems. Communication
between applications and services is governed through Intents and Activities
which are managed by the [Binder](http://www.cubrid.org/blog/dev-platform/binder-communication-mechanism-of-android-processes/)
application. Interactions with the user are based on well defined interfaces.
Heck, the Android OS even holds a number of permissions that applications
have to subscribe to before they can use it.

Such an environment is much easier to create policies for, because it allows
policies to be created almost on-the-fly, with the application permissions
being mapped to predefined SELinux rules. Because the freedom of
implementations is limited (in order to create a manageable environment which
is used by millions of devices over the world) policies can be made more
strictly and yet enjoy the static nature of the environment: no continuous
updates on existing policies, something that Linux distributions have to do
on an almost daily basis.

**Aiming for a policy development ecosystem**

Having SELinux active on Android shows that one should not confuse SELinux
with its policies. SELinux is a nice security subsystem in the Linux kernel,
and can be used and tuned to cover whatever use case is given to it. The slow
adoption of SELinux by Linux distributions might be attributed to its lack
of policy diversification, which results in few ecosystems where additional
(and perhaps innovative) policies could be developed.

It is however a huge advantage that a reference policy exists, so that
distributions can enjoy a working policy without having to put resources
into its own policy development and maintenance. Perhaps we should try to
further enhance the existing policies while support new policy ecosystems
and development initiatives.

The maturation of the [CIL](https://github.com/SELinuxProject/cil/wiki)
language by the [SELinux userland libraries and tools](https://github.com/SELinuxProject/selinux)
might be a good catalyst for this. At one point, policies will need to be
migrated to CIL (although this can happen gradually as the userland utilities
can deal with CIL and other languages such as the legacy `.pp` files 
simultaneously) and there are a few developers considering a renewal
of the reference policy. This would make use of the new benefits of the CIL
language and implementation: some restrictions that where applicable to the legacy
format no longer holds on CIL, such as rules which previously were only allowed
in the base policy which can now be made part of the modules as well.

But next to renewing existing policies, there is plenty of room left for
innovative policy ideas and developments. The [SELinux language](http://selinuxproject.org/page/PolicyLanguage)
is very versatile, and just like with programming languages we notice that only
a few set of constructs are used. Some applications might even benefit from
using SELinux as their decision and enforcement system (something that
[SEPostgreSQL](https://wiki.postgresql.org/wiki/SEPostgreSQL_Introduction) has
tried).

The [SELinux Notebook](http://freecomputerbooks.com/The-SELinux-Notebook-The-Foundations.html) by
Richard Haines is an excellent resource for developers that want to work more
closely with the SELinux language constructs. Just skimming through this resource
also shows how very open SELinux itself is, and that most of the users'
experience with SELinux is based on a singular policy implementation. This is
a prime reason why having a more open policy ecosystem makes perfect sense.

If you don't like a particular car, do you ditch driving at all? No, you try out
another car. Let's create other cars in the SELinux world as well.

