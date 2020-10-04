Title: Comparing performance with sysbench: cpu and fileio
Date: 2013-04-18 21:31
Category: Free Software
Tags: cpu, hypervisor, io, kvm, performance, sysbench
Slug: comparing-performance-with-sysbench

Being busy with virtualization and additional security measures, I
frequently come in contact with people asking me what the performance
impact is. Now, you won't find the performance impact of SELinux here as
I have no guests nor hosts that run without SELinux. But I did want to
find out what one can do to compare system (and later application)
performance, so I decided to take a look at the various benchmark
utilities available. In this first post, I'll take a look at
[sysbench](http://sysbench.sf.net) (using 0.4.12, released on March 2009
- unlike what you would think from the looks of the site alone) to
compare the performance of my KVM guest versus host.

The obligatory system information: the host is a HP Pavilion dv7 3160eb
with an Intel Core i5-430M processor (dual-core with 2 threads per
core). Frequency scaling is disabled - the CPU is fixed at 2.13 Ghz. The
system has 4Gb of memory (DDR3), the internal hard disks are configured
as a software RAID1 and with LVM on top (except for the file system that
hosts the virtual guest images, which is a plain software RAID1). The
guests run with the boot options given below, meaning 1.5Gb of memory, 2
virtual CPUs of the KVM64 type. The CFLAGS for both are given below as
well, together with the expanded set given by **gcc \${CFLAGS} -E -v -
</dev>&1 | grep cc1**.

    /usr/bin/qemu-kvm -monitor stdio -nographic -gdb tcp::1301   
     -vnc 127.0.0.1:14   
     -net nic,model=virtio,macaddr=00:11:22:33:44:b3,vlan=0   
     -net vde,vlan=0   
     -drive file=/srv/virt/gentoo/test/pg1.img,if=virtio,cache=none   
     -k nl-be -m 1536 -cpu kvm64 -smp 2

    # For host
    CFLAGS="-march=core2 -O2 -pipe"
    #CFLAGS="-D_FORTIFY_SOURCE=2 -fno-strict-overflow -march=core2   
            -fPIE -O2 -fstack-protector-all"
    # For guest
    CFLAGS="-march=x86-64 -O2 -pipe"
    #CFLAGS="-fno-strict-overflow -march=x86-64 -fPIE -O2   
            -fstack-protector-all"

I am aware that the CFLAGS between the two are not the same (duh), and I
know as well that the expansion given above isn't entirely accurate. But
still, it gives some idea on the differences.

Now before I go on to the results, please keep in mind that I am *not a
performance expert*, not even a *performance experienced* or even
*performance wanna-be experienced* person: the more I learn about the
inner workings of an operating system such as Linux, the more complex it
becomes. And when you throw in additional layers such as virtualization,
I'm almost completely lost. In my day-job, some people think they can
"prove" the inefficiency of a hypervisor by counting from 1 to 100'000
and adding the numbers, and then take a look at how long this takes. I
think this is short-sighted, as this puts load on a system that does not
simulate reality. If you really want to do performance measures for
particular workloads, you need to run those workloads and not some small
script you hacked up. That is why I tend to focus on applications that
use workload simulations for infrastructural performance measurements
(like [HammerDB](http://hammerora.sf.net) for performance testing
databases). But for this blog post series, I'm first going to start with
basic operations and later posts will go into more detail for particular
workloads (such as database performance measurements).

Oh, and BTW, when I display figures with a comma (","), that comma means
decimal (so "1,00" = "1").

The figures below are numbers that can be interpreted in many ways, and
can prove everything. I'll sometimes give my interpretation to it, but
don't expect to learn much from it - there are probably much better
guides out there for this. The posts are more of a way to describe how
**sysbench** works and what you should take into account when doing
performance benchmarks.

So the testing is done using **sysbench**, which is capable of running
CPU, I/O, memory, threading, mutex and MySQL tests. The first run of it
that I did was a single-thread run for CPU performance testing.

    $ sysbench --test=cpu --cpu-max-prime=20000 run

This test verifies prime numbers by dividing the number with
sequentially increasing numbers and verifying that the remainder (modulo
calculation) is zero. If it is, then the number is not prime and the
calculation goes on to the next number; otherwise, if none have a
remainder of 0, then the number is prime. The maximum number that it
divides by is calculated by taking the integer part of the square root
of the number (so for 17, this is 4). This algorithm is very simple, so
you should also take into account that during the compilation of the
benchmark, the compiler might already have optimized some of it.

Let's look at the numbers.

    Run     Stat     Host      Guest
    1.1    total   35,4331   37,0528
         e.total   35,4312   36,8917
    1.2    total   35,1482   36,1951
         e.total   35,1462   36,0405
    1.3    total   35,3334   36,4266
         e.total   35,3314   36,2640
    ================================
    avg    total   35,3049   36,5582
         e.total   35,3029   36,3987
    med    total   35,3334   36,4266
         e.total   35,3314   36,2640

On average (I did three runs on each system), the guest took 3,55% more
time to finish the test than the host (`total`). If we look at the pure
calculation (so not the remaining overhead of the inner workings -
`e.total`) then the guest took 3,10% more time. The median however (the
run that wasn't the fastest nor the slowest of the three) has the guest
taking 3,09% more time (total) and 2,64% more time (e.total).

Let's look at the two-thread results.

    Run     Stat     Host      Guest
    1.1    total   17,5185   18,0905
         e.total   35,0296   36,0217
    1.2    total   17,8084   18,1070
         e.total   35,6131   36,0518
    1.3    total   18,0683   18,0921
         e.total   36,1322   36,0194
    ================================
    avg    total   17,5185   18,0965
         e.total   35,0296   36,0310
    med    total   17,8084   18,0921
         e.total   35,6131   36,0194

With these figures, we notice that the guest average total run time
takes 1,67% more time to complete, and the event time only 1,23%. I was
personally expecting that the guest would have a higher percentage than
previously (gut feeling - never trust it when dealing with complex
matter) but was happy to see that the difference wasn't higher. I'm not
going to start analyze this in more detail and just go to the next test:
fileio.

In case of fileio testing, I assume that the hypervisor will take up
[more overhead](http://www.linux-kvm.org/page/Virtio/Block/Latency), but
keep in mind that you also need to consider the environmental factors:
LVM or not, RAID1 or not, mount options, etc. Since I am comparing
guests versus hosts here, I should look for a somewhat comparable setup.
Hence, I will look for the performance of the host (software raid, LVM,
ext4 file system with data=ordered) and the guest (images on software
raid, ext4 file system with data=ordered and barrier=0, and LVM in
guest).

Furthermore, running a sysbench test suggests a file that is much larger
than the available RAM. I'm going to run the tests on a 6Gb file size,
but enable O\_DIRECT for writes so that some caches (page cache) are not
used. This can be done using *--file-extra-flags=direct*.

As with all I/O-related benchmarks, you need to define which kind of
load you want to test with. Are the I/Os sequential (like reading or
writing a large file completely) or random? For databases, you are most
likely interested in random reads (data, for selects) and sequential
writes (into transaction logs). A file server usually has random
read/write. In the below test, I'll use a combined **r**a**nd**om
**r**ead/**w**rite.

    $ sysbench --test=fileio --file-total-size=6G prepare
    $ sysbench --test=fileio --file-total-size=6G --file-test-mode=rndrw --max-time=300 --max-requests=0 --file-extra-flags=direct run
    $ sysbench --test=fileio --file-total-size=6G cleanup

In the output, the throughput seems to be most important:

    Operations performed:  4348 Read, 2898 Write, 9216 Other = 16462 Total
    Read 67.938Mb  Written 45.281Mb  Total transferred 113.22Mb  (1.8869Mb/sec)

In the above case, the throughput is 1,8869 Mbps. So let's look at the
(averaged) results:

    Host:  1,8424 Mbps
    Guest: 1,5591 Mbps

The above figures (which are an average of 3 runs) tell us that the
guest has a throughput of about 84,75% (so we take about 15% performance
hit on random read/write I/O). Now I used sysbench here for some I/O
validation of guest between host, but other usages apply as well. For
instance, let's look at the impact of `data=ordered` versus
`data=journal` (taken on the host):

    6G, data=ordered, barrier=1: 1,8435 Mbps
    6G, data=ordered, barrier=0: 2,1328 Mbps
    6G, data=journal, barrier=1: 599,85 Kbps
    6G, data=journal, barrier=0: 767,93 Kbps

From the figures, we can see that the `data=journal` option slows down
the throughput to a final figure about 30% of the original throughput
(70% decrease!). Also, disabling barriers has a positive impact on
performance, giving about 15% throughput gain. This is also why some
people report performance improvements when switching to LVM, as - as
far as I can tell (but finding a good source on this is difficult) - LVM
*by default* disables barriers (but does honor the `barrier=1` mount
option if you provide it).

That's about it for now - the next post will be about the memory and
threads tests within sysbench.
