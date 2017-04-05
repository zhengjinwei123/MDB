# Mysql 管理
> 这里容纳了工作中遇到的相关mysql操作。

### 在shell命令行下导入sql脚本文件，脚本文件内容是合法的sql语句集合
1. `mysql -uusername -ppsw dbname < yoursql.sql`

### 在mysql-cli命令行下导入sql脚本文件
1. `mysql> use yourdb;`
2. `mysql> source yoursql.sql;`

### 登录
1. 方法1 `mysql> mysql -uroot -proot`这种方法有弊端，那就是密码是明文，容易被他人盗取(通过history命令就可以查看)
2. 方法2 `mysql> mysql -uroot -p`这种方法密码是不可见，安全可靠

### 导出sql脚本
1. `mysqldump -uroot -p yourdb > storepath` 输入密码即可
