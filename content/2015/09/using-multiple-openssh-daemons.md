Title: Using multiple OpenSSH daemons
Date: 2015-09-06 16:37
Category: Free-Software
Tags: openssh, ssh, u2f, selinux
Slug: using-multiple-openssh-daemons

I administer a couple of systems which provide interactive access by end users,
and for this interactive access I position [OpenSSH](http://www.openssh.com/). 
However, I also use this for administrative access to the system, and I tend to
have harder security requirements for OpenSSH than most users do.

For instance, on one system, end users with a userid + password use the
sFTP server for publishing static websites. Other access is prohibited,
so I really like this OpenSSH configuration to use chrooted users, internal
sftp support, whereas a different OpenSSH is used for administrative access
(which is only accessible by myself and some trusted parties).

<!-- PELICAN_END_SUMMARY -->

**Running multiple instances**

Although I might get a similar result with a single OpenSSH instance, I
prefer to have multiple instances for this. The default OpenSSH port is used
for the non-administrative access whereas administrative access is on a
non-default port. This has a number of advantages...

First of all, the SSH configurations are simple and clean. No complex
configurations, and more importantly: easy to manage through configuration
management tools like [SaltStack](http://saltstack.com/), my current favorite
orchestration/automation tool.

Different instances also allow for different operational support services.
There is different monitoring for end-user SSH access versus administrative
SSH access. Also the [fail2ban](https://wiki.gentoo.org/wiki/Fail2ban) configuration
is different for these instances.

I can also easily shut down the non-administrative service while ensuring that
administrative access remains operational - something important in case of
changes and maintenance.

**Dealing with multiple instances and SELinux**

Beyond enabling a non-default port for SSH (i.e. by marking it as `ssh_port_t`
as well) there is little additional tuning necessary, but that doesn't mean that
there is no additional tuning possible.

For instance, we could leverage MCS' categories to only allow users (and thus the
SSH daemon) access to the files assigned only that category (and not the rest)
whereas the administrative SSH daemon can access all categories.

On an MLS enabled system we could even use different sensitivity levels, allowing
the administrative SSH to access the full scala whereas the user-facing SSH can
only access the lowest sensitivity level. But as I don't use MLS myself, I won't go
into detail for this.

A third possibility would be to fine-tune the permissions of the SSH daemons. However,
that would require different types for the daemon, which requires the daemons to be
started through different scripts (so that we first transition to dedicated 
types) before they execute the SSHd binary (which has the `sshd_exec_t` type
assigned).

**Requiring pubkey and password authentication**

Recent OpenSSH daemons allow [chaining multiple authentication methods](https://lwn.net/Articles/544640/)
before access is granted. This allows the systems to force SSH key authentication first, and then -
after succesful authentication - require the password to be passed on as well. Or a
second step such as [Google Authenticator](https://wiki.archlinux.org/index.php/Google_Authenticator).

```
AuthenticationMethods publickey,password
PasswordAuthentication yes
```

I don't use the Google Authenticator, but the [Yubico PAM module](https://developers.yubico.com/yubico-pam/)
to require additional authentication through my U2F dongle (so ssh key, password
and u2f key). Don't consider this three-factor authentication: one thing I know
(password) and two things I have (U2F and ssh key). It's more that I have a couple
of devices with a valid SSH key (laptop, tablet, mobile) which are of course targets
for theft.

The chance that both one of those devices is stolen _together_ with the U2F
dongle (which I don't keep attached to those devices of course) is somewhat less.

