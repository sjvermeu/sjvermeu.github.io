Title: Remediation through SCAP
Date: 2013-12-20 04:47
Category: Security
Tags: openscap, remediation, scap, xccdf
Slug: remediation-through-scap

I promised in my [previous
post](http://blog.siphos.be/2013/12/running-a-bit-with-the-xccdf-document/)
to give some information about remediation.

Remediation is the process where you fix a system to become compliant
again after finding out there is a violation on the system. The easiest
form of remediation of course is to just notify the administrator and
give him the instructions to fix the problem - and in the majority of
cases, this is exactly what you will do, considering that automatically
fixing things might create more breakage if you are not careful.

But suppose that you know, for a few rules, what the remediation really
should be, and you want to automate it. Well, in that case, you can
document the remediation (the commands or scripts) in the XCCDF
document. As you might have noticed in the previous example, this is
handled through a `<fix>` entity.

In the fix, we mention how the fix should be executed
(*urn:xccdf:fix:system:commands* is to tell the XCCDF interpreter that
the remediation are commands executed on the command line (or verbatim
within a script). The platform attribute allows us to differentiate
based on the platform (or even version of the platform). The other
attributes, such as *complexity*, *disruption* and *reboot* is metadata
that helps in deciding which auto-remediation you want to execute.

With openscap, the remediation can be triggered online during the
evaluation, by adding `--remediate`

```
~$ oscap xccdf eval --remediate --profile ${PROFILE} --cpe gentoo-cpe.xml --results results-test-xccdf.xml test-xccdf.xml
Title   There should be no /dev/ROOT in /etc/fstab
Rule    xccdf_org.gentoo.dev.swift_rule_installation-fstab-root
Result  pass

Title   There should be no /dev/BOOT in /etc/fstab
Rule    xccdf_org.gentoo.dev.swift_rule_installation-fstab-boot
Result  pass

Title   rc_sys should be defined in /etc/rc.conf
Rule    xccdf_org.gentoo.dev.swift_rule_installation-rc_sys
Result  fail

 --- Starting remediation ---
Title   rc_sys should be defined in /etc/rc.conf
Rule    xccdf_org.gentoo.dev.swift_rule_installation-rc_sys
Result  fixed
```

And indeed, the file has been changed and now complies with the rules
again.

We can also generate the remediation scripts offline:

```
~$ oscap xccdf eval --profile ${PROFILE} --results results-test-xccdf.xml --cpe gentoo-cpe.xml test-xccdf.xml
~$ oscap xccdf generate fix --output remediate.sh results-test-xccdf.xml
```

The resulting `remediate.sh` script then contains the steps to remediate
the failures reported in the `results-test-xccdf.xml` file.

In general however, auto-remediation is not that recommended. The amount
of effort you put in creating remediation scripts that are safe to
execute is huge. If you do this for a single system, it is much easier
to just remediate manually. If you need to do it for a large set of
systems, it makes more sense to use a configuration management solution
like [ansible](http://www.ansibleworks.com/) or
[puppet](http://puppetlabs.com/).

So, now that we have experience with documenting our best practices and
running validation, I'll talk about OVAL in the next post.

This post is part of a series on SCAP content:

1.  [Documenting security best practices - XCCDF
    introduction](http://blog.siphos.be/2013/12/documenting-security-best-practices-xccdf-introduction/)
2.  [An XCCDF skeleton for
    PostgreSQL](http://blog.siphos.be/2013/12/an-xccdf-skeleton-for-postgresql/)
3.  [Documenting a bit more than just
    descriptions](http://blog.siphos.be/2013/12/xccdf-documenting-a-bit-more-than-just-descriptions/)
4.  [Running a bit with the XCCDF
    document](http://blog.siphos.be/2013/12/running-a-bit-with-the-xccdf-document/)

