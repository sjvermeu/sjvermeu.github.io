Title: Sustainability in IT
Date: 2022-09-25 13:00
Category: Architecture
Tags: sustainability
Slug: sustainability-in-IT
Status: published

For one of the projects I'm currently involved in, we want to have a better
view on sustainability within IT and see what we (IT) can contribute in light
of the sustainability strategy of the company. For IT infrastructure, one would
think that selecting more power-efficient infrastructure is the way to go, as
well as selecting products whose manufacturing process takes special attention
to sustainability. 

There are other areas to consider as well, though. Reusability of IT
infrastructure and optimal resource consumption are at least two other
attention points that deserve plenty of attention. But let's start at the
manufacturing process...

<!-- PELICAN_END_SUMMARY -->

**Certifications for products and companies**

Eco certifications are a good start in the selection process. By selecting
products with the right certification, companies can initiate their sustainable
IT strategy with a good start. Such certifications look at the product and
manufacturing, and see if they use proper materials, create products that
can have extended lifetimes in the circular (reuse) economy, ensure the
manufacturing processes use renewable energy and do not have harmful 
emissions, safeguard clean water, etc.

In the preliminary phase I am right now, I do not know yet which 
certifications make most sense to pursue and request. Sustainability is
becoming big business, so plenty of certifications exist as well. From a
cursory search, I'd reckon that the following certifications are worth more
time:

- [EcoVadis](https://ecovadis.com/) provides business sustainability ratings
  that not only cover the ecological aspect, but also social and ethical
  performance.
- [ISO 14001](https://www.iso.org/iso-14001-environmental-management.html)
  covers environmental management, looking at organizations' processes and
  systematic improvements contributing to sustainability.
- [Carbon Neutral](https://www.carbonneutral.com/) focus on transparency
  in measurements and disclosure of emissions, and how the company is
  progressing in their strategy to reduce the impact on the environment.
- [TCO Certified](https://tcocertified.com/) attempts to address all
  stages of a manufacturing process, from material selection over social 
  responsibility and hazardous substances up to electronic waste and 
  circular economy.
- [Energy Star](https://www.energystar.gov/) focuses on energy efficiency,
  and tries to use standardized methods for scoring appliances (including
  computers and servers).

**Power efficiency**

A second obvious part is on power efficiency. Especially in data center
environments, which is the area that I'm interested in, power efficiency
also influences the data center's capability of providing sufficient
cooling to the servers and appliances. Roughly speaking, a 500 Watt
server generates twice as much heat as a 250 Watt server. Now, that's
oversimplifying, but for calculating heat dissipation in a data center,
the maximum power of infrastructure is generally used for the calculations.

Now, we could start looking for servers with lower power consumption. But
a 250 Watt server is most likely going to be less powerful (computing-wise)
than a 500 Watt server. Hence, power efficiency should be considered in
line with the purpose of the server, and thus also the workloads that it
would have to process.

We can use benchmarks, like [SPEC's CPU 2017](https://www.spec.org/cpu2017/)
or [SPEC's Cloud IaaS 2018](https://www.spec.org/benchmarks.html) benchmarks,
to compare the performance of systems. Knowing the server's performance
for given workloads and the power consumption, allows architects to optimize
the infrastructure.

**Heat management (and more) in the data center**

A large consumer of power in a data center environment are the environmental
controls, with the cooling systems taking a big chunk out of the total
power consumption. Optimizing the heat management in the data center has a
significant impact on the power consumption. Such optimizations are not solely
about reducing the electricity bill, but also about reusing the latent heat
for other purposes. For instance, data center heat can be used to heat up
nearby buildings.

A working group of the European Commission, the European Energy Efficiency
Platform (E3P), publishes an annual set of best practices in the [EU Code
of Conduct on Data Center Energy Efficiency](https://e3p.jrc.ec.europa.eu/publications/2022-best-practice-guidelines-eu-code-conduct-data-centre-energy-efficiency)
which covers areas such as airflow design patterns, operating temperature
and humidity ranges, power management features in servers and appliances, 
infrastructure design aspects (like virtualization and appropriate, but no
over-engineered redundancy), etc.

This practice goes much beyond the heat management alone (and is worth
a complete read), covering the complete data center offering. Combining
these practices with other areas of data center design (such as redundancy
levels, covered by data center tiering) allows for companies that are looking
at new data centers to overhaul their infrastructure and be much better
prepared for sustainable IT.

**Circular ecosystem**

Another part that often comes up in sustainability measures is how reusable
the infrastructure components are after their "first life". Infrastructure
systems, which frequently renew after 4 to 5 years of activity, can be resold
rather than destroyed. The same can be said for individual components.

Companies that deal with sensitive data regularly employ "Do Not Return" clauses
in the purchases of storage devices. Disks are not returned if they are
faulty, or just swapped for higher density disks. Instead, they are routinely
destroyed to make sure no data leakage occurs.

Instead of destroying otherwise perfect disks (or disks that still have
reusable components) companies could either opt for degaussing (which still
renders the disk unusable, but has better recyclability than destroyed
disks) or data wiping (generally through certified methods that guarantee
the data cannot be retrieved).

**Extended lifecycle**

Systems are often working perfectly beyond their 4 to 5 year lifespans.
Still, these systems are process-wise automatically renewed to get more
efficient and powerful systems in place. But that might not always be necessary
- beyond even the circular ecosystem remarks above (where such systems could be
resold), these systems can even get extended lifecycle within the company.

If there is no need for a more powerful system, and the efficiency of
the system is still high (or the efficiency can be improved through
minor updates), companies can seek out ways to prolong the use of the
systems. In previous projects, I advised that big data nodes can
perfectly remain inside the cluster after their regular lifetime, as the
platform software (Hadoop) can easily cope with failures if those would
occur.

Systems can also be used to host non-production environments or support
lab environments. Or they can be refurbished to ensure maximal efficiency
while still being used in production. Microsoft for instance has a program
called [Microsoft Circular Centers](https://customers.microsoft.com/en-us/story/1431789627332547010-microsoft-circular-centers)
which aims at a zero-waste sustainability within the data center, through
reuse, repurpose and recycling.

**Right-sizing the infrastructure**

Right-sizing is to select and design infrastructure to deal with the
workload, but not more. Having a set of systems at full capacity is
better than having twice as many systems at half capacity, as this leads
to power inefficiencies.

To accomplish right-sizing isn't as easy as selecting the right server
for a particular workload. Workload is distributed, and systems are
virtualized. Virtualization allows for much better right-sizing as you
can distribute workload more optimally.

Companies with large amounts of systems can more efficiently distribute
workload across their systems, making it easier to have a good consumption
pattern. Smaller companies will notice that they need to design for
the burst and maximum usage, whereas the average usage is far, far below
that threshold. 

Using cloud resources can help to deal with bursts and higher demand, while
still having resources on-premise to deal with the regular workload. Such
hybrid designs, however, can be complex, so make sure to address this with
the right profiles (yes, I'm making a stand for architects here ;-)

Standardizing your infrastructure also makes this easier to accomplish.
If the vast majority of servers are of the same architecture, and you
standardize on as few operating systems, programming languages and what
not, you can more easily distribute workload than when these systems
have different architectures and purposes.

**Automated workload and power management**

Large environments will regularly have servers and infrastructure that is not
continuously used at near full capacity. Workloads are frequently following a
certain curve, such as higher demand during the day and lower at night.
Larger platforms use this curve to schedule appropriate workload (like
running heavy batch workload at night while keeping the systems available
for operational workload during the day) so that the resources are more
optimally used.

By addressing workload management and aligning power management, companies
can improve their power usage by reducing active systems when there are less
resource needs. This can be done gradually, such as putting CPUs in lower
power modes (CPU power takes roughly 30% of a system's total power usage),
but can expand to complete hosts being put in idle state.

We can even make designs where servers are shut down when unused. While
this is frequently frowned upon, citing possible impact on hardware
failures as well as reduced reactivity to sudden workload demand, proper
shutdown techniques do offer significant power savings (as per a
research article titled [Quantifying the Impact of Shutdown Techniques
for Energy-Efficient Data Centers](https://www.researchgate.net/publication/323356951_Quantifying_the_Impact_of_Shutdown_Techniques_for_Energy-Efficient_Data_Centers)).

**Conclusion**

Sustainability within IT focuses on several improvements and requirements.
Certification helps in finding and addressing these, but this is not
critical in any company's strategy. Companies can address sustainability
easily without certification, but with proper attention and design.

Feedback? Comments? Don't hesitate to [drop me an
email](mailto:sven.vermeulen@siphos.be), or join the [discussion on
Twitter](https://twitter.com/infrainsight/status/1573941352844464128).

