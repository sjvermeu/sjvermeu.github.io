Title: SAI and N-O-SQL
Date: 2010-04-22 01:02
Category: Databases
Tags: Databases, enterprise architecture, nosql
Slug: sai-and-n-o-sql

Yesterday (argh, the day before yesterday) I went to a
[SAI](http://www.sai.be) conference on nosql. In Belgium, SAI is a
non-profit organization for IT people which focuses on knowledge
sharing.

The conference that day was on nosql. The presentation given by
[OuterThought](http://www.outerthought.be) was very good and offered a
nice introduction to the "new types of database architectures" that are
being actively developed as we speak.

Although the use of these nosql databases within
[KBC](http://www.kbc.com) (where I work for) is limited (I'm not aware
of any application that is already using this technology) it would be
plain wrong to discard the technology as "too immature". With the recent
developments that we face in the IT industry, applications are nowadays
quick in adopting such new technologies and I suspect that off-the-shelf
applications will soon come with such nosql database technology as part
of the solution.

For large enterprises, this does face some (hard?) challenges: how do
you control your network usage (some of the technologies are easy to
use, but hard to tune), how do you design your architecture, where is
your data, how can you ensure that you do not "lock in" into a single
nosql technology (i.e. how do you ensure interoperability and migrations
between technologies), do you still need SAN-based replication or will
you now let the technology handle this for you, etc.

So yes, the nosql technology is nice to look into (and definitely
something to follow up on) but make sure you don't introduce it in your
organization without thinking about the entire integration and
management aspect.
