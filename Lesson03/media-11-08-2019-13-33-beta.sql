-- Generation time: Sun, 11 Aug 2019 13:33:51 +0000
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

DROP TABLE IF EXISTS `media`;
CREATE TABLE `media` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `media_type_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `media` VALUES ('1','1','1','application/vnd.hydrostatix.sof-data','562433','http://www.kreiger.biz/','1986-08-22 17:05:45','1994-11-27 07:12:42'),
('2','2','2','application/x-dgc-compressed','652870','http://swaniawski.com/','2000-07-19 09:21:11','2006-12-17 02:47:26'),
('3','3','3','video/x-sgi-movie','0','http://www.hartmann.com/','1976-08-29 21:15:45','2004-10-16 09:12:12'),
('4','1','4','application/yang','1','http://quitzon.net/','1977-02-15 21:38:52','2013-06-08 03:43:00'),
('5','2','5','application/x-sh','15','http://hyatt.com/','2003-12-24 13:27:01','1974-05-10 23:22:17'),
('6','3','6','application/xcap-diff+xml','4','http://grady.com/','1973-09-26 14:28:19','1996-08-20 15:58:23'),
('7','1','7','video/vnd.mpegurl','575762','http://bernier.net/','2010-10-22 03:45:56','1977-04-02 13:38:41'),
('8','2','8','application/mathml+xml','874699134','http://wiza.biz/','2006-09-24 13:24:07','2018-06-20 17:54:37'),
('9','3','9','audio/vnd.dece.audio','64788642','http://www.langosh.com/','1979-07-20 02:12:01','1981-06-23 05:40:14'),
('10','1','10','application/vnd.kde.kontour','0','http://www.pagac.com/','2013-07-30 11:06:34','2013-11-26 01:55:47'),
('11','2','11','application/jsonml+json','8596','http://www.heathcote.com/','2006-06-16 09:27:51','1999-11-15 04:33:46'),
('12','3','12','text/vnd.curl.mcurl','328189145','http://rosenbaum.com/','1978-06-26 17:31:36','2014-05-03 08:30:05'),
('13','1','13','image/x-icon','692','http://www.tremblaystrosin.biz/','1996-04-09 12:36:37','1994-12-03 18:03:00'),
('14','2','14','text/csv','941','http://www.treutel.info/','1996-01-30 08:00:15','2003-04-13 19:25:27'),
('15','3','15','audio/x-ms-wma','713849794','http://www.keeblermcclure.com/','2015-01-22 06:50:22','1991-06-24 08:01:08'),
('16','1','16','video/x-msvideo','174917','http://www.quigley.info/','1994-10-18 04:00:22','2010-07-31 19:50:52'),
('17','2','17','application/vnd.openxmlformats-officedocument.wordprocessingml.template','7','http://www.casperkuhn.com/','2007-02-20 21:06:52','1978-01-18 09:20:33'),
('18','3','18','application/xv+xml','522','http://www.hackettmoore.biz/','2003-10-07 21:23:47','1985-10-19 20:30:02'),
('19','1','19','text/x-nfo','3','http://raynor.info/','2008-06-14 21:15:29','1994-08-01 08:48:28'),
('20','2','20','application/vnd.xfdl','80','http://schneider.com/','2000-02-14 12:42:04','1970-05-10 01:57:36'),
('21','3','21','application/x-bittorrent','4','http://ohara.info/','1993-07-29 06:00:29','1970-10-31 03:07:15'),
('22','1','22','application/pkixcmp','9','http://walter.net/','2004-04-03 12:42:53','1990-02-12 17:17:52'),
('23','2','23','application/vnd.hal+xml','726595334','http://wyman.com/','2004-06-21 18:45:14','1989-07-17 22:31:28'),
('24','3','24','video/jpeg','654','http://mayertfranecki.net/','2002-06-09 21:59:43','1991-12-08 19:37:20'),
('25','1','25','application/vnd.visio','21832519','http://www.steuberkunze.com/','1986-10-08 21:45:32','1998-12-16 14:09:23'),
('26','2','26','application/vnd.sema','207540637','http://kubkessler.biz/','1988-09-22 09:53:33','1984-09-28 15:35:47'),
('27','3','27','application/vnd.openxmlformats-officedocument.presentationml.slide','52112219','http://www.tremblaygutmann.net/','1991-12-21 21:46:13','1978-03-27 05:29:32'),
('28','1','28','audio/x-pn-realaudio-plugin','692','http://www.bogisich.info/','1981-09-21 19:58:06','2006-11-06 19:52:53'),
('29','2','29','application/vnd.symbian.install','0','http://www.quitzonsimonis.com/','1979-01-09 11:19:42','2006-01-19 05:02:21'),
('30','3','30','application/vnd.ms-works','28','http://www.orn.com/','1976-08-09 07:36:19','1982-11-20 23:56:01'),
('31','1','31','video/vnd.dece.pd','9426','http://bartonquigley.net/','2001-04-27 17:04:20','2010-03-16 14:30:17'),
('32','2','32','application/vnd.dvb.ait','988','http://pfefferconnelly.net/','1990-11-11 12:39:50','1993-04-13 16:48:19'),
('33','3','33','video/vnd.dece.video','653318','http://www.langosh.com/','1973-01-20 13:17:54','1981-10-20 00:36:04'),
('34','1','34','image/x-rgb','43980607','http://bartolettirenner.info/','1982-12-04 02:27:18','1976-08-10 22:14:48'),
('35','2','35','application/vnd.dece.ttml+xml','38496302','http://rath.net/','2009-02-20 21:16:13','2009-03-14 12:36:16'),
('36','3','36','image/x-portable-pixmap','560671604','http://bergnaum.com/','1989-09-18 02:44:53','1983-12-21 07:41:18'),
('37','1','37','application/vnd.dynageo','103873683','http://www.bradtke.com/','1974-04-17 18:50:29','1984-09-24 01:45:16'),
('38','2','38','audio/x-mpegurl','79971','http://www.mitchell.com/','2006-02-25 17:48:43','2018-08-27 19:48:59'),
('39','3','39','video/x-f4v','3769378','http://www.leannon.org/','1991-04-26 17:53:03','1982-01-23 22:41:12'),
('40','1','40','application/x-tar','35296','http://www.hammesheathcote.com/','1973-03-26 15:19:50','1979-01-03 00:53:23'),
('41','2','41','application/x-ms-wmz','265675','http://www.hamill.org/','1995-01-03 13:45:38','2001-11-15 16:28:16'),
('42','3','42','application/vnd.ms-pki.seccat','9621','http://www.schambergermcglynn.com/','1995-12-02 21:04:57','1972-08-26 07:42:16'),
('43','1','43','application/x-conference','0','http://wiza.org/','1976-08-06 10:14:55','1975-07-29 11:40:22'),
('44','2','44','application/x-silverlight-app','0','http://www.price.com/','1999-11-09 19:04:10','2016-11-27 17:41:07'),
('45','3','45','application/vnd.kodak-descriptor','863308916','http://www.wyman.info/','2012-05-01 17:40:47','1985-07-31 18:46:46'),
('46','1','46','application/vnd.epson.quickanime','171529','http://www.cummings.org/','1984-08-22 10:59:21','1994-02-19 21:09:26'),
('47','2','47','application/x-font-type1','9064','http://www.marvin.com/','1982-09-15 18:47:34','1986-01-04 19:49:51'),
('48','3','48','model/vnd.collada+xml','304908623','http://www.welch.net/','1992-07-15 04:36:38','1989-10-06 06:45:58'),
('49','1','49','application/vnd.oasis.opendocument.chart','8','http://www.hintz.com/','2006-03-07 16:43:02','1976-06-22 16:49:55'),
('50','2','50','application/vnd.shana.informed.interchange','4','http://www.kunze.com/','2002-01-10 13:55:38','1979-03-08 14:41:26'),
('51','3','51','application/x-bittorrent','0','http://www.trantow.info/','2002-03-22 18:57:41','1989-02-05 17:02:38'),
('52','1','52','application/x-cfs-compressed','5','http://www.tremblaygleason.com/','2012-12-14 02:43:05','2004-01-25 04:30:35'),
('53','2','53','application/vnd.svd','9268173','http://www.kulas.com/','1996-09-17 18:02:40','1990-04-06 14:50:40'),
('54','3','54','video/x-matroska','47388','http://www.green.com/','1986-12-15 07:49:12','1998-10-29 10:01:10'),
('55','1','55','application/reginfo+xml','649102544','http://hagenesquitzon.com/','1978-04-12 19:22:23','1990-01-12 17:48:23'),
('56','2','56','video/x-matroska','6695563','http://www.leannonreilly.com/','2014-10-17 14:24:45','2012-06-18 21:26:44'),
('57','3','57','application/xhtml+xml','144410986','http://kris.info/','2005-05-28 15:06:58','1985-05-27 04:03:01'),
('58','1','58','audio/adpcm','18911767','http://www.rolfson.com/','1978-11-13 15:56:02','1990-03-25 17:52:49'),
('59','2','59','application/vnd.kde.kontour','931','http://christiansenrobel.info/','2017-08-09 09:49:41','1980-03-17 18:59:15'),
('60','3','60','image/ktx','0','http://goyette.com/','2013-06-10 06:58:44','2007-02-16 08:22:01'),
('61','1','61','application/vnd.rn-realmedia','443','http://www.walker.org/','1990-11-25 06:42:08','1976-05-29 10:40:21'),
('62','2','62','application/vnd.llamagraphics.life-balance.exchange+xml','115116','http://keeling.com/','2014-12-25 05:51:55','1981-05-31 09:40:37'),
('63','3','63','audio/x-wav','633','http://prosacco.biz/','2009-07-22 21:19:40','2011-02-05 07:29:52'),
('64','1','64','text/vcard','0','http://kuhlman.com/','1971-10-07 20:16:49','1970-05-12 00:08:49'),
('65','2','65','application/vnd.tcpdump.pcap','503','http://mitchell.com/','1995-08-11 07:54:32','1980-10-17 12:53:32'),
('66','3','66','application/x-tar','365917875','http://www.wintheiser.com/','1987-07-17 19:25:26','2006-01-26 17:07:46'),
('67','1','67','text/n3','3','http://murazik.net/','2003-08-20 02:45:53','1982-07-06 15:37:07'),
('68','2','68','application/x-dgc-compressed','0','http://www.caspermraz.biz/','2019-07-27 16:47:47','2006-10-29 20:50:28'),
('69','3','69','application/vnd.musician','0','http://www.emardoreilly.biz/','2005-12-19 16:08:43','1990-04-25 03:35:19'),
('70','1','70','application/vnd.trueapp','742','http://www.johns.com/','2015-05-27 04:43:43','1971-10-09 22:10:06'),
('71','2','71','application/vnd.tmobile-livetv','36339','http://bernierrunte.com/','1980-06-14 18:38:55','1992-06-03 21:30:38'),
('72','3','72','application/mets+xml','596','http://mayer.com/','1987-01-11 19:06:25','1977-03-06 23:03:11'),
('73','1','73','application/vnd.kde.kivio','97530992','http://www.langworth.com/','2006-02-22 17:39:42','1974-01-21 21:25:27'),
('74','2','74','application/xspf+xml','0','http://pacocha.com/','1993-07-27 20:59:27','1999-07-04 16:51:35'),
('75','3','75','application/atom+xml','0','http://crooks.com/','2018-04-06 06:45:09','1999-09-23 09:12:58'),
('76','1','76','application/vnd.hydrostatix.sof-data','102074408','http://labadie.com/','1989-12-05 14:17:56','2017-09-14 04:01:19'),
('77','2','77','image/ief','7743638','http://www.bayer.com/','2019-07-10 00:27:00','2002-11-06 23:31:59'),
('78','3','78','application/vnd.llamagraphics.life-balance.exchange+xml','0','http://www.howe.com/','1989-11-23 02:00:16','2009-01-11 05:35:37'),
('79','1','79','application/vnd.wqd','0','http://heathcote.com/','1972-10-23 07:34:28','2017-05-19 17:06:15'),
('80','2','80','application/vnd.ms-pki.seccat','33715','http://www.bayer.info/','1995-04-18 15:53:20','1983-09-02 14:55:49'),
('81','3','81','text/uri-list','0','http://www.kemmerlakin.com/','2004-05-31 09:16:15','2015-06-24 02:47:38'),
('82','1','82','application/vnd.syncml+xml','94','http://www.mertz.org/','1980-12-23 20:46:44','1985-08-23 11:38:40'),
('83','2','83','image/vnd.fastbidsheet','27204','http://www.hauckmurphy.info/','1994-04-21 15:42:12','1983-08-12 22:07:24'),
('84','3','84','application/vnd.shana.informed.formdata','44936182','http://www.pfeffer.com/','2005-06-10 04:24:17','1975-09-13 04:17:58'),
('85','1','85','application/pdf','92186','http://rath.com/','1987-11-20 22:54:09','2006-01-17 03:24:41'),
('86','2','86','text/vnd.wap.wmlscript','1312','http://www.mooreframi.com/','1978-06-11 22:20:51','1990-02-09 02:07:19'),
('87','3','87','video/x-flv','461366325','http://www.beierflatley.com/','2009-04-29 05:22:21','1977-04-01 04:33:41'),
('88','1','88','application/vnd.rn-realmedia','7669','http://conn.com/','2015-03-09 17:26:14','2006-03-15 05:32:25'),
('89','2','89','video/jpm','8','http://www.stoltenberglynch.net/','1985-06-29 20:59:32','1975-07-23 01:43:03'),
('90','3','90','application/xcap-diff+xml','782','http://von.com/','2019-05-26 17:58:35','1994-05-14 11:46:14'),
('91','1','91','application/vnd.sun.xml.draw','2581','http://www.kerlukepowlowski.com/','2012-12-06 11:09:21','2007-07-11 11:43:49'),
('92','2','92','application/xhtml+xml','546','http://www.rice.com/','1988-02-19 06:39:29','1999-02-20 20:43:03'),
('93','3','93','application/rss+xml','746','http://www.ward.biz/','2000-03-27 03:41:09','1988-11-27 15:04:23'),
('94','1','94','video/vnd.uvvu.mp4','9174','http://www.gradydach.org/','2014-09-07 18:49:30','1981-01-07 08:39:24'),
('95','2','95','application/x-silverlight-app','8831','http://www.towne.info/','1985-07-22 03:44:37','1983-07-03 02:19:10'),
('96','3','96','application/jsonml+json','71200','http://www.gerlachzemlak.com/','1989-12-24 20:43:47','1990-09-07 03:06:05'),
('97','1','97','image/x-rgb','594','http://www.turcottemacejkovic.com/','1986-01-20 04:35:00','2011-07-24 16:14:14'),
('98','2','98','application/vnd.sun.xml.writer','25037','http://www.nienow.com/','1996-12-11 05:46:39','1981-10-20 19:51:51'),
('99','3','99','application/vnd.uiq.theme','34','http://pfeffer.com/','1970-01-14 14:37:26','1972-07-09 04:21:17'),
('100','1','100','video/webm','22280','http://www.hagenes.net/','2015-02-15 18:39:53','1992-08-24 03:07:10'); 




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

