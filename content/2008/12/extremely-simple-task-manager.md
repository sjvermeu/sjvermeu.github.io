Title: Extremely simple task manager
Date: 2008-12-18 22:46
Category: Misc
Slug: extremely-simple-task-manager

At work, I am often busy with quite a few projects. Yet, at times, I
have no outstanding tasks because all of my tasks can only start when an
event has occurred (like a server which is made available, or a budget
that is approved) or another task has finished.

To keep track of my work, I write an extremely simple task manager: an
XML file (for the data), XSL file (for the rendering) and HTML/CSS file
(to render and use the browsers' XSL capabilities). I call it
[taskviewer](http://swift.siphos.be/tools-taskviewer.html) due to lack
of more imagination ;-)

It is a simple manager with no user interface for managing it at all -
so you'll need to edit the XML file yourself. However, the HTML/CSS
file, together with the XSL file, renders the content of the XML file in
such a way that you have a nice overview of your tasks.

It's "features" are simple:

-   keep track of events you are waiting for
-   keep track of a tasks' dependencies (events or other tasks)
-   get an overview of tasks that can immediately start versus that are
    blocked, waiting for its dependencies to finish

There is an [example available
online](http://swift.siphos.be/tools/taskviewer/taskviewer.html) with
some hypothetical data.

If you know of a simple program (preferably java or one available for
both Windows and Linux) that has similar features (especially tracking
tasks depending on certain events), please do tell me. I've looked at
tools like [taskjuggler](http://www.taskjuggler.org) but couldn't find
one that remains simple yet has these features.
