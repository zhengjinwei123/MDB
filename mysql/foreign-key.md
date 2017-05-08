# Mysql 外键
> mysql 中通过外键约束来保证表与表之间的数据的完整性和准确性。

## 外键的使用条件

```
1. 两个表必须都是InnoDB表，所用的存储引擎必须支持外键
2. 外键列必须建立了索引
3. 参与外键关系的两张表的列必须是数据类型相似，也就是可以相互转换数据类型的列，比如int和tinyint可以，int和char不行。
```

## 外键的好处

```
可以使得两张表关联，保证数据的一致性和实现一些级联操作。
```

## 关于主键和外键

```
关系型数据库中的一条记录中有若干属性，若其中某一个属性组能唯一标识一条记录，改属性组就可以成为一个主键。
比如：
1. 学生表(学号、姓名、性别、班级)
其中每个学生的学号是唯一的，学号就是一个主键

2. 课程表（课程编号，课程名，学分）
其中课程编号是唯一的，课程编号就是一个主键

3. 成绩表(学号，课程号，成绩)
成绩表中单一一个属性无法唯一标识一条记录，学号和课程号的组合
才可以唯一标识一条记录，所以学号和课程号的属性组是一个主键

成绩表的学号不是成绩表的主键，但它和学生表中的学号想对应，并且
学生表中的学号是学生表的主键，则称成绩表中的学号是学生表的外键。
同理，成绩表中的课程号是课程表的外键

定义主键和外键主要是为了维护关系数据库的完整性，总结一下：
1.主键是能确定一条记录的唯一标识，比如，一条记录包括身份证号，姓名，年龄。
身份证号是唯一能确定你这个人的，其他都可能有重复，所以，身份证号是主键。

2.外键用于与另一张表的关联，是能确定另一张记录的字段，用于保持数据的一致性。
例如：A表中的一个字段，是B表的主键，那他就可以是A表的外键。
```


## 主键，外键，索引的区别

|        	| 主键           | 外键           |   索引            |
| ----------|:---------------|:---------------|:-------------------|
| 定义  | 唯一标识一条记录，不能有重复的，不允许为null | 表的外键是另一张表的主键。外键可以有重复的，可以是null | 该字段没有重复值，但可以有一个空值 |
| 作用  | 用来保证数据的完整性 | 用来和其他表建立联系 | 用来提高表的查询和排序速度 |
| 个数  | 只能有一个 | 一个表可以有多个外键 | 一个表可以有多个唯一索引 |

## 外键的定义语法

``` SQL
[CONSTRAINT symbol] FOREIGN KEY [id] (index_col_name,...)
REFERENCE tbl_name (index_col_name,...)
[ON DELETE {RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT}]
[ON UPDATE {RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT}]
```
##### 该语法可以在`CREATE TABLE` 和 `ALTER TABLE` 时使用，如果不指定CONSTRAINT symbol,Mysql 会自动生成一个名字

``` SQL
ON DELETE,ON UPDATE 表示事件触发限制，可设参数:

RESTRICT (限制外表中的外键改动)
CASCADE (跟随外键改动)
SET NULL (设空值)
SET DEFAULT (设默认值)
NO ACTION (无动作，默认的)
```

## 案例 [参考资料](http://www.jb51.net/article/90729.htm)

``` SQL
dage表 和 xiaodi表，大哥表示主键，小弟表示外键

CREATE TABLE `dage`(
	`id` int(11) NOT NULL auto_increment,
	`name` varchar(32) default '',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `xiaodi` (
	`id` int(11) NOT NULL auto_increment,
	`dage_id` int(11) default NULL,
	`name` varchar(32) default '',
	PRIMARY KEY (`id`),
	KEY `dage_id` (`dage_id`),
	CONSTRAINT `xiaodi_ibfk_1` FOREIGN KEY (`dage_id`) REFERENCE `dage` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

插入一个大哥：
insert into dage(name) values('大哥1')

插入一个小弟:
insert into xiaodi(dage_id,name) values(1,'大哥1_小弟1')

把大哥删除:
delete from dage where id=1;
ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`bstar/xiaodi`, CONSTRAINT `xiaodi_ibfk_1` FOREIGN KEY (`dage_id`) REFERENCES `dage` (`id`))

提示报错，外键约束，大哥下面还有小弟，大哥删了，小弟没有了大哥

插入一个小弟:
insert into xiaodi(dage_id,name) values(2,'大哥2_小弟1')
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`bstar/xiaodi`, CONSTRAINT `xiaodi_ibfk_1` FOREIGN KEY (`dage_id`) REFERENCES `dage` (`id`))

提示报错，外键约束，还有大哥

给外键约束添加事件触发机制:
mysql> show create table xiaodi;
CONSTRAINT `xiaodi_ibfk_1` FOREIGN KEY (`dage_id`) REFERENCES `dage` (`id`)
mysql> alter table xiaodi drop foreign key xiaodi_ibfk_1; 
Query OK, 1 row affected (0.04 sec)
Records: 1 Duplicates: 0 Warnings: 
mysql> alter table xiaodi add foreign key(dage_id) references dage(id) on delete cascade on update cascade;
Query OK, 1 row affected (0.04 sec)
Records: 1 Duplicates: 0 Warnings: 0

再次删除大哥：
mysql> delete from dage where id=1;
Query OK, 1 row affected (0.01 sec)
mysql> select * from dage;
Empty set (0.01 sec)
mysql> select * from xiaodi;
Empty set (0.00 sec)

```