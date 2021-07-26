#！/bin/sh
TTY2="ttyUSB2"
function wait_for_ttyUSB2()
{
   while true
   do
   echo "dev=$TTY2"
   if [ -c "$TTY2" ];then
     echo "$TTY2 is exist"
     continue
   else
     echo "wait for $TTY2 ready,and check again after 1s"
   fi
   sleep 1s
   done
}
wait_for_ttyUSB2;
