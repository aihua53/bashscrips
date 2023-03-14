#!/bin/bash

while true
do
    TIME=$(date "+%m-%d_%H-%M-%S")
    dumpsys SurfaceFlinger > sdcard/tony/$TIME.txt
    sleep 1
done

 