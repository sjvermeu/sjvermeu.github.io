Title: Comparing performance with sysbench: performance analysis
Date: 2013-04-19 16:22
Category: Free-Software
Tags: performance, sysbench
Slug: comparing-performance-with-sysbench-part-3

So in the past few posts I discussed how **sysbench** can be used to
simulate some workloads, specific to a particular set of tasks. I used
the benchmark application to look at the differences between the guest
and host on my main laptop, and saw a major performance regression with
the *memory* workload test. Let's view this again, using parameters more
optimized to view the regressions:

    $ sysbench --test=memory --memory-total-size=32M --memory-block-size=64 run
    Host:
      Operations performed: 524288 (2988653.44 ops/sec)
      32.00 MB transferred (182.41 MB/sec)

    Guest:
      Operations performed: 524288 (24920.74 ops/sec)
      32.00 MB transferred (1.52 MB/sec)

    $ sysbench --test=memory --memory-total-size=32M --memory-block-size=32M run
    Host:
      Operations performed: 1 (  116.36 ops/sec)
      32.00 MB transferred (3723.36 MB/sec)

    Guest:
      Operations performed: 1 (   89.27 ops/sec)
      32.00 MB transferred (2856.77 MB/sec)

From looking at the code (gotta love Gentoo for making this obvious ;-)
we know that the memory workload, with a single thread, does something
like the following:

    total_bytes = 0;
    repeat until total_bytes >= memory-total-size:
      thread_mutex_lock()
      total_bytes += memory-block-size
      thread_mutex_unlock()
      
      (start event timer)
      pointer -> buffer;
      while pointer <-> end-of(buffer)
        write somevalue at pointer
        pointer++
      (stop event timer)

Given that the regression is most noticeable when the memory-block-size
is very small, the part of the code whose execution count is much
different between the two runs is the mutex locking, global memory
increment and the start/stop of event timer.

In a second phase, we also saw that mutex locking itself is not
impacted. In the above case, we have 524288 executions. However, if we
run the mutex workload this number of times, we see that this hardly has
any effect:

    $ sysbench --test=mutex --mutex-num=1 --mutex-locks=524288 --mutex-loops=0 run
    Host:      total time:        0.0275s
    Guest:     total time:        0.0286s

The code for the mutex workload, knowing that we run with one thread,
looks like this:

    mutex_locks = 524288
    (start event timer)
    do
      lock = get_mutex()
      thread_mutex_lock()
      global_var++
      thread_mutex_unlock()
      mutex_locks--
    until mutex_locks = 0;
    (stop event timer)

To check if the timer might be the culprit, let's look for a benchmark
that mainly does timer checks. The *cpu* workload can be used, when we
tell sysbench that the prime to check is 3 (as its internal loop runs
from 3 till the given number, and when the given number is 3 it skips
the loop completely) and we ask for 524288 executions.

    $ sysbench --test=cpu --cpu-max-prime=3 --max-requests=524288 run
    Host:  total time:  0.1640s
    Guest: total time: 21.0306s

Gotcha! Now, the event timer (again from looking at the code) contains
two parts: getting the current time (using `clock_gettime()`) and
logging the start/stop (which is done in memory structures). Let's make
a small test application that gets the current time (using the real-time
clock as the sysbench application does) and see if we get similar
results:

    $ cat test.c
    #include <stdio.h>
    #include <time.h>

    int main(int argc, char **argv, char **arge) {
      struct timespec tps;
      long int i = 524288;
      while (i-- > 0)
        clock_gettime(CLOCK_REALTIME, &tps);
    }

    $ gcc -lrt -o test test.c
    $ time ./test
    Host:  0m0.019s
    Guest: 0m5.030s

So given that the `clock_gettime()` is ran twice in the sysbench, we
already have 10 seconds of overhead on the guest (and only 0,04s on the
host). When such time-related functions are slow, it is wise to take a
look at the clock source configured on the system. On Linux, you can
check this by looking at `/sys/devices/system/clocksource/*`.

    # cd /sys/devices/system/clocksource/clocksource0
    # cat current_clocksource
    kvm-clock
    # cat available_clocksource
    kvm-clock tsc hpet acpi_pm

Although kvm-clock is supposed to be the best clock source, let's switch
to the tsc clock:

    # echo tsc > current_clocksource

If we rerun our test application, we get a much more appreciative
result:

    $ time ./test
    Host:  0m0.019s
    Guest: 0m0.024s

So, what does that mean for our previous benchmark results?

    $ sysbench --test=cpu --cpu-max-prime=20000 run
    Host:            35,3049 sec
    Guest (before):  36,5582 sec
    Guest (now):     35,6416 sec

    $ sysbench --test=fileio --file-total-size=6G --file-test-mode=rndrw --max-time=300 --max-requests=0 --file-extra-flags=direct run
    Host:            1,8424 MB/sec
    Guest (before):  1,5591 MB/sec
    Guest (now):     1,5912 MB/sec

    $ sysbench --test=memory --memory-block-size=1M --memory-total-size=10G run
    Host:            3959,78 MB/sec
    Guest (before)   3079,29 MB/sec
    Guest (now):     3821,89 MB/sec

    $ sysbench --test=threads --num-threads=128 --max-time=10s run
    Host:            9765 executions
    Guest (before):   512 executions
    Guest (now):      529 executions

So we notice that this small change has nice effects on some of the
tests. The CPU benchmark improves from 3,55% overhead to 0,95%; fileio
is the same (from 15,38% to 13,63%), memory improves from 22,24%
overhead to 3,48% and threads remains about status quo (from 94,76%
slower to 94,58%).

That doesn't mean that the VM is now suddenly faster or better than
before - what we changed was how fast a certain time measurement takes,
which the benchmark software itself uses rigorously. This goes to show
how important it is to

1.  understand fully how the benchmark software works and measures
2.  realize the importance of access to source code is not to be
    misunderstood
3.  know that performance benchmarks give figures, but do not tell you
    how your users will experience the system

That's it for the sysbench benchmark for now (the MySQL part will need
to wait until a later stage).
