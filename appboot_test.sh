#!/bin/bash




i=4

while [ $i -lt 5 ]
do
    echo "$i"
    i=$(($i+1))
    am start -S -R 2 -W -n com.bilibili.bilithings/com.bilibili.bilithings.homepage.HomeV2Activity
    sleep(3)

done

