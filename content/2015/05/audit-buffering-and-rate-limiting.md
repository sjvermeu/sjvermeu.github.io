Title: Audit buffering and rate limiting
Date: 2015-05-10 14:18
Category: Free Software
Tags: audit, kernel, security, selinux
Slug: audit-buffering-and-rate-limiting

Be it because of SELinux experiments, or through general audit
experiments, sometimes you'll get in touch with a message similar to the
following:

    audit: audit_backlog=321 > audit_backlog_limit=320
    audit: audit_lost=44395 audit_rate_limit=0 audit_backlog_limit=320
    audit: backlog limit exceeded

<!-- PELICAN_END_SUMMMARY -->

The message shows up when certain audit events could not be logged
through the audit subsystem. Depending on the system configuration, they
might be either ignored, sent through the kernel logging infrastructure
or even have the system panic. And if the messages are sent to the
kernel log then they might show up, but even that log has its
limitations, which can lead to output similar to the following:

    __ratelimit: 53 callbacks suppressed

In this post, I want to give some pointers in configuring the audit
subsystem as well as understand these messages...

**There is auditd and kauditd**

If you take a look at the audit processes running on the system, you'll
notice that (assuming Linux auditing is used of course) two processes
are running:

    # ps -ef | grep audit
    root      1483     1  0 10:11 ?        00:00:00 /sbin/auditd
    root      1486     2  0 10:11 ?        00:00:00 [kauditd]

The `/sbin/auditd` daemon is the user-space audit daemon. It [registers
itself](http://man7.org/linux/man-pages/man3/audit_open.3.html) with the
Linux kernel audit subsystem (through the audit netlink system), which
responds with spawning the `kauditd` kernel thread/process. The fact
that the process is a kernel-level one is why the `kauditd` is
surrounded by brackets in the `ps` output.

Once this is done, audit messages are communicated through the netlink
socket to the user-space audit daemon. For the detail-oriented people
amongst you, look for the *kauditd\_send\_skb()* method in the
[kernel/audit.c](http://lxr.free-electrons.com/source/kernel/audit.c)
file. Now, generated audit event messages are not directly relayed to
the audit daemon - they are first queued in a sort-of backlog, which is
where the backlog-related messages above come from.

**Audit backlog queue**

In the kernel-level audit subsystem, a socket buffer queue is used to
hold audit events. Whenever a new audit event is received, it is logged
and prepared to be added to this queue. Adding to this queue can be
controlled through a few parameters.

The first parameter is the backlog limit. Be it through a kernel boot
parameter (`audit_backlog_limit=N`) or through a message relayed by the
user-space audit daemon (`auditctl -b N`), this limit will ensure that a
queue cannot grow beyond a certain size (expressed in the amount of
messages). If an audit event is logged which would grow the queue beyond
this limit, then a failure occurs and is handled according to the system
configuration (more on that later).

The second parameter is the rate limit. When more audit events are
logged within a second than set through this parameter (which can be
controlled through a message relayed by the user-space audit system,
using `auditctl -r N`) then those audit events are not added to the
queue. Instead, a failure occurs and is handled according to the system
configuration.

Only when the limits are not reached is the message added to the queue,
allowing the user-space audit daemon to consume those events and log
those according to the audit configuration. There are some good
resources on audit configuration available on the Internet. I find [this
SuSe
chapter](http://webapp5.rrz.uni-hamburg.de/SuSe-Dokumentation/manual/sles-manuals_en/cha.audit.comp.html)
worth reading, but many others exist as well.

There is a useful command related to the subject of the audit backlog
queue. It queries the audit subsystem for its current status:

    # auditctl -s
    AUDIT_STATUS: enabled=1 flag=1 pid=1483 rate_limit=0 backlog_limit=8192 lost=3 backlog=0

The command displays not only the audit state (enabled or not) but also
the settings for rate limits (on the audit backlog) and backlog limit.
It also shows how many events are currently still waiting in the backlog
queue (which is zero in our case, so the audit user-space daemon has
properly consumed and logged the audit events).

**Failure handling**

If an audit event cannot be logged, then this failure needs to be
resolved. The Linux audit subsystem can be configured do either silently
discard the message, switch to the kernel log subsystem, or panic. This
can be configured through the audit user-space (`auditctl -f [0..2]`),
but is usually left at the default (which is 1, being to switch to the
kernel log subsystem).

Before that is done, the message is displayed which reveals the cause of
the failure handling:

    audit: audit_backlog=321 > audit_backlog_limit=320
    audit: audit_lost=44395 audit_rate_limit=0 audit_backlog_limit=320
    audit: backlog limit exceeded

In this case, the backlog queue was set to contain at most 320 entries
(which is low for a production system) and more messages were being
added (the Linux kernel in certain cases allows to have a few more
entries than configured for performance and consistency reasons). The
number of events already lost is displayed, as well as the current
limitation settings. The message "backlog limit exceeded" can be "rate
limit exceeded" if that was the limitation that was triggered.

Now, if the system is not configured to silently discard it, or to panic
the system, then the "dropped" messages are sent to the kernel log
subsystem. The calls however are also governed through a configurable
limitation: it uses a rate limit which can be set through `sysctl`:

    # sysctl -a | grep kernel.printk_rate
    kernel.printk_ratelimit = 5
    kernel.printk_ratelimit_burst = 10

In the above example, this system allows one message every 5 seconds,
but does allow a burst of up to 10 messages at once. When the rate
limitation kicks in, then the kernel will log (at most one per second)
the number of suppressed events:

    [40676.545099] __ratelimit: 246 callbacks suppressed

Although this limit is kernel-wide, not all kernel log events are
governed through it. It is the caller subsystem (in our case, the audit
subsystem) which is responsible for having its events governed through
this rate limitation or not.

**Finishing up**

Before waving goodbye, I would like to point out that the backlog queue
is a memory queue (and not [on disk, Red
Hat](https://access.redhat.com/solutions/19327)), just in case it wasn't
obvious. Increasing the queue size can result in more kernel memory
consumption. Apparently, a [practical size
estimate](https://www.redhat.com/archives/linux-audit/2011-October/msg00007.html)
is around 9000 bytes per message. On production systems, it is advised
not to make this setting too low. I personally set it to 8192.

Lost audit events might result in difficulties for troubleshooting,
which is the case when dealing with new or experimental SELinux
policies. It would also result in missing security-important events. It
is the audit subsystem, after all. So tune it properly, and enjoy the
power of Linux' audit subsystem.
