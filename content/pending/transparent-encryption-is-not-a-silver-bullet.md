Title: Transparent encryption is not a silver bullet
Date: 2021-09-01 00:00
Category: Architecture
Tags: encryption,transparent,luks,dm-crypt
Slug: transparent-encryption-is-not-a-silver-bullet
Status: draft

Transparent encryption is relatively easy to implement, but without
understanding what it actually means or why you are implementing it, you will
probably make the assumption that this will prevent the data from being
accessed by unauthorized users. Nothing can be further from the truth.

**Listing the threats to protect against**

Let's first list the threats you want to protect against. It is beneficial that
these threats are also scored in the organization for their likelihood of
occurrence and effect, so that you can optimize and prioritize the measures
appropriately.

* Data leakage through theft or loss of storage media
* Data leakage through unauthorized data access (OS level)
* Data leakage through unauthorized data access (middleware/database level)
* Data leakage through application vulnerability (including injection attacks)
* Loss of confidentiality through data-in-transit interception
* Loss of confidentiality through local privilege escalation

While all the "data leakage" threats are also about loss of confidentiality,
and any loss of confidentiality can also result in data leakage, I made the
distinction in name as the data intercepted through that threat is generally
not as 'bulky' as the others.

To visualize the threats, consider the situation of an application that has a
database as its backend. The application is hosted on a different system than
the database. In the diagram, the blue color indicates an application-specific
focus. This does not mean it isn't infrastructure oriented anymore, but more
that it can't be transparently implemented without the application supporting
it.

![Application and database interaction]({static}/images/202109/te-accesspatterns.png)

There are eight roles listed (well, technically seven roles but let's keep it simple and make "physical access" also a role), ranging from the application user to the physical access:

* The *application user* interacts with the application itself, for instance
  from a browser to the web application.
* The *application administrator* also interacts with the application, but has more privileges. The user might also have access to the system on which the application itself resides (but that isn't further modelled here).
* The *network poweruser* is a user that has access to the network traffic
  between the client and application, as well as to the network traffic between
  the application and the database. Depending on the privileges of the users,
  these powerusers can be administrators on systems that reside in the same
  network.
* The *database / middleware user* is a role that has access to the application
  data in the database directly (so not (only) through the application). This
  can commonly be a supporting function in the organization.
* The *database / middleware administrator* is the administrator of the
  database engine (or other middleware component that is used).
* The *system administrator* is the administrator for the server on which the
  database is hosted.
* The *system user* is an unprivileged user that has access to the server on
  which the database is hosted.
* The *physical access* is a role that has physical access to the server and
  storage.

Further, while the example is easiest to understand with a database system, be
aware that there exist many other middleware services that manage data (like
queueing systems) and the same threats and measurements apply to them as well.

**Transparent encryption is a physical medium data protection measure**

Transparent encryption, such as through LUKS (with DM-Crypt) on Linux, will
encrypt the data on the disks, while still presenting the data unencrypted to
the users. All users. Its purpose hence is not to prevent unauthorized users
from accessing the data directly, but to prevent the storage media to expose
the data if the media is leaked or lost.

![Transparent Disk Encryption]({static}/images/202109/te-tde.png)

In the diagram, you notice that the transparent disk encryption only takes
effect between the server and its storage. Hence, the only 'inappropriate'
access that it is mitigating is the physical access to the server storage. Note
that physical access to the server itself is still an important attack vector
that isn't completely mitigated here - attackers with physical access to
servers will not have a too hard time to find an entrypoint to the system.
Advanced attackers might even be able to capture the data from memory without
being detected.

My recommendation for transparent disk encryption is mostly towards removable
media (like USB sticks) if they contain any (possible) confidential data and
the method for transparent encryption is supported on all systems where you are
going to use the removable media.

For server disks or SAN storage for instance, this has to be balanced against
the downsides of the encryption. You can do disk encryption from the storage
array for instance, but this might impact the array's capability for
deduplication and compression. If your data centers are highly secured, and you
do not allow the storage media to leave the premises without being properly
wiped or destroyed, then such transparent encryption imo has little value.

Of course, when you have systems hosted in third party locations, then you do
have a higher risk that the media are being removed or stolen, especially if
those locations are accessed by many others, and your own space isn't
physically further protected.

Furthermore, a properly configured database system will not expose its data to
unauthorized users to start with, so the *system user* role should not have
access to the data. But once you have local access to a system, there is always
the threat that a privilege escalation bug is triggered that allows the
(previously lower privileged) user to access protected files.

**Transparent database encryption isn't that much better**

Some database technologies (or more general middleware) offer transparent
encryption themselves. In this case, the actual database files on the system
are encrypted by the database engine, but the database users still see the data
as it is unencrypted.

![Transparent Database Encryption]({static}/images/202109/te-tdbe.png)

Here again, it is important to know what you are protecting yourself from.
Transparent database/middleware encryption does prevent the non-middleware
administrators from directly viewing the data through the files. However,
system administrators generally have the means to become the database (or
middleware) administrator, so while the threat is not direct, it is still
indirectly there.

The threat of privilege escalation on the system level is partially mitigated.
While a full system compromise will lead to the system user getting system
administrator privileges, partial compromise (such as receiving access to the
data files, but not to the encryption key itself, or not being able to
impersonate users but just access data) will be mitigated by the transparent
database encryption.

Important to see here is that the threats related to the physical access are
also mostly mitigated by the transparent database encryption, with the
exception that database-only encryption might result in the encryption key
being leaked if it is situated on the system storage.

Most of the threats however are still not mitigated: network interception (if
it doesn't use a properly configured TLS channel), admin access, database user
access, application admin and application users (through application
vulnerability) can still get access to all that data. The only focus these
measures have is data loss through physical access.

**Database or middleware supported, application-driven encryption is somewhat better**

Some database technologies support out-of-the-box data encryption through the
appropriate stored procedures or similar. In this case, the application itself
is designed to use these encryption methods from the database (or middleware),
and often holds the main encryption key itself (rather than in the database).

![Database or middleware supported data encryption]({static}/images/202109/te-dmsde.png)

While this prevents some of the attack vectors (for instance, some attacks
against the application will not result in getting a context that is able to
decrypt the data) and mitigates the attack vectors related to direct database
user access, there are still plenty of issues here.

System administrators and database administrators are still able to control the
encryption/decryption process. Sure, it becomes harder and requires more
thought and expertise (like modifying the stored procedures to also store the
key or the data in a different table for them to access), but it remains possible.

Because of the attack complexity, this measure is one that starts to meet
certain expectations. And because the database or middleware is still
responsible for the encryption/decryption part, it can still use its knowledge
of the data for things like performance tuning.

**Application-managed data encryption is a highly appreciated measure**

With application-managed data encryption, the application itself will encrypt
and decrypt the data even before it is sent over to the database or middleware.

![Application-managed data encryption]({static}/images/202109/te-amde.png)

With this measure, many of the threats are mitigated. Even network interception
is partially prevented, as the network interception now is only still possible
to obtain data between the client and the application, and not between the
application and database. Also, all roles that are not application-related will
no longer be able to get to the data.

Personally, I think that application-managed data encryption is always
preferred over the database- or middleware supported encryption methods.
Not only does it remove many threats, it is also much more portable, as you do
not need a database or middleware that supports it (and thus have to include
logic for that in the application).

Of course, applications will need to ensure that they can still use the
functionalities of the database and middleware appropriately. If you store
names in the database in an encrypted fashion, it is no longer possible to do a
select on its content appropriately.

**Client-managed data encryption**

The highest level of protection against the threats listed, but of course also
the most impactful and challenging to implement, is to use client-managed data
encryption.

![Client-managed data encryption]({static}/images/202109/te-cmde.png)

A web application might for instance have a (properly designed) encryption
method brought to the browser (e.g. using javascript), allowing the end user to
have sensitive data be encrypted even before it is transmitted over the
network.

In that case, none of the attack vectors will be able to obtain the data. Of
course, there are plenty of other attack vectors (protecting web applications
is an art by itself), but for those we covered, client-managed encryption does
tick many of the boxes.

However, client-managed data encryption is also very complex to do securely
while still being able to fully support the users. Most applications that
employ this focus already on sensitive material (like password managers) and
use end user provided information to generate the encryption keys. You need to
be able to deal with stale versions (old javascript libraries), multitude of
browsers (if it is browser-based), vulnerabilities within browsers themselves
and the web application, etc.

**Network encryption**

Network encryption (as in the use of TLS encrypted communications) only focuses
on the confidentiality and integrity of the communication, in our example
towards the network poweruser that might be using network interception.

![Network encryption]({static}/images/202109/te-ne.png)

While the majority of other threats are still applicable, I do want to point
out that network encryption is an important measure against other threats. For
instance, with network encryption, attackers cannot easily inject code or data
in existing flows. In case of the client-managed data encryption approach for
instance, the use of network encryption is paramount, as otherwise an 'in the
middle' attacker can just remove the client-side encryption part of the code
that is transmitted.

**Conclusions**

I hope that this article provides better insights in when transparent
encryption is sensible, and when not. With the above assessment, it should be
obvious that transparent (and thus without any application support) encryption
methods do not cover all the threats out there, and it is likely that your
company already has other means to cover the threats that it does handle.

![Full overview]({static}/images/202109/te-full.png)

The above image shows all the different encryption levels and where in the
application, database and system interactions they are situated.

<!-- PELICAN_END_SUMMARY -->
