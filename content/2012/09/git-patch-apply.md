Title: git patch apply
Date: 2012-09-27 20:45
Category: Documentation
Slug: git-patch-apply

I recently had to merge the changes made to an upstream project with a
local repository. I took out the changes as patches through
**`git format-patch`** (as the local repository isn't a clone of the
remote one so I couldn't just create a branch and merge) and hoped to
apply them with **`git am`**. Sadly, trying this resulted in an error
equivalent with:

` error: test.txt: does not match index`

Git suggested to fix the index, and then continue with
**`git am --resolved`**. But what the ... does it mean with fixing the
index? Basically, it means that the change needs to be recorded by git
in order to be applied, but why does the patch fail to recognize this?
The `test.txt` file exists and is known by git.

After some searching, I found a way to handle this - it might not be
pretty, but it did the trick, and I succesfully merged about 200 commits
in an hour or so. You can see this post as a "backup" for my memory ;-)

First of all, I tried to apply the patch using
**`git am 0001-some-stuff.patch`**. If it succeeds, continue. If it
doesn't, apply the patch manually using
**`patch < 0001-some-stuff.patch`**. Then make sure that the changed
files (see **`git status`**) are taking part of the commit (use
**`git add`**). When the changes are made and recorded, run
**`git am --resolved`**. Or if you want to discard it, make sure no
changes are made/recorded and run **`git am --skip`**.

That's it. Some scripting made this a whole lot easier. Check the return
code of **`git am`**. If it is zero, continue with the next patch. If it
isn't, run patch and again check for the return code. If it is zero,
remove all `*.orig` files (or change the patch command so it doesn't
write orig files), add all (changed) files to the git index and run
**`git am --resolved`**. And if the patch fails, have the user fix
things manually and continue.
