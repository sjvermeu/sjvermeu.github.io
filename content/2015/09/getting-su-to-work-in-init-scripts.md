Title: Getting su to work in init scripts
Date: 2015-09-14 16:37
Category: SELinux
Tags: selinux, initrc
Slug: getting-su-to-work-in-init-scripts

While developing an init script which has to switch user, I got a couple of
errors from SELinux and the system itself:

```shell-session
~# rc-service hadoop-namenode format
Authenticating root.
 * Formatting HDFS ...
su: Authentication service cannot retrieve authentication info
(Ignored)
```
<!-- PELICAN_END_SUMMARY -->

The authentication log shows entries such as the following:

```
Sep 14 20:20:05 localhost unix_chkpwd[5522]: could not obtain user info (hdfs)
```

I've always had issues with getting su to work properly again. Now that I have
what I think is a working set, let me document it for later (as I still need to
review why they are needed):

```ruby
# Allow initrc_t to use unix_chkpwd to check entries
# Without it gives the retrieval failure
auth_domtrans_chk_passwd(initrc_t)

# Allow initrc_t to query selinux access, otherwise avc assertion
allow initrc_t self:netlink_selinux_socket { bind create read };
selinux_compute_access_vector(initrc_t)

# Allow initrc_t to honor the pam_rootok setting
allow initrc_t self:passwd { passwd rootok };
```
With these SELinux rules, switching the user works as expected from within an
init script.

