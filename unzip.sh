#!/bin/bash

echo "hello"

echo $1
cd $1
ls *.zip > ls.log

# while true
#     do
# 		echo $1
# 		cd $1        
# 		# cd /home/jerome/Documents/issues/388561/test
# 		ls *.zip > ls.log
# 		return
#         if test -s ./ls.log;then
#             for i in $(cat ls.log)
#                 do  
#                     echo $i
#                     unzip $i > /dev/null
#                     rm $i
#                 done 
#         else
#             break
#         fi
#     done
# rm ls.log

# egrep -rn "beginning|AppKiller"|egrep "datacollector|datacollection|vehicle|cpu:9|cpu:1|main">result.txt

echo "good bye!"

