Title: Matching MD5 SSH fingerprint
Date: 2017-05-18 18:20
Category: Security
Tags: openssh, fingerprint, md5
Slug: matching-md5-ssh-fingerprint

Today I was attempting to update a local repository, when SSH complained
about a changed fingerprint, something like the following:

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:p4ZGs+YjsBAw26tn2a+HPkga1dPWWAWX+NEm4Cv4I9s.
Please contact your system administrator.
Add correct host key in /home/user/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /home/user/.ssh/known_hosts:9
ECDSA host key for 192.168.56.101 has changed and you have requested strict checking.
Host key verification failed.
```

<!-- PELICAN_END_SUMMARY -->

I checked if the host was changed recently, or the alias through
which I connected switched host, or the SSH key changed. But that
wasn't the case. Or at least, it wasn't the case recently, and I
distinctly remember connecting to the same host two weeks ago.

Now, what happened I don't know yet, but I do know I didn't want
to connect until I reviewed the received SSH key fingerprint. I
obtained the fingerprint from the administration (who graceously
documented it on the wiki)...

... only to realize that the documented fingerprint are MD5
hashes (and in hexadecimal result) whereas the key shown by the
SSH command shows it in base64 SHA256 by default.

Luckily, a quick search revealed this [superuser](https://superuser.com/questions/929566/sha256-ssh-fingerprint-given-by-the-client-but-only-md5-fingerprint-known-for-se)
post which told me to connect to the host using the
`FingerprintHash md5` option:

```
~$ ssh -o FingerprintHash=md5 192.168.56.11
```

The result is SSH displaying the MD5 hashed fingerprint which I
can now validate against the documented one. Once I validated that
the key is the correct one, I accepted the change and continued
with my endeavour.

I later discovered (or, more precisely, have strong assumptions)
that I had an old elliptic curve key registered in my `known_hosts`
file, which was not used for the communication for quite some time.
I recently re-enabled elliptic curve support in OpenSSH (with Gentoo's
USE="-bindist") which triggered the validation of the old key.

