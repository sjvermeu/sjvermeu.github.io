Title: My application base: bash and kiss tools
Date: 2013-06-06 03:50
Category: Free Software
Tags: bash, dash, mab, scripting
Slug: my-application-base-bash-and-kiss-tools

Okay, this just had to be here. I'm an automation guy - partially
because of my job in which I'm responsible for the long-term strategy
behind batch, scheduling and workload automation, but also because I
believe proper automation makes life just that much easier. And for
personal work, why not automate the majority of stuff as well? For most
of the automation I use, I use bash scripts (or POSIX sh scripts that I
try out with the dash shell if I need to export the scripts to non-bash
users).

The [Bourne-Again
SHell](http://tiswww.case.edu/php/chet/bash/bashtop.html) (or **bash**)
is the default shell on Gentoo Linux systems, and is a powerful shell in
features as well. There are numerous resources available on bash
scripting, such as the [Advanced Bash-Scripting
Guide](http://tldp.org/LDP/abs/html/) or the
[commandlinefu.com](http://www.commandlinefu.com/commands/browse) (not
purely bash), and specific features of Bash have several posts and
articles all over the web.

Shell scripts are easy to write, but their power comes from the various
tools that a Linux system contains (including the often forgotten
GNU-provided ones, of which bash is one of them). My system is filled
with scripts, some small, some large, all with a specific function that
I imagined I would need to use again later. I prefix almost all my
scripts with `sw` (first letters of SwifT) or `mgl` (in case the scripts
have the potential to be used by others) so I can easily find them (if
they are within my `${PATH}` of course, not all of them are): just type
the first letters followed by two tabs and bash shows me the list of
scripts I have:

    $ sw\t\t
    swbackup               swdocbook2html      swsandboxfirefox    swletter      swpics
    swstartvm              swstripcomment      swvmconsole         swgenpdf      swcheckmistakes
    swdoctransaccuracy     swhardened-secmerge swmailman2mbox      swmassrename  swmassstable
    swmovepics             swbumpmod           swsecontribmerge    swseduplicate swfindbracket
    swmergeoverlay         swshowtree          swsetvid            swfileprocmon swlocalize
    swgendigest            swgenmkbase         swgenfinoverview    swmatchcve

    $ mgl\t\t
    mglshow                mglverify         mglgxml2docbook       mglautogenif  mgltellabout
    mgltellhowto           mgltellwhynot     mglgenmodoverview     mglgenoval    mglgensetup
    mglcertcli             mglcleannode      mglwaitforfile

With the proper basic template, I can keep the scripts sane and well
documented. None of the scripts execute something without arguments, and
"-h" and "--help" are always mapped to the help information. Those that
(re)move files often have a "-p" (or "--pretend") flag that instead of
executing the logic, echo's it to the screen.

A simple example is the swpics script. It mounts the SD card, moves the
images to a first location (`Pictures/local/raw`), unmounts the SD card,
renames the pictures based on the metadata information, finds duplicates
based on two checksums (in case I forgot to wipe the SD card afterwards
- I don't wipe it from the script) and removes the duplicates, converts
the raws into JPEGs and moves these to a minidlna-served location so I
can review the images from DLNA-compliant devices when I want and then
starts the Geeqie application. When the Geeqie application has finished,
it searches for the removed raws and removes those from the
minidlna-served location as well. It's simple, nothing fancy, and saves
me a few minutes of work every time.

The kiss tools are not really a toolset that is called kiss, but rather
a set of commands that are simple in their use. Examples are exiv2 (to
manage JPEG EXIF information, including renaming them based on the EXIF
timestamp), inotifywait (passive waiting for file modification/writes),
sipcalc (calculating IP addresses and subnetwork ranges), socat (network
socket "cat" tool), screen (or tmux, to implement virtual sessions), git
(okay, not that KISS, but perfect for what it does - versioning stuff)
and more. Because these applications just do what they are supposed to,
without too many bells and whistles, it makes it easy to "glue" them
together to get an automated flow.

Automation saves you from performing repetitive steps manually, so is a
real time-saver. And bash is a perfect scripting language for it.
