Title: Perimeter security testing
Date: 2012-08-28 22:47
Category: Security
Slug: perimeter-security-testing

I've been asked a few times how I would do perimeter security testing.
Personally, I'm not an offensive security guy, more a defensive one,
meaning I'm more about security-related defensive methods rather than
PEN testing of any kind. But still, even in a defensive position, having
a "view" on how to do security testing is important. For me, I would use
the following testing categorisation to look at IT architectures and see
how they would react against certain attacks. I'm calling this one about
*perimeter* testing as I am interested here in remote attacks (or
differentiation), not local ones (which requires, in my opinion, a
different way of looking at things).

-   Eggs and a basket
-   Overhead testing
-   Protocol insecurity or misuse
-   Application insecurity or misuse
-   Client insecurity
-   Correlation

**Eggs and a basket**

First of all, don't put all your eggs in the same basket. I would never
trust myself enough to say things are secure. Always see if you can't
benefit from other people's knowledge (or even other companies
knowledge). If you are doing testing to choose a specific
security-related technology, use analysis made by independent analysis
firms or organizations to further steer your choice. But make sure that
the organization is truely independent and doesn't give "reports" that
are heavily in favor of whomever asked for them.

**Overhead testing**

Most technologies you use to counter certain threats will incur some
overhead. This is true for application firewalls, network firewalls,
isolation technologies, confidentiality technologies, access controls
and more. You should set yourself a baseline of what you consider too
much overhead and what not.

Overhead comes in many layers, so it is important to be able to perform
load testing based on real loads, not fake lab-specific situations.
Running one thousand clients with the same client certificate, same
hosts, same reaction times against one SSL resource has an entirely
different performance profile than running one thousand clients with
different certificates, using different encryption libraries (other
ciphers and such) and different speeds/reaction times (including things
like SSL handshake timings). And that's just one example.

I always find it very important to be able to run load testing
regularly. I would even go as far as recommend organizations to run load
testing as a "business as usual" test, or at least allow your
technology-inspired teams to easily request such loads against their new
applications or technologies.

But enough of that. Let's talk about attack methods (or categorisation).

I tend to look first towards *protocol* insecurity, then *application*
insecurity and finally *client-level* insecurity. Protocol insecurity is
primarily about knowing how the protocol works (or should work) and
finding ways to attack that. Some protocols are inherently insecure, and
introducing proper protection against these is extremely important as
the technology that implements the protocol might not be able to do that
itself. Then I look at application-specific insecurity, which is more
about knowing the application (vendor/product). And finally it is about
client insecurity (such as browser-based attacks, ActiveX component
attacks, and more).

In each of these cases, I consider the following attack methods:

-   Denial-of-Service - what could be done to disable the protocol or
    service behind it completely or partially
-   Out-of-order Execution - can the protocol or application be tricked
    into executing tasks when it isn't meant to, which most of the time
    leads to either information leakage or the next attack method
-   Privilege escalation - to get more rights/privileges (or switch from
    unauthenticated to authenticated access)
-   Remote command execution - executing whatever the attacker wants on
    the remote system
-   Application switching/routing - updating the behavior of the
    application to become a service that can be used to further
    expose/explore the remote servers' environment

**Protocol insecurity or misuse**

Many protocols are inherently insecure. Good security solutions will
need to detect if a protocol is being used in a way that does not match
the behavior expected. And this goes beyond the standard TCP/IP
protocols and the application-level HTTP protocol. Consider SMTP and
VoIP-related protocols as well as a nice example.

Denial of service attacks against TCP/IP are widely documented. Be it
the well-known SYN flooding, a [low-rate tcp-targeted
DoS](http://www-ece.rice.edu/networks/papers/lrdos.pdf) or messing with
the TCP stack itself (like with the [Microsoft Windows TCP/IP Stack
Vulnerabilities](http://support.microsoft.com/kb/2563894)), these
attacks can be easily evaluated against your architecture.

With TCP/IP, I would generally also look at how the stacks present their
information. Can an attacker use [TCP sequence prediction
attacks](https://en.wikipedia.org/wiki/TCP_sequence_prediction_attack)?
Can he get information on when is the most feasible period to launch an
attack (for instance from a reasonably stable TCP window size value
reading)? And how about TCP session hijacking?

Or if we look at HTTP, can attacks such as
[Slowloris](http://ha.ckers.org/slowloris/) or an [HTTP POST
DOS](http://www.acunetix.com/blog/web-security-zone/articles/http-post-denial-service/)
attack bring down the service? And what if a user comes to a certain
page after an obscure redirection, where the attacker hopes that the
user authenticates against? Perhaps an attacker might hijack an HTTP
session, or force a user to use a non-secure connection.

E-mail services too are particularly interesting to look at. Does it
expose information (settings, or account identification)? Does it accept
large time-outs (giving attackers time to just "play" with the service
using netcat/telnet)?

And in case of VoIP, have you checked common [voip-based
attacks](http://www.slideshare.net/null0x00/voip-vulnerabilities-and-attacks)
lately? VoIP is (imo) a complex set of protocols and whomever implements
it has to follow strict rules. I would be very surprised if this can't
be heavily influenced.

**Application insecurity or misuse**

Of course, protocols are implemented by applications, and applications
have their own set of problems. And if you're running software that
isn't properly configured or up to date, you'll definitely need to take
a good read at my blog posting series on [mitigating
risks](http://blog.siphos.be/2011/09/mitigating-risks-part-1/).

Consider Citrix for instance: a commonly found remote management
toolsuite (well yeah, Citrix offers a lot more, I'm not going to delve
into that right now). It has seen its share of vulnerabilities in the
past, like [DoS](http://support.citrix.com/article/CTX121172)
vulnerabilities, [directory traversal or open
proxy](http://support.citrix.com/article/CTX133648), [command
execution](http://www.vsecurity.com/resources/advisory/20101221-1/) and
more. And Citrix is far from an insecure platform.

Just like with all other applications, it is extremely important to have
a good view / knowledge of each product you expose. Some applications
can even mimic other protocols (like
[Nginx](http://wiki.nginx.org/Modules) handling HTTP, IMAP, POP3, SMTP,
WebDAV, ... which, if exploited by an attacker, can provide a new
fall-out base to work from.

**Client insecurity**

Finally, the last thing to consider is most likely the one most
difficult to manage: client insecurity. Especially with internet-facing
services, it is very hard to protect yourself from client systems that
are not properly protected. How to deal with user authentication if the
user could have a keystroke logger running in the background? A browser
is a commonly used application for service access, but what about things
like a Citrix client (especially if local drive mapping is enabled)?

**Correlation**

A good security system is integrated with the various security
technologies in place. An attacked that did discovery or even tried out
a few other attacks before should already alert most of your security
components, possibly even invoking a temporary countermeasure against
the users' location. It is not sufficient to block the IP address on the
webserver when the attacker tried an HTTP-based attack only to have him
try his luck on the next service that you expose...

Now for each "category" I tend to look at the attack from a "hit and
run" aspect (exploitable with a single attack or burst), "build up"
(most of the slower attacks tend to be like this) or "evaded" (trying to
work around detection of the previous ones), and this for a single host,
a relayed host or distributed. All these factors combined give me enough
things to consider while evaluating an architecture (or security
technology implementation) for remote attacks.
