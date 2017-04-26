# Mysql 常见功能语句

### 1. 自己更新自己
> 工作中经常会遇到更新一张表的所有数据，可以使用一条简单的SQL 语句搞定

``` sql
假设有一张表:
-- ----------------------------
-- 充值上报表 -- 服务端
-- ----------------------------
CREATE TABLE IF NOT EXISTS `t_post_pay` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `areaid` int(4) NOT NULL DEFAULT '0' COMMENT '所属区',
    `groupid` int(10) NOT NULL DEFAULT '0' COMMENT '所属组',
    `channel` int(8) NOT NULL DEFAULT '0' COMMENT ' 渠道',
    `account` varchar(64) NOT NULL DEFAULT '' COMMENT '渠道账号',
    `roleid` bigint(20) NOT NULL DEFAULT '0' COMMENT '角色',
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

UPDATE (SELECT id,savetime,LEVEL,TIME FROM t_post_pay) A  LEFT JOIN t_post_pay B ON A.id=B.id SET B.savetime=FROM_UNIXTIME(A.time)
```