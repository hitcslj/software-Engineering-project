/*
SQLyog Ultimate v13.1.1 (64 bit)
MySQL - 5.7.32 : Database - table_test
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`table_test` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `table_test`;

/*Table structure for table `commodity` */

DROP TABLE IF EXISTS `commodity`;

CREATE TABLE `commodity` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `price` varchar(100) DEFAULT NULL,
  `stock` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `commodity` */

insert  into `commodity`(`id`,`name`,`price`,`stock`,`type`) values 
(1,'香烟啤酒','12','12','二次元'),
(2,'火车','13','1','生鲜水果'),
(3,'飞机','14','1','二次元'),
(4,'汽车','15','1','生鲜水果');

/*Table structure for table `customer` */

DROP TABLE IF EXISTS `customer`;

CREATE TABLE `customer` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(32) DEFAULT NULL,
  `telephone` varchar(32) DEFAULT NULL,
  `orders` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `customer` */

insert  into `customer`(`ID`,`NAME`,`telephone`,`orders`) values 
(1,'振杰','111','1'),
(2,'国庆','222','2'),
(3,'碧晨','333','3');

/*Table structure for table `customerinfo` */

DROP TABLE IF EXISTS `customerinfo`;

CREATE TABLE `customerinfo` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(32) DEFAULT NULL,
  `telephone` varchar(32) DEFAULT NULL,
  `orders` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

/*Data for the table `customerinfo` */

insert  into `customerinfo`(`ID`,`NAME`,`telephone`,`orders`) values 
(1,'碧晨','113',''),
(2,'国庆','226','');

/*Table structure for table `items` */

DROP TABLE IF EXISTS `items`;

CREATE TABLE `items` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `INPRICE` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `TRADEPRICE` int(11) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  `location` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

/*Data for the table `items` */

insert  into `items`(`ID`,`name`,`INPRICE`,`price`,`TRADEPRICE`,`number`,`location`) values 
(1,'水晶',100,180,150,674,'Z'),
(2,'原石',120,200,180,1145,'Z'),
(3,'碧晨',2,3,1,10,'A'),
(4,'补给卡',5,30,10,3589,'B'),
(7,'水晶',100,180,150,2943,'A'),
(8,'水晶',100,180,150,497,'B'),
(10,'盖中盖',6,12,10,1004,'Z'),
(11,'小霸王',50,100,80,3002,'Z'),
(12,'小霸王',50,100,80,50,'A');

/*Table structure for table `orderitems` */

DROP TABLE IF EXISTS `orderitems`;

CREATE TABLE `orderitems` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `orderid` int(10) unsigned DEFAULT NULL,
  `itemid` int(10) unsigned DEFAULT NULL COMMENT '商品id',
  `itemnum` int(10) unsigned DEFAULT NULL COMMENT '商品数目',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4;

/*Data for the table `orderitems` */

insert  into `orderitems`(`id`,`orderid`,`itemid`,`itemnum`) values 
(1,2,1,7),
(123,65,10,50),
(124,65,2,100),
(125,65,1,200);

/*Table structure for table `orders` */

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `customername` varchar(32) DEFAULT NULL,
  `telephone` varchar(32) DEFAULT NULL,
  `state` varchar(32) DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4;

/*Data for the table `orders` */

insert  into `orders`(`ID`,`customername`,`telephone`,`state`,`type`) values 
(65,'guoqing','123','通过','trade');

/*Table structure for table `userinfo` */

DROP TABLE IF EXISTS `userinfo`;

CREATE TABLE `userinfo` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT '姓名',
  `AGE` int(11) DEFAULT NULL COMMENT '年龄',
  `LOGINNAME` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT '登入账号',
  `PASSWORD` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT '密码',
  `identity` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `userinfo` */

insert  into `userinfo`(`ID`,`NAME`,`AGE`,`LOGINNAME`,`PASSWORD`,`identity`) values 
(1,'张三',24,'admin','123','boss'),
(14,'马云',56,'mayun','123','DPManager'),
(15,'百度',12,'baidu','123','sales'),
(16,'华为',23,'huawei','123','sales'),
(21,'碧晨',50,'bichen','123','sales');

/*Table structure for table `warehouse` */

DROP TABLE IF EXISTS `warehouse`;

CREATE TABLE `warehouse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `warehousename` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

/*Data for the table `warehouse` */

insert  into `warehouse`(`id`,`warehousename`) values 
(1,'Z'),
(2,'A'),
(3,'B');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
