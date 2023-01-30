#!/bin/bash
grep -rsn "am_pss" $1 > tmp.txt
# rm result.csv
# cat tmp.txt | while read line;
# do
#     array=(${line//,/ })
#     echo ${array[1]}, ${array[9]}, ${array[10]} >> result.csv
# done

cat tmp.txt | while read line;do
    array=(${line//,/ })
    if [ ${array[10]} -gt 1000000000 ];
    then
        echo ${array[1]}, ${array[9]}, ${array[10]}
    fi
done



