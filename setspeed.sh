#!/system/bin/sh
echo "userspace" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo $1 >/sys/devices/system/cpu/cpu3/cpufreq/scaling_setspeed
echo "userspace" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo $1 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed


echo -e "\033[32mCPU&GPU status\033[0m"
echo "CPU1 available governor:"
cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_available_governors
echo "CPU1 governor:"
cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo "CPU1 available freq:"
cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_available_frequencies
echo "CPU1 freq:"
cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
echo "CPU3 available governor:"
cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_available_governors
echo "CPU3 governor:"
cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo "CPU3 available freq:"
cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_available_frequencies
echo "CPU3 freq:"
cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq
