#!/bin/bash
line=1;
while [ $line -le 3000 ]
do
    line_end=`expr $line + 200`;
    cat can.txt|sed -n "$line,"$line_end"p"|wc -w
    line=$line_end;
done

