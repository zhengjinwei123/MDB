# Mysql 存储过程
> 涵盖了工作中各种情况下需要用到存储过程案例和存储过程脚本例子代码

### 基本语法
> 存储过程就是一组sql语句集合，类似于编程语言中的方法(函数),用来处理具有针对性的复杂逻辑，支持条件判断，变量声明，
> 语句分支等。

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
