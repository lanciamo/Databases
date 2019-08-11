-- Generation time: Sun, 11 Aug 2019 13:35:43 +0000
-- Host: mysql.hostinger.ro
-- DB name: u574849695_23
/*!40030 SET NAMES UTF8 */;
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
  `user_id` int(10) unsigned NOT NULL,
  `sex` char(1) COLLATE utf8_unicode_ci NOT NULL,
  `birthday` date DEFAULT NULL,
  `hometown` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `photo_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `profiles` VALUES ('1','D','1989-04-16','South Ernabury','1'),
('2','D','2017-11-25','East Antoniaborough','2'),
('3','D','1995-05-23','Lake Margret','3'),
('4','P','1976-07-06','South Stuartchester','4'),
('5','M','1978-03-27','Hellerburgh','5'),
('6','P','1980-01-24','Christopberg','6'),
('7','M','1989-09-27','Kaileeville','7'),
('8','D','1998-09-28','Winnifredport','8'),
('9','D','1990-09-25','Murphyview','9'),
('10','D','1974-04-10','Kuphalmouth','10'),
('11','D','2012-02-05','East Maya','11'),
('12','D','2011-12-15','East Dandre','12'),
('13','P','1984-09-18','Clementineshire','13'),
('14','D','1996-07-19','South Cotyburgh','14'),
('15','M','1991-05-15','Kailynside','15'),
('16','D','2011-10-03','Lake Samson','16'),
('17','M','1998-04-01','Janiceville','17'),
('18','P','1999-07-05','Olivermouth','18'),
('19','M','2016-06-17','Torphyshire','19'),
('20','D','1997-03-13','Davisfurt','20'),
('21','P','2004-04-12','South Enriquehaven','21'),
('22','P','1994-07-23','North Bridieport','22'),
('23','P','2002-05-08','Port Isabella','23'),
('24','M','1991-07-26','Scarlettside','24'),
('25','M','1994-11-04','Port Sylvester','25'),
('26','M','2015-03-06','Ryleyview','26'),
('27','P','2014-06-19','Port Triston','27'),
('28','M','2004-05-08','Hellerburgh','28'),
('29','P','2002-08-10','Lucioushaven','29'),
('30','M','1984-05-21','Johnsberg','30'),
('31','P','1977-06-02','Hammesview','31'),
('32','M','2002-05-26','Elianbury','32'),
('33','D','1991-09-24','North Gerardoton','33'),
('34','P','1993-09-29','West Jarrettborough','34'),
('35','D','1988-11-04','Horaceville','35'),
('36','P','1980-06-30','Dustyfurt','36'),
('37','M','1974-03-22','Port Cruzhaven','37'),
('38','P','1988-09-26','Ariannamouth','38'),
('39','P','1996-04-20','North Natside','39'),
('40','M','2002-03-17','Lake Trevion','40'),
('41','P','2011-06-18','Port Joshuatown','41'),
('42','M','1995-04-21','Franeckitown','42'),
('43','P','2001-04-02','Volkmanton','43'),
('44','P','1994-04-26','North Margaretehaven','44'),
('45','M','1984-03-01','Lake Omafort','45'),
('46','M','1985-04-24','West Gregg','46'),
('47','D','1996-04-09','Port Jaedenside','47'),
('48','D','1986-12-09','Ursulahaven','48'),
('49','D','1975-08-03','East Yolanda','49'),
('50','M','1995-03-14','Port Kyleightown','50'),
('51','P','1982-02-06','South Keonville','51'),
('52','M','1977-05-05','Harrisfurt','52'),
('53','D','1995-01-06','North Zoie','53'),
('54','M','1987-05-08','North Jason','54'),
('55','M','1984-02-19','Leonelmouth','55'),
('56','D','2004-12-25','Robelborough','56'),
('57','M','2005-02-10','East Laney','57'),
('58','M','1995-06-15','East Curtville','58'),
('59','M','1986-03-15','Port Renee','59'),
('60','D','1987-02-17','Lake Hallie','60'),
('61','M','1974-06-01','Mosciskiside','61'),
('62','P','2018-12-29','Buckridgestad','62'),
('63','D','1980-12-07','New Geovany','63'),
('64','M','1977-03-28','New Gladycestad','64'),
('65','D','1971-05-23','Krajcikmouth','65'),
('66','D','2011-07-20','Nikolausberg','66'),
('67','D','2002-03-13','South Merlinberg','67'),
('68','M','1998-11-16','Lake Nicolaton','68'),
('69','D','2009-04-29','West Mollie','69'),
('70','M','1981-05-06','West Nedstad','70'),
('71','M','1993-06-10','Langworthfurt','71'),
('72','D','2005-11-13','Orvalstad','72'),
('73','D','1982-04-19','Loraineville','73'),
('74','M','1994-03-08','Powlowskiburgh','74'),
('75','P','1987-11-18','Amelieville','75'),
('76','M','2009-10-11','South Carole','76'),
('77','D','2011-12-23','Lake Omerhaven','77'),
('78','P','1980-12-16','Kuhlmanburgh','78'),
('79','M','2015-11-02','North Reyesbury','79'),
('80','D','1974-07-02','Lilianestad','80'),
('81','M','2003-07-12','Aliatown','81'),
('82','P','1994-09-08','South Ardellastad','82'),
('83','M','1997-02-11','North Theodoraborough','83'),
('84','D','1982-09-28','Lake Ashley','84'),
('85','D','1988-09-11','Beattyside','85'),
('86','M','2010-01-08','North Sylvia','86'),
('87','M','1990-09-04','Ignacioport','87'),
('88','M','1974-06-24','East Irving','88'),
('89','M','1984-03-22','West Rupert','89'),
('90','D','2017-10-04','Ellieview','90'),
('91','D','1992-09-18','South Abdullah','91'),
('92','M','2019-06-03','South Halliemouth','92'),
('93','P','1974-11-13','Lebsackmouth','93'),
('94','D','2019-03-15','Port Destineefurt','94'),
('95','P','2007-03-12','Lennamouth','95'),
('96','P','2005-11-30','Port Cindyfort','96'),
('97','D','1979-01-10','New Chet','97'),
('98','P','2003-08-04','Predovicmouth','98'),
('99','D','2007-07-20','Bettefort','99'),
('100','D','2004-02-05','Lake Solon','100'); 




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

