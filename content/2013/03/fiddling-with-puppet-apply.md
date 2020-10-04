Title: Fiddling with puppet apply
Date: 2013-03-20 12:31
Category: Gentoo
Tags: provider, puppet, selinux, service
Slug: fiddling-with-puppet-apply

As part of a larger exercise, I am switching my local VM set from a
more-or-less scripted manual configuration towards a fully
Puppet-powered one. Of course, it still uses a lot of custom modules and
is most likely too ugly to expose to the wider internet, but it does
seem to improve my ability to quickly rebuild images if I corrupt them
somehow.

One of the tricks I am using is to use a local apply instead of using a
Puppet master server - mainly because that master server is again a VM
that might need to be build up and consumes some resources that I'd
rather have free for other VMs. So what I do now is akin to the
following:

    ~# puppet apply --modulepath /mnt/puppet/modules /mnt/puppet/manifests/site.pp

All I have to do is make sure that the /mnt/puppet location is a shared
resource (in my case, an NFSv4 read-only mount) which I can just mount
on a fresh image.

Part of this exercise I noticed that Puppet by default uses the regular
*gentoo* provider for the services. I'd like to use the *openrc*
provider instead, as I can easily tweak that one to work with SELinux (I
need to prepend **run\_init** to the **rc-service** calls, otherwise
SELinux wants to authenticate the user and Puppet doesn't like that; I
have a pam\_rootok.so statement in the run\_init PAM file to allow
unattended calls towards rc-service).

A quick Google revealed that all I had to do was to add a *provider
=&gt; openrc* in the service definitions, like so:

    service { "net.eth0":
      provider => openrc,
      ensure => running,
    }

As mentioned, I still manually patch the openrc provider (located in
/usr/lib64/ruby/site\_ruby/1.9.1/puppet/provider/service) so that the
run\_init command is known as well, and that all invocations of the
rc-service is prepended with run\_init:

    ...
      commands :runinit => '/usr/sbin/run_init'
      commands :rcservice => '/sbin/rc-service'
    ...
     [command(:runinit), command(:rcservice), @resource[:name], :start ]

And the same for the stop and status definitions. I might use Portage'
postinst hook to automatically apply the patch so I don't need to do
this manually each time.
