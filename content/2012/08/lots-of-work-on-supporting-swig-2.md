Title: Lots of work on supporting swig-2
Date: 2012-08-20 20:50
Category: SELinux
Slug: lots-of-work-on-supporting-swig-2

The SELinux [setools](http://oss.tresys.com/projects/setools/)
[package](http://packages.gentoo.org/package/app-admin/setools) provides
a few of the commands I used the most when working with SELinux:
**sesearch** for looking through the policy and **seinfo** to get
information on type/attribute/role/... from the currently loaded policy.

This package uses [swig](http://www.swig.org/), the Simplified (sic)
Wrapper and Interface Generator to provide libraries that can be loaded
by Python and used as regular Python modules, based on the C code that
setools uses. Or, in other words: you write C code, and swig transforms
it into libraries that can be loaded by a dozen higher generation
languages such as Python.

The change from swig-1 to swig-2 however broke the setools build. It
seems that the swig interface code that setools uses doesn't work
properly anymore with more recent swig versions. The last few days (yes,
days) I have been trying to get setools to build again. The fixes that I
put in were not extremely difficult, but very labour-intensive (beyond
the point that I think I'm doing things wrong, but hey - this is my
first time I'm working on swig stuff, and I'm glad I already got it to
build again).

The first thing I had to do was fix constructor/destructor logic. It
looks like swig-1 supported the C shorthand notation for structures
whereas swig-2 sees the name of the structure as its class (note that I
just got it to build, I still need to see if things still work):

      typedef struct apol_ip {...} apol_ip_t;
      %extend apol_ip_t {
    -   apol_ip_t(const char * str) {
    +   apol_ip(const char * str) {
      ...
    -   ~apol_ip_t() {
    +   ~apol_ip() {
      ...
    }

Without this, I got "Illegal destructor" errors (not related to the
illegal destructor fix made to swig itself) and "Method apol\_ip\_t
requires a return type" (because it doesn't see them as constructors).

The second fix I had to introduce was to rename all functions that swig
would generate which would then have the same name as the C-function.
For instance, suppose a C function in the code has
`apol_vector_get_size` then swig would, for the `apol_vector` class with
method `get_size` in the swig interface, generate a function called
`apol_vector_get_size` which of course collides with the already defined
function, giving an error like "Conflicting types for
apol\_vector\_get\_size" followed by a "previous declaration was here:".

Swig supports the `%rename` method for this, so I had to do:

      typedef struct apol_vector {} apol_vector_t;
    + %rename(apol_vector_get_size) apol_vector_wrap_get_size;
    + %rename(apol_vector_get_capacity) apol_vector_wrap_get_capacity;
    ...
    - size_t get_size() {
    + size_t wrap_get_size() {
    ...
    - size_t get_capacity() {
    + size_t wrap_get_capacity() {

The patch that I had to add to finally get it to build again is 7019
lines (229 Kbyte). Too much manual labour. Now let's hope this really
fixes things, and doesn't just masquerade the build failures but
introduces runtime failures. Of course, if I think it works, I'll send
it upstream so that, if it is indeed the right fix, other developers
don't have to go through this...
