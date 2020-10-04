Title: Putting OVAL at work
Date: 2013-08-01 15:01
Category: Security
Tags: baseline, benchmark, oval, security, xccdf
Slug: putting-oval-at-work

When we look at the [SCAP security standards](http://scap.nist.gov/),
you might get the feeling of "How does this work". The underlying
interfaces, like OVAL and XCCDF, might seem a bit daunting to implement.

This is correct, but you need to remember that the standards are
protocols, agreements that can be made across products so that several
products, each with their own expertise, can work together easily. It is
a matter of interoperability between components.

Let's look at the following diagram to see how OVAL and XCCDF *can* be
used. I'm not saying this is the only way forward, but it is a possible
approach.

(Diagram lost during blog conversion)

On the local side (and local here doesn't mean a single server, but
rather an organization or company) a list of checks is maintained. These
checks are OVAL checks, which can be downloaded from reputable sites
like NVD or are given to you by vendors (some vendors provide OVAL as
part of vulnerability reports). Do not expect this list to be hundreds
of checks - start small, the local database of checks will grow anyhow.

The advantage is that the downloaded checks (OVALs) already have a
unique identifier (the OVAL ID). For instance, the check "Disable Java
in Firefox" for Windows is `oval:org.mitre.oval:def:12609`. If
additional Windows operating systems are added, this ID remains the same
(it is updated) because the check (and purpose) remains the same.

Locally, the OVAL checks are ran against targets by an OVAL interpreter.
Usually, you will have multiple interpreters in the organization, some
of them focused on desktops, some on servers, some perhaps on network
equipment, etc. By itself that doesn't matter, as long as they interpret
the OVAL checks. The list of targets to check against are usually
managed in a configuration management database.

Targets can be of various granularity. The "Disable Java in Firefox"
will be against an operating system (where the check then sees if the
installed Firefox indeed has the setting disabled), but a check that
validates the permissions (rights) of a user will be against this user
account.

The results of the OVAL checks are stored in a database that maps the
result against the target. By itself this result database does not
contain much more logic than "This rule is OK against this target and
that rule isn't" (well, there is some granularity, but not much more)
and the time stamp when this was done.

Next comes the XCCDF. XCCDF defines the state that you want the system
to be in. It is a benchmark, a document describing how the system /
target should be configured. XCCDF documents usually contain the whole
shebang of configuration settings, and then differentiate them based on
profiles. For instance, a web server attached to the Internet might have
a different profile than a web server used internally or for development
purposes.

The XCCDF document refers to OVAL checks, and thus uses the results from
the OVAL result database to see if a target is fully aligned with the
requirements or not. The XCCDF results themselves are also stored, often
together with exceptions (if any) that are approved (for instance, you
want to keep track of the workstations where Java *is* enabled in
Firefox and only report for those systems where it is enabled by the
user without approval). Based on these results, reports can be generated
on the state of your park.

Not all checks are already available as OVAL checks. Of course you can
write them yourself, but there are also other possibilities. Next to
OVAL, there are (less standardized) methods for doing checks which
integrate with XCCDF as well. The idea you'll need to focus on then is
the same as with OVAL: what is your source, how do you store it, you
need interpreters that can "play" it, and on the reporting side you'll
need to store the results so you can combine them later in your
reporting.
