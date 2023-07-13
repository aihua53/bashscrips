#!/system/bin/sh
TOP_CNT=15
KILL_AFTER_SECONEDS=5
BUSYBOX_DIR=/data/performance_bin/bbox_installed/
TOP_STRACE_CAPTURED_DIR=/log/Klog/performance_data/top_strace_captured/

#KEY_STR="tv_sec=0"
#nanosleep({tv_sec=10, tv_nsec=0}
KEY_STR="nanosleep"
if [[ $# == 0 ]];then
    echo "Error! not enough params, just exit!"
#    exit
else
    TOP_CNT=$1
    KILL_AFTER_SECONEDS=$2
    BUSYBOX_DIR=$3
    TOP_STRACE_CAPTURED_DIR=$4
fi

echo "param count:" $#
echo "top_CNT:" $TOP_CNT
echo "strace for seconds:" $KILL_AFTER_SECONEDS
echo "BUSYBOX_DIR:" $BUSYBOX_DIR
echo "TOP_STRACE_CAPTURED_DIR:" $TOP_STRACE_CAPTURED_DIR
#sleep 20

TOP_STATISTIC_FILE=$TOP_STRACE_CAPTURED_DIR/top_statistic.txt
TOP_PROCESSES_FILE=$TOP_STRACE_CAPTURED_DIR/top_processes.txt
STRACE_OUT_PIDDIR=$TOP_STRACE_CAPTURED_DIR/pidsdir
PSTREE_FILE=pstree.txt
STRACE_OUT_FILE=strace_out_file.txt
STRACE_FILE=strace.txt

rm -rf $TOP_STRACE_CAPTURED_DIR
mkdir -p $TOP_STRACE_CAPTURED_DIR

#top -m $TOP_CNT -n 1 | grep -v top > $TOP_STATISTIC_FILE
top -b -m $TOP_CNT -n 1 | grep -v top > $TOP_STATISTIC_FILE
cat $TOP_STATISTIC_FILE | awk '/^[ ]*[0-9]+[ ]/ {print $1}' > $TOP_PROCESSES_FILE

OLDIFS=$IFS
IFS=$'\n'

top_processes_array=($(cat $TOP_PROCESSES_FILE))
IFS=$OLDIFS

echo ${array[*]}
mkdir $STRACE_OUT_PIDDIR
cd $STRACE_OUT_PIDDIR
echo "pwd: " $PWD
for process in ${top_processes_array[@]}
    do
        echo $processls /
        mkdir $process
        cd $process
        echo "pwd:" $PWD
        pstree $process -p > $PSTREE_FILE
        #strace -f -p $process 2>&1 | grep tv_sec=0 | grep tv_nsec >> $STRACE_OUT_FILE & { sleep $KILL_AFTER_SECONEDS; }
        strace -f -p $process 2>&1 | grep -E $KEY_STR >> $STRACE_OUT_FILE & { sleep $KILL_AFTER_SECONEDS; }
        echo "stop current strace"
        ps -A|grep strace |grep -v grep|awk '{print $2}'|xargs kill
        sleep 2;
        cd ..
    done
