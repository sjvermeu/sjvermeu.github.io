Title: CIL and attributes
Date: 2015-02-15 15:49
Category: SELinux
Tags: attribute, cil, selinux
Slug: cil-and-attributes

I keep on struggling to remember this, so let's make a blog post out of
it ;-)

When the SELinux policy is being built, recent userspace (2.4 and
higher) will convert the policy into CIL language, and then build the
binary policy. When the policy supports type attributes, these are of
course also made available in the CIL code. For instance the
`admindomain` attribute from the `userdomain` module:

    ...
    (typeattribute admindomain)
    (typeattribute userdomain)
    (typeattribute unpriv_userdomain)
    (typeattribute user_home_content_type)

Interfaces provided by the module are also applied. You won't find the
interface CIL code in `/var/lib/selinux/mcs/active/modules` though; the
code at that location is already "expanded" and filled in. So for the
`sysadm_t` domain we have:

    # Equivalent of
    # gen_require(`
    #   attribute admindomain;
    #   attribute userdomain;
    # ')
    # typeattribute sysadm_t admindomain;
    # typeattribute sysadm_t userdomain;

    (typeattributeset cil_gen_require admindomain)
    (typeattributeset admindomain (sysadm_t ))
    (typeattributeset cil_gen_require userdomain)
    (typeattributeset userdomain (sysadm_t ))
    ...

However, when checking which domains use the `admindomain` attribute,
notice the following:

    ~# seinfo -aadmindomain -x
    ERROR: Provided attribute (admindomain) is not a valid attribute name.

But don't panic - this has a reason: as long as there is no SELinux rule
applied towards the `admindomain` attribute, then the SELinux policy
compiler will drop the attribute from the final policy. This can be
confirmed by adding a single, cosmetic rule, like so:

    ## allow admindomain admindomain:process sigchld;

    ~# seinfo -aadmindomain -x
       admindomain
          sysadm_t

So there you go. That does mean that if something previously used the
attribute assignation for any decisions (like "for each domain assigned
the userdomain attribute, do something") will need to make sure that the
attribute is really used in a policy rule.
