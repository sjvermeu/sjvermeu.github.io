Title: XCCDF - Documenting a bit more than just descriptions
Date: 2013-12-16 04:58
Category: Security
Tags: openscap, scap, sce, xccdf
Slug: xccdf-documenting-a-bit-more-than-just-descriptions

In my [previous
post](http://blog.siphos.be/2013/12/an-xccdf-skeleton-for-postgresql/) I
made a skeleton XCCDF document. By now, we can create a well documented
"baseline" (best practice) for our subject (say PostgreSQL). But for now
I only talked about `<description>` whereas XCCDF allows many other tags
as well.

You can add *metadata* information for a particular `Group`. It is
recommended to use the [dublin core](http://dublincore.org/) notation:

(XML content lost during blog conversion)`

If you use metadata information however, it should **not** be used
*instead* of XCCDF elements.

Another set of elements that can be used are `warning` elements:

(XML content lost during blog conversion)

The `<rationale>` element can be used to explain in more detail why a
rule is important.

(XML content lost during blog conversion)

Some elements we saw before also apply on the specific `<Group>`
elements, such as `<status>` or `<version>`. The combination of these
elements should allow for a pretty good explanation of the secure setup
we want to achieve.

But documentation is one thing - how about checking something
automatically? Enter the XCCDF `Rule` element.

Rules are particular tests, checks if you wish, that you want to have
executed. To start off, let's look at a `Rule` element that, as
automated approach, calls a script. To accomplish this, we use the **SCE
(Script Check Engine)** method. This is *not* part of the SCAP standard
by itself (SCAP uses OVAL for automated checks - I'll discuss OVAL
later) but XCCDF allows for other check systems to be used. And SCE is
supported by [openscap](http://www.open-scap.org).

(XML content lost during blog conversion)

First of all, we have the `Rule` element itself, with the specially
crafted `id` attribute as seen before. There are three attributes used
in the example:

1.  `selected="false"` tells the XCCDF interpreter that the Rule should
    not be automatically selected. In other words, only if a `Profile`
    refers to the rule will be rule be triggered (and the
    check executed).
2.  `severity="low"` is a matter of documenting how severe a
    non-compliant rule is.
3.  `weight="0.0"` gives a weight on the `Rule`. In this case, the
    weight is 0, meaning that the rule might be recommended but by
    itself does not introduce a security vulnerability or mismatch. Of
    course, you are free to use whatever value suits you best.

We also notice a `fixtext` element. When the rule failed (the system is
not compliant to the rule) then the fixtext should assist administrators
in securing the system again. In other words, `fixtext` are the
human-readable instructions on remediating the system.

Finally, we have the `check` element. This element tells the XCCDF
interpreter that an automated validation is defined. The type of
automated validation is provided by the `system` attribute, which in
this case refers to the SCE system. The `check-content-ref` element
refers to the script to be executed.

Let's look at the contents of the script:

```
#!/bin/sh

# Get CHOST value
echo "Getting CHOST variable content through portageq.";
my_chost=$(portageq envvar CHOST);
if [ -z "${my_chost}" ];
then
  echo "-- The portageq command failed. Falling back to glibc build info.";
  my_chost=$(cat /var/db/pkg/sys-libs/glibc-*/CHOST | tail -1);
fi
echo "-- Got CHOST=${my_chost}";

# Get current GCC version
echo "Getting current GCC version through /etc/env.d/gcc/config-*";
current_gcc=$(grep CURRENT /etc/env.d/gcc/config-* | sed -e "s:CURRENT=${my_chost}-::g" | sed -e "s:\([0-9\.-r]*\){$,-.*$}:\1:g" );
echo "-- Got version=${current_gcc}";

# Get type
echo "Getting compiler type (profile/spec) through its CURRENT= value.";
current_type=$(grep CURRENT /etc/env.d/gcc/config-* | sed -e "s:CURRENT=${my_chost}-${current_gcc}::g" | sed -e 's:^-::g');
echo "-- Got type=${current_type}";

echo "Checking USE flags of gcc-${current_gcc} for hardened USE flag.";
grep -q hardened /var/db/pkg/sys-devel/gcc-${current_gcc}/USE;
current_hardened_use=$?;
if [ ${current_hardened_use} -ne 0 ];
then
  echo "!! GCC ${current_gcc} is not build with USE=hardened!";
  echo "!! Please enable a hardened profile.";
  exit ${XCCDF_RESULT_FAIL};
else
  echo "-- GCC ${current_gcc} is build with USE=hardened.";
  if [ -z "${current_type}" ];
  then
    echo "-- The default type is used which is a hardened type.";
    exit ${XCCDF_RESULT_PASS};
  else
    echo "!! A non-default type is used: ${current_type}";
    echo "!! This means not all hardened toolchain measures are enabled.";
    exit ${XCCDF_RESULT_FAIL};
  fi
fi
```

As you can see, the script can give output when needed, but the most
important part is that it has to return a particular return value. This
return value is provided through environment variables
(`XCCDF_RESULT_*`).

All we need to do now is to include this `Rule` in the `Profile`.

(XML content lost during blog conversion)

We can now evaluate the XCCDF file on the system if we refer to the
right profile. By selecting the profile, the XCCDF interpreter will also
automatically check the rules referred to by the profile (and the rules
that do not have `selected="false"` set too).

    # oscap xccdf eval --profile ... gentoo-xccdf.xml

    Title   Test if the hardened toolchain is used
    Rule    xccdf_org.gentoo.dev.swift_rule_installation-toolchain-hardened
    Result  pass

    Title   Test if sulogin is used for single-user boot (/etc/inittab)
    Rule    xccdf_org.gentoo.dev.swift_rule_inittab-sulogin
    Result  fail

Now, if you want to check this on several systems, you would need to
distribute not only the XCCDF file, but also all files referred to by
the XCCDF document. As this is counterproductive, SCAP supports *Data
Streams*. A data stream is a single file that includes the content of
all files. With openscap, data streams can be made as follows:

    # oscap ds sds-compose postgresql-xccdf.xml postgresql-ds.xml

So now we have a document explaining the secure setup of a component,
and included automated checks to validate system compliance with the
document using scripts. In the next post, I'll go on with OVAL.

This post is part of a series on SCAP content:

1.  [Documenting security best practices - XCCDF
    introduction](http://blog.siphos.be/2013/12/documenting-security-best-practices-xccdf-introduction/)
2.  [An XCCDF skeleton for
    PostgreSQL](http://blog.siphos.be/2013/12/an-xccdf-skeleton-for-postgresql/)

