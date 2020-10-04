Title: Hacking java bytecode with dhex
Date: 2013-06-01 03:50
Category: Misc
Tags: bytecode, dhex, java
Slug: hacking-java-bytecode-with-dhex

I found myself in a weird situation: a long long time ago, I wrote a
java application that I didn't touch nor ran for a few years. Today, I
found it on a backup and wanted to run it again (its a graphical
application for generating HTML pages). However, it failed in a
particular feature. Not with an exception or stack trace, just
functionally. Now, I have the source code at hand, so I look into the
code and find the logical error. Below is a snippet of it:

    if (myHandler != null) {
      int i = startValue + maxRange;
      for (int j = endValue; j > i; j--) {
        ... (do some logic)
      }
    }

It doesn't matter what the code is supposed to do, but from what I can
remember, I shouldn't be adding `maxRange` to the `i` variable (yet - as
I do that later in the code). But instead of setting up the java
development environment, emerging the IDE etc. I decided to just edit
the class file directly using **dhex** (a wonderful utility I recently
discovered) because doing things the hard way is sometimes fun as well.
So I ran **javap -c MyClass** to get some java bytecode information from
the method, which gives me:

       8:   ifnull  116
       11:  iload_2
       12:  iload_3
       13:  iadd
       14:  istore  5
       16:  iload_2
       17:  istore  6
       19:  iload   6
       21:  iload   5
       23:  if_icmpge       106

I know lines 11 and 12 is about pushing the 2nd and 3rd arguments of the
function (which are `startValue` and `maxRange`) to the stack to add
them (line 13). To remove the third argument, I can change this opcode
from `1d` (iload\_3) to `03` (iconst\_0). This way, zero is added and
the code itself just continues as needed. And for some reason, that
seems to be the only mistake I made then because the application now
works flawlessly.

Hacking is fun.
