Title: Using salt-ssh with agent forwarding
Date: 2016-03-26 19:57
Category: Free Software
Tags: salt
Slug: using-salt-ssh-with-agent-forwarding

Part of a system's security is to reduce the attack surface. Following this principle,
I want to see if I can switch from using regular salt minions for a saltstack managed
system set towards `salt-ssh`. This would allow to do some system management over SSH
instead of ZeroMQ.

I'm not confident yet that this is a solid approach to take (as performance is also
important, which is greatly reduced with `salt-ssh`), and the security exposure of the
salt minions over ZeroMQ is also not that insecure (especially not when a local firewall
ensures that only connections from the salt master are allowed). But playing doesn't hurt.

<!-- PELICAN_END_SUMMARY -->

**Using SSH agent forwarding**

Anyway, I quickly got stuck with accessing minions over the SSH interface as it seemed that
salt requires its own SSH keys (I don't enable password-only authentication, most of the systems
use the [AuthenticationMethods](https://blog.flameeyes.eu/2013/03/openssh-6-2-adds-support-for-two-factor-authentication)
approach to chain both key and passwords). But first things first, the current target uses regular
ssh key authentication (no chained approach, that's for later). But I don't want to assign
such a powerful key to my salt master (especially not if it would later also document the
passwords). I would like to use SSH agent forwarding.

Luckily, salt does support that, it just [forgot to document](https://github.com/saltstack/salt/pull/31328/commits/024439186a0c51c0ac1242b38d6584d2abd1a534)
it. Basically, what you need to do is update the roster file with the `priv:` parameter
set to `agent-forwarding`:

```
myminion:
  host: myminion.example.com
  priv: agent-forwarding
```

It will use the `known_hosts` file of the currently logged on user (the one executing
the `salt-ssh` command) so make sure that the system's key is already known.

```
~$ salt-ssh myminion test.ping
myminion:
    True
```

