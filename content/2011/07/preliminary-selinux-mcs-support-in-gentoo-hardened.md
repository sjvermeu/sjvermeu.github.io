Title: Preliminary SELinux MCS support in Gentoo Hardened
Date: 2011-07-21 22:04
Category: Gentoo
Slug: preliminary-selinux-mcs-support-in-gentoo-hardened

Users tracking the
[hardened-dev](http://git.overlays.gentoo.org/gitweb/?p=proj/hardened-dev.git)
overlay for SELinux packages will notice yet another update on the
`selinux-base-policy` package. This time however, the change is [a
little more](http://thread.gmane.org/gmane.linux.gentoo.hardened/4939)
than just a policy update. With this new revision, preliminary support
for *Multi-Category Security* (aka MCS) is added.

MCS is an update on the SELinux policy where domains and resources can
be given a "category". This is especially useful on what is called
multi-tenant systems, where multiple processes (but of the same
application and hence the same domain definition) are running, servicing
requests of different clients (or even customers). With MCS, these
different processes, although using the same domain definitions, can
still be isolated. The use of categories is well accepted for
virtualization hosts (where virtual guests should be run isolated from
each other) and web servers, but other uses can be found easily as well.

Next to MCS, the update also supports MLS or *Multi-Level Security*.
Like MCS, this supports multiple categories, but it also supports
multiple sensitivity levels. On an MLS system, the security
administrator can control how information of a certain sensitivity label
"flows" through the system. Now, the MLS support within Gentoo Hardened
is still very experimental so I don't recommend it yet, unless you are
willing to help us get it in a workable shape.

In order to use MCS, you need to use the `POLICY_TYPES` variable in
/etc/make.conf (which allows Portage to build the policy type(s) you
want) and the `SELINUXTYPE` variable in /etc/selinux/config. Whereas
this previously was limited to "strict" or "targeted", they now support
"mls" and "mcs" as well. Of course, this is
[documented](http://goo.gl/DlHJD) in the Gentoo Hardened SELinux
handbook (currently in the hardened-doc overlay).

Now, this is still *preliminary* support for MCS. A small fix needs to
happen on our eclass and it definitely needs lots of testing before it
can be considered for production use. Also, the majority of development
attention will continue in the "strict" policy type although MCS testing
and support will grow.
