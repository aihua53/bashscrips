#!/bin/bash

# 检查文件夹是否存在
path="/sdcard/io_test"
if [ ! -d $path ]
then
    # 创建文件夹
    mkdir $path  
    echo "文件夹 /sdcard/io_tes 创建成功！"
# else
    # echo "文件夹 io_test 已经存在，无需创建。"
fi

# 获取当前日期和时间
DATETIME=$(date +"%Y_%m_%d_%H_%M_%S")

echo "记录磁盘mount信息"
mount  >$path/mount_$DATETIME.txt
echo "记录线程id"
ps -AT >$path/thread_$DATETIME.txt


#每三秒采样，记录分区的读写频率与IO吞吐量，采集100次（5分钟），关注最大值，平均值
echo "抓取iostat"
iostat 3 100 -x >$path/iostat_$DATETIME.txt&
#每三秒采样，记录的是线程的IO吞吐量，采集100次（5分钟），关注最大值，平均值
echo "抓取iotop"
iotop -d 3 -n 100 -s write -m 30 >$path/iotop_$DATETIME.txt&

p=0
while [ $p -le 100 ]
do
    echo "$p%"
    sleep 15
    p=$(( $p + 5 ))    #或者写作n=$(( $n + 1 ))
done
echo "done!"

