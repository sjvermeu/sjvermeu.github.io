Title: Switching context depending on user code-wise
Date: 2014-01-12 22:43
Category: SELinux
Tags: default_context, domain, libselinux, selinux, selinux-aware, transition
Slug: switching-context-depending-on-user-code-wise

I blogged about how SELinux decides what the context should be for a
particular Linux user; how it checks the default context(s) and tells
the SELinux-aware application on what the new context should be. Let's
look into the C code that does so, and how an application should behave
depending on the enforcing/permissive mode...

I use the following, extremely simple C that fork()'s and executes
`id -Z`:

```
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdarg.h>

#define DEBUG  7
#define INFO   6
#define NOTICE 5
#define WARN   4
#define ERR    3
#define CRIT   2
#define ALERT  1
#define EMERG  0

#ifndef LOGLEVEL
#define LOGLEVEL 4
#endif

/* out - Simple output */
void out(int level, char * msg, ...) {
  if (level <= LOGLEVEL) {
    va_list ap;
    printf("%d - ", level);

    va_start(ap, msg);
    vprintf(msg, ap);
    va_end(ap);
  };
};
int main(int argc, char * argv[]) {
  int rc = 0;
  pid_t child;

  child = fork();
  if (child < 0) {
    out(WARN, "fork() failed\n", NULL);
  };

  if (child == 0) {
    int pidrc;
    pidrc = execl("/usr/bin/id", "id", "-Z", NULL);
    if (pidrc != 0) {
      out(WARN, "Command failed with return code %d\n", pidrc);
    };
    return(0);
  } else {
    int status;
    out(DEBUG, "Child is %d\n", child);
    wait(&status);
    out(DEBUG, "Child exited with %d\n", status);
  };
  return 0;
};
```

The code is ran as follows:

    ~$ test myusername
    staff_u:staff_r:staff_t

As you can see, it shows the output of the `id -Z` command. Let's
enhance this code with some SELinux specific functions. The purpose of
the application now is to ask SELinux what the context should be that
the command should run in, and switch to that context for the `id -Z`
invocation.

We will include the necessary SELinux code with `#ifdef SELINUX`,
allowing the application to be build without SELinux code if wanted.

First, add in the proper `#include` directives.

```
#ifdef SELINUX
#include <selinux/selinux.h>
#include <selinux/flask.h>
#include <selinux/av_permissions.h>
#include <selinux/get_context_list.h>
#endif
```

Next, we create a function called *selinux\_prepare\_fork()* which takes
one input variable: the Linux user name for which we are going to
transition (and thus run `id -Z` for). This function can always be
called, even if SELinux is not built in. If that happens, we return 0
immediately.

```
/* selinux_prepare_fork - Initialize context switching
 *
 * Returns
 *  - 0 if everything is OK, 
 *  - +1 if the code should continue, even if SELinux wouldn't allow
 *       (for instance due to permissive mode)
 *  - -1 if the code should not continue
 */
int selinux_prepare_fork(char * name) {
#ifndef SELINUX
  return 0;
#else
  // ... this is where the remainder goes
#endif
};
```

We include this call in the application above, and take into account the
return codes passed on. As can be seen from the comment, if the
returncode is 0 (zero) then everything can go on as expected. A positive
return code means that there are some issues, but the application should
continue with its logic as SELinux is either in permissive, or the
domain in which the application runs is permissive - in either case, the
code will succeed. A returncode of -1 means that the code will most
likely fail and thus the application should log an error and exit or
break.

```
  pid_t child;

  rc = selinux_prepare_fork(argv[1]);
  if (rc < 0) {
    out(WARN, "The necessary context change will fail.\n");
    // Continuing here would mean that the newly started process
    // runs in the wrong context (current context) which might
    // be either too privileged, or not privileged enough.
    return -1;
  } else if (rc > 0) {
    out(WARN, "The necessary context change will fail, but permissive mode is active.\n");
  };

  child = fork();
```

Now all we need to do is fill in the logic in *selinux\_prepare\_fork*.
Let's start with the variable declarations (boring stuff):

```
#ifndef SELINUX
  return 0;
#else
  security_context_t newcon = 0;
  security_context_t curcon = 0;
  struct av_decision avd;
  int rc;
  int permissive = 0;
  int dom_permissive = 0;

  char * sename = 0;
  char * selevel = 0;
```

With that out of the way, let's take our first step: we want to see if
SELinux is enabled or not. Applications that are SELinux-aware should
always check if SELinux itself is enabled and, if not, just continue
with the (application) logic.

```
  /*
   * See if SELinux is enabled.
   * If not, then we can immediately tell the code
   * that everything is OK.
   */
  rc = is_selinux_enabled();
  if (rc == 0) {
    out(DEBUG, "SELinux is not enabled.\n");
    return 0;
  } else if (rc == -1) {
    out(WARN, "Could not check SELinux state (is_selinux_enabled() failed)\n");
    return 1;
  };
  out(DEBUG, "SELinux is enabled.\n");
```

As you can see, we use *is\_selinux\_enabled* here to do just that. If
it returns 0, then it is not enabled. A returncode of 1 means it is
enabled, and -1 means something wicked happened. I recommend that
applications who are SELinux-aware enable info on these matters in
debugging output. Nothing is more annoying than having to debug
permission issues that might be SELinux-related, but are not enforced
through SELinux (and as such do not show up in any logs).

Next, see if SELinux is in permissive mode and register this (as we need
this later for deciding to continue or not).

```
  /*
   * See if SELinux is in enforcing mode
   * or permissive mode
   */
  rc = security_getenforce();
  if (rc == 0) {
    permissive = 1;
  } else if (rc == 1) {
    permissive = 0;
  } else {
    out(WARN, "Could not check SELinux mode (security_getenforce() failed)\n");
  }
  out(DEBUG, "SELinux mode is %s\n", permissive ? "permissive" : "enforcing");
```

The *security\_getenforce* method will check the current SELinux mode
(enforcing or permissive). If SELinux is in permissive mode, then the
application logic should always go through - even if that means contexts
will go wrong and such. The end user marked the system in permissive
mode, meaning he does not want to have SELinux (or SELinux-aware
applications) to block things purely due to SELinux decisions, but log
when things are going wrong (for instance for policy development).

Now, let's look up what the current context is (the context that the
process is running in). This will be used later for logging by the
SELinux-aware application in debugging mode. Often, applications that
fail run too short to find out if their context is correct or not, and
having it logged definitely helps. This step is not mandatory per se (as
you will see from the code later).

```
  /*
   * Get the current SELinux context of the process.
   * Always interesting to log this for end users
   * trying to debug a possible issue.
   */
  rc = getcon(&curcon);
  if (rc) {
    out(WARN, "Could not get current SELinux context (getcon() failed)\n");
    if (permissive)
      return +1;
    else
      return -1;
  };
  out(DEBUG, "Currently in SELinux context \"%s\"\n", (char *) curcon);
```

The *getcon()* method places the current context in the *curcon*
variable. Note that from this point onwards, we should always
*freecon()* the context before exiting the *selinux\_prepare\_fork()*
method.

A second important note is that, if we have a failure, we now check the
permissive state and return a positive error (SELinux is in permissive
mode, so log but continue) or negative error (SELinux is in enforcing
mode). The negative error is needed so that the code itself does not go
run the *fork()* as it will fail anyway (or, it might succeed, but run
in the parent context which is not what the application should do).

Next, we try to find out what the SELinux user is for the given Linux
account name.

```
  /*
   * Get the SELinux user given the Linux user
   * name passed on to this function.
   */
  rc = getseuserbyname(name, &sename, &selevel);
  if (rc) {
    out(WARN, "Could not find SELinux user for Linux user \"%s\" (getseuserbyname() failed)\n", name);
    freecon(curcon);
    if (permissive)
      return +1;
    else
      return -1;
  };
  out(DEBUG, "SELinux user for Linux user \"%s\" is \"%s\"\n", name, sename);
```

The *getseuserbyname()* method returns the SELinux name for the given
Linux user. It also returns the MLS level (but we're not going to use
that in the remainder of the code). Again, if it fails, we check the
permissive state to see how to bail out.

Now get the context to which we should transition when calling `id -Z`:

```
  /*
   * Find out what the context is that this process should transition
   * to.
   */
  rc = get_default_context(sename, NULL, &newcon);
  if (rc) {
    out(WARN, "Could not deduce default context for SELinux user \"%s\" given our current context (\"%s\")\n", sename, (char *) curcon);
    freecon(curcon);
    if (permissive)
      return +1;
    else
      return -1;
  };
  out(DEBUG, "SELinux context to transition to is \"%s\"\n", (char *) newcon);
```

The *get\_default\_context()* will do what I blogged about earlier.
It'll check what the contexts are in the user-specific context files or
the `default_contexts` file, given the current context. You might notice
I don't pass on this context - the `NULL` second argument means "use the
current context". This is why the *getcon()* method earlier is not
strictly needed. But again, for logging (and thus debugging) this is
very much recommended.

From this point onward, we also need to *freecon()* the `newcon`
variable before exiting the function.

Now let's see if we are allowed to transition. We will query the SELinux
policy and see if a transition from the current context to the new
context is allowed (class `process`, privilege `transition`). I know, to
truly see if a transition is allowed, more steps should be checked, but
let's stick with this one permission.

```
  /*
   * Now let's look if we are allowed to transition to the new context.
   * We currently only check the transition access for the process class. However,
   * transitioning is a bit more complex (execute rights on target context, 
   * entrypoint of that context for the new domain, no constraints like target
   * domain not being a valid one, MLS constraints, etc.).
   */
  rc = security_compute_av_flags(curcon, newcon, SECCLASS_PROCESS, PROCESS__TRANSITION, &avd);
  if (rc) {
    out(WARN, "Could not deduce rights for transitioning \"%s\" -> \"%s\" (security_compute_av_flags() failed)\n", (char *) curcon, (char *) newcon);
    freecon(curcon);
    freecon(newcon);
    if (permissive)
      return +1;
    else
      return -1;
  };
```

In the above code, I didn't yet check the result. This is done in two
steps.

In the first step, I want to know if the current context is a permissive
domain. Since a few years, SELinux supports permissive domains, so that
a single domain is permissive even though the rest of the system is in
enforcing mode. Currently, we only know if the system is in permissive
mode or not.

```
  /* Validate the response 
   *
   * We are interested in two things:
   * - Is the transition allowed, but also
   * - Is the permissive flag set
   *
   * If the permissive flag is set, then we
   * know the current domain is permissive
   * (even if the rest of the system is in
   * enforcing mode).
   */
  if (avd.flags & SELINUX_AVD_FLAGS_PERMISSIVE) {
    out(DEBUG, "The SELINUX_AVD_FLAGS_PERMISSIVE flag is set, so domain is permissive.\n");
    dom_permissive = 1;
  };
```

We check the flags provided to us by the SELinux subsystem and check if
`SELINUX_AVD_FLAGS_PERMISSIVE` is set. If it is, then the current domain
is permissive, and we register this (in the `dom_permissive` variable).
From this point onwards, `permissive=1` or `dom_permissive=1` is enough
to tell the real application logic to continue (even if things would
fail SELinux-wise) - the actions are executed by a permissive domain (or
system) and thus should continue.

```
  if (!(avd.allowed & PROCESS__TRANSITION)) {
    // The transition is denied
    if (permissive) {
      out(DEBUG, "Transition is not allowed by SELinux, but permissive mode is enabled. Continuing.\n");
    };
    if (dom_permissive) {
      out(DEBUG, "Transition is not allowed by SELinux, but domain is in permissive mode. Continuing.\n");
    };
    if ((permissive == 0) && (dom_permissive == 0)) {
      out(WARN, "The domain transition is not allowed and we are not in permissive mode.\n");
      freecon(curcon);
      freecon(newcon);
      return -1;
    };
  };
```

In the second step, we checked if the requested operation (transition)
is allowed or not. If denied, we log it, but do not break out of the
function if either `permissive` (SELinux permissive mode) or
`dom_permissive` (domain is permissive) is set.

Finally, we set the (new) context, telling the SELinux subsystem that
the next *exec()* done by the application should also switch the domain
of the process to the new context (i.e. a domain transition):

```
  /*
   * Set the context for the fork (process execution).
   */
  rc = setexeccon(newcon);
  if (rc) {
    out(WARN, "Could not set execution context (setexeccon() failed)\n");
    freecon(curcon);
    freecon(newcon);
    if ((permissive) || (dom_permissive))
      return +1;
    else
      return -1;
  };

  freecon(newcon);
  freecon(curcon);

  return 0;
#endif
```

That's it - we free'd all our variables and can now have the application
continue (taking into account the return code of this function). As
mentioned before, a positive return code (0 or higher) means the logic
should continue; a strictly negative return code means that the
application should gracefully fail.
