# Redis
> 作为一个典型的内存数据库,redis比memcache 操作方面更加友好，虽然只是单进程，但是只要运用得当，其性能还是非常可观的，而且在数据落地方面也是提供了多种方式来保证稳定。

## 1、安装

````
$ sudo yum install redis php-pecl-redis
````

## 2、启动

````
$ sudo systemctl enable redis.service
$ sudo systemctl start redis.service

或者:
cd /data/redis/
redis-server redis.conf &
````
客户端
```
cd /data/redis/
redis-cli
```

## 3、配置

修改/etc/redis.conf文件

````
# 绑定ip地址
bind 127.0.0.1
# 指定不同的 pid 文件和端口
pidfile /var/run/redis.pid
# 指定监听端口
port 6379

# log日志等级
loglevel warning
# 配置log文件地址
logfile stdout

# 设置数据库个数
databases 16

# 在进行镜像备份时,是否进行压缩
rdbcompression yes
# 镜像备份文件的文件名
dbfilename dump.rdb
# Redis进行数据库镜像备份的频率
save 900 1      #900秒之内有1个keys发生变化时
save 300 10     #300秒之内有10个keys发生变化时
save 60 10000   #60秒之内有10000个keys发生变化时

# 设置该数据库为其他数据库的从数据库
slaveof <masterip> <masterport>
# 指定与主数据库连接时需要的密码验证
masterauth <master-password>
````
