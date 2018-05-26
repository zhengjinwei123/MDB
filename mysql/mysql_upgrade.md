# MSQL 升级方法
> 本文源于实际工作升级mysql操作记录

## 目的
> 将MySQL 从 5.6.29 升级到 5.7.22，同时不影响线上数据

```
+-----------+
| version() |
+-----------+
| 5.6.29    |
+-----------+
     ||

+-----------+
| version() |
+-----------+
| 5.7.22    |
+-----------+
```

## 配置步骤

```
1.  到官网下载 mysql5.7.22
   [地址：https://dev.mysql.com/downloads/mysql/5.7.html#downloads]

   下载得到：mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz
   解压到： /data/install/ 目录下
       tar -xzvf  mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz
2.   移动文件到 /user/local/mysql（如果没有需要创建）
     mkdir /usr/local/mysql
     mv   /data/install/mysql-5.7.22-linux-glibc2.12-x86_64  /usr/local/mysql
     mkdir /usr/local/data/
     chown mysql:mysql /usr/local/mysql -R
     chmod 755 /usr/local/mysql -R
3.   拷贝配置和可执行文件
    cp   /usr/local/mysql/support-files/mysql.server  /etc/init.d/mysqld
    cp  /etc/my.conf    /etc/my57.conf （备份之前5.6版本的配置）
4.   修改 /etc/my.conf
    [mysqld]
    datadir=/storage/db/mysql
    socket=/storage/db/mysql/mysql.sock

    [mysql]
    socket=/storage/db/mysql/mysql.sock

    [client]
    socket=/storage/db/mysql/mysql.sock

    [mysqldump]
    socket=/storage/db/mysql/mysql.sock

    [mysqladmin]
    socket=/storage/db/mysql/mysql.sock
5.  链接到5.6 mysql
    查看数据库目录
    mysql> show variables like '%datadir%';
        +---------------+-----------------+
        | Variable_name | Value           |
        +---------------+-----------------+
        | datadir       | /var/lib/mysql/ |
        +---------------+-----------------+  

    mysql> show variables like '%basedir%';
        +---------------+-------+
        | Variable_name | Value |
        +---------------+-------+
        | basedir       | /usr  |
        +---------------+-------+

6.   停止mysql5.6
     /etc/init.d/mysqld stop

7.   修改 my.conf
     [mysqld]
     datadir=/var/lib/mysql/
     basedir=/usr/
     [mysqld_safe]
     pid-file=/usr/local/mysql/data/mysql.pid
```

## 启动mysql
   `/etc/init.d/mysqld start`

## 升级数据字典
> 升级字典，否则会在错误日志中看到很多错误

 `/usr/local/mysql/bin/mysql_upgrade  -uroot -proot`

## 查看升级后版本

```
mysql> select version();
+-----------+
| version() |
+-----------+
| 5.7.22    |
+-----------+
1 row in set (0.00 sec)

```
