#!/bin/bash
ps -Leo pid,lwp,user,pcpu,pmem,cmd >> /tmp/pthreads.log
echo "ps -Leo pid,lwp,user,pcpu,pmem,cmd >> /tmp/pthreads.log" >> /tmp/pthreads.log
echo `date` >> /tmp/pthreads.log
echo 1
pid=`ps aux|grep tomcat|grep cwh|awk -F ' ' '{print $2}'`
echo 2
echo "pstack $pid >> /tmp/pstack.log" >> /tmp/pstack.log
pstack $pid >> /tmp/pstack.log
echo `date` >> /tmp/pstack.log
echo 3
echo "lsof >> /tmp/sys-o-files.log" >> /tmp/sys-o-files.log
lsof >> /tmp/sys-o-files.log
echo `date` >> /tmp/sys-o-files.log
echo 4
echo "lsof -p $pid >> /tmp/service-o-files.log" >> /tmp/service-o-files.log
lsof -p $pid >> /tmp/service-o-files.log
echo `date` >> /tmp/service-o-files.log
echo 5
echo "jstack -l $pid  >> /tmp/js.log" >> /tmp/js.log
jstack -l -F $pid  >> /tmp/js.log
echo `date` >> /tmp/js.log
echo 6
echo "free -m >> /tmp/free.log" >> /tmp/free.log
free -m >> /tmp/free.log
echo `date` >> /tmp/free.log
echo 7
echo "vmstat 2 1 >> /tmp/vm.log" >> /tmp/vm.log
vmstat 2 1 >> /tmp/vm.log
echo `date` >> /tmp/vm.log
echo 8
echo "jmap -dump:format=b,file=/tmp/heap.hprof $pid" >> /tmp/jmap.log
jmap -dump:format=b,file=/tmp/heap.hprof $pid >> /tmp/jmap.log
echo `date` >> /tmp/jmap.log
echo 9
echo end