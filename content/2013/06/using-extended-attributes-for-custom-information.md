Title: Using extended attributes for custom information
Date: 2013-06-02 03:50
Category: Free-Software
Tags: attributes, expiration, extended-attributes, linux, xattr
Slug: using-extended-attributes-for-custom-information

One of the things I have been meaning to implement on my system is a way
to properly "remove" old files from the system. Currently, I do this
through frequently listing all files, going through them and deleting
those I feel I no longer need (in any case, I can retrieve them back
from the backup within 60 days). But this isn't always easy since it
requires me to reopen the files and consider what I want to do with
them... again.

Most of the time, when files are created, you generally know how long
they are needed on the system. For instance, an attachment you download
from an e-mail to view usually has a very short lifespan (you can always
re-retrieve it from the e-mail as long as the e-mail itself isn't
removed). Same with output you captured from a shell command, a strace
logfile, etc. So I'm wondering if I can't create a simple method for
keeping track of *expiration dates* on files, similar to the expiration
dates supported for z/OS data sets. And to implement this, I am
considering to use extended attributes.

The idea is simple: when working with a file, I want to be able to
immediately set an expiration date to it:

    $ strace -o strace.log ...
    $ expdate +7d strace.log

This would set an extended attribute named `user.expiration` with the
value being the number of seconds since epoch (which you can obtain
through **date +%s** if you want) on which the file can be expired (and
thus deleted from the system). A system cronjob can then regularly scan
the system for files with the extended attribute set and, if the
expiration date is beyond the current date, the file can be removed from
the system (perhaps first into a specific area where it lingers for an
additional while just in case).

It is just an example of course. The idea is that the extended
attributes keep information about the file close to the file itself. I'm
probably going to have an additional layer on top if it, checking
SELinux contexts and automatically identifying expiration dates based on
their last modification time. Setting the expiration dates manually
after creating the files is prone to be forgotten after a while. And
perhaps introduce the flexibility of setting an `user.expire_after`
attribute is well, telling that the file can be removed if it hasn't
been touched (modification time) in at least XX number of days.
