Title: Comparing performance with sysbench: memory, threads and mutexes
Date: 2013-04-19 04:11
Category: Free Software
Tags: memory, mutex, performance, sysbench, threading, threads
Slug: comparing-performance-with-sysbench-part-2

In the previous post, I gave some feedback on the cpu and fileio
workload tests that [sysbench](http://sysbench.sf.net) can handle. Next
on the agenda are the *memory*, *threads* and *mutex* workloads.

When using the *memory* workload, **sysbench** will allocate a buffer
(provided through the *--memory-block-size* parameter, defaults to
1kbyte) and each execution will read or write to this memory
(*--memory-oper*, defaults to write) in a random or sequential manner
(*--memory-access-mode*, defaults to **seq**uential).

    $ sysbench --test=memory --memory-block-size=1M --memory-total-size=10G run
    Host throughput, 1M:  3959,78 MB/sec
    Guest throughput, 1M: 3079,29 MB/sec

The guest has a lower throughput (about 77% of the host), which is lower
than what most online posts provide on KVM performance. We'll get back
to that later. Let's look at the default block size of 1k (meaning that
the benchmark will do a lot more executions before it reaches the total
memory (in load):

    $ sysbench --test=memory --memory-total-size=1G run
    Host throughput, 1k:  1702,59 MB/sec
    Guest throughput, 1k:   23,67 MB/sec

This is a lot worse: the guest' throughput is only 1,4% of the host
throughput! The `qemu-kvm` process on the host is also taking up a lot
of CPU.

Now let's take a look at the other workload, *threads*. In this
particular workload, you identify the number of threads
(*--num-threads*), the number of locks (*--thread-locks*) and the number
of times a thread should run its 'lock-yield..unlock' workload
(*--thread-yields*). The more locks you identify, the less number of
threads will have the same lock (each thread is allocated a single lock
during an execution, but every new execution will give it a new lock so
the threads do not always take the same lock).

Note that parts of this is also handled by the other tests: mutex'es are
used when a new operation (execution) for the thread is prepared. In
case of the memory-related workload above, the smaller the buffer size,
the more frequent thread operations are needed. In the last run we did
(with the bad performance), millions of operations were executed
(although no yields were performed). Something similar can be simulated
using a single lock, single thread and a very high number of operations
and no yields:

    $ sysbench --test=threads --num-threads=1 --thread-yields=0 --max-requests=1000000 --thread-locks=1 run
    Host runtime:    0,3267 s  (event:    0,2278)
    Guest runtime:  40,7672 s  (event:   30,6084)

This means that the guest "throughput" problems from the memory
identified above seem to be related to this rather than memory-specific
regressions. To verify if the scheduler itself also shows regressions,
we can run more threads concurrently. For instance, running 128 threads
simultaneously, using the otherwise default settings, during 10 seconds:

    $ sysbench --test=threads --num-threads=128 --max-time=10s run
    Host:   9765 executions (events)
    Guest:   512 executions (events)

Here we get only 5% throughput.

Let's focus on the mutex again, as sysbench has an additional mutex
workload test. The workload has each thread running a local fast loop
(simple increments, *--mutex-loops*) after which it takes a random mutex
(one of *--mutex-num*), locks it, increments a global variable and then
releases the mutex again. This is repeated for the number of locks
identified (*--mutex-locks*). If mutex operations would be the cause of
the performance issues above, then we would notice that the mutex
operations are a major performance regression on my system.

Let's run that workload with a single thread (default), no loops and a
single mutex.

    $ sysbench --test=mutex --mutex-num=1 --mutex-locks=50000000 --mutex-loops=1 run
    Host (duration):   2600,57 ms
    Guest (duration):  2571,44 ms

In this example, we see that the mutex operations are almost at the same
speed (99%) of the host, so pure mutex operations are not likely to be
the cause of the performance regressions earlier on. So what does give
the performance problems? Well, that investigation will be for the third
and last post in this series ;-)
