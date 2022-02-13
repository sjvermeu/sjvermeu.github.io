Title: GnuPG: private key suddenly missing?
Date: 2016-10-12 18:56
Category: Free-Software
Tags: gnupg
Slug: gnupg-private-key-suddenly-missing

After updating my workstation, I noticed that keychain reported that it could
not load one of the GnuPG keys I passed it on.

```
 * keychain 2.8.1 ~ http://www.funtoo.org
 * Found existing ssh-agent: 2167
 * Found existing gpg-agent: 2194
 * Warning: can't find 0xB7BD4B0DE76AC6A4; skipping
 * Known ssh key: /home/swift/.ssh/id_dsa
 * Known ssh key: /home/swift/.ssh/id_ed25519
 * Known gpg key: 0x22899E947878B0CE
```

I did not modify my key store at all, so what happened?

<!-- PELICAN_END_SUMMARY -->

**GnuPG upgrade to 2.1**

The update I did also upgraded GnuPG to the 2.1 series. This version has [quite
a few updates](https://www.gnupg.org/faq/whats-new-in-2.1.html), one of which is
a change towards a new private key storage approach. I thought that it might have
done a wrong conversion, or that the key which was used was of a particular method
or strength that suddenly wasn't supported anymore (PGP-2 is mentioned in the
article).

But the key is a relatively standard RSA4096 one. Yet still, when I listed my
private keys, I did not see this key. I even tried to re-import the `secring.gpg`
file, but it only found private keys that it already saw previously.

**I'm blind - the key never disappeared**

Luckily, when I tried to sign something with the key, `gpg-agent` still asked me
for the passphraze that I had used for a while on that key. So it isn't gone. What
happened?

Well, the key id is not my private key id, but the key id of one of the subkeys.
Previously, `gpg-agent` sought and found the private key associated with the subkey,
but now it no longer does. I don't know if this is a bug in the past that I accidentally
used, or if this is a bug in the new version. I might investigate that a bit more,
but right now I'm happy that I found it.

All I had to do was use the right key id in keychain, and things worked again.

Good, now I can continue debugging networking issues with an azure-hosted system...

