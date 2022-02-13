Title: Switching OpenSSH to ed25519 keys
Date: 2015-08-19 18:26
Category: Free-Software
Tags: openssh, ssh, gentoo
Slug: switching-openssh-to-ed25519-keys

With Mike's [news item](http://comments.gmane.org/gmane.linux.gentoo.devel/96896)
on OpenSSH's deprecation of the [DSA algorithm](https://en.wikipedia.org/wiki/Digital_Signature_Algorithm)
for the public key authentication, I started switching the few keys I still had
using DSA to the suggested [ED25519](http://ed25519.cr.yp.to/) algorithm. Of
course, I wouldn't be a security-interested party if I did not do some additional
investigation into the DSA versus Ed25519 discussion.

<!-- PELICAN_END_SUMMARY -->

**The issue with DSA**

You might find DSA a bit slower than RSA:

```
~$ openssl speed rsa1024 rsa2048 dsa1024 dsa2048
...
                  sign    verify    sign/s verify/s
rsa 1024 bits 0.000127s 0.000009s   7874.0 111147.6
rsa 2048 bits 0.000959s 0.000029s   1042.9  33956.0
                  sign    verify    sign/s verify/s
dsa 1024 bits 0.000098s 0.000103s  10213.9   9702.8
dsa 2048 bits 0.000293s 0.000339s   3407.9   2947.0
```

As you can see, RSA verification outperforms DSA in verification, while signing
with DSA is better than RSA. But for what OpenSSH is concerned, this speed
difference should not be noticeable on the vast majority of OpenSSH servers.

So no, it is not the speed, but the secure state of the DSS standard.

The OpenSSH developers find that [ssh-dss (DSA) is too weak](http://www.openssh.com/legacy.html),
which is followed by [various](http://meyering.net/nuke-your-DSA-keys/) 
[sources](https://docs.moodle.org/dev/SSH_key). Considering the impact of these keys,
it is important that they follow the state-of-the-art cryptographic services. 

Instead, they suggest to switch to elliptic curve cryptography based algorithms,
with Ed25519 and [Curve25519](https://en.wikipedia.org/wiki/Curve25519) coming out
on top.

**Switch to RSA or ED25519?**

Given that RSA is still considered very secure, one of the questions is of
course if [ED25519](http://ed25519.cr.yp.to/) is the right choice here or not.
I don't consider myself anything in cryptography, but I do like to validate stuff
through academic and (hopefully) reputable sources for information (not that I don't
trust the OpenSSH and OpenSSL folks, but more from a broader interest in the subject).

Ed25519 should be written fully as _Ed25519-SHA-512_ and is a signature
algorithm. It uses elliptic curve cryptography as explained on the
[EdDSA wikipedia page](https://en.wikipedia.org/wiki/EdDSA). An often cited
paper is [Fast and compact elliptic-curve cryptography](http://aspartame.shiftleft.org/papers/fff/fff.pdf)
by Mike Hamburg, which talks about the performance improvements, but the main
paper is called [High-speed high-security signatures](http://ed25519.cr.yp.to/ed25519-20110705.pdf)
which introduces the Ed25519 implementation.

Of the references I was able to (quickly) go through (not all papers are
publicly reachable) none showed any concerns about the secure state of the 
algorithm. 

**The (simple) process of switching**

Switching to Ed25519 is simple. First, generate the (new) SSH key (below
just an example run):

```
~$ ssh-keygen -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/testuser/.ssh/id_ed25519): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/testuser/.ssh/id_ed25519.
Your public key has been saved in /home/testuser/.ssh/id_ed25519.pub.
The key fingerprint is:
SHA256:RDaEw3tNAKBGMJ2S4wmN+6P3yDYIE+v90Hfzz/0r73M testuser@testserver
The key's randomart image is:
+--[ED25519 256]--+
|o*...o.+*.       |
|*o+.  +o ..      |
|o++    o.o       |
|o+    ... .      |
| +     .S        |
|+ o .            |
|o+.o . . o       |
|oo+o. . . o ....E|
| oooo.     ..o+=*|
+----[SHA256]-----+
```

Then, make sure that the `~/.ssh/authorized_keys` file contains the public key
(as generated as `id_ed25519.pub`). Don't remove the other keys yet until the
communication is validated. For me, all I had to do was to update the file in
the Salt repository and have the master push the changes to all nodes (starting
with non-production first of course).

Next, try to log on to the system using the Ed25519 key:

```
~$ ssh -i ~/.ssh/id_ed25519 testuser@testserver
```

Make sure that your SSH agent is not running as it might still try to revert
back to another key if the Ed25519 one does not work. You can validate if the
connection was using Ed25519 through the `auth.log` file:

```shell-session
~$ sudo tail -f auth.log
Aug 17 21:20:48 localhost sshd[13962]: Accepted publickey for root from \
  192.168.100.1 port 43152 ssh2: ED25519 SHA256:-------redacted----------------
```

If this communication succeeds, then you can remove the old key from the `~/.ssh/authorized_keys` files.

On the client level, you might want to hide `~/.ssh/id_dsa` from the SSH agent:

```sh
# Obsolete - keychain ~/.ssh/id_dsa
keychain ~/.ssh/id_ed25519
```

If a server update was forgotten, then the authentication will fail and, depending
on the configuration, either fall back to the regular authentication or fail
immediately. This gives a nice heads-up to you to update the server, while keeping
the key handy just in case. Just refer to the old `id_dsa` key during the authentication
and fix up the server.

