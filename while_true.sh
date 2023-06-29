#!/bin/bash

deadloop() {
    while true; do
	   # echo "tony"
    done
}

i=4

while [ $i -lt 5 ]
do
    echo "$i"
    i=$(($i+1))
    deadloop &
done

wait
