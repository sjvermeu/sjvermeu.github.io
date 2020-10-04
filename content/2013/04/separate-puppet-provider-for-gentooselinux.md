Title: Separate puppet provider for Gentoo/SELinux?
Date: 2013-04-07 19:22
Category: Gentoo
Tags: Gentoo, openrc, provider, puppet, selinux
Slug: separate-puppet-provider-for-gentooselinux

While slowly transitioning my playground infrastructure towards Puppet,
I already am in process of creating a custom provider for things such as
services. Puppet uses providers as "implementations" for the functions
Puppet needs. For instance, for the *service* type (which handles init
script services), there are providers for RedHat, Debian, FreeBSD, ...
and it also has providers called *gentoo* and *openrc*. The *openrc* one
uses the service scripts that Gentoo's OpenRC provides, such as
**rc-service** and **rc-status**.

On a SELinux-enabled system, and especially when using a decentralized
Puppet environment (I dropped the puppet master set in favor of a
decentralized usage of Puppet), if you call **rc-service** to, say,
start a service, it will ask for the users' password. Of course, Puppet
doesn't want this, so I have to prefix the commands with **run\_init**
and have a `pam_rootok.so` rule in run\_init's PAM definition.

So far that's a simple change - I just patched the `openrc.rb` file to
do so. But then the second problem I'm facing is that Puppet wants to
use return code based commands for checking the run-time state of
services. Even though some of my services weren't running, Puppet either
thought they were or called the start routine and consider the service
started. Sadly that wasn't the case, as the rc-\* scripts always return
0 (you'll need to parse the output).

So what I did now is to create a simple script called `runstatus` which
returns the state of services. It's crude, but seems to work:

    #!/bin/sh

    SERVICENAME=$1;

    # We need to exit:
    # 0 - if running
    # 1 - if dead but PID exists
    # 2 - if dead but lock file exists
    # 3 - if not running
    # 4 - if unknown

    rc-status -a -C | grep ${SERVICENAME} | grep -q started && exit 0;
    rc-status -a -C | grep ${SERVICENAME} | grep -q stopped && exit 3;
    exit 4;

I then have the service provider (I now provide my own instead of
patching the openrc one) call **runstatus** to get the state of a
service, as well as call it after trying to start a service. But as this
is quite basic functioning, I'm wondering if I'm doing things the right
way or not. Who else has experience with Puppet and Gentoo, and did you
have to tweak things to get services and such working?
