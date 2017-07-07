# Mysql 常见功能语句

### 1. 自己更新自己
> 工作中经常会遇到更新一张表的所有数据，可以使用一条简单的SQL 语句搞定

``` sql
假设有一张表:
CREATE TABLE IF NOT EXISTS `t_pay` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `level` int(11) NOT NULL DEFAULT '0' COMMENT '角色等级',
    `fee` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '付费金额',
    `currency` int(3) NOT NULL DEFAULT '0' COMMENT '货币类型',
    `lastamount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '付费后游戏币',
    `amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '新增游戏币',
    `ip` varchar(32) NOT NULL DEFAULT '' COMMENT '客户端IP',
    `device` varchar(128) NOT NULL DEFAULT '' COMMENT '设备',
    `deviceuuid` varchar(64) NOT NULL DEFAULT '' COMMENT '设备唯一号',
    `time` int(11) NOT NULL DEFAULT '0' COMMENT '时间戳',
    `savetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '数据写入时间',
    PRIMARY KEY (`id`, `savetime`),
    KEY `index_post_pay` (`roleid`, `account`, `deviceuuid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8
PARTITION BY LIST ( MONTH(`savetime`) )
( PARTITION p1 VALUES IN (1),
  PARTITION p2 VALUES IN (2),
  PARTITION p3 VALUES IN (3),
  PARTITION p4 VALUES IN (4),
  PARTITION p5 VALUES IN (5),
  PARTITION p6 VALUES IN (6),
  PARTITION p7 VALUES IN (7),
  PARTITION p8 VALUES IN (8),
  PARTITION p9 VALUES IN (9),
  PARTITION p10 VALUES IN (10),
  PARTITION p11 VALUES IN (11),
  PARTITION p12 VALUES IN (12));

我们将这张表的每条数据的savetime 更新为 time所在时间戳指定的时间格式:

UPDATE (SELECT id,savetime,LEVEL,TIME FROM t_pay) A  LEFT JOIN t_pay B ON A.id=B.id SET B.savetime=FROM_UNIXTIME(A.time)
```

### 2. 不存在插入，存在则更新
> `DUPLICATE KEY UPDATE` 是mysql特有语法

``` sql
INSERT INTO t_pay (`level`,`fee`) VALUES (1,30),(2,70) ON DUPLICATE KEY UPDATE level = VALUES(`level`);
```

### 3. 差集，交集，并集

##### 1. 并集

``` sql
select table_a.`id` as id,table_b.`fee` as fee from (
	select * from table_a 
	union all
	select * from table_b
) temp where id>1;
```

##### 2. 差集

``` sql
SELECT ID FROM (  
     SELECT DISTINCT A.ID AS ID FROM TABLEA A  #有ID： 1 2 3 4 5  
     UNION ALL  
     SELECT DISTINCT B.ID AS ID FROM TABLEB B  #有ID： 2 3  
)TEMP GROUP BY ID HAVING COUNT(ID) = 1;
```

##### 3. 交集

``` sql
SELECT ID FROM (  
     SELECT DISTINCT A.ID AS ID FROM TABLEA A  #有ID： 1 2 3 4 5  
     UNION ALL  
     SELECT DISTINCT B.ID AS ID FROM TABLEB B  #有ID： 2 3  
)TEMP GROUP BY ID HAVING COUNT(ID) = 2;
```


















