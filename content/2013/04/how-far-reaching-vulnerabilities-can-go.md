Title: How far reaching vulnerabilities can go
Date: 2013-04-09 19:39
Category: Security
Tags: firewall, patching, postgresql, security
Slug: how-far-reaching-vulnerabilities-can-go

If you follow the news a bit, you know that PostgreSQL has had a
significant security vulnerability. The PostgreSQL team announced it up
front and communicated how they would deal with the vulnerability (which
basically comes down to saying that it is severe, that the public
repositories will be temporarily frozen as developers add in the
necessary fixes and start building the necessary software for a new
release, and at the release moment give more details about the
vulnerability.

The exploitability of the vulnerability was quickly identified, and we
know that compromises wouldn't take long. A [blog
post](http://schemaverse.tumblr.com/post/47312545952/the-schemaverse-was-hacked)
from the schemaverse tells us that exploits won't take long (less than
24 hours) and due to the significance of the vulnerability, it cannot be
stressed enough that patching should really be part of the minimal
security requirements of any security-conscious organization. But
patching alone isn't the only thing to consider.

The notice that PostgreSQL mentions also that restricting access to the
database through `pg_hba.conf` isn't sufficient, as the vulnerable code
is executed before the `pg_hba.conf` file is read. So one of the
mitigations for the vulnerability would be a firewall (hostbased or
network) that restricts access to the database so only trusted addresses
are allowed. I'm personally an advocate in favor of hostbased firewalls.

But the thing that hits me the most, is the amount of applications that
use "embedded" postgresql database services in their product. If you
take part of a larger organization with a large portfolio of software
titles running in the data center, you'll undoubtedly have seen lists
(through network scans or otherwise) of systems that are running
PostgreSQL as part of the product installation (and not as a "managed"
database service). The HP GUIDManager or the NNMI components or the
Systems Insight Manager use embedded PostgreSQL services. The cloudera
manager can be easily set up with an "embedded" PostgreSQL (which
doesn't mean it isn't a full-fledged PostgreSQL, but rather that the
setup and management of the service is handled by the product instead of
by "your own" DBA team). Same with Servoy.

I don't disagree with all products providing embedded database
platforms, and especially not with choosing for PostgreSQL which I
consider a very mature, stable and feature-rich (and not to be
forgotten, very active community) database platform. But I do hope that
these products take up their responsibility and release updated versions
or patches for their installations to their customers *very* soon.

Perhaps I should ask our security operational team to take a scan to
actively follow-up on these...
