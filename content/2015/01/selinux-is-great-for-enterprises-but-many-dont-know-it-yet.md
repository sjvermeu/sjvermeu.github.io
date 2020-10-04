Title: SELinux is great for enterprises (but many don't know it yet)
Date: 2015-01-03 13:36
Category: SELinux
Tags: companies, configuration, engineering, enterprise, selinux
Slug: selinux-is-great-for-enterprises-but-many-dont-know-it-yet

Large companies that handle their own IT often have internal support
teams for many of the technologies that they use. Most of the time, this
is for reusable components like database technologies, web application
servers, operating systems, middleware components (like file transfers,
messaging infrastructure, ...) and more. All components that are used
and deployed multiple times, and thus warrant the expenses of a
dedicated engineering team.

Such teams often have (or need to write) secure configuration deployment
guides, so that these components are installed in the organization with
as little misconfigurations as possible. A wrongly configured component
is often worse than a vulnerable component, because vulnerabilities are
often fixed with the software upgrades (you do patch your software,
right?) whereas misconfigurations survive these updates and remain
exploitable for longer periods. Also, misuse of components is harder to
detect than exploiting vulnerabilities because they are often seen as
regular user behavior.

But next to the redeployable components, most business services are
provided by a single application. Most companies don't have the budget
and resources to put dedicated engineering teams on each and every
application that is deployed in the organization. Even worse, many
companies hire external consultants to help in the deployment of the
component, and then the consultants hand over the maintenance of that
software to internal teams. Some consultants don't fully bother with
secure configuration deployment guides, or even feel the need to disable
security constraints put forth by the organization (policies and
standards) because "it is needed". A deployment is often seen as
successful when the software functionally works, which not necessarily
means that it is misconfiguration-free.

As a recent example that I came across, consider an application that
needs [Node.js](http://nodejs.org/). A consultancy firm is hired to set
up the infrastructure, and given full administrative rights on the
operating system to make sure that this particular component is deployed
fast (because the company wants to have the infrastructure in production
before the end of the week). Security is initially seen as less of a
concern, and the consultancy firm informs the customer (without any
guarantees though) that it will be set up "according to common best
practices". The company itself has no engineering team for Node.js nor
wants to invest in the appropriate resources (such as training) for
security engineers to review Node.js configurations. Yet the application
that is deployed on the Node.js application server is internet-facing,
so has a higher risk associated with it than a purely internal
deployment.

So, how to ensure that these applications cannot be exploited or, if an
exploit is done, how to ensure that the risks involved with the exploit
are contained? Well, this is where I believe SELinux has a great
potential. And although I'm talking about SELinux here, the same goes
for other similar technologies like [TOMOYO
Linux](http://en.wikipedia.org/wiki/TOMOYO_Linux), [grSecurity's RBAC
system](http://en.wikibooks.org/wiki/Grsecurity/The_RBAC_System),
[RSBAC](http://www.rsbac.org/) and more.

SELinux can provide a container, decoupled from the application itself
(but of course built for that particular application) which restricts
the behavior of that application on the system to those activities that
are expected. The application itself is not SELinux-aware (or does not
need to be - some applications are, but those that I am focusing on here
usually don't), but the SELinux access controls ensure that exploits on
the application cannot reach beyond those activities/capabilities that
are granted to it.

Consider the Node.js deployment from before. The Node.js application
server might need to connect to a [MongoDB](http://www.mongodb.org/)
cluster, so we can configure SELinux to allow just that, but all other
connections that originate from the Node.js deployment should be
forbidden. Worms (if any) cannot use this deployment then to spread out.
Same with access to files - the Node.js application probably only needs
access to the application files and not to other system files. Instead
of trying to run the application in a chroot (which requires engineering
effort from those people implementing Node.js, which could be a
consultancy firm that does not know or want to deploy within a chroot)
SELinux is configured to disallow any file access beyond the application
files.

With SELinux, the application can be deployed relatively safely while
ensuring that exploits (or abuse of misconfigurations) cannot spread.
All that the company itself has to do is to provide resources for a
SELinux engineering team (which can be just a responsibility of the
Linux engineering teams, but can be specialized as well). Such a team
does not need to be big, as policy development effort is usually only
needed during changes (for instance when the application is updated to
also send e-mails, in which case the SELinux policy can be adjusted to
allow that as well), and given enough experience, the SELinux
engineering team can build flexible policies that the administration
teams (those that do the maintenance of the servers) can tune the policy
as needed (for instance through SELinux booleans) without the need to
have the SELinux team work on the policies again.

Using SELinux also has a number of additional advantages which other,
sometimes commercial tools (like Symantecs SPE/SCSP - really Symantec,
you ask customers to disable SELinux?) severly lack.

-   SELinux is part of a default Linux installation in many cases.
    RedHat Enterprise Linux ships with SELinux by default, and actively
    supports SELinux when customers have any problems with it. This also
    improves the likelihood for SELinux to be accepted, as other, third
    party solutions might not be supported. Ever tried getting support
    for a system on which both McAfee AV for Linux and Symantec SCSP are
    running (if you got it to work together at all)? At least McAfee
    gives pointers to how to update [SELinux
    settings](https://kc.mcafee.com/corporate/index?page=content&id=KB67360)
    when they would interfere with McAfee processes.
-   SELinux is widely known and many resources exist for users,
    administrators and engineers to learn more about it. The resources
    are freely available, and often kept up2date by a very
    motivated community. Unlike commercial products, whose support pages
    are hidden behind paywalls, customers are usually prevented from
    interacting with each other and tips and tricks for using the
    product are often not found on the Internet, SELinux information can
    be found almost everywhere. And if you like books, I have a couple
    for you to read: [SELinux System
    Administration](https://www.packtpub.com/networking-and-servers/selinux-system-administration)
    and [SELinux
    Cookbook](https://www.packtpub.com/networking-and-servers/selinux-cookbook),
    written by yours truly.
-   Using SELinux is widely supported by third party configuration
    management tools, especially in the free software world.
    [Puppet](http://puppetlabs.com/), [Chef](https://www.chef.io/chef/),
    [Ansible](http://www.ansible.com/home),
    [SaltStack](http://www.saltstack.com/) and others all support
    SELinux and/or have modules that integrate SELinux support in the
    management system.
-   Using SELinux incurs no additional licensing costs.

Now, SELinux is definitely not a holy grail. It has its limitations, so
security should still be seen as a global approach where SELinux is just
playing one specific role in. For instance, SELinux does not prevent
application behavior that is allowed by the policy. If a user abuses a
configuration and can have an application expose information that the
user usually does not have access to, but the application itself does
(for instance because other users on that application might) SELinux
cannot do anything about it (well, not as long as the application is not
made SELinux-aware). Also, vulnerabilities that exploit application
internals are not controlled by SELinux access controls. It is the
application behavior ("external view") that SELinux controls. To
mitigate in-application vulnerabilities, other approaches need to be
considered (such as memory protections for free software solutions,
which can protect against some kinds of exploits - see
[grsecurity](http://grsecurity.net/) as one of the solutions that could
be used).

Still, I believe that SELinux can definitely provide additional
protections for such "one-time deployments" where a company cannot
invest in resources to provide engineering services on those
deployments. The SELinux security controls do not require engineering on
the application side, making investments in SELinux engineering very
much reusable.
