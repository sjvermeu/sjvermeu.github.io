Title: Loading CIL modules directly
Date: 2015-07-15 15:54
Category: SELinux
Tags: cil, selinux
Slug: loading-cil-modules-directly

In a [previous
post](http://blog.siphos.be/2015/06/where-does-cil-play-in-the-selinux-system/)
I used the `secilc` binary to load an additional test policy. Little did
I know (and that's actually embarrassing because it was one of the
things I complained about) that you can just use the CIL policy as
modules directly.

<!-- PELICAN_END_SUMMMARY -->

With this I mean that a CIL policy as mentioned in the previous post can
be loaded like a prebuilt `.pp` module:

    ~# semodule -i test.cil
    ~# semodule -l | grep test
    test

That's all that is to it. Loading the module resulted in the test port
to be immediately declared and available:

    ~# semanage port -l | grep test
    test_port_t                    tcp      1440

In hindsight, it makes sense that it is this easy. After all, support
for the old-style policy language is done by converting it into CIL when
calling `semodule` so it makes sense to immediately put the module (in
CIL code) ready to be taken up.
