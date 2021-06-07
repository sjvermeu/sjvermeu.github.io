Title: How does foo_t get this privilege?
Date: 2014-01-05 04:14
Category: SELinux
Tags: policy, selinux, seshowtree
Slug: how-does-foo_t-get-this-privilege

Today a question was raised how the unprivileged user domain `user_t`
was allowed to write to `cgroup_t` files. There is nothing obvious about
that in the `roles/unprivuser.te` file, so what gives?

I used a simple script (which I've been using for a while already)
called **seshowtree** which presents the SELinux rules for a particular
domain in a tree-like structure, expanding the interfaces as it finds
them. The script is far from perfect, but does enough to help me answer
such questions. If you're interested, the script is also available on my
[github
small.coding](https://github.com/sjvermeu/small.coding/blob/master/se_scripts/seshowtree)
project.

```
~# seshowtree user roles/unprivuser.te > output.txt
```

In the resulting output, I search for the `cgroup_t` and work my way up,
which gives:

``` 
userdom_unpriv_user_template(user)
. userdom_common_user_template($1)
. . fs_rw_cgroup_files($1_t)
. . . rw_files_pattern($1, cgroup_t, cgroup_t)
. . . . allow $1 $3:file rw_file_perms;
```

So in this case, the user forgot to look into
`userdom_common_user_template`, which is called by
`userdom_unpriv_user_template` to find the path to this privilege. Of
course, that still doesn't explain why the privileges are assigned in
the first place. As the policy file itself does not contain the
necessary comments to deduce this, I had to ask the git repository for
more information:

```
~$ git annotate userdomain.if
```

In the end, it was a commit from 2010, informing me that "Common users
can read and write cgroup files (access governed by dac)". So the
privilege is by design, referring to the regular DAC permissions to
properly govern access to the files.
