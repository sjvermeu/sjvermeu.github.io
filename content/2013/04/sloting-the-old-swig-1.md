Title: SLOT'ing the old swig-1
Date: 2013-04-23 03:50
Category: Gentoo
Tags: Gentoo, selinux, setools, slot, swig
Slug: sloting-the-old-swig-1

The [SWIG](http://www.swig.org) tool helps developers in building
interfaces/libraries that can be accessed from many other languages than
the ones the library is initially written in or for. The SELinux
userland utility [setools](http://oss.tresys.com/projects/setools) uses
it to provide Python and Ruby interfaces even though the application
itself is written in C. Sadly, the tool currently requires swig-1 for
its building of the interfaces and uses constructs that do not seem to
be compatible with swig-2 (same with the apse package, btw).

I first tried to [patch
setools](http://comments.gmane.org/gmane.comp.security.selinux/17822) to
support swig-2, but eventually found regressions in the libapol library
it provides so the patch didn't work out (that is why some users
mentioned that a previous setools version did build with swig - yes it
did, but the result wasn't correct). Recently, a [post on Google Plus'
SELinux
community](https://plus.google.com/117641514179258643044/posts/gNrhVDuwGzp)
showed me that I wasn't wrong in this matter (it really does require
swig-1 and doesn't seem to be trivial to fix).

Hence, I have to fix the [gentoo build
problem](https://bugs.gentoo.org/show_bug.cgi?id=453512) where one set
of tools requires swig-1 and another swig-2. Otherwise world-updates and
even building stages for SELinux systems would fail as Portage finds
incompatible dependencies. One way to approach this is to use Gentoo's
support for
[SLOTs](http://devmanual.gentoo.org/general-concepts/slotting/). When a
package (ebuild) in Gentoo defines a SLOT, it tells the package manager
that the same package but a different version might be installed
alongside the package if that has a different SLOT version. In case of
swig, the idea is to give swig-1 a different slot than swig-2 (which
uses `SLOT="0"`) and make sure that both do not install the same files
(otherwise you get file collisions).

Luckily, swig places all of its files except for the **swig** binary
itself in `/usr/share/swig/<version>`, so all I had left to do was to
make sure the binary itself is renamed. I chose to use **swig1.3**
(similar as to how tools like **ruby** and **python** and for some
packages even **java** is implemented on Gentoo). The result (through
[bug 466650](https://bugs.gentoo.org/show_bug.cgi?id=466650)) is now in
the tree, as well as an adapted setools package that uses the new swig
SLOT.

Thanks to Samuli Suominen for getting me on the (hopefully ;-) right
track. I don't know why I was afraid of doing this, it was much less
complex than I thought (now let's hope I didn't break other things ;-)
