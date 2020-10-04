Title: Project prioritization
Date: 2017-07-18 20:40
Category: Architecture
Tags: pmo, strategy, SAFe, prioritization, project
Slug: project-prioritization

<sub>This is a long read, skip to “Prioritizing the projects and changes” for the
approach details...</sub>

Organizations and companies generally have an IT workload (dare I say,
backlog?) which needs to be properly assessed, prioritized and taken up.
Sometimes, the IT team(s) get an amount of budget and HR resources to "do their
thing", while others need to continuously ask for approval to launch a new
project or instantiate a change.
 
Sizeable organizations even require engineering and development effort on IT
projects which are not readily available: specialized teams exist, but they are
governance-wise assigned to projects. And as everyone thinks their project is
the top-most priority one, many will be disappointed when they hear there are
no resources available for their pet project.
 
So... how should organizations prioritize such projects?
 
<!-- PELICAN_END_SUMMARY -->

**Structure your workload, the SAFe approach**
 
A first exercise you want to implement is to structure the workload, ideas or
projects. Some changes are small, others are large. Some are disruptive, others
are evolutionary. Trying to prioritize all different types of ideas and changes
in the same way is not feasible.
 
Structuring workload is a common approach. Changes are grouped in projects,
projects grouped in programs, programs grouped in strategic tracks. Lately,
with the rise in Agile projects, a similar layering approach is suggested in
the form of SAFe.
 
In the [Scaled Agile Framework][1] a structure is suggested that uses, as a
top-level approach, value streams. These are strategically aligned steps that
an organization wants to use to build solutions that provide a continuous flow
of value to a customer (which can be internal or external). For instance, for a
financial service organization, a value stream could focus on 'Risk Management
and Analytics'.
 
![SAFe full framework]({static}/images/201707/safe-full.png)

<sub>SAFe full framework overview, picture courtesy of www.scaledagileframework.com</sub>

The value streams are supported through solution trains, which implement
particular solutions. This could be a final product for a customer (fitting in
a particular value stream) or a set of systems which enable capabilities for a
value stream. It is at this level, imo, that the benefits exercises from IT
portfolio management and benefits realization management research plays its
role (more about that later). For instance, a solution train could focus on an
'Advanced Analytics Platform'.
 
Within a solution train, agile release trains provide continuous delivery for
the various components or services needed within one or more solutions. Here,
the necessary solutions are continuously delivered in support of the solution
trains. At this level, focus is given on the culture within the organization
(think DevOps), and the relatively short-lived delivery delivery periods. This
is the level where I see 'projects' come into play.
 
Finally, you have the individual teams working on deliverables supporting a
particular project.
 
SAFe is just one of the many methods for organization and development/delivery
management. It is a good blueprint to look into, although I fear that larger
organizations will find it challenging to dedicate resources in a manageable
way. For instance, how to deal with specific expertise across solutions which
you can't dedicate to a single solution at a time? What if your organization
only has two telco experts to support dozens of projects? Keep that in mind,
I'll come back to that later...
 
**Get non-content information about the value streams and solutions**
 
Next to the structuring of the workload, you need to obtain information about
the solutions that you want to implement (keeping with the SAFe terminology).
And bear in mind that seemingly dull things such as ensuring your firewalls are
up to date are also deliverables within a larger ecosystem. Now, with
information about the solutions, I don't mean the content-wise information, but
instead focus on other areas.
 
Way back, in 1952, Harry Markowitz introduced [Modern portfolio theory][2] as a
mathematical framework for assembling a portfolio of assets such that the
expected return is maximized for a given level of risk (quoted from Wikipedia).
This was later used in an IT portfolio approach by McFarlan in his [Portfolio
Approach to Information Systems][3] article, published in September 1981.
 
There it was already introduced that risk and return shouldn't be looked at
from an individual project viewpoint, but how it contributes to the overall
risk and return. A balance, if you wish. His article attempts to categorize
projects based on risk profiles on various areas. Personally, I see the
suggested categorization more as a way of supporting workload assessments (how
many mandays of work will this be), but I digress.
 
Since then, other publications came up which tried to document frameworks and
methodologies that facilitate project portfolio prioritization and management.
The focus often boils down to value or benefits realization. In [The
Information Paradox][4] John Thorp comes up with a benefits realization
approach, which enables organizations to better define and track benefits
realization - although it again boils down on larger transformation exercises
rather than the lower-level backlogs. The realm of [IT portfolio management][5]
and [Benefits realization management][6] gives interesting pointers as to
the lecture part of prioritizing projects.
 
Still, although one can hardly state the resources are incorrect, a common
question is how to make this tangible. Personally, I tend to view the above on
the value stream level and solution train level.  Here, we have a strong
alignment with benefits and value for customers, and we can leverage the ideas
of past research.
 
The information needed at this level often boils down to strategic insights and
business benefits, coarse-grained resource assessments, with an important focus
on quality of the resources. For instance, a solution delivery might take up
500 days of work (rough estimation) but will also require significant back-end
development resources.
 
**Handling value streams and solutions**
 
As we implement this on the highest level in the structure, it should be
conceivable that the overview of the value streams (a dozen or so) and
solutions (a handful per value stream) is manageable, and something that at an
executive level is feasible to work with. These are the larger efforts for
structuring and making strategic alignment. Formal methods for prioritization
are generally not implemented or described.
 
In my company, there are exercises that are aligning with SAFe, but it isn't
company-wide. Still, there is a structure in place that (within IT) one could
map to value streams (with some twisting ;-) and, within value streams, there
are structures in place that one could map to the solution train exercises.
 
We could assume that the enterprise knows about its resources (people, budget
...) and makes a high-level suggestion on how to distribute the resources in
the mid-term (such as the next 6 months to a year). This distribution is
challenged and worked out with the value stream owners. See also "lean
budgeting" in the SAFe approach for one way of dealing with this.
 
There is no prioritization of value streams. The enterprise has already made
its decision on what it finds to be the important values and benefits and
decided those in value streams.
 
Within a value stream, the owner works together with the customers (internal or
external) to position and bring out solutions. My experience here is that
prioritization is generally based on timings and expectations from the
customer. In case of resource contention, the most challenging decision to make
here is to put a solution down (meaning, not to pursue the delivery of a
solution), and such decisions are hardly taken.
 
**Prioritizing the projects and changes**
 
In the lower echelons of the project portfolio structure, we have the projects
and changes. Let's say that the levels here are projects (agile release trains)
and changes (team-level). Here, I tend to look at prioritization on project
level, and this is the level that has a more formal approach for
prioritization.
 
Why? Because unlike the higher levels, where the prioritization is generally
quality-oriented on a manageable amount of streams and solutions, we have a
large quantity of projects and ideas. Hence, prioritization is more
quantity-oriented in which formal methods are more efficient to handle.
 
The method that is used in my company uses scoring criteria on a per-project
level. This is not innovative per se, as past research has also revealed that
project categorization and mapping is a powerful approach for handling project
portfolio's. Just look for "categorizing priority projects it portfolio" in
Google and you'll find ample resources. Kendal's [Advanced Project Portfolio
Management and the PMO][7] (book) has several example project scoring
criteria's. But allow me to explain our approach.

It basically is like so:

1. Each project selects three value drivers (list decided up front)
2. For the value drivers, the projects check if they contribute to it slightly (low), moderately (medium) or fully (high)
3. The value drivers have weights, as do the values. Sum the resulting products to get a priority score
4. Have the priority score validated by a scoring team

Let's get to the details of it.

For the IT projects within the infrastructure area (which is what I'm active
in), we have around 5 scoring criteria (value drivers) that are value-stream
agnostic, and then 3 to 5 scoring criteria that are value-stream specific. Each
scoring criteria has three potential values: low (2), medium (4) and high (9).
The numbers are the weights that are given to the value.
 
A scoring criteria also has a weight. For instance, we have a scoring criteria
on efficiency (read: business case) which has a weight of 15, so a score of
medium within that criteria gives a total value of 60 (4 times 15). The
potential values here are based on the "return on investment" value, with low
being a return less than 2 years, medium within a year, and high within a few
months (don't hold me on the actual values, but you get the idea).
 
The sum of all values gives a priority score. Now, hold your horses, because
we're not done yet. There is a scoring rule that says a project can only be
scored by at most 3 scoring criteria. Hence, project owners need to see what
scoring areas their project is mostly visible in, and use those scoring
criteria. This rule supports the notion that people don't bring around ideas
that will fix world hunger and make a cure for cancer, but specific, well
scoped ideas (the former are generally huge projects, while the latter requires
much less resources).
 
OK, so you have a score - is that your priority? No. As a project always falls
within a particular value stream, we have a "scoring team" for each value
stream which does a number of things. First, it checks if your project really
belongs in the right value stream (but that's generally implied) and has a
deliverable that fits the solution or target within that stream. Projects that
don't give any value or aren't asked by customers are eliminated.
 
Next, the team validates if the scoring that was used is correct: did you
select the right values (low, medium or high) matching the methodology for said
criteria? If not, then the score is adjusted.
 
Finally, the team validates if the resulting score is perceived to be OK or
not. Sometimes, ideas just don't map correctly on scoring criteria, and even
though a project has a huge strategic importance or deliverable it might score
low. In those cases, the scoring team can adjust the score manually. However,
this is more of a fail-safe (due to the methodology) rather than the norm.
About one in 20 projects gets its score adjusted. If too many adjustments come
up, the scoring team will suggest a change in methodology to rectify the
situation.
 
With the score obtained and validated by the scoring team, the project is given
a "go" to move to the project governance. It is the portfolio manager that then
uses the scores to see when a project can start.
 
**Providing levers to management**
 
Now, these scoring criteria are not established from a random number generator.
An initial suggestion was made on the scoring criteria, and their associated
weights, to the higher levels within the organization (read: the people in
charge of the prioritization and challenging of value streams and solutions).
 
The same people are those that approve the weights on the scoring criteria. If
management (as this is often the level at which this is decided) feels that
business case is, overall, more important than risk reduction, then they will
be able to put a higher value in the business case scoring than in the risk
reduction.
 
The only constraint is that the total value of all scoring criteria must be
fixed. So an increase on one scoring criteria implies a reduction on at least
one other scoring criteria. Also, changing the weights (or even the scoring
criteria themselves) cannot be done frequently. There is some inertia in
project prioritization: not the implementation (because that is a matter of
following through) but the support it will get in the organization itself.
 
Management can then use external benchmarks and other sources to gauge the
level that an organization is at, and then - if needed - adjust the scoring
weights to fit their needs.
 
**Resource allocation in teams**
 
Portfolio managers use the scores assigned to the projects to drive their
decisions as to when (and which) projects to launch. The trivial approach is to
always pick the projects with the highest scores. But that's not all.
 
Projects can have dependencies on other projects. If these dependencies are
"hard" and non-negotiable, then the upstream project (the one being dependent
on) inherits the priority of the downstream project (the one depending on the
first) if the downstream project has a higher priority. Soft dependencies
however need to validate if they can (or have to) wait, or can implement
workarounds if needed.
 
Projects also have specific resource requirements. A project might have a high
priority, but if it requires expertise (say DBA knowledge) which is unavailable
(because those resources are already assigned to other ongoing projects) then
the project will need to wait (once resources are fully allocated and the
projects are started, then they need to finish - another reason why projects
have a narrow scope and an established timeframe).
 
For engineers, operators, developers and other roles, this approach allows them
to see which workload is more important versus others. When their scope is
always within a single value stream, then the mentioned method is sufficient.
But what if a resource has two projects, each of a different value stream? As
each value stream has its own scoring criteria it can use (and weight), one
value stream could systematically have higher scores than others...
 
**Mixing and matching multiple value streams**
 
To allow projects to be somewhat comparable in priority values, an additional
rule has been made in the scoring methodology: value streams must have a
comparable amount of scoring criteria (value drivers), and the total value of
all criteria must be fixed (as was already mentioned before). So if there are
four scoring criteria and the total value is fixed at 20, then one value stream
can have its criteria at (5,3,8,4) while another has it at (5,5,5,5).
 
This is still not fully adequate, as one value stream could use a single
criteria with the maximum amount (20,0,0,0). However, we elected not to put in
an additional constraint, and have management work things out if the situation
ever comes out. Luckily, even managers are just human and they tend to follow
the notion of well-balanced value drivers.
 
The result is that two projects will have priority values that are currently
sufficiently comparable to allow cross-value-stream experts to be exchangeable
without monopolizing these important resources to a single value stream
portfolio.
 
**Current state**
 
The scoring methodology has been around for a few years already. Initially, it
had fixed scoring criteria used by three value streams (out of seven, the other
ones did not use the same methodology), but this year we switched to support
both value stream agnostic criteria (like in the past) as well as value stream
specific ones.

The methodology is furthest progressed in one value stream (with focus of around
1000 projects) and is being taken up by two others (they are still looking at
what their stream-specific criteria are before switching).


[1]: http://www.scaledagileframework.com/
[2]: https://en.wikipedia.org/wiki/Modern_portfolio_theory
[3]: https://hbr.org/1981/09/portfolio-approach-to-information-systems
[4]: https://books.google.be/books/about/The_Information_Paradox.html?id=mk60QgAACAAJ&redir_esc=y&hl=en
[5]: https://en.wikipedia.org/wiki/IT_portfolio_management
[6]: https://en.wikipedia.org/wiki/Benefits_realisation_management
[7]: https://www.amazon.com/Advanced-Project-Portfolio-Management-PMO/dp/1932159029
 
