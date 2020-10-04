Title: Using multiple priorities with modules
Date: 2014-10-31 18:24
Category: SELinux
Tags: priorities, priority, selinux, semodule
Slug: using-multiple-priorities-with-modules

One of the new features of the 2.4 SELinux userspace is support for
module priorities. The idea is that distributions and administrators can
override a (pre)loaded SELinux policy module with another module without
removing the previous module. This lower-version module will remain in
the store, but will not be active until the higher-priority module is
disabled or removed again.

The "old" modules (pre-2.4) are loaded with priority 100. When policy
modules with the 2.4 SELinux userspace series are loaded, they get
loaded with priority 400. As a result, the following message occurs:

    ~# semodule -i screen.pp
    libsemanage.semanage_direct_install_info: Overriding screen module at lower priority 100 with module at priority 400

So unlike the previous situation, where the older module is substituted
with the new one, we now have two "screen" modules loaded; the last one
gets priority 400 and is active. To see all installed modules and
priorities, use the `--list-modules` option:

    ~# semodule --list-modules=all | grep screen
    100 screen     pp
    400 screen     pp

Older versions of modules can be removed by specifying the priority:

    ~# semodule -X 100 -r screen
