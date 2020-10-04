Title: Switching gpg key to 0x2EDD52403B68AF47
Date: 2013-09-19 21:17
Category: Security
Tags: gpg, key
Slug: switching-gpg-key-to-0x2edd52403b68af47

I recently switched my GnuPG key. The previous key - which is still in
place for now (no revocation send out yet) - was 0x5DFAB3ECCDBA2FDB and
was a 1024 bit DSA key. The new one, 0x2EDD52403B68AF47, is a 4096 bit
RSA key. It also has the following preferences:

    gpg> showpref
    [ultimate] (1). Sven Vermeulen <sven.vermeulen@siphos.be>
    [ultimate] (2)  Sven Vermeulen <swift@gentoo.org>
         Cipher: AES256, AES192, AES, CAST5, 3DES
         Digest: SHA512, SHA384, SHA256, SHA224, SHA1
         Compression: BZIP2, ZLIB, ZIP, Uncompressed
         Features: MDC, Keyserver no-modify

The new key's fingerprint is as follows:

    gpg> fpr
    pub   4096R/0x2EDD52403B68AF47 2013-09-16 Sven Vermeulen 
     Primary key fingerprint: 7264 9F85 E8F1 6F6A 4B68  1102 2EDD 5240 3B68 AF47

A signed [key transition
statement](http://dev.gentoo.org/~swift/key-transition.txt.asc) can be
found on my Gentoo development page; the document is signed with both of
my keys (the old one and new one).
