# 触发器 trigger

## 简介
> 触发器(trigger) 是一个特殊的存储过程，它的执行不是由程序调用，也不是手工启动，而是由事件来触发，比如当对一个表进行操作 </br>
> (insert ,delete,update)时就会激活它执行。触发器经常用于加强数据的完成性约束和业务规则等。</br>

```
例如：
当学生表中增加了一个学生的信息时，学生的总数就应该同时改变。因此可以针对学生表创建一个触发器，每次增加一个学生记录时，
就执行一次学生总数的计算操作，从而保证学生总数与记录数一致性。
```

## 创建

``` sql
语法：
 delimiter $$ //修改结束符，否则报错
 create trigger 触发器名称 before|after 触发事件
 on 表名 for each row
 begin
	触发器程序体
 end$$
 
 delimiter $ //还原结束符
 
 <触发器名称>    			最多64个字符，它和mysql中其他对象的命名方式一样
 {before|after}  			触发器时机
 {inset|update|delete} 		触发器事件
 on <表名称>				标识简历触发器的表名，即在哪张表上建立触发器
 for each row               触发器的执行间隔：for each row 字句通知触发器每隔一行执行一次动作，而不是对整个表执行一次
 <触发器程序体>				要触发的程序语句：可用顺序，判断，循环等语句实现一般程序需要的逻辑功能
```

## 案例1
``` sql
create table student(
    id int(10) unsigned auto_increment primary key not null,
	name varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT ''
);

create table student_total(
total int(10)
);

#创建触发器
delimiter $$
create trigger student_insert_trigger after insert
on student for each row
begin
	update student_total set total=total+1;
end$$

delimiter $

# 测试
insert into student(name) values("carry");
```

## 案例2

``` sql

# 创建表1
drop table if exists tab1;
create table tab1(
	id int primary key auto_increment,
	name varchar(50),
	sex enum('m','f'),
	age int
);

# 创建表2 
drop table if exists tab2
create table tab2(
	id int primary key auto_increment,
	name varchar(50),
	salary double(10,2)
);

#触发器tab1_after_delete_trigger
#作用： tab1 表删除记录后，自动将tab2 表中对应记录删除
\d $$
create trigger tab1_after_delete_trigger 
after delete on tab1
for each row
begin
	delete from tab2 where name=old.name;
end$$

# 触发器tab1_after_update_trigger
# 作用：当tab1更新后，自动更新tab2
create trigger tab1_after_update_trigger
after update on tab1
for each row
begin
	update tab2 set name=new.name
	where name=old.name;
end$$

#触发器tab1_after_insert_trigger
create trigger tab1_after_insert_trigger
after insert on tab1_after_delete_trigger
for each row
begin
	insert into tab2(name,salary) values(new.name,5000);
end$$
```

## 查看触发器

``` sql
1.执行命令:show triggers;
2.通过系统表triggers查看
use information_schema
select * from trigger;
select * from trigger where trigger_name='触发器名称';
```

## 删除触发器

``` sql
drop trigger 触发器名称;
```

