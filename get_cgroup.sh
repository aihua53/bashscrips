# cd /sdcard
# mkdir cgroup
# cd ..
# mkdir $1
# cd ..

echo "help info:"
echo "sh /system/bin/get_cgroup.sh name"
echo "file saved in /sdcard/cgroup/name"
echo "wait 30s, it will auto exit after 30s"

path="/sdcard/cgroup/"$1
mkdir -p $path

path_cpuset=$path/cpuset.txt
echo background >> $path_cpuset
cat /dev/cpuset/background/cpus >> $path_cpuset
echo top-app >> $path_cpuset
cat /dev/cpuset/top-app/cpus >> $path_cpuset
echo foreground >> $path_cpuset
cat /dev/cpuset/foreground/cpus >> $path_cpuset
echo vip-app >> $path_cpuset
cat /dev/cpuset/vip-app/cpus >> $path_cpuset
echo system-background >> $path_cpuset
cat /dev/cpuset/system-background/cpus >> $path_cpuset
echo camera-daemon >> $path_cpuset
cat /dev/cpuset/camera-daemon/cpus >> $path_cpuset

ps -eT > $path/thread.txt
ps -e > $path/process.txt

cat /dev/cpuset/background/cgroup.procs > $path/bg_procs.txt
cat /dev/cpuset/background/tasks > $path/bg_tasks.txt

cat /dev/cpuset/top-app/cgroup.procs > $path/top_procs.txt
cat /dev/cpuset/top-app/tasks > $path/top_tasks.txt

cat /dev/cpuset/foreground/cgroup.procs > $path/fg_procs.txt
cat /dev/cpuset/foreground/tasks > $path/fg_tasks.txt

cat /dev/cpuset/vip-app/cgroup.procs > $path/vip_procs.txt
cat /dev/cpuset/vip-app/tasks > $path/vip_tasks.txt

cat /dev/cpuset/system-background/cgroup.procs > $path/sys_bg_procs.txt
cat /dev/cpuset/system-background/tasks  > $path/sys_bg_tasks.txt

cat /dev/cpuset/camera-daemon/cgroup.procs > $path/camera-daemon_procs.txt
cat /dev/cpuset/camera-daemon/tasks  > $path/camera-daemon_tasks.txt

top -d 30 -m 30 -n 2 > $path/top.txt