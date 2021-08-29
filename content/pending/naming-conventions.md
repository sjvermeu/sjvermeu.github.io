Title: Naming conventions
Date: 2021-09-01 00:00
Category: Architecture
Tags: naming
Slug: naming-conventions
Status: draft

Naming conventions. Picking the right naming convention is easy if you are all
by yourself, but hard when you need to agree upon the conventions in a larger
group. Everybody has an opinion on naming conventions, and once you make a
decision on it, you do expect everybody to follow through on it.

Let's consider why naming conventions are (not) important and consider a few
examples to help in creating a good naming convention yourself.

**Naming conventions imply standardization**

When you settle on a naming convention, you're effectively putting some
standardization in place which you expect everybody to follow, and which should
also cover 100% of the cases. So, when assessing a possible naming convention,
first identify what standards you really need to enforce and are future proof.

Say you are addressing database object naming conventions. Are you able to
enforce this at all times? You might want to start tables with `tbl_` and views
with `vw_`, but when you are dealing with ISV software, they generally do not
allow such freedom on 'their' database definitions. Your DBAs thus will learn
to deal with setups that are more flexible anyway.

Using a naming convention for internal development is of course still a
possible venue to take. But in that case, you will need to look at the
requirements from the development teams (and related stakeholders).

**Standardization does not imply naming conventions**

The inverse isn't true: even though you might have certain standards in place,
it doesn't mean that the object names need to reflect the standards. If your
company standardizes on two operating systems (like Red Hat Enterprise Linux
and Microsoft Windows), it doesn't mean that server names have to include an
identifier that maps to Linux or Windows.

I personally often fall into this trap - I see standards, so I want to see them
fixed in the naming convention, because that allows better control over
following the standards. But naming conventions aren't about control, they are
about exposing identifiable information.

**Structure it for readability**

Trying to add too much information in a naming convention makes it
more complex for users to deal with. You might be able to read and understand
the naming convention immediately upon seeing it, but are all the other
stakeholders equally invested in understanding the naming conventions? 

Say that you have a hostname that looks like so:

```
sppchypkc05m01.reg1.internal.company.com
```

While I can tell you that this name comes from the following convention, it
might be overdoing things:

* **s** to identify it is a server
* **p** to identify it is a physical server
* **p** to identify it is hosted in a production environment
* **c** to identify it is a cattle-alike managed server
* **hypk** to identify the ownership (in this case, hypervisor usage, KVM)
* **c05** to identify it is the fifth cluster
* **m01** to identify it is the first master node
* **reg1** to identify the first region (location)

Even if you still want to include this information, using separators might make
this more obvious. For instance, for the given name, I would suggest splitting
this as follows:

```
sppc-hypk-c05m01.reg1.internal.company.com
```

The first two parts are then global naming convention requirements, with the
first set being about the type of systen whereas the second is about ownership,
and the third is then a naming convention specific to that owner.

**Choose what information to expose easily**

Assets that follow a certain naming convention provide information about that
asset that a reader can immediately assume, without having to do additional
lookups. The intention here is that you want to define important information
that many stakeholders will need immediately to support their work (and thus
their efficiency). Insights that are useful for a select set of stakeholders
might not be suitable for a naming convention (or at least not a global one).

You should consider every stakeholder that comes in contact with the name of
the asset, and how that stakeholder would obtain the information they need. If
you have a central, easily accessible configuration management system, it might
be possible to have most structured insights exposed through that interface,
but is that useful when you are dealing with lists of assets?

Suppose you do not include the host class for hostnames, with host class being
what class of system the host is (server, workstation, router, firewall,
appliance, ...). Does your SOC team need this insight every time they are going
through events? Does your helpdesk need that information? What about the
resource managers?

If all these stakeholders do need that information over and over again, it
might be sensible to include it in the naming convention. If however only a few
stakeholders need that information, you might want to expose that easily
through different means. For instance, resource managers might be able to
easily join that information with the asset management system information.

**Choose what information NOT to expose easily**

Sometimes, you want to have some information about objects easily available,
but not for everybody. It might be information that can be abused for nefarious
purposes. In that case, you want this information to be shielded and only
offered to authenticated and authorized users.

For instance, if you use separate accounts for administering systems, you might
not want to add information about what type of admin account it is, as account
enumeration might reveal too much immediately and provide attackers with better
insights.

So, rather than having `ken_adadmin` for Ken's Active Directory administration
account, stick to a nonsensible account identification like `ua1503` (user
account 1503). Stakeholders that need information about accounts in this case
can still notice it is a user account rather than a system or machine account,
and will need to query the central repositories for more information (such as
AD to get information about the user - and don't forget to add sensitive users
to for instance the `Protected Users` group in AD).

**Use layered naming conventions**

With "global naming convention" I am suggesting the ability to add naming
conventions for specific purposes, but leave that open in general. A server
name could for instance require an indication of the environment (production or
not) and the fact that it is a server (and not a workstation), but leave a part
of the name open for the administrators. The administrators can then add their
own specific naming convention to it.

An active directory group for instance might have a standard global naming
convention (usually the start of the group name) and leave the second part
open, whereas specific teams can then use that part to add in their own naming
convention. Groups that are used for NAS access might then use a naming
convention to identify which NAS share and which privileges are assigned,
whereas a group that is used for remote access support can use VPN naming
conventions.

The University of Wisconsin has their [Campus Active Directory - Naming
Convention](https://kb.wisc.edu/iam/page.php?id=30600) published online, and
the workstation and server object part is a good example of this: while the
objects in AD have to follow a global naming convention (because Active
Directory is often core to an organization) it leaves some room for local
department policies to assign their own requirements:
`<department><objectfunction>-<suffix>` only has the first two fields
standardized globally, with the `<suffix>` field left open (but within certain
length constraints).

**Consider the full name for your naming conventions**

If you do want to add in information in a naming convention, do not consider
this purely on a single object type, but at the full name. A hostname by itself
is just a hostname, but when you consider the fully qualified hostname (thus
including domain names) you know that certain information points can be put in
the domain name rather than the hostname.

The people over at [Server Density](https://www.serverdensity.com/) have a post
titled "[Server Naming Conventions and Best
Practices](https://blog.serverdensity.com/server-naming-conventions-and-best-practices/)"
where they describe that the data center location (for the server) is a
subdomain.

For databases for instance, you not only have a table, but also the database in
which the table is located. Hence, ownership of that table can easily be
considered on the database level.

**Learn from mistakes or missing conventions**

As you approach naming conventions, you will make mistakes. But before making
mistakes yourself, try looking out for public failures that might have been due
to (bad or missing) naming conventions. Now, most public root cause analysis
reports do not go in depth on the matter completely, but they do provide some
insights we might want to learn from.

For instance, the incident that AWS had on February 28th 2017 has a [Summary of
the Amazon S3 Service Disruption in the Northern Virginia (US-EAST-1)
Region](https://aws.amazon.com/message/41926/). While there is no immediate
indication about the naming conventions used (mainly that a wrong command input
impacted more servers than it should), we could ask ourselves if the functional
purpose of the servers was included in the name (or, if not in the name, if it
was added in other labeling information that the playbook should use).

The analysis does reveal that AWS moved on to implement partitions (which they
call cells), and it is likely that the cell name will become part of the naming
convention (or other identifier).

But also internally, it is important to go over the major incidents and their
root causes, and see if the naming conventions of the company are appropriate
or not.

**Still need examples?**

While most commercial companies will not expose their own naming conventions
(as there is no value for them to receive, and it exposes information that
malicious users might abuse), many governmental agencies and educational
institutions do have this information publicly available, given their
organization public nature.

Hence, searching for "naming convention" on `*.gov` and `*.edu` already reveals
many examples.

Personally, I am still a stickler for naming conventions, but I am slowly
accepting that some information might be better exposed elsewhere.

<!-- PELICAN_END_SUMMARY -->
