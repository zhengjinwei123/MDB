#/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

pid=`lsof -i:6379 | awk '$1 != "COMMAND" {print $2}'`

if [[ ${pid} != "" ]];then
    kill $pid
    sleep 3
    unset -v pid
    pid=`lsof -i:6379 | awk '$1 != "COMMAND" {print $2}'`
    if [[ $pid != "" ]];then
        echo "redis 服务关闭失败"
    else
       echo "redis 服务成功停止"
    fi
else
  echo "没有正在运行的redis服务"
fi
