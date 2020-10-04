Title: Dynamic transitions in SELinux
Date: 2012-07-22 21:11
Category: SELinux
Slug: dynamic-transitions-in-selinux

In between talks on heap spraying techniques and visualization of data
for fast analysis, I'm working on integrating the chromium SELinux
policy that was offered in bug [bug
\#412637](https://bugs.gentoo.org/show_bug.cgi?id=412637) within Gentoo
Hardened. If you take a look at the bug, you notice I'm not really fond
of the policy because it uses *dynamic transitions*. That's not
something the policy writer can do anything about if he can't access the
source code of the application though, since it means that the
application is SELinux aware and will trigger transitions when needed.

So what's this dynamic transitioning? Well, in short, it means that a
process can decide to switch domains whenever it pleases (hence the
dynamic part) instead of doing this on fork/exec's. Generally, that
sounds like a flexible feature - and it is. But it's also dangerous.

Dynamic transitions might seem like a way to enhance security - the
application knows it will start a "dangerous" or more risky piece of
code, and thus transitions towards another domain with less privileges.
Once the dangerous code is passed, it transitions back to the main
domain. The problem with this is that the entire process is still live -
anything that happened within the transitioned domain remains, and
SELinux cannot prevent what happens within the domain itself (like
memory accesses within the same process space). If the more risky code
resulted in corruption or modification of memory, this remains
regardless of the SELinux context transitioning back or not. Assume that
some code is "injected" in the transitioned domain (which isn't allowed
to execute other applications) the moment it transitions back to the
main domain which is allowed to execute applications, this injected code
can become active and do its thing.

This is why I didn't allow the original code (which ran chromium in the
main user domain and used dynamic transitions towards
`chromium_renderer_t`) to be used, asking to confine the browser itself
within its own domain too (`chromium_t`) so that we have a more clear
view on the allowed privileges (which is the set of the chromium domain
and the renderer domain together). It is that policy that I'm now
enhancing to work on a fully confined system (no unconfined domains).

If you want to know more about dynamic transitions, it seems that the
blog post [Subject & Object Tranquility, part
2](http://beyondabstraction.net/2005/11/07/subject-object-tranquility-part-2/)
(and don't forget to read the comments too) is a fine read.
