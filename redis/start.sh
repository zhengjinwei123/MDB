#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

pid=`lsof -i:6379 | awk '$1 != "COMMAND" {print $2}'`

echo "pid:$pid"
if [[ ${pid} != "" ]];then
    echo "====================服务在运行中.确认重启服务(yes/no)======================"
    read answer

    echo "您选择的是：${answer}"
    if [[ ${answer} == 'yes' ]]; then
        echo "当前redis进程pid:$pid"
        kill ${pid}
        sleep 3
        unset -v pid
        pid=`lsof -i:6379 | awk '$1 != "COMMAND" {print $2}'`
        echo "pid:$pid"
        if [[ ${pid} != "" ]];then
            echo "服务关闭失败."
        else
            echo "服务成功关闭..."
        fi
    else
        exit
    fi
fi

unset -v pid

/data/redis/bin/redis-server /data/redis/bin/redis.conf &

pid=`lsof -i:6379 | awk '$1 != "COMMAND" {print $2}'`

if [[ ${pid} != "" ]];then
    echo "服务启动成功"
else
    echo "服务启动失败"
fi