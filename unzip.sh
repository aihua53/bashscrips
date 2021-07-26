#!/bin/bash

echo "hello"
echo "path: $1"
cd $1 

while true
    do 
		ls *.zip > ls.log
        if test -s ./ls.log;then
            for i in $(cat ls.log)
                do  
                    if test -e $i;then
                        unzip $i > /dev/null
                        rm $i
                    else
                        echo "$i: no such file"
                        exit
                    fi
                done 
        else
            break
        fi
    done
rm ls.log

# egrep -rn "beginning|AppKiller"|egrep "datacollector|datacollection|vehicle|cpu:9|cpu:1|main">result.txt

echo "good bye!"

