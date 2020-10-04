Title: My application base: graphviz
Date: 2013-06-09 03:50
Category: Free Software
Tags: dependencies, dot, graphviz, mab, neato, scheduling, visualization, visualize
Slug: my-application-base-graphviz

Visualization of data is often needed in order to understand what the
data means. When data needs to be visualized automatically, I often use
the [graphviz](http://www.graphviz.org/) tools. Not that they are
extremely pretty, but it works very well and is made to be automated.

Let me give a few examples of when visualization helps...

In SELinux, there is the notion of domain transitions: security contexts
that can transition to another security context (and thus change the
permissions that the application/process has). Knowing where domains can
transition to (and how) as well as how domains can be transitioned to
(so input/output, if you may) is an important aspect to validate the
security of a system. The information can be obtained from tools such as
**sesearch**, but even on a small system you easily find hundreds of
transitions that can occur. Visualizing the transitions in a graph
(using **dot** or **neato**) shows how a starting point can move (or
cannot move - equally important to know ;-) to another domain. So a
simple **sesearch** with a few **awk** statements in the middle and a
**dot** at the end produces a nice graph in PNG format to analyze
further.

A second visualization is about dependencies. Be it package dependencies
or library dependencies, or even architectural dependencies (in IT
architecturing, abstraction of assets and such also provides a
dependency-like structure), with the Graphviz tools the generation of
dependency graphs can be done automatically. At work, I sometimes use a
simple home-brew web-based API to generate the data (similar to
[Ashitani's Ajax/Graphviz](http://ashitani.jp/gv/)) since the
workstations don't allow installation of your own software - and they're
windows.

Another purpose I use graphviz for is to quickly visualize processes
during the design. Of course, this can be done using Visio or Draw.io
easily as well, but these have the disadvantage that you already require
some idea on how the process will evolve. With the dot language, I can
just start writing processes in a simple way, combining steps into
clusters (or in scheduling terms: streams or applications ;-) and let
Graphviz visualize it for me. When the process is almost finished, I can
either copy the result in Draw.io to generate a nicer drawing or use the
Graphviz result (especially when the purpose was just rapid
prototyping).

And sometimes it is just fun to generate graphs based on data. For
instance, I can take the IRC logs of \#gentoo or \#gentoo-hardened to
generate graphs showing interactions between people (who speaks to who
and how frequently) or to find out the strength of topics (get the
keywords and generate communication graphs based on those keywords).
