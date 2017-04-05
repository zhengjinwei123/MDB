# Mysql 管理
### 这里容纳了工作中遇到的相关mysql操作，从数据库导入导出到简单的sql语句。

>  导入sql脚本文件,在shell命令行下导入sql脚本文件，脚本文件内容是合法的sql语句集合
#### `mysql -uusername -ppsw dbname < yoursql.sql`

>  导入sql脚本文件，在mysql-cli命令行下导入sql脚本文件
1, `mysql> use yourdb;`
2, `mysql> source yoursql.sql;`
