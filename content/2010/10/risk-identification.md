Title: Risk identification
Date: 2010-10-14 20:18
Category: Security
Slug: risk-identification

Risk identification is a difficult subject. Analysts need it to defend
mitigation strategies or to suggest investments. Yet risk identification
is often a subjective method, especially in the IT industry. How do you
give a number on a certain risk? When do you believe that that number
exceeds a threshold? Because of the ambiguous definition of risks, it is
often overlooked or substituted with impact analysis.

Now impact analysis is not much better, but it is easier to comprehend.
Impact analysis describes what happens when something has occurred. It
doesn't state how often it can occur, or what the chances are of the
event to occur, but gives an estimation on how big the impact would be
when it occurs. Most of the time one describes an impact with financial
loss. The highest impact a company has is that its survival is
threatened. If you're a simple shop and you don't take an insurance on
your stock, the impact of a fire or explosion in your shop might be that
you're put out of business. If you do have insurance, your impact is
more limited.

In the majority of cases, impact analysis is more straightforward.

IT risks are a prime example of difficult exercises. Quantifying the IT
risks that a company is taking is difficult. In this post, I'm
introducing a more straightforward method - even if it isn't fail-safe,
it might still give some interesting sights on the matter. It is of
course not something I invented myself (there's enough information on
the internet about risk analysis or risk identification), merely a
combination of several methods and ideas which I find useful (and
decided to write up about).

The method identifies a risk within four levels: low, medium, high and
very high. To get inside a level, it uses two metrics: *impact analysis*
which we've discussed before, and *chance of occurrence*. The latter is
the most difficult to identify, but let's first show how to map the two
onto the risk level:

    chance of occurrence
       ^
     4 +  M  M  VH VH
     3 +  M  M  VH VH
     2 +  L  L  H  H
     1 +  L  L  H  H
       x--+--+--+--+--> impact analysis
          1  2  3  4

As you can see, I give each axis four values, going from low (low
impact, or low probability) onto high. The resulting point lays within
one of four quadrants - Low, Medium, High or Very High. I identify an
event as having a high(er) risk when its probability is low but impact
high, whereas an event that has a high probability but low impact is
considered to be less of a risk: when something with a somewhat low(er)
impact occurs, you should still have some breathing space to make sure
it won't happen again (or find a way to reduce the impact) whereas an
occurrence of something with a high(er) impact will most likely leave
you hurt, fragile and licking your wounds.

So, how to measure the chance of occurrence of an event? Well, let's do
this in two stages: do an initial assessment, and then elevate the
chance using particular checks. Within IT, an often described threat is
the threat of someone trying to achieve personal gain (financial or
public) from the system(s). Note that, for every possible threat, one
will need to make a risk identification - you can't just say that a
system has a risk. It is always a particular threat which is assigned a
risk. So how large is the chance of such a "hack" attempt occurring?

First, how "wide" is the access vector towards your system? Can the
entire world (read: Internet) access the system (level = 4), is it
everyone in the company (level = 3), everyone within an affiliated
department (in most cases it means "IT department", level = 2) or
limited to a very small set of people (level = 1)?

Second, if one of the people identified earlier would want to perform
malicious activity with eye on personal gain (financial or PR), would he
succeed by his own (level + 1) or would he need at least one accomplice?

Third, if the activity was performed, would it be traceable to the
person or not (if not: level + 1)?

As an example (purely hypothetical): read access to the access logs of a
web application server which contains HTTP session information (logging
of SESSIONID) as well as username (authentication) and origin (IP
address) as well as other information. The threat: using this
information to hijack an active session.

First, if a hijack would be successful, the impact would be considered a
level-3 (with 1 being low and 4 being very high): the company might
suffer huge financial losses or PR would be a difficult beast to tame
(because the application is an internal stock application with features
to perform financial operations). But how high is the chance of
occurrence?

Well, say that the log files themselves can only be read by IT staff
(level = 2), but that someone of the IT staff cannot hijack the session
easily with this information alone as he would either require firewall
changes (for instance because the application can only be reached
through trusted middleware components) or have access to the machine the
user is working on, and such changes or access require more than a
single person in the situation. Also, if he did, audit trails would lead
the changes (firewall changes or machine access) to the person. As a
result, the chance of this event occurring given the circumstances is
considered a level 2. At the quadrant, this would yield a level of
"High". The risk of occurrence is relatively low, but the impact is too
high to ever consider this a "Medium" or "Low".

Now if we were to reduce the risk, we could focus on lowering the chance
of occurrence (only few people access to the given information - say
keep SESSIONID information in a separate, inaccessible logfile only to
be used for general, automated metric collection - after all, if there's
no point in keeping track of SESSIONID's, they wouldn't be logged
anyhow). This is a lot easier to accomplish than to try and lower the
impact analysis. On the other hand, if the impact analysis could be
lowered (say by requesting a stronger authentication method for
validating particular steps within the application, such as approvals) a
session hijack would give less impact - say level 2 or even 1. In that
case, the current risk would be lowered from "High" to "Low".
