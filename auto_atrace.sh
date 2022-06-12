#!/bin/bash

TIME=$(date "+%m-%d_%H-%M-%S")
atrace camera hal ss aidl sched irq disk workq binder_driver binder_lock --async_dump -o /sdcard/atrace/$TIME.trace
tar -czvf /sdcard/atrace/$TIME.tar /sdcard/atrace/$TIME.trace
rm /sdcard/atrace/$TIME.trace