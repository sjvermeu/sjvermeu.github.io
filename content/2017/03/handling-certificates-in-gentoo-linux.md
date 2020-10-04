Title: Handling certificates in Gentoo Linux
Date: 2017-03-06 22:20
Category: Gentoo
Tags: gentoo, certificates, nss
Slug: handling-certificates-in-gentoo-linux

I recently created a new article on the Gentoo Wiki titled [Certificates](https://wiki.gentoo.org/wiki/Certificates)
which talks about how to handle certificate stores on Gentoo Linux. The write-up
of the article (which might still change name later, because it does not handle
*everything* about certificates, mostly how to handle certificate stores) was
inspired by the observation that I had to adjust the certificate stores of both
Chromium and Firefox separately, even though they both use NSS.

<!-- PELICAN_END_SUMMARY -->

**Certificates?**

Well, when a secure communication is established from a browser to a site (or any
other interaction that uses SSL/TLS, but let's stay with the browser example for now)
part of the exchange is to ensure that the target site is actually the site it claims
to be. Don't want someone else to trick you into giving your e-mail credentials do you?

To establish this, the certificate presented by the remote site is validated (alongside
other [handshake steps](https://en.wikipedia.org/wiki/Transport_Layer_Security#TLS_handshake)).
A certificate contains a public key, as well as information about what the certificate can
be used for, and who (or what) the certificate represents. In case of a site, the identification
is (or should be) tied to the fully qualified domain name.

Of course, everyone could create a certificate for accounts.google.com and try to trick you
into leaving your credentials. So, part of the validation of a certificate is to verify that
it is signed by a third party that you trust to only sign certificates that are trustworthy.
And to validate this signature, you hence need the certificate of this third party as well.

So, what about this certificate? Well, turns out, this one is also often signed by
another certificate, and so on, until you reach the "top" of the certificate tree. This top
certificate is called the "root certificate". And because we still have to establish that this
certificate is trustworthy, we need another way to accomplish this.

**Enter certificate stores**

The root certificates of these trusted third parties (well, let us call them "Certificate Authorities"
from now onward, because they [sometimes will lose your trust](https://en.wikipedia.org/wiki/DigiNotar))
need to be reachable by the browser. The location where they are stored in is (often) called
the truststore (a naming that I came across when dealing with Java and which stuck).

So, what I wanted to accomplish was to remove a particular CA certificate from the certificate
store. I assumed that, because Chromium and Firefox both use NSS as the library to support their
cryptographic uses, they would also both use the store location at `~/.pki/nssdb`. That was wrong.

Another assumption I had was that NSS also uses the `/etc/pki/nssdb` location as a system-wide one.
Wrong again (not that NSS doesn't allow this, but it seems that it is very much up to, and often
ignored by, the NSS-implementing applications).

Oh, and I also assumed that there wouldn't be a hard-coded list in the application. Yup. Wrong again.

**How NSS tracks root CA**

Basically, NSS has a hard-coded root CA list inside the `libnssckbi.so` file. On Gentoo, this
file is provided by the `dev-libs/nss` package. Because it is hard-coded, it seemed like there
was little I could do to remove it, yet still through the user interfaces offered by Firefox and
Chromium I was able to remove the trust bits from the certificate.

Turns out that Firefox (inside `~/.mozilla/firefox/*.default`) and Chromium (inside `~/.pki/nssdb`)
store the (modified) trust bits for those locations, so that the hardcoded list does not need to
be altered if all I want to do was revoke the trust on a specific CA. And it isn't that this hard-coded
list is a bad list: Mozilla has a [CA Certificate Program](https://www.mozilla.org/en-US/about/governance/policies/security-group/certs/)
which controls the CAs that are accepted inside this store.

Still, I find it sad that the system-wide location (at `/etc/pki/nssdb`) is not by default used as
well (or I have something wrong on my system that makes it so). On a multi-user system, administrators
who want to have some control over the certificate stores might need to either use login scripts to
manipulate the user certificate stores, or adapt the user files directly currently.


