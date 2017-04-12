# Memcache
> 纯内存数据库,多进程，key=>value 哈希存储

## 1、安装

````
$ sudo yum install libmemcached memcached libevent
````

## 2、启动

````
-d  以守护进程形式运行
-u  运行memcached的用户
-m  使用的内存空间大小
-M  内存使用超出配置值时，禁止自动清除缓存中的数据项
-c  最大并发连接数(默认1024)
-p  监听的TCP端口
-U  监听的UDP端口
-l  监听的ip地址
-s  监听的UNIX socket文件
-a  设置-s选项指定的UNIX socket文件的权限
-P  pid文件
-t  用来处理请求的线程数(默认4)
-f  用于计算缓存数据项的内存块大小的乘数因子(默认1.25)
-n  为缓存数据项的key、value、flag设置最小分配字节数(默认48)
-k  设置锁定所有分页的内存，对于大缓存应用场景
-r  产生core文件大小
-C  禁用CAS
-h  显示Memcached版本和摘要信息
-V  输出警告和错误信息
-vv 打印信息比-v更详细：不仅输出警告和错误信息，也输出客户端请求和响应信息
-i  打印libevent和Memcached的licenses信息
-D  用于统计报告中Key前缀和ID之间的分隔符(默认是冒号":")
-L  尝试使用大内存分页(HugePage)
-B  指定使用的协议，默认行为是自动协商(autonegotiate)，可能使用的选项有auto、ascii、binary
-I  覆盖默认的STAB页大小(默认1M)
-F	禁用flush_all命令
-o  指定逗号分隔的选项，一般用于用于扩展或实验性质的选项
````

启动一个memcached守护进程
````
$ sudo memcached -d -m 512 -c 5000 -t 8 -f 1.1 -n 100 -u root -l 172.31.8.123 -p 15000 -P /data/memcached/memcachedLogin.pid
$ sudo memcached -d -m 1024 -c 3000 -t 4 -f 1.25 -n 180 -u root -l 10.162.87.55 -p 15001 -P /data/memcached/memcachedServer1.pid
````

## 3、使用
> telnet 操作memcached

```
telnet 127.0.0.1 11211
```

命令参数
```
<command name> <key> <flags> <exptime> <bytes>
<data block>


<command name>：set/add/replace

<key>：查找关键字

<flags>：整型参数，客户机使用它存储关于键值对的额外信息

<exptime>：该数据的存活时间（以秒为单位，0 表示永远）

<bytes>：存储字节数

<data block>：存储的数据块（可直接理解为key-value结构中的value）
```
案例
```
1. set添加或者编辑
set a 0 0 4
8888
STORED

上述命令的意思是：设置a=8888

2. get获取
get a
VALUE a 0 4
8888
END

3. delete删除
delete a
DELETED

4. replace替换
replace a 0 0 4
9999
STORED

5. flush_all清除所有缓存
```
