#!/system/bin/sh

#重置cpuset
funcInitCPUCTL() {
  if [ ! -d /dev/cpuctl/ ]; then
    echo "error /dev/cpuctl not exists."
    return 6
  fi

  if [ -d /dev/cpuctl/perfmeasure ]; then
    cat /dev/cpuctl/perfmeasure/tasks | while read line;do echo $line >> /dev/cpuctl/tasks;done
    rmdir /dev/cpuctl/perfmeasure
  fi

  if [ -d /dev/cpuctl/perfexclude ]; then
    cat /dev/cpuctl/perfexclude/tasks | while read line;do echo $line >> /dev/cpuctl/tasks;done
    rmdir /dev/cpuctl/perfexclude
  fi

  #如果不是reset
  if [ ! -n "$1" -o "reset"x != "$1"x ]; then
    mkdir /dev/cpuctl/perfmeasure
    mkdir /dev/cpuctl/perfexclude
    echo "1" >/dev/cpuctl/perfmeasure/cgroup.clone_children
    echo "1" >/dev/cpuctl/perfexclude/cgroup.clone_children
    echo "-1" > /dev/cpuctl/perfmeasure/cpu.cfs_quota_us
  fi
  return 0
}

funConfigCPUCTL() {
  if [ ! -d /dev/cpuctl/perfmeasure ]; then
    echo "warnning /dev/cpuctl/perfmeasure not exists."
    return 1
  fi

  if [ ! -d /dev/cpuctl/perfexclude ]; then
    echo "warnning /dev/cpuctl/perfexclude not exists."
    return 2
  fi

  funChkValueArg $1
  if [  $? -ne 0 ]; then
    return 1
  fi
  funChkValueArg $2
  if [ $? -ne 0 ]; then
    return 1
  fi
  echo 1 >/dev/cpuctl/perfmeasure/cgroup.clone_children
  echo 1 >/dev/cpuctl/perfexclude/cgroup.clone_children

  echo $1 > /dev/cpuctl/perfmeasure/cpu.shares
  echo $2 > /dev/cpuctl/perfexclude/cpu.shares
  typeset msg
  msg=$(funcTransCPUMAX2Quota $3)
  if [ $? -eq 0 ]; then
    echo $msg > /dev/cpuctl/perfmeasure/cpu.cfs_quota_us
  else
    echo "error: $msg"
    return 1
  fi
  return 0
}

#将pids导入到cpuctl中
funcImportPIDS2CPUCTL() {
  if [ ! -d /dev/cpuctl/perfmeasure ]; then
    echo "warnning /dev/cpuset/perfmeasure not exists."
    return 1
  fi

  cat /dev/cpuctl/perfmeasure/tasks | while read line;do echo $line >> /dev/cpuctl/tasks;done
  cat /dev/cpuctl/tasks | while read line;do echo $line >> /dev/cpuctl/perfexclude/tasks;done
  local newarr
	newarr=(`echo "$@"`)
  for member in ${newarr[@]}
  do
    funChkValueArg $member
    if [  $? -ne 0 ]; then
      return 1
    fi
    echo $member > /dev/cpuctl/perfmeasure/cgroup.procs
  done

  return 0
}

#重置cpuset
funcInitCPUSET() {
  if [ ! -d /dev/cpuset/ ]; then
    echo "error /dev/cpuset not exists."
    return 7
  fi

  if [ -d /dev/cpuset/perfmeasure ]; then
    cat /dev/cpuset/perfmeasure/tasks | while read line;do echo $line >> /dev/cpuset/tasks;done
    rmdir /dev/cpuset/perfmeasure
  fi

  if [ -d /dev/cpuset/perfexclude ]; then
    cat /dev/cpuset/perfexclude/tasks | while read line;do echo $line >> /dev/cpuset/tasks;done
    rmdir /dev/cpuset/perfexclude
  fi
  echo 1 > /dev/cpuset/mems
  echo 0-3 > /dev/cpuset/cpus

  #如果不是reset
  if [ ! -n "$1" -o "reset"x != "$1"x ]; then
    mkdir /dev/cpuset/perfmeasure
    mkdir /dev/cpuset/perfexclude
    echo 0 > /dev/cpuset/mems
    echo 0 > /dev/cpuset/perfexclude/mems
    echo 0 > /dev/cpuset/perfmeasure/mems
  fi
  return 0
}

#配置cpuset锁核
funConfigCPUSET() {
  echo $2 > /dev/cpuset/foreground/boost/cpus
  echo $2 > /dev/cpuset/foreground/cpus
  echo $2 > /dev/cpuset/background/cpus
  echo $2 > /dev/cpuset/audio-app/cpus
  echo $2 > /dev/cpuset/top-app/cpus
  echo $2 > /dev/cpuset/camera-daemon/cpus
  echo $2 > /dev/cpuset/system-background/cpus
  if [ ! -d /dev/cpuset/perfexclude ]; then
    echo "warnning /dev/cpuset/perfexclude not exists."
    return 1
  fi

  if [ ! -d /dev/cpuset/perfmeasure ]; then
    echo "warnning /dev/cpuset/perfmeasure not exists."
    return 2
  fi
  echo $1 > /dev/cpuset/perfmeasure/cpus
  echo $2 > /dev/cpuset/perfexclude/cpus

  return 0
}

#将pids导入到cpuset中
funcImportPIDS2CPUSET() {
  if [ ! -d /dev/cpuset/perfmeasure ]; then
    echo "warnning /dev/cpuset/perfmeasure not exists."
    return 1
  fi
  cat /dev/cpuset/perfmeasure/tasks | while read line;do echo $line >> /dev/cpuset/tasks;done
  cat /dev/cpuset/tasks | while read line;do echo $line >> /dev/cpuset/perfexclude/tasks;done
  local newarr
  newarr=(`echo "$@"`)
  for member in ${newarr[@]}
  do
    funChkValueArg $member
    if [ $? -ne 0 ]; then
      return 1
    fi
    echo $member > /dev/cpuset/perfmeasure/cgroup.procs
  done

  return 0
}

# 检查参数是不是数字，检查参数是不是空
funChkValueArg() {
  if [ -z "$1" ]; then
    echo "need value."
    return 1
  fi

  echo "$1" | sed 's/\.//g'  | sed 's/-//g' | grep [^0-9] >/dev/null
  if [ $? -ne 1 ]; then
    echo "error Args must be integer!"
    return 2
  fi

  # if [ 0 -eq "$1" ]; then
  #   return 0
  # fi
  #
  # expr $1 + 0 &>/dev/null
  # if [ 0 -ne "$?" ]; then
  #   echo "error Args must be integer!"
  #   return 3
  # fi

  return 0
}

funChkArg() {
  if [ -z "$1" ]; then
    echo "error need value."
    return 4
  fi

  if [ ${1:0:1} == "-" ]; then
    echo "error not valid arg."
    return 2
  fi

  return 0
}

funcTransCPUMAX2Quota() {
  if [ -1 -eq $1 ]; then
    echo -1
    return 0
  fi

  if [ 0 -ge $1 -o 100 -le $1 ]; then
    echo "cpu-usage-max pct value must be > 0 and < 100, unexpect $1pct"
    return 1
  fi

  local cfs_period_us=`cat /dev/cpuctl/perfmeasure/cpu.cfs_period_us`
  local cfs_quota_us=`expr $1 \* $cfs_period_us / 100`
  if [ $cfs_quota_us -lt 1000 ]; then
    cfs_quota_us=1000
  fi

  echo $cfs_quota_us
  return 0
}

printHelp() {
  echo "User guide:"
  echo "--reset                                重置所有cgroup、cpu和gpu设置, 重置nice值需要指定pids"
  echo "-p|--pids [id ...]                     指定需要测试的进程号，会对进程的cgroup、nice值做处理"
  echo "-q|query                               最后会打印所有修改过的环境配置和可配置选项,还包括一些配置后被影响的信息"
  echo "-r|--renice [-20~19]                   修改进程nice值，需要指定pids, 修改后的新建线程不受影响"
  echo "-s|--cpuctl [目标进程cpu资源倾斜比例] [其他进cpu程资源倾斜比例] [目标进程cpu资源上限百分比, -1是不限制]"
  echo "                                       设置cpu资源分配的优先指数，两个指数的比例就是优先分配cpu的占比，第三个参数是目标进程的最大cpu占用的百分比"
  echo "-l|--cpuset [目标进程锁核] [其他进程锁核]"
  echo "                                       将进程限制在哪些cpu核上运行，配置格式 0 1 2 3 0-1 0-3 2-3 1-3等搭配方式"
  echo "\n\n"
  return 0
}


#开始
if [ "$#" -lt 1 ]; then
  echo "error need arguments."
  exit 5
fi


while [[ $# -ge 1 ]]; do
	case $1 in
    -h|--help )
      printHelp
      exit 0
      ;;
    --reset )
      RESET="true"
      shift
      ;;
    -p|--pids )
      PIDS=($2)
    #  echo "PIDS = ${PIDS[@]}"
      shift 2
			;;
    -q|query )
			Q="true"
		#	echo "query = $Q"
			shift
			;;
		-r|--renice )
      funChkValueArg $2
      if [ $? -ne 0 ]; then
        exit 9
      fi
			R=$2
		#	echo "renice = $R"
			shift 2
			;;
		-s|--cpuctl )
      funChkValueArg $2
      if [ $? -ne 0 ]; then
        exit 1
      fi
			S=$2
      funChkValueArg $3
      if [ $? -ne 0 ]; then
        exit 1
      fi
      SO=$3
      funChkValueArg $4
      if [ $? -ne 0 ]; then
        exit 1
      fi
      SM=$4
		#	echo "cpu-share = $S $SO"
			shift 4
			;;
    -l|--cpuset )
      funChkArg $2
      if [ $? -ne 0 ]; then
        exit 1
      fi
			L=$2
      funChkArg $3
      if [ $? -ne 0 ]; then
        exit 1
      fi
      LO=$3
	#		echo "cpuset $L $LO"
			shift 3
			;;
    # -g|--gpu-freq )
    #   funChkValueArg $2
		# 	G=$2
		# 	echo "gpu-freq = $G"
		# 	shift 2
		# 	;;

		* )
			echo "无法识别参数：$1"
      printHelp
      exit 8
			shift
			;;
	esac
done

echo "Options:"
echo "reset = $RESET"
echo "query = $Q"
echo "renice = $R"
echo "cpu-share = $S $SO"
echo "cpu-max = $SM"
echo "cpuset = $L $LO"
echo "PIDS = ${PIDS[@]}"

if [ x"$RESET" == x"true" ]; then
  #reset all configuration
  funcInitCPUCTL "reset"
  if [ $? -ne 0 ]; then
    exit 1
  fi
  funcInitCPUSET "reset"
  if [ $? -ne 0 ]; then
    exit 1
  fi
  echo "0-3" > /dev/cpuset/foreground/boost/cpus
  echo "0-3" > /dev/cpuset/foreground/cpus
  echo "0-3" > /dev/cpuset/background/cpus
  echo "0-3" > /dev/cpuset/audio-app/cpus
  echo "0-3" > /dev/cpuset/top-app/cpus
  echo "0-3" > /dev/cpuset/camera-daemon/cpus
  echo "0-3" > /dev/cpuset/system-background/cpus

  echo "interactive" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
  echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

  echo "msm-adreno-tz" >/sys/class/kgsl/kgsl-3d0/devfreq/governor
  echo "0" >/sys/class/kgsl/kgsl-3d0/force_clk_on
  echo "80" >/sys/class/kgsl/kgsl-3d0/idle_timer

  # 把对象pids的nice都变成0
  if [[ -n $PIDS ]]; then
    for member in ${PIDS[@]}
    do
      ls -1 /proc/${member}/task/ | while read line;
        do
          renice -n 40 -p $line;
          renice -n -19 -p $line;
        done
    done
  fi

else
  #main process begins
  #CPU frequence
  echo "userspace" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
  echo "1670400" >/sys/devices/system/cpu/cpu3/cpufreq/scaling_setspeed
  echo "userspace" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  echo "1593600" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed

  #GPU frequence
  echo "1" >/sys/class/kgsl/kgsl-3d0/force_clk_on
  echo "10000000" >/sys/class/kgsl/kgsl-3d0/idle_timer
  echo "performance" >/sys/class/kgsl/kgsl-3d0/devfreq/governor
  echo "510000000" >/sys/class/kgsl/kgsl-3d0/gpuclk

  if [[ -n $L && -n $LO ]]; then
    funcInitCPUSET
    if [ $? -ne 0 ]; then
      exit 1
    fi
    ret=$(funConfigCPUSET $L $LO)
    if [ $? -ne 0 ]; then
      echo $ret
      exit 11
    fi
  fi

  if [[ -n $S ]]; then
    funcInitCPUCTL
    if [ $? -ne 0 ]; then
      exit 1
    fi
    ret=$(funConfigCPUCTL $S $SO $SM)
    if [ $? -ne 0 ]; then
      echo $ret
      exit 11
    fi
  fi

  if [[ -n $PIDS ]]; then
   ret=$(funcImportPIDS2CPUSET ${PIDS[@]})
   if [ $? -ne 0 ]; then
     echo $ret
     exit 11
   fi
   ret=$(funcImportPIDS2CPUCTL ${PIDS[@]})
   if [ $? -ne 0 ]; then
     echo $ret
     exit 11
   fi
  fi

  if [[ -n $R && -n $PIDS ]]; then
    for member in ${PIDS[@]}
    do
      ls -1 /proc/${member}/task/ | while read line;
        do
          renice -n 40 -p $line;
          renice -n -19 -p $line;
          renice -n $R -p $line;
        done
    done
  fi
fi

if [ "true"x = "$Q"x ]; then
  echo -e "\n\n\n\033[32m $(uptime)\033[0m"
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
  echo "GPU available governor:"
  cat /sys/class/kgsl/kgsl-3d0/devfreq/available_governors
  echo "GPU governor:"
  cat /sys/class/kgsl/kgsl-3d0/devfreq/governor
  echo "GPU available freq:"
  cat /sys/class/kgsl/kgsl-3d0/gpu_available_frequencies
  echo "GPU freq:"
  cat /sys/class/kgsl/kgsl-3d0/devfreq/cur_freq
  echo "GPU busy:"
  cat /sys/class/kgsl/kgsl-3d0/gpubusy

  echo -e "\n\033[32mCPUSET:\033[0m"
  if [ ! -d /dev/cpuset/ ]; then
    echo "/dev/cpuset is not exists."
  elif [ ! -d /dev/cpuset/perfmeasure -o ! -d /dev/cpuset/perfexclude ]; then
    echo "/dev/cpuset/perfmeasure or /dev/cpuset/perfexclude are not exist."
  else
    echo "/dev/cpuset/foreground/boost/cpus"
    cat /dev/cpuset/foreground/boost/cpus
    echo "dev/cpuset/foreground/cpus"
    cat /dev/cpuset/foreground/cpus
    echo "/dev/cpuset/background/cpus"
    cat dev/cpuset/background/cpus
    echo "/dev/cpuset/audio-app/cpus"
    cat /dev/cpuset/audio-app/cpus
    echo "/dev/cpuset/top-app/cpus"
    cat /dev/cpuset/top-app/cpus
    echo "/dev/cpuset/camera-daemon/cpus"
    cat /dev/cpuset/camera-daemon/cpus
    echo "/dev/cpuset/system-background/cpus"
    cat /dev/cpuset/system-background/cpus
    echo "/dev/cpuset/perfexclude/cpus"
    cat /dev/cpuset/perfexclude/cpus
    echo "/dev/cpuset/perfmeasure/cpus"
    cat /dev/cpuset/perfmeasure/cpus
    echo "dev/cpuset/perfmeasure/cgroup.procs"
    cat /dev/cpuset/perfmeasure/cgroup.procs
  fi

  echo -e "\n\033[32mCPUCTL:\033[0m"
  if [ ! -d /dev/cpuctl/ ]; then
    echo "/dev/cpuctl is not exists."
  elif [ ! -d /dev/cpuctl/perfmeasure -o ! -d /dev/cpuctl/perfexclude ]; then
    echo "/dev/cpuctl/perfmeasure or /dev/cpuctl/perfexclude are not exist."
  else
    echo "/dev/cpuctl/perfmeasure/cpu.shares"
    cat /dev/cpuctl/perfmeasure/cpu.shares
    echo "/dev/cpuctl/perfexclude/cpu.shares"
    cat /dev/cpuctl/perfexclude/cpu.shares
    echo "/dev/cpuctl/perfmeasure/cgroup.procs"
    cat /dev/cpuctl/perfmeasure/cgroup.procs
    echo "/dev/cpuctl/perfmeasure/cpu.cfs_period_us"
    cat /dev/cpuctl/perfmeasure/cpu.cfs_period_us
    echo "/dev/cpuctl/perfmeasure/cpu.cfs_quota_us"
    cat /dev/cpuctl/perfmeasure/cpu.cfs_quota_us
    echo "/dev/cpuctl/perfmeasure/cpu.stat"
    cat /dev/cpuctl/perfmeasure/cpu.stat

  fi

  THREADS=""
  if [[ -n $PIDS ]]; then
    for member in ${PIDS[@]}
    do
      THREADS=(${THREADS[@]} $(ls /proc/${member}/task/))
    done
    echo -e "\n\033[32mThreads info:\033[0m"
    echo ${THREADS[@]}
    ps -eT -O 'GROUP,PGID,TID,PR,NI,CMDLINE' -p ${THREADS[@]}
  fi
fi
