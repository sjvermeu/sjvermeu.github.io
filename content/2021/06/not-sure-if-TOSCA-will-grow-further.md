Title: Not sure if TOSCA will grow further
Date: 2021-06-30 14:30
Category: Architecture
Tags: architecture,cloud,TOSCA,OASIS,topology,orchestration,infrastructure,IaC,NFV
Slug: not-sure-if-TOSCA-will-grow-further
Status: published

TOSCA is an OASIS open standard, and is an abbreviation for *Topology and
Orchestration Specification for Cloud Applications*. It provides a
domain-specific language to describe how an application should be deployed
in the cloud (the topology), which and how many resources it needs, as well
as tasks to run when certain events occur (the orchestration). When I
initially came across this standard, I was (and still am) interested
in how far this goes. The promise of declaring an application (and even
bundling the necessary application artefacts) within a single asset and
then using this asset to deploy on whatever cloud is very appealing to
an architect. Especially in organizations that have a multi-cloud
strategy.

<!-- PELICAN_END_SUMMARY -->

But while I do see some adoption of TOSCA, I get the feeling that it is
struggling with its position against the various infrastructure-as-code
(IaC) frameworks that are out there. While many of these frameworks do
not inherently support the abstraction that TOSCA has, it is not all that
hard to apply similar principles and use those frameworks to facilitate
multi-cloud deployments.

Before considering the infrastructural value of TOSCA further, let's
see what TOSCA is about first.

**Simplifying and abstracting cloud deployments**

TOSCA offers a model where you can declare how an application should be
hosted in the cloud, or in a cloud-native environment (like a Kubernetes
cluster). For instance, you might want to describe a certain document
management system, which has a web application front-end deployed on 
a farm of web application servers with a load balancer in front of it,
a backend processing system, a database system and a document storage
system. With TOSCA, you can define these structural elements with their
resource requirements.

For instance, for the database system, we could declare that it has to
be a PostgreSQL database system with a certain administration password,
and within the database system we define two databases with their
own user roles:

```
topology_template:
  ...
  node_templates:
    db_server:
      type: tosca.nodes.Compute
      ...
    postgresql:
      type: tosca.nodes.DBMS.PostgreSQL
      properties:
        root_password: "..."
      requirements:
        host: db_server
    db_filemeta:
      type: tosca.nodes.Database.PostgreSQL
      properties:
        name: db_filemeta
        user: fmusr
        password: "..."
      artifacts:
        db_content:
          file: files/file_server_metadata.txt
          type: tosca.artifacts.File
      requirements:
        - host: postgresql
```

The parameters can, and should be further parameterized. TOSCA supports
declaring inputs that are provided upon deployment so you can safely
publicize the TOSCA structure without putting passwords in there
for instance. Furthermore, TOSCA allows you to add scripts to execute
when a resource is created, which is a common requirement for database
systems.

But that's not all. Within TOSCA, you then further define the relationship
between the different systems (nodes), including connectivity requirements.
Connections can then be further aligned with virtual networks to model
the network design of the application.

One of the major benefits of TOSCA is that it also provides abstraction on
the requirements. While the above example explicitly pushes for a PostgreSQL
database hosted on a specific compute server, we could also declare that we
need a database management system, or for the network part we need firewall
capabilities. The TOSCA interpreter, when mapping the model to the target
cloud environment, can then either suggest or pick the technology service
itself. The TOSCA model can then have different actions depending on the
selected technology. For the database for instance, it would have different
deployment scripts.

The last major benefit that I would like to point out are the workflow
and policy capabilities of TOSCA. You can declare how for instance a 
backup process should look like, or how to cleanly stop and start the
application. You can even model how a rolling upgrade of the application
or database could be handled.

**It is not just theoretical**

Standards can often be purely theoretical, with one or a few reference
implementations out there. That is not the case with TOSCA. While reading
up on TOSCA, it became clear that it has a strong focus on Network
Functions Virtualization (NFV), a term used to denote the shift
from appliance-driven networking capabilities towards an environment
that has a multitude of solutions running in virtual environments, and
where the infrastructure adopts to this virtualized situation with
(for network) virtual routers, firewalls, etc. Another standards body,
namely the European Telecommunications Standards Institute (ETSI), seems
to be the driving force behind the NFV architecture.

TOSCA has a simple profile for NFV, which aligns with ETSI's NFV and 
ensures that TOSCA parsers that support this profile can easily be used
to set up and manage solutions in virtualized environments (and thus
also cloud environments). The amount of online information about TOSCA
with respect to the NFV side is large, although still in my opinion
strongly vendor-oriented (products that support TOSCA) and standards-oriented
(talks about how well it fits). On TOSCA's [implementation stories](https://www.oasis-open.org/tosca-implementation-stories/)
page, two of the three non-vendor stories are within the telco industry.

There are a few vendors that heavily promote
TOSCA: [Cloudify](https://cloudify.co/) and [Ubicity](https://designer.otc-service.com)
offer multi-cloud orchestrators that are TOSCA-based. Many vendors, 
including the incumbent network technology vendors like Cisco and Nokia,
embrace TOSCA NFV. But most information from practical TOSCA usage out
there is in open source solutions. The list of [known TOSCA implementations](https://github.com/oasis-open/tosca-community-contributions/wiki/Known-TOSCA-Implementations)
mentions plenty of open source products. One of the solutions that I
am considering of playing around with is [turandot](https://turandot.puccini.cloud/),
which uses TOSCA to compose and orchestrate Kubernetes workloads.

As an infrastructure architect, TOSCA could be a nice way of putting
initial designs into practice: after designing solutions in a language
like ArchiMate, which is in general not 'executable', the next step could
be to move the deployment specifications into TOSCA and have the next
phases of the project use and enhance the TOSCA definition. But that
easily brings me to what I consider to be shortcomings of the current
situation.

**Inhibitors for growth potential**

There are a number of issues I have with the current state of TOSCA.

TOSCA's ecosystem *seems* to be lacking sufficient visualization support.
I did come across [Winery](https://projects.eclipse.org/projects/soa.winery)
but that seems to be it. I would really like to see a solution that reads
TOSCA and generates an architectural overview. For instance, for the
example I started this blog with, something like the following:

![Visualization of a deployment]({static}/images/202106/tosca-archimate.png)

Furthermore, my impression is that TOSCA is strongly and mostly Infrastructure
as a Service (IaaS) oriented. The company I currently work for strongly
focuses on platform services, managed cloud services rather than the
more traditional infrastructure services where we would still have to do
the blunt of the management ourselves. Can TOSCA still play a role
in solutions that are fully using platform services? Perhaps the answer
here is "no", as those managed services are often very cloud-vendor specific,
but that isn't always the case, and can often also be tackled using the
abstraction and implementation specifics that TOSCA supports.

I also have to rely too much on impressions. While the TOSCA ecosystem
has plenty of open source solutions out there, I find it hard to get
tangible examples: TOSCA definitions of larger-scale definitions that
not only show an initial setup, but are actively maintained to show
maintenance evolution of the solution. If TOSCA is so great for vendors
to have a cloud-independent approach, why do I find it hard to find
vendors that expose TOSCA files? If the adoption of TOSCA stops
at the standards bodies and too few vendors, then it is not likely
to grow much further.

TOSCA orchestration engines often are in direct competition with
general IaC orchestration like Terraform. Cloudify has a post that
[compares Terraform with their solution](https://cloudify.co/blog/terraform-vs-cloudify/)
but doesn't look into how Terraform is generally used in CI/CD
processes that join Terraform with the other services that create a
decent end-to-end orchestration for cloud deployments. For Kubernetes,
it competes with Helm and the likes - not fully, as TOSCA has other 
benefits of course, but if you compare how quickly Helm is taking
the lead in Kubernetes you can understand the struggle that TOSCA in
my opinion has.

Another inhibitor is TOSCA's name. If you search for information on
TOSCA, you need to exclude [Tricentis'](https://www.tricentis.com/resources/tricentis-tosca-overview/)
continuous testing platform, the [1900's Opera](https://en.wikipedia.org/wiki/Tosca),
and several other projects, films, and other entities that use the same
name. You'll need to explicitly mention OASIS and/or cloud as well if
you want to find decent articles about TOSCA, knowing well that there
can be pages out there that are missed because of it.

**Conclusion**

While I appreciate the value TOSCA brings, I feel that it might not grow
to its fullest potential. I hope to be wrong of course, and I would
like to see big vendors publish their reference architecture TOSCA material
so that large-scale solutions are shown to be manageable using TOSCA and
that solution architects do not need to reinvent the wheel over and
over again, as well as link architecture with the more operations
side of things.

**More resources**

To learn more about TOSCA, there are a few resources that I would recommend
here:

- [OASIS TOSCA Technical Committee](https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=tosca)
  has a number of resources linked. The [TOSCA Simple Profile in YAML Version 1.3](https://docs.oasis-open.org/tosca/TOSCA-Simple-Profile-YAML/v1.3/os/TOSCA-Simple-Profile-YAML-v1.3-os.pdf)
  PDF is a good read which gradually explains the structure of a TOSCA YAML
  file with plenty of examples.
- [Network Functions Virtualisation (NFV)](https://www.etsi.org/technologies/nfv)
  is the ETSI site on NFV. Given the focus on NFV that I find around when
  looking at TOSCA (and is even referenced on this page) understanding what
  NFV is about clarifies a bit more how valuable TOSCA is/can be in this
  environment.
- [OCB: AMA on TOSCA the Topology and Orchestration Specification for Cloud Applications - Tal Liron](https://www.youtube.com/watch?v=NHYRESmE6uA)
  is an hour-long briefing that covers TOSCA not only in theory but also applies
  it in practice, and covers some of the new features that are coming up.

