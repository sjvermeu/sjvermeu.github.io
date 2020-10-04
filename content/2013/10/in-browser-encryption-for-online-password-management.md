Title: In-browser encryption for online password management
Date: 2013-10-20 21:29
Category: Security
Tags: aes, encryption, javascript, password, passwordmanagement
Slug: in-browser-encryption-for-online-password-management

Lately I've been trying to find a good free software project that uses
PHP or cgi-bin (one of the requirements for this particular
organization) that allows its users to store passwords centrally, but
uses encryption on the browser level before the passwords are sent to
the central server. I've found one -
[Clipperz](https://www.clipperz.com) - but was not able to get it to
build and install.

With the continuous revelations regarding hacked sites and servers (and
even potential snooping into server data by governments) the requirement
isn't that weird: by using strong encryption (I currently still assume
that AES-256 is safe for use) on the browser level, no unencrypted
sensitive data (such as usernames and passwords) would be sent to the
server, let alone stored (in plain text) on the server database.

I did a small test to see how difficult it would be to implement this in
a simple PHP password management tool called [online
passwords](http://onlinepasswords.sourceforge.net/). The PHP-based
application does not even use a database, relying on flat-files instead.
By design, the tool encrypts the data before storing on the file system,
but I wanted to go a bit further, implementing the in-browser
encryption. The Javascript AES is provided by
[movable-type.co.uk](http://www.movable-type.co.uk/scripts/aes.html) and
for the hashing algorithm I found [pajhome's
implementation](http://pajhome.org.uk/crypt/md5) often cited.

The first thing I did was substitute the password information needed to
log on to the site (and which is also used as encryption key for the
back-end side encryption) with a hashed version of the password. For the
application, this hardly matters - it is still the encryption key it
will use on the backend, although most likely a bit stronger than most
passwords would be.

Next, I keep the real password in a local session storage (which is
supported by most modern browsers nowadays) so that the user only has to
enter it once (when logging on to the site) and it is kept in memory
then, never leaving the browser. This is needed in order to decrypt the
data as we get it without having to ask the user for the password over
and over again. Of course, I don't want to keep this password in a
Cookie (or pass it on through the URL) because that would void the idea
of keeping the password (reasonably) secure.

To accomplish this, I hide the password field of the PHP application
itself, and create a second input field (outside the `<form> </form>` to
make sure its value is never POSTed to the site) in which the user
enters his password. Upon submit of the data, the following javascript
code will create the hash of the password (and user name) to use as the
"site password" for the application, and put that in the (hidden) input
field. It then also stores the site password in the local session
storage in the browser. The code is triggered through the *onSubmit*
handler of the form.

    function storeAppPassword() {
      var sitepw = document.getElementById('password');
      var siteus = document.getElementById('login');
      var userpw = document.getElementById('userpassword');

      sessionStorage.setItem('userpassword', userpw.value);
      sitepw.value = hex_sha1(siteus.value + userpw.value);
    }

Now I need to make sure that the fields that need to be encrypted (the
various user ids and passwords that are stored on the site) are
encrypted before they are sent to the server, and decrypted after having
received them by the browser. For instance, if the fields are within a
form, the following javascript function could be triggered on the
*onSubmit* handler again:

    function encryptFields() {
      var useridFld = document.getElementById('userid');
      var passwordFld = document.getElementById('password');
      var notesFld = document.getElementById('notes');

      var pw = sessionStorage.getItem('userpassword');
      useridFld.value = Aes.Ctr.encrypt(useridFld.value, pw, 256);
      passwordFld.value = Aes.Ctr.encrypt(passwordFld.value, pw, 256);
      notesFld.value = Aes.Ctr.encrypt(notesFld.value, pw, 256);
    }

Similarly, to decrypt the fields (inside the same form), that part of
the code would become:

    useridFld.value = Aes.Ctr.decrypt(useridFld.value, pw, 256);

Decryption of the fields can be called by a simple javascript call at
the end of the page.

If the data is within regular fields (non-form related), such as a
table, you'll need to find the right DOM element and call the decryption
function there.

With those few changes, I was able to get it up and running quickly. I
don't think I'll use the PHP application itself in production though, as
it doesn't look like it sanitizes the field data in the PHP code and it
starts to show performance issues when called with only a few hundred
accounts, each having a few dozen passwords. But that hardly matters for
this post where I want to point out that it isn't that hard to put some
higher security on such sites.

The big downside right now is that, if the user forgets his password, he
wont have access to all his data (similar to the Clipperz one). And
unlike Clipperz, the approach above does not allow for password changes
yet (although it doesn't look that hard to implement some logic
decrypting and re-encrypting the data with a different password if that
comes about). An approach to resolve that would be to encrypt all data
with a static key, and then encrypt that key with the password, storing
the encrypted key on the server. A password change only requires a
decrypt/encrypt of the key while all values remain encrypted with the
static key.

Moral of the story: application managers of web password storage sites:
please add in-browser encryption for those of us that want to make
\*really\* sure that no sensitive data is sent over unencrypted (I don't
count SSL/TLS as that "ends" at the remote side while this one is full
end-to-end encryption).
