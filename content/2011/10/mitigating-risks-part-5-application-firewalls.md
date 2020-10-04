Title: Mitigating risks, part 5 - application firewalls
Date: 2011-10-05 23:38
Category: Security
Slug: mitigating-risks-part-5-application-firewalls

The last *isolation-related* aspect on risk mitigation is called
**application firewalls**. Like more "regular" firewalls, its purpose is
to be put in front of a service, controlling which data/connections get
through and which don't. But unlike these regular firewalls,
[application
firewalls](https://en.wikipedia.org/wiki/Application_firewall) work on
higher-level protocols (like HTTP, FTP) that deal with user data rather
than with connection routing. I'm going to call these firewalls "network
firewalls", although most modern network firewalls have some application
firewall functionality as well.

The purpose and necessity of network firewalls is well known and
understood: make sure that the service is only accessible from the right
location, check if connections aren't abused (or too many connections
are made), etc. But what if the connection itself is valid? After all,
most abuse of services is not because they originate from the wrong
location or try to access the wrong service. Instead, such abuse comes
from valid access to the application, but with less kosher intentions.
So what can application firewalls do in this case?

-   Because they perform inspection of the data that is transferred
    itself, application firewalls can **detect malicious data
    fragments** or attempts to abuse the service. These detection rules
    can be based on general, heuristic rules (well-known examples are
    detection rules for cross-site scripting attacks (XSS) or
    SQL Injection) but can also be very specific to a
    particular application.
-   Because all data is transferred through the firewall and the
    firewall has knowledge of the application itself, these firewalls
    offer **advanced auditing features** since they can detect
    authentication steps, user data, application-specific transactions
    and more.
-   With knowledge of the users' session and
    behavior (application-level) and origin (network level), application
    firewalls can **detect and prevent unauthorized sessions**, such as
    the case with session hijacking or even man-in-the-middle attacks
    (based on behavior detection)

Implementing an application firewall however doesn't only mean that you
improve access controls on it. It has other advantages that make
application firewalls an important part in many architectures:

-   If all service access is forced through the application firewall
    (for instance through an IP filter on the service that only allows
    connections from the application firewalls) you can implement rules
    that **deter known attacks/vulnerabilities** without needing to fix
    the code itself (or if fixing is possible, lower the time pressure).
    For instance, for Apache-based services, such an application
    firewall could detect or even change the `Range:` header on
    malicious requests to lower the impact of this potentially nasty DoS
    vulnerability
-   Depending on the complexity, some **functional application bug
    fixing** might even be possible. For instance changing content types
    on requests/replies (HTTP), adding a domain on an FTP accounts'
    login statement, ...
-   Many application firewalls (or gateways) offer proxy functionality
    which might **improve response times**. This is not a sure-given,
    since most applications are session-aware so the advantage is only
    for session-agnostic requests (be it static content or specific SQL
    statements in case of a database firewall). But also in case of
    session-aware statements can an improvement be found. Consider a
    database firewall which translates SQL statements from an
    unsupported application towards better defined statements (for
    instance using proper indexes or materialized views).
-   In some cases, you might even be able to upgrade a backend of an
    unsupported application (which previously required an outdated
    version of that database) by translating the backend requests when
    they are incompatible with the new backend version. So you can
    **improve integration** or **support unsupported upgrades**.
-   In case of risk reduction, application firewalls also allow you to
    move a service elsewhere (even in the **public cloud**) and still
    keep the access under control.

Of course, it would be TGTBT (Too Good To Be True) if there isn't an
(important) downside: *maintaining the application firewall is a
daunting task*. Because of its flexibility, you'll need deep knowledge
in the application firewall administration and development, keep track
of all rules you have (and why you have them), do lots and lots of
testing on each rule (since it might affect the functioning of the
application) and still be aware that subtle differences introduced by
the application firewall rules can pop up unexpectedly. Also,
integrating an application firewall is another service between your
customer and his service, which might influence performance but also
makes the underlying architecture more complex. Finally, you'll need to
consider that an application firewall requires lots of resources
(CPU/memory), especially when it needs to perform SSL/TLS termination.
Oh, and they're often expensive too.

Still, even with these downsides, application firewalls are an important
part of the service isolation strategy, which is a key aspect in the
[risk mitigation
strategy](http://blog.siphos.be/2011/09/mitigating-risks-part-1/) which
this series started with. We've focused on three now: [service
isolation](http://blog.siphos.be/2011/09/mitigating-risks-part-2-service-isolation/)
(network-wise), process isolation (through [mandatory access
control](http://blog.siphos.be/2011/09/mitigating-risks-part-4-mandatory-access-control/))
and now access isolation through application firewalls. And with proper
[hardening](http://blog.siphos.be/2011/09/mitigating-risks-part-3-hardening/)
in place, I believe that you have done all you can do to reduce the
risks when running unsupported software (apart from upgrading it or
switching towards supported software).

If you have other ideas that benefit risk mitigation, with specific
focus on unsupported software, I would be glad to hear about them.
