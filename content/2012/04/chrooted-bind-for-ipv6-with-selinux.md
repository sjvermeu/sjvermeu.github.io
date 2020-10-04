Title: Chrooted BIND for IPv6 with SELinux
Date: 2012-04-14 23:08
Category: Gentoo
Slug: chrooted-bind-for-ipv6-with-selinux

BIND, or Berkeley Internet Name Domain, is one of the Internet's most
popular domain name service software (DNS). It has seen its set of
security flaws in the past, which is not that strange as it is such a
frequently used service on the Internet. In this post, I'll give a quick
intro on how to use it in Gentoo Hardened (with PaX)... chrooted... for
IPv6... with SELinux ;-)

Installing is of course, as usual, dead easy on Gentoo
(Hardened/SELinux). Make sure you have USE="ipv6" set, and then **emerge
bind**. Also install **bind-tools** as they contain some great tools to
help with DNS troubleshooting. Then we're editing /etc/conf.d/named to
set the CHROOT variable. I also set CHROOT\_NOMOUNT so that Gentoo
doesn't bind-mount the information in the chroot but instead uses the
files in the chroot.

    CHROOT="/var/named/chroot"
    CHROOT_NOMOUNT="1"

Now we need to either temporarily add some privileges in SELinux, or run
the portage\_t domain in permissive mode. If you go for privileges, then
add the following:

    allow portage_t var_t:chr_file { create getattr setattr };

If you however want to temporarily run the portage\_t domain in
permissive mode, do that as follows:

    ~# semanage permissive -a portage_t

We are doing this because we are now going to ask the BIND ebuild to
prepare the chroot for us. Doing so however requires portage to work on
our live file system (and not in the regular "sandbox" mode). SELinux
however forces portage in the portage\_t domain and only gives it the
privileges it needs for building and installing software.

    ~# emerge --config bind

When done, remove the previous SELinux allow rules again (or set the
portage\_t domain back in enforcing mode, through **semanage permissive
-d portage\_t**). Next we need to relabel the files in the chroot. By
default, all files are labeled by SELinux as var\_t in that location
because it isn't aware that it needs to see /var/named/chroot as a
"root" location.

    ~# setfiles -r /var/named/chroot /etc/selinux/strict/contexts/files/file_contexts /var/named/chroot

So far so good. Now let's create a simple named.conf file (in
/var/named/chroot/etc/bind):

    options {
      directory "/var/bind";
      pid-file "/var/run/named/named.pid";
      statistics-file "/var/run/named/named.stats";
      listen-on { 127.0.0.1; };
      listen-on-v6 { 2001:db8:81:21::ac:98ad:5fe1; };
      allow-query { any; };
      zone-statistics yes;
      allow-transfer { 2001:db8:81:22::ae:6b01:e3d8; };
      notify yes;
      recursion no;
      version "[nope]";
    };

    # Access to DNS for local addresses (i.e. genfic-owned)
    view "local" {
      match-clients { 2001:db8:81::/48; };
      recursion yes;
      zone "genfic.com" { type master; file "pri/com.genfic"; };
      zone "1.8.0.0.8.b.d.0.1.0.0.2.ip6.arpa" { type master; file "pri/inv.com.genfic"; };
    };

The zone files referenced in the configuration file are located in
/var/named/chroot/var/bind (in a subdirectory called pri - which I use
for "primary"). The regular one would look similar to this:

    $TTL 1h ;
    $ORIGIN genfic.com.
    @       IN      SOA     ns.genfic.com. ns.genfic.com. (
                            2012041101
                            1d      
                            2h
                            4w
                            1h )

            IN      NS      ns.genfic.com.
            IN      NS      ns2.genfic.com.
            IN      MX      10      mail.genfic.com.
            IN      MX      20      mail2.genfic.com.

    genfic.com.     IN      AAAA    2001:db8:81:80::dd:13ed:c49e;
    ns              IN      AAAA    2001:db8:81:21::ac:98ad:5fe1;
    ns2             IN      AAAA    2001:db8:81:22::ae:6b01:e3d8;
    www             IN      CNAME   genfic.com.;
    mail            IN      AAAA    2001:db8:81:21::b0:0738:8ad5;
    mail2           IN      AAAA    2001:db8:81:22::50:5e9f:e569;
    ; (...)

while the one for reverse lookups looks like so:

    $TTL 1h ;
    @       IN      SOA     1.8.0.0.8.b.d.0.1.0.0.2.ip6.arpa ns.genfic.com. (
                            2012041101
                            1d
                            2h
                            4w
                            1h )

            IN      NS      ns.genfic.com.
            IN      NS      ns2.genfic.com.

    $ORIGIN 1.8.0.0.8.b.d.0.1.0.0.2.ip6.arpa.

    1.e.f.5.d.a.8.9.c.a.0.0.0.0.0.0.1.2.0.0         IN      PTR     ns.genfic.com.
    8.d.3.e.1.0.b.6.e.a.0.0.0.0.0.0.2.2.0.0         IN      PTR     ns2.genfic.com.
    ; (...)

We can now start the init script:

    ~# rc-service named start

On the slave, don't set the allow-transfer directive and set its type to
"slave". In each zone, you will need to tell where the master is:

    zone "genfic.com" {
      type slave;
      masters { 2001:db8:81:21::ac:98ad:5fe1; }
      file "sec/com.genfic";
    };

By default, the SELinux policy for BIND does not allow BIND to write
stuff in its directories. On the slave system, you will need to change
this. A SELinux boolean here does the trick:

    ~# setsebool -P named_write_master_zones on;

There ya go ;-) Okay, all very condensely written, but it should give
some feedback on how to proceed. I'm adding this information to the new
online resource I'm writing - [A Gentoo Linux Advanced Reference
Architecture](http://swift.siphos.be/aglara). Nothing really ready yet,
just writing as I go forward with exploring these technologies...
