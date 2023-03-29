#!/bin/bash
echo gpu_set_log_level 4 > /dev/kgsl-control
echo gpubusystats 1000 > /dev/kgsl-control
slog2info -b KGSL -w | grep utilization|awk '{print$30}'