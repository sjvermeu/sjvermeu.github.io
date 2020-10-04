Title: A simple IPv6 setup
Date: 2013-05-20 03:50
Category: Documentation
Tags: dhcpcd, dnsmasq, ip6, ipv6, ra
Slug: a-simple-ipv6-setup

For internal communication between guests on my workstation, I use IPv6
which is set up using the *Router Advertisement* "feature" of IPv6. The
tools I use are [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
for DNS/DHCP and router advertisement support, and
[dhcpcd](http://roy.marples.name/projects/dhcpcd) as client. It might be
a total mess (grew almost organically until it worked), but as far as
I'm concerned, it is working... and that is all that matters (for now).
I'll have to look deeper into the IPv6 stuff to understand it all better
though.

On the client side, **dhcpcd** is ran with the following options:

    dhcpcd_eth0="-t 5 -L --ipv6ra_own"

I had to enable `--ipv6ra_own` to get it to obtain its global address,
otherwise it only got its link local one (`fe80::` something). I also
added a hook into `/lib/dhcpcd/dhcpcd-hooks` to get it to trigger a
hostname update for IPv6.

    $ cat 28-set-ip6-address 
    if $ifup; then export new_ip_address=${ra1_prefix%%/64}; fi

SELinux-policy wise, I had to enable `dhcpc_t` to write to the hostname
proc file and set the system hostname. The first one (21) is needed
because of the `--ipv6ra_own` parameter.

    # selocal -l | grep dhcpc_t
    21: allow dhcpc_t self:rawip_socket create_socket_perms; # dhcpclient
    22: kernel_rw_kernel_sysctl(dhcpc_t) # set hostname
    23: allow dhcpc_t self:capability sys_admin; # set hostname

Finally, in `/etc/dhcpcd.conf`, I removed the *nohook lookup-hostname*
and set the *force\_hostname* one:

    #nohook lookup-hostname
    env force_hostname=YES

On the server side, I use the following configuration of dnsmasq
(snippet):

    dhcp-range=2001:db8:81:e2::,ra-only
    enable-ra
    dhcp-option=option6:dns-server,[2001:db8:81:e2::26b5:365b:5072]

As you can see, I use the documentation prefix for now (since it is
meant for internal communication only, and makes it easier to copy/paste
into documentation ;-) but when I am going to use full IPv6 access to
the Internet, this prefix will of course change.

Finally, I enabled IPv6 forwarding on the `tap0` interface because
otherwise I continuously got the following messages on the clients:

    May 12 18:43:07 test dhcpcd[3869]: eth0: adding default route via fe80::d848:19ff:fe0d:55c2
    May 12 18:43:07 test dhcpcd[3869]: eth0: fe80::d848:19ff:fe0d:55c2 is no longer a router
    May 12 18:43:07 test dhcpcd[3869]: eth0: deleting default route via fe80::d848:19ff:fe0d:55c2
    May 12 18:43:13 test dhcpcd[3869]: eth0: fe80::d848:19ff:fe0d:55c2 is unreachable, expiring it

To enable IPv6 forwarding, you can use sysctl but I added it in the
script that sets up the tap0 interface:

    tunctl -b -u swift -t tap0
    ifconfig tap0 add 2001:db8:81:e2::26b5:365b:5072/64
    vde_switch --numports 16 --mod 777 --group users --tap tap0 -d
    echo 1 > /proc/sys/net/ipv6/conf/tap0/forwarding
