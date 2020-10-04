Title: A SELinux policy for incron: marking types eligible for watching
Date: 2013-05-29 03:50
Category: SELinux
Tags: attribute, incrond, selinux, watch
Slug: a-selinux-policy-for-incron-marking-types-eligible-for-watching

In the
<a herf="http://blog.siphos.be/2013/05/a-selinux-policy-for-incron-default-set/">previous
post</a> we made **incrond** able to watch `public_content_t` and
`public_content_rw_t` types. However, this is not scalable, so we might
want to be able to update the policy more dynamically with additional
types. To accomplish this, we will make types eligible for watching
through an attribute.

So how does this work? First, we create an attribute called
`incron_notify_type` (we can choose the name we want of course) and
grant `incrond_t` the proper rights on all types that have been assigned
the `incron_notify_type` attribute. Then, we create an interface that
other modules (or admins) can use to mark specific types eligible for
watching, called *incron\_notify\_file*. This interface will assign the
`incron_notify_type` attribute to the provided type.

First, the attribute and its associated privileges:

    attribute incron_notify_type;
    ...
    allow incrond_t incron_notify_type:dir list_dir_perms;
    allow incrond_t incron_notify_type:file read_file_perms;
    allow incrond_t incron_notify_type:lnk_file read_lnk_file_perms;

That's it. For now, this won't do much as there are no types associated
with the `incron_notify_type` attribute, so let's change that by
introducing the interface:

    ########################################
    ## <summary>
    ##      Make the specified type a file or directory
    ##      that incrond can watch on.
    ## </summary>
    ## <param name="file_type">
    ##      <summary>
    ##      Type of the file to be allowed to watch
    ##      </summary>
    ## </param>
    #
    interface(`incron_notify_file',`
            gen_require(`
                    attribute incron_notify_type;
            ')

            typeattribute $1 incron_notify_type;
    ')

That's it! If you want **incrond** to watch user content, one can now do
something like:

    incron_notify_file(home_root_t)
    incron_notify_file(user_home_dir_t)
    incron_notify_file(user_home_t)

Moreover, we can now also easily check what additional types have been
marked as such:

    $ seinfo -aincron_notify_type -x
       incron_notify_type
          user_home_dir_t
          user_home_t
          home_root_t

This attribute approach is commonly used for such setups and is becoming
more and more a "standard" approach.

In the next post, we'll cover a boolean-triggered approach where
**incrond** will be eligible for watching all (non-security) content.
