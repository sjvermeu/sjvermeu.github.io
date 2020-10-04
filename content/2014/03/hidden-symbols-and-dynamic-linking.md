Title: Hidden symbols and dynamic linking
Date: 2014-03-24 21:14
Category: Gentoo
Tags: elf, hidden, selinux, symbols
Slug: hidden-symbols-and-dynamic-linking

A few weeks ago, we introduced an error in the (\~arch) `libselinux`
ebuild which caused the following stacktrace to occur every time the
**semanage** command was invoked:

    ~ # semanage
    Traceback (most recent call last):
      File "/usr/lib/python-exec/python2.7/semanage", line 27, in 
        import seobject
      File "/usr/lib64/python2.7/site-packages/seobject.py", line 27, in 
        import sepolicy
      File "/usr/lib64/python2.7/site-packages/sepolicy/__init__.py", line 11, in 
        import sepolgen.interfaces as interfaces
      File "/usr/lib64/python2.7/site-packages/sepolgen/interfaces.py", line 24, in 
        import access
      File "/usr/lib64/python2.7/site-packages/sepolgen/access.py", line 35, in 
        from selinux import audit2why
    ImportError: /usr/lib64/python2.7/site-packages/selinux/audit2why.so: undefined symbol: sepol_set_policydb

Usually this error means that a needed library (a `.so` file) is
missing, or is not part of the `/etc/ld.so.conf` list of directories to
scan. And when SELinux is enabled, you might want to check the
permissions of that file as well (who knows). But that wasn't the case
here. After trying to figure things out (which includes switching Python
versions, grepping for *sepol\_set\_policydb* in `libsepol.so` and more)
I looked at the `audit2why.c` code and see if/where
*sepol\_set\_policydb* is needed, as well as at the `libsepol` sources
to see where it is defined. And yes, the call is (of course) needed, but
the definition made me wonder if this wasn't a bug:

``` {lang="c"}
int hidden sepol_set_policydb(policydb_t * p)
{
        policydb = p;
        return 0;
}
```

Hidden? But, that means that the function symbol is not available for
dynamic linking... So if that is the case, shouldn't `audit2why.c` not
call it? Turns out, this was due to a fix we introduced earlier on,
where `libsepol` got linked dynamically instead of statically (i.e.
using `libsepol.a`). Static linking of libraries still allows for the
(hidden) symbols to be used, whereas dynamic linking doesn't.

So that part of the fix got reverted (and should fix the bug we
introduced), and I learned a bit more about symbols (and the *hidden*
statement).

Bonus: if you need to check what symbols are available in a binary /
shared library, use **nm**:

    ~$ nm -D /path/to/binary
