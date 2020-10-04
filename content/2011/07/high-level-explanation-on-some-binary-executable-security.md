Title: High level explanation on some binary executable security
Date: 2011-07-15 22:01
Category: Security
Slug: high-level-explanation-on-some-binary-executable-security

One very important functionality offered by [Gentoo
Hardened](http://hardened.gentoo.org) is a specific toolchain (compiler,
libraries and more) that contains patches to make the built binaries a
bit more protected from certain vulnerabilities. Explaining all those in
detail is too much for a simple blog post like this, but some time ago
the friendly folks of the Gentoo Hardened project told be about a script
called [checksec.sh](http://www.trapkit.de/tools/checksec.html) that
displays a few of those protections on a binary.

So what can I find out of such a run? Let me show you the output on two
binaries here:

    ~$ checksec.sh --file /opt/skype/skype
    RELRO           STACK CANARY      NX            PIE                     FILE
    No RELRO        Canary found      NX disabled   No PIE                  /opt/skype/skype

    ~$ checksec.sh --file /bin/bash
    RELRO           STACK CANARY      NX            PIE                     FILE
    Full RELRO      Canary found      NX enabled    PIE enabled             /bin/bash

It even comes with pretty colors (the "No RELRO" is red whereas "Full
RELRO" is green). But beyond interpreting those colors (which should be
obvious for the non-colorblind), what does that all mean? Well, let me
try to explain them in one-paragraph entries (yes, I like such
challenges ;-) Note that, if a protection is not found, then it probably
means that the application was not built with this protection (the skype
example, since this is a binary from Skype\^WMicrosoft, versus bash
which is built by the Gentoo Hardened toolchain).

**RELRO** stands for *Relocation Read-Only*, meaning that the headers in
your binary, which need to be writable during startup of the application
(to allow the dynamic linker to load and link stuff like shared
libraries) are marked as read-only when the linker is done doing its
magic (but before the application itself is launched). The difference
between **Partial RELRO** and **Full RELRO** is that the Global Offset
Table (and Procedure Linkage Table) which act as kind-of
process-specific lookup tables for symbols (names that need to point to
locations elsewhere in the application or even in loaded shared
libraries) are marked read-only too in the **Full RELRO**. Downside of
this is that lazy binding (only resolving those symbols the first time
you hit them, making applications start a bit faster) is not possible
anymore.

A **Canary** is a certain value put on the stack (memory where function
local variables are also stored) and validated before that function is
left again. Leaving a function means that the "previous" address (i.e.
the location in the application right before the function was called) is
retrieved from this stack and jumped to (well, the part right after that
address - we do not want an endless loop do we?). If the **canary**
value is not correct, then the stack might have been overwritten /
corrupted (for instance by writing more stuff in the local variable than
allowed - called *buffer overflow*) so the application is immediately
stopped.

The abbreviation **NX** stands for non-execute or non-executable
segment. It means that the application, when loaded in memory, does not
allow any of its segments to be both writable and executable. The idea
here is that writable memory should never be executed (as it can be
manipulated) and vice versa. Having **NX enabled** would be good.

The last abbreviation is **PIE**, meaning *Position Independent
Executable*. A **No PIE** application tells the loader which virtual
address it should use (and keeps its memory layout quite static). Hence,
attacks against this application know up-front how the virtual memory
for this application is (partially) organized. Combined with in-kernel
ASLR (*Address Space Layout Randomization*, which Gentoo's
hardened-sources of course support) PIE applications have a more diverge
memory organization, making attacks that rely on the memory structure
more difficult.

But hold on, the checksec.sh application also supports detection for
`FORTIFY_SOURCE`:

    ~$ checksec.sh --fortify-file /opt/skype/skype
     * FORTIFY_SOURCE support available (libc)    : Yes
    * Binary compiled with FORTIFY_SOURCE support: Yes

     ------ EXECUTABLE-FILE ------- . -------- LIBC --------
     FORTIFY-able library functions | Checked function names
     -------------------------------------------------------
     printf                         | __printf_chk
    ...
    SUMMARY:

    * Number of checked functions in libc                : 75
    * Total number of library functions in the executable: 2468
    * Number of FORTIFY-able functions in the executable : 25
    * Number of checked functions in the executable      : 0
    * Number of unchecked functions in the executable    : 25

In the given example, my system does support `FORTIFY_SOURCE` and the
binary is supposedly built with this support as well, but the checks
return that out of the 25 functions identified as `FORTIFY`-able, none
of them were successfully verified as using a `FORTIFY`-ed library call.
It goes without saying that for the /bin/bash binary, this yielded a bit
more good results (12 out of 30 verified).

Again, what is **FORTIFY\_SOURCE**? Well, when using `FORTIFY_SOURCE`,
the compiler will try to intelligently read the code it is compiling /
building. When it sees a C-library function call against a variable
whose size it can deduce (like a fixed-size array - it is more
intelligent than this btw) it will replace the call with a `FORTIFY`'ed
function call, passing on the maximum size for the variable. If this
special function call notices that the variable is being overwritten
beyond its boundaries, it forces the application to quit immediately.
Note that not all function calls that can be fortified are fortified as
that depends on the intelligence of the compiler (and if it is realistic
to get the maximum size).

If you do not agree with the explanation above, please comment... and
try to explain it in a single paragraph without going too detailed (i.e.
do not assume people are capable of writing their own compiler just for
fun).
