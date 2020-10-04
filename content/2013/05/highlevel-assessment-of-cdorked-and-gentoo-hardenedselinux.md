Title: Highlevel assessment of Cdorked and Gentoo Hardened/SELinux
Date: 2013-05-14 03:50
Category: Security
Tags: apache, cdorked, Gentoo, hardened, ima, selinux
Slug: highlevel-assessment-of-cdorked-and-gentoo-hardenedselinux

With all the
[reports](http://www.welivesecurity.com/2013/05/07/linuxcdorked-malware-lighttpd-and-nginx-web-servers-also-affected/)
surrounding
[Cdorked](https://threatpost.com/attack-using-backdoored-apache-binaries-to-lead-to-blackhole-kit/),
I took a look at if SELinux and/or other Gentoo Hardened technologies
could reduce the likelihood that this infection occurs on your system.

First of all, we don't know yet how the malware gets installed on the
server. We do know that the Apache binaries themselves are modified, so
the first thing to look at is to see if this risk can be reduced. Of
course, using an intrusion detection system like
[AIDE](https://wiki.gentoo.org/wiki/AIDE) helps, but even with Gentoo's
**qcheck** command you can test the integrity of the files:

    # qcheck www-servers/apache
    Checking www-servers/apache-2.2.24 ...
      * 424 out of 424 files are good

If the binary is modified, this would result in something equivalent to:

    Checking www-servers/apache-2.2.24 ...
     MD5-DIGEST: /usr/sbin/apache2
      * 423 out of 424 files are good

I don't know if the modified binary would otherwise work just fine, I
have not been able to find exact details on the infected binary to (in a
sandbox environment of course) analyze this further. Also, because we
don't know how they are installed, it is not easy to know if binaries
that you built yourself are equally likely to be modified/substituted or
if the attack checks checksums of the binaries against a known list.

Assuming that it would run, then the infecting malware would need to set
the proper SELinux context on the file (if it overwrites the existing
binary, then the context is retained, otherwise it gets the default
context of `bin_t`). If the context is wrong, then starting Apache
results in:

    apache2: Syntax error on line 61 of /etc/apache2/httpd.conf: Cannot load /usr/lib64/apache2/modules/mod_actions.so into server: /usr/lib64/apache2/modules/mod_actions.so: cannot open shared object file: Permission denied

This is because the modified binary stays in the calling domain context
(`initrc_t`). If you use a targeted policy, then this will not present
itself as `initrc_t` is an unconfined domain. But with strict policies,
`initrc_t` is not allowed to read `httpd_modules_t`. Even worse, the
remainder of SELinux protections don't apply anymore, since with
unconfined domains, all bets are off. That is why Gentoo focuses this
hard on using a strict policy.

So, what if the binary runs in the proper domain? Well then, from the
articles I read, the malware can do a reverse connect. That means that
the domain will attempt to connect to an IP address provided by the
attacker (in a specifically crafted URL). For SELinux, this means that
the *name\_connect* permission is checked:

    # sesearch -s httpd_t -c tcp_socket -p name_connect -ACTS
    Found 20 semantic av rules:
       allow nsswitch_domain dns_port_t : tcp_socket { name_connect } ; 
    DT allow httpd_t port_type : tcp_socket { name_connect } ; [ httpd_can_network_connect ]
    DT allow httpd_t ftp_port_t : tcp_socket { name_connect } ; [ httpd_can_network_relay ]
    DT allow httpd_t smtp_port_t : tcp_socket { name_connect } ; [ httpd_can_sendmail ]
    DT allow httpd_t postgresql_port_t : tcp_socket { name_connect } ; [ httpd_can_network_connect_db ]
    DT allow httpd_t oracledb_port_t : tcp_socket { name_connect } ; [ httpd_can_network_connect_db ]
    DT allow httpd_t squid_port_t : tcp_socket { name_connect } ; [ httpd_can_network_relay ]
    DT allow httpd_t mssql_port_t : tcp_socket { name_connect } ; [ httpd_can_network_connect_db ]
    DT allow httpd_t kerberos_port_t : tcp_socket { name_connect } ; [ allow_kerberos ]
    DT allow nsswitch_domain ldap_port_t : tcp_socket { name_connect } ; [ authlogin_nsswitch_use_ldap ]
    DT allow httpd_t http_cache_port_t : tcp_socket { name_connect } ; [ httpd_can_network_relay ]
    DT allow httpd_t http_port_t : tcp_socket { name_connect } ; [ httpd_can_network_relay ]
    DT allow httpd_t http_port_t : tcp_socket { name_connect } ; [ httpd_graceful_shutdown ]
    DT allow httpd_t mysqld_port_t : tcp_socket { name_connect } ; [ httpd_can_network_connect_db ]
    DT allow httpd_t ocsp_port_t : tcp_socket { name_connect } ; [ allow_kerberos ]
    DT allow nsswitch_domain kerberos_port_t : tcp_socket { name_connect } ; [ allow_kerberos ]
    DT allow httpd_t pop_port_t : tcp_socket { name_connect } ; [ httpd_can_sendmail ]
    DT allow nsswitch_domain ocsp_port_t : tcp_socket { name_connect } ; [ allow_kerberos ]
    DT allow httpd_t gds_db_port_t : tcp_socket { name_connect } ; [ httpd_can_network_connect_db ]
    DT allow httpd_t gopher_port_t : tcp_socket { name_connect } ; [ httpd_can_network_relay ]

So by default, the Apache (`httpd_t`) domain is allowed to connect to
DNS port (to resolve hostnames). All other *name\_connect* calls depend
on SELinux booleans (mentioned after it) that are by default disabled
(at least on Gentoo). Disabling hostname resolving is not really
feasible, so if the attacker uses a DNS port as port that the malware
needs to connect to, SELinux will not deny it (unless you use additional
networking constraints).

Now, the reverse connect is an interesting feature of the malware, but
not the main one. The main focus of the malware is to redirect customers
to particular sites that can trick the user in downloading additional
(client) malware. Because this is done internally within Apache, SELinux
cannot deal with this. As a user, make sure you configure your browser
not to trust non-local iframes and such (always do this, not just
because there is a possible threat right now). The configuration of
Cdorked is a shared memory segment of Apache itself. Of course, since
Apache uses shared memory, the malware embedded within will also have
access to the shared memory. However, if this shared memory would need
to be accessed by third party applications (the malware seems to grant
read/write rights on everybody to this segment) SELinux will prevent
this:

    # sesearch -t httpd_t -c shm -ACTS
    Found 2 semantic av rules:
       allow unconfined_domain_type domain : shm { create destroy getattr setattr read write associate unix_read unix_write lock } ; 
       allow httpd_t httpd_t : shm { create destroy getattr setattr read write associate unix_read unix_write lock } ; 

Only unconfined domains and the `httpd_t` domain itself have access to
`httpd_t` labeled shared memory.

So what about IMA/EVM? Well, those will not help here since IMA checks
for integrity of files that were modified *offline*. As the modification
of the Apache binaries is most likely done online, IMA would just accept
this.

For now, it seems that a good system integrity approach is the most
effective until we know more about how the malware-infected binary is
written to the system in the first place (as this is better protected by
MAC controls like SELinux).
