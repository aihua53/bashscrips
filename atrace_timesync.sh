#!/bin/bash
cd /proc
echo m > sysrq-trigger
dmesg|grep Show >/sdcard/timesync.txt
logcat -b kernel|grep Show >>/sdcard/timesync.txt