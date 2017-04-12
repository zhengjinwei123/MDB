# Mongodb
> 最像关系型数据库的非关系型数据，mongodb无论在性能上还是操作上我都感觉它很像mysql,但是它确实是nosql，基于文档类型的非关系型数据库

## 安装
```
1. 下载
首先到其官网上下载最新稳定版，解压到目录，如/usr/local/mongodb
wget https://www.mongodb.com/download-center#community


2. 进入/usr/local目录下
cd /usr/local


3. 创建mongodb文件夹，作为安装目标文件夹
mkdir mongodb


4. 解压缩文件，并且移动到mongodb文件夹下
tar -zxvf mongodb-linux-x86_64-2.6.7.tgz

5.移动解压缩后的文件夹下的所有文件到mongodb文件夹下cd mongodb-linux-x86_64-2.6.7
mv * /usr/local/mongodb


6. 创建data文件夹用于存放数据，创建logs文件用于存放文件
cd /usr/local/mongodb
mkdir data
touch logs

7.更改目录权限
chown `id -u` /data/db
chown `id -u` /data
cd ..
chown `id -u` /mongo

8.启动MongoDB服务
cd bin
./mongod -dbpath=/usr/local/mongodb/data -logpath=/usr/local/mongodb/logs

9.后台服务启动
./mongod -dbpath=/usr/local/mongodb/data -logpath=/usr/local/mongodb/logs --fork

10.后台权限启动
./mongod -dbpath=/usr/local/mongodb/data -logpath=/usr/local/mongodb/logs --fork --auth
```
