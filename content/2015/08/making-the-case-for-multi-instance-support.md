Title: Making the case for multi-instance support
Date: 2015-08-22 12:45
Category: Architecture
Slug: making-the-case-for-multi-instance-support

With the high attention that technologies such as [Docker](https://www.docker.com/),
[Rocket](https://coreos.com/blog/rocket/) and the like get (I recommend to look at 
[Bocker](https://github.com/p8952/bocker) by Peter Wilmott as well ;-), I
still find it important that technologies are well capable of supporting a
multi-instance environment.

Being able to run multiple instances makes for great consolidation. The system
can be optimized for the technology, access to the system limited to the admins
of said technology while still providing isolation between instances. For some
technologies, running on commodity hardware just doesn't cut it (not all 
software is written for such hardware platforms) and consolidation allows for
reducing (hardware/licensing) costs.

<!-- PELICAN_END_SUMMARY -->

**Examples of multi-instance technologies**

A first example that I'm pretty familiar with is multi-instance database
deployments: Oracle DBs, SQL Servers, PostgreSQLs, etc. The consolidation
of databases while still keeping multiple instances around (instead of
consolidating into a single instance itself) is mainly for operational 
reasons (changes should not influence other database/schema's) or
technical reasons (different requirements in parameters, locales, etc.)

Other examples are web servers (for web hosting companies), which next to
virtual host support (which is still part of a single instance) could
benefit from multi-instance deployments for security reasons (vulnerabilities
might be better contained then) as well as performance tuning. Same goes
for web application servers (such as TomCat deployments).

But even other technologies like mail servers can benefit from multiple
instance deployments. Postfix has a [nice guide](http://www.postfix.org/MULTI_INSTANCE_README.html)
on multi-instance deployments and also covers some of the use cases for it.

**Advantages of multi-instance setups**

The primary objective that most organizations have when dealing with multiple
instances is the consolidation to reduce cost. Especially expensive, 
propriatary software which is CPU licensed gains a lot from consolidation 
(and don't think a CPU is a CPU, each company
[has](http://www-01.ibm.com/software/passportadvantage/pvu_licensing_for_customers.html)
[its](http://www.oracle.com/us/corporate/contracts/processor-core-factor-table-070634.pdf) (PDF)
[own](go.microsoft.com/fwlink/?LinkID=229882) (PDF) core weight table to
get the most money out of their customers).

But beyond cost savings, using multi-instance deployments also provides for
resource sharing. A high-end server can be used to host the multiple instances,
with for instance SSD disks (or even flash cards), more memory, high-end CPUs,
high-speed network connnectivity and more. This improves performance considerably,
because most multi-instance technologies don't need all resources continuously.

Another advantage, if properly designed, is that multi-instance capable software
can often leverage the multi-instance deployments for fast changes. A database
might be easily patched (remove vulnerabilities) by creating a second codebase
deployment, patching that codebase, and then migrating the database from one
instance to another. Although it often still requires downtime, it can be made
considerably less, and roll-back of such changes is very easy.

A last advantage that I see is security. Instances can be running as different
runtime accounts, through different SELinux contexts, bound on different
interfaces or chrooted into different locations. This is not an advantage
compared to dedicated systems of course, but more an advantage compared
to full consolidation (everything in a single instance).

**Don't always focus on multi-instance setups though**

Multiple instances isn't a silver bullet. Some technologies are generally much
better when there is a single instance on a single operating system. Personally,
I find that such technologies should know better. If they are really designed to
be suboptimal in case of multi-instance deployments, then there is a design error.

But when the advantages of multiple instances do not exist (no license cost,
hardware cost is low, etc.) then organizations might focus on single-instance
deployments, because

- multi-instance deployments might require more users to access the system
  (especially when it is multi-tenant)
- operational activities might impact other instances (for instance updating 
  kernel parameters for one instance requires a reboot which affects other
  instances)
- the software might not be properly "multi-instance aware" and as such
  starts fighting for resources with its own sigbling instances

Given that properly designed architectures are well capable of using
virtualization (and in the future containerization) moving towards
single-instance deployments becomes more and more interesting.

**What should multi-instance software consider?**

Software should, imo, always consider multi-instance deployments. Even
when the administrator decides to stick with a single instance, all that
that takes is that the software ends up with a "single instance" setup
(it is _much_ easier to support multiple instances and deploy a single one,
than to support single instances and deploy multiple ones).

The first thing software should take into account is that it might (and
will) run with different runtime accounts - service accounts if you whish.
That means that the software should be well aware that file locations are
separate, and that these locations will have different access control settings
on them (if not just a different owner).

So instead of using `/etc/foo` as the mandatory location, consider supporting
`/etc/foo/instance1`, `/etc/foo/instance2` if full directories are needed, or
just have `/etc/foo1.conf` and `/etc/foo2.conf`. I prefer the directory approach,
because it makes management much easier. It then also makes sense that the log
location is `/var/log/foo/instance1`, the data files are at `/var/lib/foo/instance1`,
etc.

The second is that, if a service is network-facing (which most of them
are), it must be able to either use multihomed systems easily (bind to
different interfaces) or use different ports. The latter is a challenge
I often come across with software - the way to configure the software to
deal with multiple deployments and multiple ports is often a lengthy
trial-and-error setup.

What's so difficult with using a _base port_ setting, and document how the
other ports are derived from this base port. [Neo4J](http://neo4j.com/docs/stable/ha-setup-tutorial.html)
needs 3 ports for its enterprise services (transactions, cluster management
and online backup), but they all need to be explicitly configured if you
want a multi-instance deployment. What if one could just set `baseport = 5001`
with the software automatically selecting 5002 and 5003 as other ports (or 6001
and 7001). If the software in the future needs another port, there is no need
to update the configuration (assuming the administrator leaves sufficient room).

Also consider the service scripts (`/etc/init.d`) or similar (depending on the
init system used). Don't provide a single one which only deals with one instance.
Instead, consider supporting symlinked service scripts which automatically obtain
the right configuration from its name.

For instance, a service script called `pgsql-inst1` which is a symlink to
`/etc/init.d/postgresql` could then look for its configuration in `/var/lib/postgresql/pgsql-inst1`
(or `/etc/postgresql/pgsql-inst1`). 

Just like supporting [.d directories](http://blog.siphos.be/2013/05/the-linux-d-approach/),
I consider multi-instance support an important non-functional requirement for software.

