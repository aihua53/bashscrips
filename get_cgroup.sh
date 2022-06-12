cd /sdcard
mkdir cgroup
cd ..

ps -eT > /sdcard/cgroup/thread.txt
cat /dev/cpuset/background/cgroup.procs > /sdcard/cgroup/bg_procs.txt
cat /dev/cpuset/background/tasks > /sdcard/cgroup/bg_tasks.txt

cat /dev/cpuset/top-app/cgroup.procs > /sdcard/cgroup/top_procs.txt
cat /dev/cpuset/top-app/tasks > /sdcard/cgroup/top_tasks.txt

cat /dev/cpuset/foreground/cgroup.procs > /sdcard/cgroup/fg_procs.txt
cat /dev/cpuset/foreground/tasks > /sdcard/cgroup/fg_tasks.txt

cat /dev/cpuset/vip-app/cgroup.procs > /sdcard/cgroup/vip_procs.txt
cat /dev/cpuset/vip-app/tasks > /sdcard/cgroup/vip_tasks.txt

cat /dev/cpuset/system-background/cgroup.procs > /sdcard/cgroup/sys_bg_procs.txt
cat /dev/cpuset/system-background/tasks  > /sdcard/cgroup/sys_bg_tasks.txt
