Title: SELinux System Administration 3rd Edition
Date: 2021-01-06 20:00
Category: SELinux
Tags: selinux,packt,book
Slug: selinux-system-administration-3rd-edition

As I mentioned previously, recently my latest installment of "SELinux System
Administration" has been released by Packt Publishing. This is already the
third edition of the book, after the first (2013) and second (2016) editions
have gotten reasonable success given the technical and often hard nature of
full SELinux administration.

Like with the previous editions, this book remains true to the public of
system administrators, rather than SELinux policy developers. Of course,
SELinux policy development is not ignored in the book.

**What has changed**

First and foremost, it of course updates the content of the previous edition
to be up to date with the latest evolutions within SELinux. There are no earth
shattering changes, so the second edition isn't suddenly deprecated. The examples
are brought up to date with a recent distribution setup, for which I used
Gentoo Linux and CentOS.

The latter is, given the recent announcement of CentOS stopping support for
CentOS version 8 in general, a bit confrontational, although it doesn't
really matter that much for the scope of the book. I hope that [Rocky
Linux](https://rockylinux.org/) will get the focus and support it deserves.

Anyway, I digress. A significant part of the updates on the existing content
is on SELinux-enabled applications, applications that act as a so-called object
manager themselves. While quite a few were already covered in the past, these
applications continue to enhance their SELinux support, and in the third edition
a few of these receive a full dedicated chapter.

There are also a small set of SELinux behavioral changes, like SELinux' NNP
support, as well as SELinux userspace changes like specific extended attributes
for restorecon.

Most of the book though isn't about changes, but about new content.

**What has been added**

As administrators face SELinux-aware applications more and more, the book
goes into much more detail on how to tune SELinux with those SELinux-aware
applications. If we look at the book's structure, you'll find that it has
roughly three parts:

1. Using SELinux, which covers the fundamentals of using SELinux and
   understanding what SELinux is.
2. SELinux-aware platforms, which dives into the SELinux-aware application
   suites that administrators might come in contact with
3. Policy management, which focuses on managing, analyzing and even
   developing SELinux policies.

By including additional content on SEPostgreSQL, libvirt, container
platforms like Kubernetes, and even Xen Security Modules (which is not
SELinux itself, but strongly influenced and aligned to it to the level
that it even uses the SELinux userspace utilities) the book is showing how
wide SELinux is being used.

Even on policy development, the book now includes more support than before.
While another book of mine, SELinux Cookbook, is more applicable to policy
development, I did not want to keep administrators out of the loop on how
to develop SELinux policies at all. Especially not since there are more
tools available nowadays that support policy creation, like udica.

**SELinux CIL**

One of the changes I also introduced in the book is to include SELinux
Common Intermediate Language (CIL) information and support. When we need
to add in a small SELinux policy change, the book will suggest CIL based
changes as well.

SELinux CIL is not commonly used in large-scale policy development. Or at
least, not directly. The most significant policy development out there,
the [SELinux Reference Policy](https://github.com/SELinuxProject/refpolicy/wiki),
does not use CIL directly itself, and the level of support you find for
the current development approach is very much the default way of working. So
I do not ignore this more traditional approach.

The reason I did include more CIL focus is because CIL has a few advantages
up its sleeve that is harder to get with the traditional language. Nothing
major perhaps, but enough that I feel it should be more actively promoted
anyway. And this book is hopefully a nice start to it.

I hope the book is a good read for administrators or even architects that
would like to know more about the technology.

<!-- PELICAN_END_SUMMARY -->

