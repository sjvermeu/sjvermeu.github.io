Title: Talk about SELinux on GSE Linux/Security
Date: 2014-03-25 23:11
Category: Security
Tags: gse, mainframe, s390x, security, selinux, zenterprise
Slug: talk-about-selinux-on-gse-linuxsecurity

On today's [GSE Linux / GSE Security](http://www.gsebelux.com) meeting
(in cooperation with
[IMUG](http://www.imug.be/events_be/IMUG_LinuxSecurity_Event.asp)) I
gave a small (30 minutes) presentation about what SELinux is. The
[slides are
online](http://dev.gentoo.org/~swift/blog/201403/20140325_GSE_SELinux.pdf)
and cover two aspects of SELinux: some of its design principles, and
then a set of features provided by SELinux. The talk is directed towards
less technical folks - still IT of course, but not immediately involved
in daily operations - so no commands and example/output.

SELinux came across the board a few times during the entire day. In the
talks about *Open Source Security* and *Security Guidelines for z/VM and
Linux on System z* SELinux came (of course) up as the technology of
choice for providing in-operating system mandatory access control (on
the zEnterprise' Z/VM level - the hypervisor - this is handled through
RACF Mandatory Access Control) and the *Security Enablement on Virtual
Machines* had SELinux in the front line for the sVirt security
protection measures (which focuses on the segregation through MLS
categories).

And during the talk about *A customer story about logging and audit*,
well, you can guess which technology is also one of the many sources of
logging. Right. SELinux ;-)

Anyway, if your company is interested in such GSE events, make sure to
follow the [gsebelux.com](http://www.gsebelux.com) site for updates.
It's a great way for networking as well as sharing experiences.
