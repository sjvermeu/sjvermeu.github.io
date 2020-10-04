Title: Have dhcpcd wait before backgrounding
Date: 2015-02-08 16:50
Category: Gentoo
Tags: dhcp, dhcpcd, Gentoo
Slug: have-dhcpcd-wait-before-backgrounding

Many of my systems use DHCP for obtaining IP addresses. Even though they
all receive a static IP address, it allows me to have them moved over
(migrations), use TFTP boot, cloning (in case of quick testing), etc.
But one of the things that was making my efforts somewhat more difficult
was that the `dhcpcd` service continued (the `dhcpcd` daemon immediately
went in the background) even though no IP address was received yet.
Subsequent service scripts that required a working network connection
failed to start then.

The solution is to configure `dhcpcd` to wait for an IP address. This is
done through the `-w` option, or the `waitip` instruction in the
`dhcpcd.conf` file. With that in place, the service script now waits
until an IP address is assigned.
