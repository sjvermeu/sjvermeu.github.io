Title: What is that net-pf-## thingie?
Date: 2014-04-01 19:46
Category: Free Software
Tags: linux, module_request, net-pf
Slug: what-is-that-net-pf-thingie

When checking audit logs, you might come across applications that
request loading of a `net-pf-##` module, with `##` being an integer.
Having requests for `net-pf-10` is a more known cause (enable IPv6) but
what about `net-pf-34`?

The answer can be found in `/usr/src/linux/include/linux/socket.h`:

    #define AF_ATMPVC       8       /* ATM PVCs                     */
    #define AF_X25          9       /* Reserved for X.25 project    */
    #define AF_INET6        10      /* IP version 6                 */
    #define AF_ROSE         11      /* Amateur Radio X.25 PLP       */
    #define AF_DECnet       12      /* Reserved for DECnet project  */
    ...
    #define AF_BLUETOOTH    31      /* Bluetooth sockets            */
    #define AF_IUCV         32      /* IUCV sockets                 */
    #define AF_RXRPC        33      /* RxRPC sockets                */
    #define AF_ISDN         34      /* mISDN sockets                */
    #define AF_PHONET       35      /* Phonet sockets               */
    #define AF_IEEE802154   36      /* IEEE802154 sockets           */

So next time you get such a weird module load request, check `socket.h`
for more information.
