Title: Mitigating risks, part 4 - Mandatory Access Control
Date: 2011-09-23 20:16
Category: Security
Slug: mitigating-risks-part-4-mandatory-access-control

I've talked about [service
isolation](http://blog.siphos.be/2011/09/mitigating-risks-part-2-service-isolation/)
earlier and the risks that it helps to mitigate. However, many
applications still run as highly privileged accounts, or can be abused
to execute more functions than intended. Service isolation doesn't help
there, and system hardening can only go that far. The additional
countermeasures that you can take are application firewalls and
mandatory access control. And now you know what part 5 will talk about
;-)

Standard access control on most popular operating systems is based on a
limited set of privileges (such as read, write and execute) on a limited
scale (user, group, everyone else). Recent developments are showing an
increase in the privilege flexibility, with the advent of [manageable
capabilities](http://www.gentoo.org/proj/en/hardened/capabilities.xml)
(Linux/Unix) or [Group
Policies](http://technet.microsoft.com/en-us/windowsserver/bb310732)
(Windows). However, these still lack some important features:

-   Users are still able to **delegate their privilege** to others. A
    user with read access on a particular file can copy that file to a
    public readable location so others can read it as well. Privileges
    on his own files and directories are fully manageable by the owner.
    For our risk mitigation approach on unsupported software, that means
    that a vulnerability might be exploited so that the service
    "leaks" information. It is especially important in an attack that
    uses a sequence of vulnerabilities (such as in an [advanced
    persistent
    threat](https://secure.wikimedia.org/wikipedia/en/wiki/Advanced_persistent_threat))
    where low-risk vulnerabilities can be combined into a
    high-risk exploit.
-   Privileges are still **user-level privileges** (including technical
    account users). In case of running services, this almost always
    means that the process has more privileges than it requires. Some
    software titles allow for dropping capabilities when not
    needed anymore. Most however are oblivious of the rights
    they possess. Abuse of the service (which includes use of features
    that the service offers but are not allowed policy-wise by
    the organization) cannot be prevented if
    [hardening](http://blog.siphos.be/2011/09/mitigating-risks-part-3-hardening/)
    doesn't disable it.
-   Privileges are **managed by many actors** (such as the
    system administrators) and are not that easy to audit. Privilege
    denials are often not audited, causing issues to only come up when
    they occur, rather then when the attempt to provoke issues
    is started. In many cases, a malicious (or "playful, inventive")
    user starts with investigating and trying out long before a way is
    found to abuse the service.

In case of a mandatory access control system, a security administrator
is responsible for writing and managing a security policy which is
**enforced by the operating system** (well, higher level enforcement
would be even better, but is currently not realistic). Once enforced,
the policy ensures that privileges are not delegated (unless allowed).
Also, in most MAC systems, the policy allows for a much **more detailed
privilege granularity**. And recent server operating systems have
support for MAC - I personally work with
[SELinux](http://hardened.gentoo.org/selinux) for the (GNU/)Linux
operating system.

But this more granular flexibility in privileges comes with some costs.
First of all, it becomes much more **complex to manage the policy**.
You'll need highly experienced administrators to work with a MAC-enabled
system. Second, a MAC model has a **negative influence on performance**
since the system has to check many more accesses and access rules. To
make MAC-enabled systems workable, operating systems offer a *default
policy* which already covers many services. Also, developers on the MAC
technology are continuously safe-guarding performance - I personally do
not notice a performance degradation when using SELinux, and more
realistic benchmarks suggest that the impact of SELinux is between 3%
and 12% depending on the policy level.

But what does that mean towards the initial [risk
list](http://blog.siphos.be/2011/09/mitigating-risks-part-1) that I
identified in the beginning of this article series? Well, directly, very
little: mandatory access control in this case is about reducing the
impact of security vulnerabilities (and abuse of the service). It will
not help you out in other ways. However, there are other things to gain
from a mandatory access control than just threat reduction.

An advantage is - again - that you get to **know your application**
well, especially if you had to write a security policy for it. Since you
need to define what files it can access, which kind of accesses it is
allowed to do, which commands it can execute, etc, it will give you
insight in how the application operates. Bugs in the application might
be solved faster and you'll definitely learn more about how the
application is integrated. Another one is that most mandatory access
control systems have much more **detailed auditing** capabilities.
Attempts to abuse the service will result in denials which are detected
and on which you can then take proper action.

Taking a higher-level look at mandatory access control will show you
that, in case of risk mitigation, it is much more like service
isolation, but then on the operating system level. You isolate the
processes, governing the accesses they are allowed to do.

But the one main issue - active exploits on the application service -
cannot be hindered by neither service isolation (since the service is
still accessible), hardening (although it might help) or mandatory
access control (which reduces the actions an exploit can do). To make
sure that vulnerabilities are less likely to be exploited, I'll talk
about *application firewalls* in the next post.
