-- Generation time: Sun, 11 Aug 2019 13:44:14 +0000
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

DROP TABLE IF EXISTS `communities`;
CREATE TABLE `communities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `communities` VALUES ('49','accusamus'),
('11','ad'),
('76','alias'),
('36','aliquam'),
('48','aliquid'),
('78','animi'),
('51','asperiores'),
('91','aspernatur'),
('62','assumenda'),
('46','at'),
('13','aut'),
('81','autem'),
('29','beatae'),
('45','blanditiis'),
('31','corporis'),
('92','corrupti'),
('32','culpa'),
('75','cupiditate'),
('39','debitis'),
('100','deleniti'),
('59','deserunt'),
('61','dignissimos'),
('18','dolor'),
('47','doloribus'),
('70','ducimus'),
('82','eaque'),
('4','earum'),
('66','enim'),
('8','eos'),
('80','est'),
('37','et'),
('85','eum'),
('94','facilis'),
('10','fugiat'),
('43','harum'),
('97','id'),
('95','illum'),
('53','impedit'),
('24','in'),
('96','inventore'),
('67','ipsa'),
('21','ipsam'),
('86','ipsum'),
('79','iste'),
('7','itaque'),
('64','iure'),
('54','labore'),
('65','laboriosam'),
('93','laborum'),
('6','magni'),
('89','maiores'),
('84','maxime'),
('15','minima'),
('58','minus'),
('98','modi'),
('83','molestiae'),
('16','nam'),
('35','natus'),
('19','necessitatibus'),
('14','neque'),
('3','nesciunt'),
('57','nihil'),
('71','non'),
('50','occaecati'),
('60','odit'),
('27','omnis'),
('30','perferendis'),
('28','perspiciatis'),
('55','placeat'),
('56','possimus'),
('52','provident'),
('22','quaerat'),
('1','quam'),
('63','quasi'),
('9','qui'),
('42','quia'),
('68','quidem'),
('17','quis'),
('77','quo'),
('25','quod'),
('38','quos'),
('23','ratione'),
('41','repellat'),
('87','repudiandae'),
('72','rerum'),
('33','sapiente'),
('12','sed'),
('40','sequi'),
('74','sint'),
('34','sit'),
('5','sunt'),
('69','temporibus'),
('90','tenetur'),
('73','ullam'),
('99','unde'),
('20','velit'),
('44','veniam'),
('2','voluptas'),
('26','voluptatem'),
('88','voluptates'); 




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

