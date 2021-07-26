#! /system/bin/sh

cat /dev/ttyUSB3 & 
while true
do
echo -en "at+qtemp\r\n" > /dev/ttyUSB3
sleep 2s
done
