Title: Can Gentoo play a role in a RHEL-only environment?
Date: 2014-01-09 04:13
Category: Gentoo
Tags: Gentoo, linux, vappliance, virtual-appliance
Slug: can-gentoo-play-a-role-in-a-rhel-only-environment

Sounds like a stupid question, as the answer is already in the title. If
a company has only RedHat Enterprise Linux as allowed / supported Linux
platform (be it for a support model requirement, ISV certification,
management tooling support or what not) how could or would Gentoo still
play a role in it.

But the answer is, surprisingly, that Gentoo can still be made available
in the company architecture. One of the possible approaches is a
*virtual appliance* role.

Virtual appliances are entire operating systems, provided through VM
images (be it VMDK or in an
[OVF](http://en.wikipedia.org/wiki/Open_Virtualization_Format) package),
which offer a well defined service to its consumers. More and more
products are being presented as virtual appliances. Why not - in the
past, they would be in sealed hardware appliances (but still running
some form of Linux on it) but nowadays the hypervisor and other
infrastructure is strong and powerful enough to handle even the most
intensive tasks in a virtual guest.

Gentoo is extremely powerful as a meta-distribution. You can tweak,
update, enhance and tune a Gentoo Linux installation to fulfill whatever
requirement you have. And in the end, you can easily create a virtual
image from it, and have it run as a virtual appliance in the company.

An example could be to offer a web-based password management suite. A
Gentoo Linux deployment could be created, fully
[hardened](https://wiki.gentoo.org/wiki/Project:Hardened) of course,
with a MAC such as SELinux active. On it, a properly secured web server
with the password management suite, with underlying database (of course
only listening on localhost - don't want to expose the database to the
wider network). Through a simple menu, the various administrative
services needed to integrate the "appliance" in a larger environment can
be configured: downloading an SSL certificate request (and uploading the
signed one), (encrypted) backup/restore routines, SNMP configuration and
more.

If properly designed, all configuration data could be easily exported
and imported (or provided through a secundary mount) so that updates on
the appliance are as simple as booting a new image and
uploading/mounting the configuration data.

Building such a virtual appliance can be simplified with [Gentoo
Prefix](http://www.gentoo.org/proj/en/gentoo-alt/prefix/), multi-tenancy
on the web application level through the
[webapp-config](http://www.gentoo.org/proj/en/webapps/index.xml) tool
while all necessary software is readily available in the Portage tree.

All you need is some imagination...
