Title: Trying out imapsync
Date: 2016-03-13 12:57
Category: Free Software
Tags: imapsync
Slug: trying-out-imapsync

Recently, I had to migrate mail boxes for a couple of users from one mail provider to
another. Both mail providers used IMAP, so I looked into IMAP related synchronization
methods. I quickly found the [imapsync](https://github.com/imapsync/imapsync) application,
also supported through Gentoo's repository.

<!-- PELICAN_END_SUMMARY -->

**What I required**

The migration required that all mails, except for the spam and trash e-mails, were
migrated to another mail server. The migrated mails had to retain their status flags
(so unread mails had to remain unread while read mails had to remain read), and the
migration had to be done in two waves: one while the primary mail server was still
in use (where most of the mails where synchronized) and then, after switching the
mail servers (which was done through DNS changes) re-sync to fetch the final ones.

I did not get access to the credentials of all mail boxes, but together with the
main administrator we enabled a sort-of shadow authentication system (a temporary
OpenLDAP installation) in which the same users were enabled, but with passwords that
will be used during the synchronization. The mailservers were then configured to
have a secondary interface available which used this OpenLDAP rather than the primary
authentication that was being used by the end users.

**Using imapsync**

Using `imapsync` is simple. It is a command-line application, and everything
configurable is done through command arguments. The basic ones are of course the
source and target definitions, as well as the authentication information for both
sides.

```
~$ imapsync \
  --host1 src-host --user1 src-user --password1 src-pw --authmech1 LOGIN --ssl1 \
  --host2 dst-host --user2 dst-user --password2 dst-pw --authmech2 LOGIN --ssl2
```

The use of the `--ssl1` and `--ssl2` is not to enable an older or newer version of
the SSL/TLS protocol. It just enables the use of SSL/TLS for the source host (`--ssl1`)
and destination host (`--ssl2`).

This would just start synchronizing messages, but we need to include the necessary
directives to skip trash and spam mailboxes for instance. For this, the `--exclude` parameter
can be used:

```
~$ imapsync ... --exclude "Trash|Spam|Drafts"
```

It is also possible to transform some mailbox names. For instance, if the source host
uses `Sent` as the mailbox for sent mail, while the target has `Sent Items`, then the
following would enable migrating mails between the right folders:

```
~$ imapsync ... --folder "Sent" --regextrans2 's/Sent/Sent Items/'
```

**Conclusions and interesting resources**

Using the application was a breeze. I do recommend to create a test account on both sides
so that you can easily see the available folders, source and target naming conventions as
well as test if rerunning the application works flawlessly.

In my case for instance, I had to add `--skipsize` so that the application does not use the
mail sizes for comparing if a mail is already transferred or not, as the target mailserver
showed different mail sizes for the same mails. This was luckily often documented on the
various online tutorials about `imapsync`, such as 

- [Moving to Google Apps with imapsync](http://seagrief.co.uk/2010/12/moving-to-google-apps-with-imapsync/) on seagrief.co.uk
- [Guide to imapsync](https://wiki.zimbra.com/wiki/Guide_to_imapsync) on wiki.zimbra.com

The migration took a while, but without major issues. Within a few hours, the mailboxes of all
users where correctly migrated.

