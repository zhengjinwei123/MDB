# Mysql
> 作为国内用户数最多的数据库，作为一个开源已久的数据库，作为一个性能极强的关系型数据库，作为一个屌丝都知道的数据库，我就不多说了

## 1、安装

添加软件源
````shell
$ sudo rpm -ivh http://repo.mysql.com//mysql57-community-release-el7-8.noarch.rpm
$ sudo yum clean all && yum makecache
$ sudo yum-config-manager --disable mysql57-community
$ sudo yum-config-manager --enable mysql56-community
$ sudo yum install mysql mysql-server
````

修改配置文件/etc/my.cnf

初始化数据库
````shell
mysql_install_db
mysql_secure_installation
# mysql5.7以上版本
mysqld –initialize --user=mysql --basedir=/opt/mysql/mysql --datadir=/opt/mysql/mysql/data
mysqld -initialize-insecure --user=mysql --basedir=/opt/mysql/mysql --datadir=/opt/mysql/mysql/data
````

启动守护进程
````
systemctl enable mysqld.service
systemctl start mysqld.service
ln -s /data/mysql/mysql.sock /var/lib/mysql/mysql.sock
````

修改innodb打开文件数限制，然后执行`systemctl daemon-reload`和`systemctl restart mysqld`，使配置生效
````
#修改/etc/systemd/system/multi-user.target.wants/mysqld.service，加入以下内容
    LimitNOFILE = infinity
    LimitMEMLOCK = infinity
````

## 2、配置

````
1. 数据库目录
　/var/lib/mysql/
2. 配置文件
	/usr/share/mysql（mysql.server命令及配置文件）
3. 相关命令
	/usr/bin(mysqladmin mysqldump等命令)
4. 启动脚本
	/etc/rc.d/init.d/（启动脚本文件mysql的目录）

修改登录密码
  	MySQL默认没有密码
  	usr/bin/mysqladmin -u root password 'new-password'
  	格式：mysqladmin -u用户名 -p旧密码 password 新密码
启动与停止
  	MySQL安装完成后启动文件mysql在/etc/init.d目录下，在需要启动时运行下面命令即可
  	启动：
  		/etc/init.d/mysql start
  	停止：
  		/usr/bin/mysqladmin -u root -p shutdown
  	重新启动：

  		sudo /etc/init.d/mysql restart

  	自动启动：
  		察看mysql是否在自动启动列表中 /sbin/chkconfig --list
  		把MySQL添加到你系统的启动服务组里面去 /sbin/chkconfig --add mysql
  		把MySQL从启动服务组里面删除 /sbin/chkconfig --del mysql

将/usr/share/mysql/my-medium.cnf复制到/etc/my.cnf，以后修改my.cnf文件来修改mysql的全局设置
将my.cnf文件中的innodb_flush_log_at_trx_commit设成0来优化
[mysqld]后添加添加lower_case_table_names设成1来不区分表名的大小写
````

## 3、特殊操作

### 修改权限

````sql
GRANT [privilege] ON [dbName].[tableName] '[user]'@'[ip]' IDENTIFIED BY "[password]"  WITH GRANT OPTION
GRANT ALL PRIVILEGES ON *.* TO 'zbgame'@'%' IDENTIFIED BY "zbgame@2016"  WITH GRANT OPTION;
FLUSH PRIVILEGES;
````

##### 也可以通过修改表来操作

````sql
USE mysql;
INSERT INTO mysql.user (Host,User,Password) VALUES ("[ip]","[user]",password("[password]"));
DELETE FROM mysql.user WHERE User="[user]" and Host="[ip]";
````
##### 增加MySQL用户
``` sql
	格式：grant select on 数据库.* to 用户名@登录主机 identified by "密码"
		grant select,insert,update,delete on *.* to user_1@'%' Identified by '123';
		grant all on *.* to user_1@'localhost' Identified by '123';
```

##### 远程访问
``` sql
其一：
　　GRANT ALL PRIVILEGES ON *.* TO xoops_root@'%' IDENTIFIED BY '654321';
　　允许xoops_root用户可以从任意机器上登入MySQL。
　　其二：
　　编辑 /etc/mysql/my.cnf
　　>skip-networking => # skip-networking
　　这样就可以允许其他机器访问MySQL了。
   grant all on *.* to 'root'@'ip' identified by 'password';
```

##### 备份与恢复
``` sql
	备份
	进入到库目录，cd /val/lib/mysql
		mysqldump -u root -p --opt aaa > back_aaa
	恢复
		mysql -u root -p ccc < back_aaa
```

### 字符集和校对集
> MySQL的默认编码是Latin1，不支持中文，要支持需要把数据库的默认编码修改为gbk或者utf8。
> 1、中止MySQL服务（bin/mysqladmin -u root shutdown）
> 2、在/etc/下找到my.cnf，如果没有就把MySQL的安装目录下的support-files目录下> 的my-medium.cnf复制到/etc/下并改名为my.cnf即可
> 3、打开my.cnf以后，在[client]和[mysqld]下面均加上default-character-set=utf8，保存并关闭
> 4、启动MySQL服务（bin/mysqld_safe &）
> 查询字符集：show variables like '%set%';


全局字符集配置
````sql
character_set_system        # 系统元数据(字段名等)字符集
character_set_server        # 默认的内部操作字符集
character_set_client        # 客户端来源数据使用的字符集
character_set_connection    # 连接层字符集
character_set_results       # 服务器返回的查询结果字符集
character_set_database      # 当前选中数据库的默认字符集
# 如果character_set_client、character_set_connection、character_set_results字符集一致
SET NAMES [charset_name];
````

查看字符集和校对集
````sql
show collation;
````

数据库字符集和校对集
````sql
CREATE DATABASE [db_name]
    [[DEFAULT] CHARACTER SET charset_name]  #可选
    [[DEFAULT] COLLATE collation_name]      #可选
````

表的字符集和校对集
````sql
CREATE TABLE tbl_name (column_list)
    [DEFAULT CHARACTER SET charset_name [COLLATE collation_name]]
````

字段的字符集和校对集
````sql
col_name {CHAR | VARCHAR | TEXT} (col_length)
    [CHARACTER SET charset_name [COLLATE collation_name]]
````

**如果需要mysql数据库对数据严格区分大小写，需要将COLLATE设置为`utf8_bin`**

### 显示表状态

````sql
SHOW TABLE STATUS WHERE Name = [tableName];
````

### 存储过程

显示存储过程状态
````sql
show procedure status;
show procedure status where Name="procedureName";
show procedure status like 'fullName';
show procedure status like '%partName%';
````

显示存储过程代码
````sql
show create procedure [procedureName];
````

### 变量信息

显示变量信息
````sql
show variables;
show variables where Variable_name='variablesName';
show variables like 'fullName';
show variables like '%partName%';
````

设置变量信息(全局)

````sql
SET GLOBAL [variablesName]='value';
````

### Row size too large(数据库中table的row size过大)

innodb引擎支持的文件格式包括Antelope(羚羊)、Barracuda(梭子鱼)
 > Antelope提供Redundant（冗余）、Compact（紧凑）文件格式
 > Barracuda除此之外提供Dynamic(动态)和 Compressed(压缩)

修改mysql的innodb引擎的文件格式
````
innodb_file_per_table=1				//每张表一个文件，不建议使用
innodb_file_format=Barracuda
````

修改当前运行数据库变量
````mysql
SET GLOBAL innodb_file_format=Barracuda;		//row的COMPRESSED模式，依赖这个配置。Barracuda
ALTER TABLE [tableName]
    ENGINE=InnoDB			//表的存储引擎
    ROW_FORMAT=COMPRESSED 	//row的格式，有DEFAULT(默认)、FIXED(混合)、DYNAMIC(动态)、COMPRESSED(压缩)、REDUNDANT(冗长)、COMPACT(紧凑)
    KEY_BLOCK_SIZE=8;		//压缩InnoDB的缓冲池的索引页
````

### 避免重复插入记录

方案一：使用Ignore

```sql
INSERT IGNORE INTO [tableName] (colName1, colName2...) VALUES (val1, val2...);
INSERT IGNORE INTO [tableName1] SELECT colName,... FROM [tableName2];
```

方案二：使用Replace

```sql
REPLACE INTO [tableName] (colName, ...) VALUES (val1, val2...);
REPLACE INTO [tableName1] (colName, ...) SELECT colName,... FROM [tableName2];
REPLACE INTO [tableName] SET colName=val, ...;
```

方案三：ON DUPLICATE KEY UPDATE

```sql
INSERT INTO [tableName] (colName1, colName2...) VALUES (val1, val2...) ON DUPLICATE KEY UPDATE colName2=colName2+1;
//更新后colName2的值将会取val3
INSERT INTO [tableName] (colName1, colName2) VALUES (val1, val2),(val1, val3) ON DUPLICATE KEY UPDATE colName2=VALUES(colName2);
```

### 索引或约束

增加索引
````
# 增加主键
ALTER TABLE [tableName] ADD PRIMARY KEY (colName);
# 唯一键约束
ALTER TABLE [tableName] ADD UNIQUE KEY [unx_name] (colName1, colName2);
# 唯一约束
ALTER TABLE [tableName] ADD UNIQUE ADD UNIQUE (colName1);
# 增加索引
ALTER TABLE [tableName] ADD INDEX (colName);
ALTER TABLE [tableName] ADD KEY (colName);
# 增加全文索引
ALTER TABLE [tableName] ADD FULLTEXT (colName);
````

删除索引/约束
````
ALTER TABLE [tableName] DROP INDEX [unx_name];
````

修改索引/约束
````
ALTER TABLE [tableName] DROP INDEX [unx_name];
ALTER TABLE	[tableName] ADD UNIQUE KEY [unx_name] (colName1, colName2);
````

### provided the mandatory server-id

在设置bin log日志的时候，没有设置server_id参数。
server-id参数用于在复制中，为主库和备库提供一个独立的ID，以区分主库和备库；开启二进制文件的时候，需要设置这个参数。

````
server-id=1
log_bin=/data/mysql/binlog/mysql-bin.log
````

### Table 'performance_schema.session_variables' doesn't exist (1146)

`performance_schema`数据库是mysql用来收集数据库服务器性能参数，以及记录一些session和global变量的。
`performance_schema`数据库中的部分表不存在，可能是mysql版本升级，而`performance_schema`中的部分表没有升级，导致新版本mysql访问不到某些变量导致出错。

强制升级mysql中的数据可以解决(保持mysqld启动)
````
# mysql_upgrade -u [user] -p [password] -h host --force
````

### Aborted connection ... (Got an error reading communication packets)

````
# 查看当前状态中，和连接相关的状态
show status like "%connect%";
    Aborted_connects        // 断开的连接数
    Connections             // 试图连接到数据库的连接总数
    Max_used_connections    // 使用过的连接最大数量(并发)
    Threads_connected       // 当前的连接数

# 显示正在运行的线程
show processlist        // 对应账号的线程数
show full processlist   // 全部线程数

# 显示mysql状态
mysqladmin -u -p -h status          // mysql当前状态
mysqladmin -u -p -h extended-status // mysql其他状态
````

Aborted_connects的原因可能有：

- 客户端退出前没有close
- 客户端sleep时间超过了`interactive_timeout`或者`wait_timeout`的值
- 传输数据过程突然结束
- 没有成功连接(权限认证、密码错误、连接超时)

````
connect_timeout=        // 连接过程的超时时间，默认值是10秒。
interactive_timeout=    // 连接空闲(服务器端无交互状态)时的超时时间(使用CLIENT_INTERACTIVE标志的客户端)，默认值是28800秒（8小时）
wait_timeout=           // 连接空闲(服务器端无交互状态)时的超时时间(未使用CLIENT_INTERACTIVE标志的客户端)，默认值是28800秒（8小时）
net_read_timeout=       // 连接繁忙时的读取超时时间
net_write_timeout=      // 连接繁忙时的写入超时时间
````

mysql建立连接需要经过6次握手，前3次是TCP3次握手，后三次握手过程超时与connect_timeout有关。

## mysql变量类型

mysql按照可见范围分为session和global。其变量分为三类: session_only, global_only, both;

- session_only， 仅线程级别意义
- global_only， 仅全局级别有意义
- both， 同时有全局和线程两个状态

每个新线程创建时，从global获取值，设置为线程值；执行`set [variable]=[value]`，只改变线程级别的值，不改变global；执行`set global [variable]=[value]`，只改变global的值，不改变线程级别的值。
对于both类型的变量，执行`set [variable]=[value]`或者`set global [variable]=[value]`，都会改变

`show variables`等效于`show session variables`;
`show global variables`可以查看global_only和both类型的变量;
`show session variables`显示所有变量；

## innodb引擎的索引

Innodb存储引擎支持两种常见的索引: B+树索引、Hash索引

### B+树索引

关系型数据库系统中最常见、最有效的索引。B+树中的B，是平衡树(balance),而不是二叉树(binary)。

- B+树索引只能找到被查找数据行所在的"页"，然后把页读取到内存，再从内存进行查找，最后得到所查找的数据。
- 数据库中，B+树高度一般在2-3层，也就是说在查找某一个键所对应的值时，大概需要进行2-3次IO。

数据库中的B+树索引，分为聚集索引和非聚集索引(辅助索引)。

- 聚集索引，按照每张表的主键构造一个B+树，B+树的一个叶子节点中记录着表中一行记录的所有值。(只要找到这个节点，就找到了该记录的所有值)
- 辅助索引，叶节点不包括行记录的所有值，只包含一个键值和一个书签(bookmark)，书签用于定位与索引对应的数据行。

每张表只能有一个聚集索引，可以有多个辅助索引。辅助索引通过"页"级别的指针获得主键的索引，然后再通过聚集索引定位数据行。

### 索引的添加和删除

对于索引的添加或者删除操作，mysql数据库会先创建一张临时表，然后将数据导入临时表并删除原表，再把临时表名改为原来的表名。所以，增加或者删除索引有成本。

### 索引的选择

当某个字段取值分布范围比较广的时候(高选择性)，适合使用B+树索引。如果某字段只有Y和N两个取值，那么没必要使用索引。

如果要查询的字段具有高选择性，但是本次检索的数据占总数据量的一半以上时，mysql就不会使用索引进行查询。

联合索引，指对表上的多个列做索引。如果有一个3列索引(col1, col2, col3)，则已经对(col1)、(col1, col2)、(col1, col3)和(col1, col2, col3)上建立了索引=> `最左前缀原则`。

搜索的索引，不一定是所要选择的列(最适合索引的列，是出现在WHERE子句中的列，或者连接子句中指定的列，而不是出现在SELECT等关键字后的选择列表中的列)。

使用短索引。如果对字符串列进行索引，应该指定一个前缀长度(尽量这么做)。如果一个CHAR(200)的列，在其前10个或者20个字符内，多数值时唯一的，那么就不要对整个列进行索引。

### 索引对比

- Hash索引，只适用于 = 或 <=> ("等价于"符号，可以用于null等无意义数的操作)操作符的等式比较。
- B+树索引，当使用>、 <、 >=、 <=、 BETWEEN、 !=或<>、 LIKE 'pattern'(其中pattern不以通配符开始)等操作符时，都可以使用相关列上的索引。

> 操作符`<=>`,`IS NULL`,`IS NOT NULL`可以用来处理某个值和null的比较。

> `<=>`只能在mysql中使用,`IS NULL`和`IS NOT NULL`是ANSI标准。

> [field] <=> NULL  ===>  [field] IS NULL

> NOT ([field] <=> NULL)  ===>  [field] IS NOT NULL

## mysql分区表

`PARTITION`类型: 水平分区和垂直分区

### 水平分区

### 垂直分区

## mysql语句优化

mysql的优化，三分是配置的优化，七分是sql语句的优化。

- 不是所有sql语句都能通过sql优化，有时候可以调整业务逻辑
- 大部分时候通过空间换时间，冗余数据来提高性能(大化小，分而治之)
- 多利用explain来分析sql语句
- 索引利大于弊，多使用、有效利用索引

### 1.简化sql，将部分逻辑放到代码层

````sql
-- 粉丝查询
SELECT user FROM `t_friends` f INNER JOIN `t_user` u
ON u.id=f.user AND f.friend=? AND f.user<>?
ORDER BY create_time DESC;

````

### 2.数据量过大的表，部分数据单独建表

### 3.添加冗余字段，减少大表联合查询

### 4.索引优化

### 5.关注数据库状态
