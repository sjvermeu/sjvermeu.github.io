Title: Comparing Hadoop with mainframe
Date: 2016-06-15 20:55
Category: Hadoop
Tags: hadoop, mainframe
Slug: comparing-hadoop-with-mainframe

At my work, I have the pleasure of being involved in a big data project that
uses Hadoop as the primary platform for several services. As an architect, I
try to get to know the platform's capabilities, its potential use cases, its
surrounding ecosystem, etc. And although the implementation at work is not in
its final form (yay agile infrastructure releases) I do start to get a grasp of
where we might be going.

For many analysts and architects, this Hadoop platform is a new kid on the block
so I have some work explaining what it is and what it is capable of. Not for the
fun of it, but to help the company make the right decisions, to support management
and operations, to lift the fear of new environments. One thing I've once said is
that "Hadoop is the poor man's mainframe", because I notice some high-level
similarities between the two.

<!-- PELICAN_END_SUMMARY -->

Somehow, it stuck, and I was asked to elaborate. So why not bring these points
into a nice blog post :)

**The big fat disclaimer**

Now, before embarking on this comparison, I would like to state that I am **not**
saying that Hadoop offers the same services, or even quality and functionality
of what can be found in mainframe environments. Considering how much time, effort
and experience was already put in the mainframe platform, it would be strange if
Hadoop could match the same. This post is to seek some similarities and, who knows,
learn a few more tricks from one or another.

Second, I am not an avid mainframe knowledgeable person. I've been involved as
an IT architect in database and workload automation technical domains, which also
spanned the mainframe parts of it, but most of the effort was within the distributed
world. Mainframes remain somewhat opaque to me. Still, that shouldn't prevent me
from making any comparisons for those areas that I do have some grasp on.

And if my current understanding is just wrong, I'm sure that I'll learn from the
comments that you can leave behind!

With that being said, here it goes...

**Reliability, Availability, Serviceability**

Let's start with some of the promises that both platforms make - and generally are
also able to deliver. Those promises are of reliability, availability and serviceability.

For the mainframe platform, these quality attributes are shown as the [mainframe strengths](https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zmainframe/zconc_RAS.htm).
The platform's hardware has extensive self-checking and self-recovery
capabilities, the systems can recover from failed components without service
interruption, and failures can be quickly determined and resolved. On the mainframes,
this is done through a good balance and alignment of hardware and software, design
decisions and - in my opinion - tight control over the various components and
services.

I notice the same promises on Hadoop. Various components are checking the state
of the hardware and other components, and when something fails, it is often 
automatically recovered without impacting services. Instead of tight control
over the components and services, Hadoop uses a service architecture and APIs
with Java virtual machine abstractions.

Let's consider hardware changes. 

For **hardware failure and component substitutions**, both platforms are capable
of dealing with those without service disruption.

- Mainframe probably has a better reputation in this matter, as its components
  have a very high Mean Time Between Failure (MTBF), and many - if not all - of
  the components are set up in a redundant fashion. Lots of error detection and
  failure detection processes try to detect if a component is close to failure,
  and ensure proper transitioning of any workload towards the other components
  without impact.
- Hadoop uses redundancy on a server level. If a complete server fails, Hadoop
  is usually able to deal with this without impact. Either the sensor-like
  services disable a node before it goes haywire, or the workload and data that
  was running on the failed node is restarted on a different node. 

Hardware (component) failures on the mainframe side will not impact the services
and running transactions. Component failures on Hadoop might have a noticeable
impact (especially if it is OLTP-like workload), but will be quickly recovered.

Failures are more likely to happen on Hadoop clusters though, as it was designed
to work with many systems that have a worse MTBF design than a mainframe. The
focus within Hadoop is on resiliency and fast recoverability. Depending on the
service that is being used, active redundancy can be in use (so disruptions are
not visible to the user).

If the Hadoop workload includes anything that resembles online transactional
processing, you're still better off with enterprise-grade hardware such as ECC
memory to at least allow improved hardware failure detection (and perform
proactive workload management). CPU failures are not that common (at least not
those without any upfront Machine Check Exception - MCE), and disk/controller
failures are handled through the abstraction of HDFS anyway.

For **system substitutions**, I think both platforms can deal with this in a
dynamic fashion as well:

- For the mainframe side (and I'm guessing here) it is possible to switch
  machines with no service impact *if* the services are running on LPARs
  that are joined together in a Parallel Sysplex setup (sort-of clustering
  through the use of the Coupling Facilities of mainframe, which is supported
  through high-speed data links and services for handling data sharing and
  IPC across LPARs). My company 
  [switched to the z13 mainframe](https://www-03.ibm.com/press/us/en/pressrelease/47812.wss)
  last year, and was able to keep core services available during the migration.
- For Hadoop systems, the redundancy on system level is part of its design.
  Extending clusters, removing nodes, moving services, ... can be done with
  no impact. For instance, switching the active HiveServer2 instance means
  de-registering it in the ZooKeeper service. New client connects are then no
  longer served by that HiveServer2 instance, while active client connections
  remain until finished.
  There are also in-memory data grid solutions such as through the Ignite
  project, allowing for data sharing and IPC across nodes, as well as
  building up memory-based services with Arrow, allowing for efficient
  memory transfers.

Of course, also **application level code failures** tend to only disrupt that
application, and not the other users. Be it because of different address
spaces and tight runtime control (mainframe) or the use of different
containers / JVMs for the applications (Hadoop), this is a good feat to have
(even though it is not something that differentiates these platforms from
other platforms or operating systems).

**Let's talk workloads**

When we look at a mainframe setup, we generally look at different workload
patterns as well. There are basically two main workload approaches for the
mainframe: batch, and On-Line Transactional Processing (OLTP) workload. In
the OLTP type, there is often an additional distinction between synchronous
OLTP and asynchronous OLTP (usually message-based). 

Well, we have the same on Hadoop. It was once a pure batch-driven platform
(and many of its components are still using batches or micro-batches in their
underlying designs) but now also provides OLTP workload capabilities. Most of
the OLTP workload on Hadoop is in the form of SQL-like or NoSQL database
management systems with transaction manager support though.

To manage these (different) workloads, and to deal with prioritization of
the workload, both platforms offer the necessary services to make things both
managed as well as business (or "fit for purpose") focused.

- Using the Workload Manager (WLM) on the mainframe, policies can be set on
  the workload classes so that an over-demand of resources (cross-LPARs) results
  in the "right" amount of allocations for the "right" workload. To actually 
  manage jobs themselves, the Job Entry Subsystem (JES) to receive jobs and
  schedule then for processing on z/OS. For transactional workload, WLM
  provides the right resources to for instance the involved IMS regions.
- On Hadoop, workload management is done through Yet Another Resource 
  Negotiator (YARN), which uses (logical) queues for the different workloads.
  Workload (Application Containers) running through these queues can be, 
  resource-wise, controlled both on the queue level (high-level resource
  control) as well as process level (low-level resource control) through
  the use of Linux Control Groups (CGroups - when using Linux based systems
  course).

If I would try to compare both against each other, one might say that the
YARN queues are like WLMs service classes, and for batch applications, the
initiators on mainframe are like the Application Containers within YARN
queues. The latter can also be somewhat compared to IMS regions in case
of long-running Application Containers.

The comparison will not hold completely though. WLM can be tuned based on
goals and will do dynamic decision making on the workloads depending on its
parameters, and even do live adjustments on the resources (through the 
System Resources Manager - SRM). Heavy focus on workload management on
mainframe environments is feasible because extending the available resources
on mainframes is usually expensive (additional Million Service Units - MSU).
On Hadoop, large cluster users who notice resource contention just tend
to extend the cluster further. It's a different approach.

**Files and file access**

Another thing that tends to confuse some new users on Hadoop is its approach
to files. But when you know some things about the mainframe, this does remain
understandable.

Both platforms have a sort-of master repository where data sets (mainframe)
or files (Hadoop) are registered in. 

- On the mainframe, the catalog translates data set names into the right
  location (or points to other catalogs that do the same)
- On Hadoop, the Hadoop Distributed File System (HDFS) NameNode is
  responsible for tracking where files (well, blocks) are located across
  the various systems

Considering the use of the repository, both platforms thus require the
allocation of files and offer the necessary APIs to work with them. But
this small comparison does not end here.

Depending on what you want to store (or access), the file format you use
is important as well.
- On mainframe, Virtual Storage Access Method (VSAM) provides both the
  methods (think of it as API) as well as format for a particular data
  organization. Inside a VSAM, multiple data entries can be stored in a
  structured way. Besides VSAM, there is also Partitioned Data Set/Extended
  (PDSE), which is more like a directory of sorts. Regular files are Physical
  Sequential (PS) data sets.
- On Hadoop, a number of file formats are supported which optimize the use of
  the files across the services. One is Avro, which holds both methods and
  format (not unlike VSAM), another is Optimized Row Columnar (ORC).  HDFS also
  has a number of options that can be enabled or set on certain locations (HDFS
  uses a folder-like structure) such as encryption, or on files themselves,
  such as replication factor.

Although I don't say VSAM versus Avro are very similar (Hadoop focuses more on
the concept of files and then the file structure, whereas mainframe focuses on
the organization and allocation aspect if I'm not mistaken) they seem to be
sufficiently similar to get people's attention back on the table.

**Services all around**

What makes a platform tick is its multitude of supported services. And even
here can we find similarities between the two platforms.

On mainframe, DBMS services can be offered my a multitude of softwares.
Relational DBMS services can be provided by IBM DB2, CA Datacom/DB, NOMAD, ...
while other database types are rendered by titles such as CA IDMS and ADABAS.
All these titles build upon the capabilities of the underlying components and
services to extend the platform's abilities.

On Hadoop, several database technologies exist as well. Hive offers a SQL layer
on top of Hadoop managed data (so does Drill btw), HBase is a non-relational
database (mainly columnar store), Kylin provides distributed analytics, MapR-DB
offers a column-store NoSQL database, etc.

When we look at transaction processing, the mainframe platform shows its decades
of experience with solutions such as CICS and IMS. Hadoop is still very much
at its infancy here, but with projects such as Omid or commercial software solutions
such as Splice Machine, transactional processing is coming here as well. Most
of these are based on underlying database management systems which are extended with
transactional properties.

And services that offer messaging and queueing are also available on both
platforms: mainframe can enjoy Tibco Rendezvous and IBM WebSphere MQ, while
Hadoop is hitting the news with projects such as Kafka and Ignite.

Services extend even beyond the ones that are directly user facing. For instance,
both platforms can easily be orchestrated using workload automation tooling.
Mainframe has a number of popular schedulers up its sleeve (such as IBM TWS,
BMC Control-M or CA Workload Automation) whereas Hadoop is generally easily
extended with the scheduling and workload automation software of the distributed
world (which, given its market, is dominated by the same vendors, although many
smaller ones exist as well). Hadoop also has its "own" little scheduling
infrastructure called Oozie.

**Programming for the platforms**

Platforms however are more than just the sum of the services and the properties
that it provides. Platforms are used to build solutions on, and that is true for
both mainframe as well as Hadoop.

Let's first look at scripting - using interpreted languages. On mainframe, you
can use the Restructed Extended Executor (REXX) or CLIST (Command LIST). Hadoop
gives you Tez and Pig, as well as Python and R (through PySpark and SparkR).

If you want to directly interact with the systems, mainframe offers the Time
Sharing Option/Extensions (TSO/E) and Interactive System Productivity Facility
(ISPF). For Hadoop, regular shells can be used, as well as service-specific
ones such as Spark shell. However, for end users, web-based services such 
as Ambari UI (Ambari Views) are generally better suited.

If you're more fond of compiled code, mainframe supports you with COBOL, Java
(okay, it's "a bit" interpreted, but also compiled - don't shoot me here), C/C++
and all the other popular programming languages. Hadoop builds on top of Java,
but supports other languages such as Scala and allows you to run native
applications as well - it's all about using the right APIs.

To support development efforts, Integrated Development Environments (IDEs) are
provided for both platforms as well. You can use Cobos, Micro Focus Enterprise
Developer, Rational Developer for System z, Topaz Workbench and more for
mainframe development. Hadoop has you covered with web-based notebook solutions
such as Zeppelin and JupyterHub, as well as client-level IDEs such as Eclipse
(with the Hadoop Development Tools plugins) and IntelliJ.

**Governing and managing the platforms**

Finally, there is also the aspect of managing the platforms.

When working on the mainframe, management tooling such as the Hardware
Management Console (HMC) and z/OS Management Facility (z/OSMF) cover operations
for both hardware and system resources. On Hadoop, central management
software such as Ambari, Cloudera Manager or Zettaset Orchestrator try to
cover the same needs - although most of these focus more on the software
side than on the hardware level.

Both platforms also have a reasonable use for multiple roles: application
developers, end users, system engineers, database adminstrators, operators, 
system administrators, production control, etc. who all need some kind of access
to the platform to support their day-to-day duties. And when you talk roles,
you talk authorizations.

On the mainframe, the Resource Access Control Facility (RACF) provides
access control and auditing facilities, and supports a multitude of services on
the mainframe (such as DB2, MQ, JES, ...). Many major Hadoop services, such
as HDFS, YARN, Hive and HBase support Ranger, providing a single pane for
security controls on the Hadoop platform.

Both platforms also offer the necessary APIs or hooks through which system
developers can fine-tune the platform to fit the needs of the business, or
develop new integrated solutions - including security oriented ones. 
Hadoop's extensive plugin-based design (not explicitly
named) or mainframe's Security Access Facility (SAF) are just examples of this.

**Playing around**

Going for a mainframe or a Hadoop platform will always be a management decision.
Both platforms have specific roles and need particular profiles in order to
support them. They are both, in my opinion, also difficult to migrate away from
once you are really using them actively (lock-in) although it is more digestible
for Hadoop given its financial implications.

Once you want to start meddling with it, getting access to a full platform used
to be hard (the coming age of cloud services makes that this is no longer the
case though), and both therefore had some potential "small deployment" uses.
Mainframe experience could be gained through the Hercules 390 emulator, whereas
most Hadoop distributions have a single-VM sandbox available for download.

To do a full scale roll-out however is much harder to do by your own. You'll
need to have quite some experience or even expertise on so many levels that 
you will soon see that you need teams (plural) to get things done.

This concludes my (apparently longer than expected) write-down of this matter.
If you don't agree, or are interested in some insights, be sure to comment!

