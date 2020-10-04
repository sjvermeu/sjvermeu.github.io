Title: Doing away with interfaces
Date: 2015-08-29 11:30
Category: SELinux
Tags: selinux, cil
Slug: doing-away-with-interfaces

CIL is SELinux' Common Intermediate Language, which brings on a whole new set of
possibilities with policy development. I hardly know CIL but am (slowly)
learning. Of course, the best way to learn is to try and do lots of things with
it, but real-life work and time-to-market for now forces me to stick with the
M4-based refpolicy one.

Still, I do try out some things here and there, and one of the things I wanted
to look into was how CIL policies would deal with interfaces.

<!-- PELICAN_END_SUMMARY -->

**Recap on interfaces**

With the M4 based reference policy, interfaces are M4 macros that expand into
the standard SELinux rules. They are used by the reference policy to provide 
a way to isolate module-specific code and to have "public" calls.

Policy modules are not allowed (by convention) to call types or domains that
are not defined by the same module. If they want to interact with those modules,
then they need to call the interface(s):

```m4
# module "ntp"
# domtrans: when executing an ntpd_exec_t binary, the resulting process 
#           runs in ntpd_t
interface(`ntp_domtrans',`
  domtrans_pattern($1, ntpd_exec_t, ntpd_t)
)

# module "hal"
ntp_domtrans(hald_t)
```

In the above example, the purpose is to have `hald_t` be able to execute
binaries labeled as `ntpd_exec_t` and have the resulting process run as the
`ntpd_t` domain.

The following would not be allowed inside the hal module:

```m4
domtrans_pattern(hald_t, ntpd_exec_t, ntpd_t)
```

This would imply that both `hald_t`, `ntpd_exec_t` and `ntpd_t` are defined
by the same module, which is not the case.

**Interfaces in CIL**

It _seems_ that CIL will not use interface files. Perhaps some convention
surrounding it will be created - to know this, we'll have to wait until a
"cilrefpolicy" is created. However, functionally, this is no longer necessary.

Consider the `myhttp_client_packet_t` declaration from a [previous post](http://blog.siphos.be/2015/08/filtering-network-access-per-application/).
In it, we wanted to allow `mozilla_t` to send and receive these packets. The 
example didn't use an interface-like construction for this, so let's see
how this would be dealt with.

First, the module is slightly adjusted to create a _macro_ called `myhttp_sendrecv_client_packet`:

```lisp
(macro myhttp_sendrecv_client_packet ((type domain))
  (typeattributeset cil_gen_require domain)
  (allow domain myhttp_client_packet_t (packet (send recv)))
)
```

Another module would then call this:

```lisp
(call myhttp_sendrecv_client_packet (mozilla_t))
```

That's it. When the policy modules are both loaded, then the `mozilla_t` domain is able
to send and receive `myhttp_client_packet_t` labeled packets.

**There's more: namespaces**

But it doesn't end there. Whereas the reference policy had a single namespace
for the interfaces, CIL is able to use namespaces. It allows to create an almost
object-like approach for policy development.

The above `myhttp_client_packet_t` definition could be written as follows:

```lisp
(block myhttp
  ; MyHTTP client packet
  (type client_packet_t)
  (roletype object_r client_packet_t)
  (typeattributeset client_packet_type (client_packet_t))
  (typeattributeset packet_type (client_packet_t))

  (macro sendrecv_client_packet ((type domain))
    (typeattributeset cil_gen_require domain)
    (allow domain client_packet_t (packet (send recv)))
  )
)
```

The other module looks as follows:

```lisp
(block mozilla
  (typeattributeset cil_gen_require mozilla_t)
  (call myhttp.sendrecv_client_packet (mozilla_t))
)
```

The result is similar, but not fully the same. The packet is no longer called
`myhttp_client_packet_t` but `myhttp.client_packet_t`. In other words, a period (`.`)
is used to separate the object name (`myhttp`) and the object/type (`client_packet_t`)
as well as interface/macro (`sendrecv_client_packet`):

```shell-session
~$ sesearch -s mozilla_t -c packet -p send -Ad
  ...
  allow mozilla_t myhttp.client_packet_t : packet { send recv };
```

And it looks that namespace support goes even further than that, but I still
need to learn more about it first.

Still, I find this a good evolution. With CIL interfaces are no longer separate
from the module definition: everything is inside the CIL file. I secretly hope
that tools such as `seinfo` would support querying macros as well.

