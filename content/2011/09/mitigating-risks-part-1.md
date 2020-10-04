Title: Mitigating risks, part 1
Date: 2011-09-05 22:05
Category: Security
Slug: mitigating-risks-part-1

> We are running Foobar 2.0 on Tomcat 4. We know that Tomcat 4 isn't
> supported, but hey - our (internal) customer is happy that the Foobar
> application works and would like to keep it that way. Upgrading to
> Tomcat 5 or higher is not possible - Foobar 2.0 only works on Tomcat
> 4. If we want to use a higher Tomcat version, we need to upgrade the
> application which costs a lot of money (which our (internal) customer
> doesn't want to pay) and requires lots of testing as it is a
> non-trivial upgrade. So... what can an IT department do to mitigate
> the risks here?

This is not a hypothetical example (well, apart from the software titles
used) for many organizations. Be it the application itself, its
middleware, back-end or operating system: often you'll face an
end-of-support deadline without the means to upgrade the application
(because of budgetary issues, unwillingness of the responsible
department or no alternative). Whatever the reason, you as an IT
department have the responsibility to mitigate the risks involved with
running out-of-support software (and communicate risks to all parties
that are affected by it). So what are your options?

In this series of posts, I'll cover a set of risk mitigation strategies
that might help you reduce the issues that come up from running
out-of-support software. But first, what are those risks?

-   **Security patches**. It is the first risk that the operations
    department will say when they have to deal with
    unsupported software. Well, the risk isn't the security patches, but
    the result made by the lack of it. Software tends to have bugs. Some
    of these bugs can result in inappropriate functionality, such as
    granting access to unauthorized people or even executing (unwanted)
    commands on the server. Sounds improbable? [Guess
    again](http://cvedetails.com/cve/CVE-2011-3190/). Especially when
    running out-of-support software this becomes a nightmare to manage,
    because security patches are not created anymore, and newly
    discovered vulnerabilities might still affect older versions - even
    when the vulnerabilities do not mention the older versions anymore.
    And the worst thing is that you *might not even detect it*.
-   **Functional bugs**. If your customer tries something out and the
    application barfs, then there is little you can do to fix this.
    Either you dive in the code yourself (good luck with that) or you
    hope that a workaround exists. Getting a functional bug fix is not
    that feasible. Also, do not think that functional bugs will not pop
    up anymore "because the application has been running fine
    for years". A change on the system (update of the java runtime,
    kernel upgrade, update on a particular library) might be enough to
    trigger it.
-   **Non-functional bugs**. The application starts dragging down? You
    notice inflated response times? Can the application only deal with
    10 concurrent users, but your customer just hired 2 additional
    employees? Too bad. You might be able to work around this by
    duplicating the application and putting a load balancer in front of
    it, but with stateful applications that isn't always that easy to  
    accomplish. Forget about service level agreements when the software
    is unsupported. You can't guarantee them anymore.
-   **Legal requirements**. You might not know it, but many institutions
    are governed by specific IT requirements. Especially the financial
    sector (with the recent crisis and all) is and will get more and
    more regulatory compliance requests, and the IT infrastructure will
    not be spared. If you run unsupported software, you might be
    ignoring particular requirements that you have.
-   **Upgrade difficulties**. Eventually you will need to upgrade. If
    the software you are upgrading from is unsupported, chances are very
    low that a good, flexible (and cost-efficient) upgrade
    trajectory exists. Migration scripts will probably not work and
    consultancy will fail. Anyone have experience with upgrading from
    Oracle 7.3 to Oracle 11g?
-   **Integration failures**. Most applications are integrated in a
    larger architecture. Applications probably get authorization feeds
    or send out events to other components. As the external services
    that the application interacts with get updated, their interfaces
    update with them. And eventually you will get into a situation where
    the integration suddenly fails. I've seen an application use
    HTTP/1.0 whereas its external services suddenly only
    supported HTTP/1.1. Have fun explaining that to your customer (who
    might not even know that HTTP is a protocol).
-   **Customer support**. If you use an internal help desk, then you
    might be able to educate them with troubleshooting the (unsupported)
    software. But if the help desk is external, you'll probably be
    facing a "No" after a while - or a nice additional fee.

Some of these risks not only affect the product itself, but all other
products / softwares that are installed on the server (or even on the
network). If you ever face the request to continue supporting Foobar 2.0
on an unsupported Tomcat, now you have a checklist that you can tell
your (requesting) customer about the risks he is introducing - and don't
forget to tell the other customers about the risks they will be taking
as well then.

But I promised that I will be talking about risk mitigation... so just
hold on for part 2 -- "service isolation".
