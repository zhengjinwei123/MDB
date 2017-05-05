# Mysql 存储过程

### 基本语法
> 存储过程就是一组sql语句集合，类似于编程语言中的方法(函数),用来处理具有针对性的复杂逻辑，支持条件判断，变量声明，
> 语句分支等。</br>
> 存储过程和函数是事先经过编译并存储在数据库中的一段sql语句的集合。</br>
> 存储过程和函数的区别:</br>
> 	1.函数必须有返回值，而存储过程没有 </br>
> 	2.存储过程的参数可以是IN,OUT,INOUT类型，函数的参数只能是IN </br>
> 优点: </br>
>   1.存储过程只在创建时进行编译；而sql语句每执行一次就编译一次，所以使用存储过程可以提高数据库执行速度 </br>
>   2.简化复杂操作，结合事务一起封装 </br>
>   3.复用性好
>   4.安全性高，可指定存储过程的使用权
> 说明: </br>
>   1.并发量少的情况下，很少使用存储过程。</br>
>   2.并发量高的情况下，为了提高效率，用存储过程比较多


### 创建于调用

``` sql
创建存储过程语法:
 create procedure sp_name(参数列表)
	[特性...]过程体
	
 存储过程的参数形式:[IN|OUT|INOUT]参数名 类型
	IN     输入参数
	OUT    输出参数
	INOUT  输入输出参数
	
  delimiter $$
  create procedure 过程名(形式参数列表)
  begin
	SQL语句
  end $$
  delimiter ;
  
  调用:
  call 存储过程名(实参列表)
  
```

1. 创建一个存储过程
``` mysql
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_if`(IN type int)
BEGIN
    #Routine body goes here...
    DECLARE c varchar(500);
    IF type = 0 THEN
        set c = 'param is 0';
    ELSEIF type = 1 THEN
        set c = 'param is 1';
    ELSE
        set c = 'param is others, not 0 or 1';
    END IF;
    select c;
END
;;
DELIMITER ;
```
DELIMITER用来修改系统默认的分隔符，否则存储过程执行会报错，注意存储过程结束时需要还原默认分隔符`;`,在一对`BEGAIN`和`END`之间写sql代码即可，创建时有输入输出参数，可以声明变量，有if/else, case,while等控制语句，通过编写存储过程，可以实现复杂的逻辑功能。

2. 删除指定存储过程
``` mysql
DROP PROCEDURE IF EXISTS `proc_if`;
```
3. 执行存储过程
``` mysql
call proc_if(1);
```

### 使用场合
