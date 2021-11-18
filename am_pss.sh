#!/bin/bash
grep -rsn "am_pss" logcat.log > tmp.txt
rm result.csv
cat tmp.txt | while read line
do
    array=(${line//,/ })
    echo ${array[1]}, ${array[9]}, ${array[10]} >> result.csv
done


