Title: Enabling Kernel Samepage Merging (KSM)
Date: 2013-05-09 03:50
Category: Free-Software
Tags: cow, ksm, kvm, linux, virtualization
Slug: enabling-kernel-samepage-merging-ksm

When using virtualization extensively, you will pretty soon hit the
limits of your system (at least, the resources on it). When the
virtualization is used primarily for testing (such as in my case), the
limit is memory. So it makes sense to seek memory optimization
strategies on such systems. The first thing to enable is KSM or *Kernel
Samepage Merging*.

This Linux feature looks for memory pages that the applications have
marked as being a possible candidate for optimization (sharing) which
are then reused across multiple processes. The idea is that, especially
for virtualized environments (but KSM is not limited to that), some
processes will have the same contents in memory. Without any sharing
abilities, these memory pages will be unique (meaning at different
locations in your system's memory). With KSM, such memory pages are
consolidated to a single page which is then referred to by the various
processes. When one process wants to modify the page, it is "unshared"
so that there is no corruption or unwanted modification of data for the
other processes.

Such features are not new - VMWare has it named TPS (*Transparent Page
Sharing*) and Xen calls it "Memory CoW" (Copy-on-Write). One advantage
of KSM is that it is simple to setup and advantageous for other
processes as well. For instance, if you host multiple instances of the
same service (web service, database, tomcat, whatever) there is a high
chance that several of its memory pages are prime candidates for
sharing.

Now before I do mention that this sharing is only enabled when the
application has marked it as such. This is done through the *madvise()*
method, where applications mark the memory with *MADV\_MERGEABLE*,
meaning that the applications explicitly need to support KSM in order
for it to be successful. There is work on the way to support transparent
KSM (such as
[UKSM](http://www.phoronix.com/scan.php?page=news_item&px=MTEzMTI) and
[PKSM](https://code.google.com/p/pksm/)) where no *madvise* calls would
be needed anymore. But beyond quickly reading the home pages (or
translated home pages in case of UKSM ;-) I have no experience with
those projects.

So let's get back to KSM. I am currently running three virtual machines
(all configured to take at most 1.5 Gb of memory). Together, they take
just a little over 1 Gb of memory (sum of their resident set sizes).
When I consult KSM, I get the following information:

     # grep -H '' /sys/kernel/mm/ksm/pages_*
    /sys/kernel/mm/ksm/pages_shared:48911
    /sys/kernel/mm/ksm/pages_sharing:90090
    /sys/kernel/mm/ksm/pages_to_scan:100
    /sys/kernel/mm/ksm/pages_unshared:123002
    /sys/kernel/mm/ksm/pages_volatile:1035

The `pages_shared` tells me that 48911 pages are shared (which means
about 191 Mb) through 90090 references (`pages_sharing` - meaning the
various processes have in total 90090 references to pages that are being
shared). That means a gain of 41179 pages (160 Mb). Note that the
resident set sizes do not take into account shared pages, so the sum of
the RSS has to be subtracted with this to find the "real" memory
consumption. The `pages_unshared` value tells me that 123002 pages are
marked with the `MADV_MERGEABLE` advise flag but are not used by other
processes.

If you want to use KSM yourself, configure your kernel with `CONFIG_KSM`
and start KSM by echo'ing the value "1" into `/sys/kernel/mm/ksm/run`.
That's all there is to it.
