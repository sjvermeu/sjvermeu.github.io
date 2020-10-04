Title: hex2passwd, a password generator
Date: 2008-09-25 19:34
Category: Free Software
Slug: hex2passwd-a-password-generator

I know that repeatable password generators are less secure than random
character generators. After all, if you want a strong password, you can
simply perform **head -c 8 /dev/urandom | mimencode** to obtain a nice,
random password string.

However, in certain cases you might want to generate passwords given a
particular entry which always returns the same password. For instance,
for low-profile web sites. Most people use mneumonics (such as username
reversed and appended with domainname abbreviation to give an example)
but mneumonics can be quite insecure, especially if you use a mneumonic
that, once someone sees one of your passwords, he can deduce all
passwords.

An example would be the above-given algorithm, which yields for the
following sites:

    bugs.gentoo.org, user foobar, password raboofbgo
    forums.gentoo.org, user bleh, password helbfgo
    www.sourceforge.net, user mynick, password kcinymwsn

I'm sure you can find the password for other sites I would show you, so
this kind of passwords are not that secure.

Enter [hex2passwd](http://dev.gentoo.org/~swift/tools-hex2passwd.html),
a tool which generates (the same) password for the same input over and
over again. With the tool you can make your mneumonic a bit more secure
as it uses hashfunctions to create a pseudorandom sequence and a
character mapping to convert the hash result into a possible password.

An example for the above sites / mneumonic would yield:

    For bugs.gentoo.org, user foobar
    $ echo raboofbgo | sha1sum | hex2passwd -n 8
    XqXgOYce
    For forums.gentoo.org, user bleh
    $ echo helbfgo | sha1sum | hex2passwd -n 8
    l8U.tdzg
    For www.sourceforge.net, user mynick
    $ echo kcinymwsn | sha1sum | hex2passwd -n 8
    70z4Bu3k

Of course, the tool offers some more flexibility, such as choosing your
own character maps or scrambling the maps before you use them. In any
case, if you think such a tool is useful for you as well, don't hesitate
to download, compile and install it - it's a simple C program, probably
too ugly to show ;-)
