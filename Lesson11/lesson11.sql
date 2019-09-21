-- 1.

DROP TABLE IF EXISTS `logs`;

CREATE TABLE `logs` (
  id int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at datetime DEFAULT current_timestamp(),
  tablename varchar(50) NOT NULL,
  table_record_id int(10) NOT NULL,
  contet_of_name varchar(255)
) ENGINE=ARCHIVE;

DELIMITER //

DROP TRIGGER IF EXISTS write_product_log_insert;

CREATE TRIGGER write_product_log_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
 INSERT INTO `logs` (tablename, table_record_id, contet_of_name)
 VALUES ('products', (SELECT NEW.id), (SELECT NEW.name));
END//

DROP TRIGGER IF EXISTS write_users_log_insert;

CREATE TRIGGER write_users_log_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
 INSERT INTO `logs` (tablename, table_record_id, contet_of_name)
 VALUES ('users', (SELECT NEW.id), (SELECT NEW.name));
END//

DROP TRIGGER IF EXISTS write_catalogs_log_insert;

CREATE TRIGGER write_catalogs_log_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
 INSERT INTO `logs` (tablename, table_record_id, contet_of_name)
 VALUES ('catalogs', (SELECT NEW.id), (SELECT NEW.name));
END//


INSERT INTO products (name) VALUES ('probe');
INSERT INTO users (name) VALUES ('probe');
INSERT INTO catalogs (name) VALUES ('probe');
/*
mysql> select * from logs//
+----+---------------------+-----------+-----------------+----------------+
| id | created_at          | tablename | table_record_id | contet_of_name |
+----+---------------------+-----------+-----------------+----------------+
|  1 | 2019-09-20 17:58:57 | products  |               8 | NULL           |
|  2 | 2019-09-20 18:03:51 | products  |               9 | probe          |
|  3 | 2019-09-20 18:03:51 | users     |              11 | probe          |
|  4 | 2019-09-20 18:03:51 | catalogs  |               6 | probe          |
+----+---------------------+-----------+-----------------+----------------+
4 rows in set (0.00 sec)

mysql> 
*/

-- 2.
DROP PROCEDURE IF EXISTS millions;

CREATE PROCEDURE millions()
BEGIN
  DECLARE i INT DEFAULT 1000000;
  WHILE i > 0 DO
	INSERT INTO users (name) VALUES ('millions');
	SET i = i - 1;
  END WHILE;
END//

CALL millions();

-- это нагуглил)
CREATE OR REPLACE VIEW generator_16
AS SELECT 0 n UNION ALL SELECT 1  UNION ALL SELECT 2  UNION ALL 
   SELECT 3   UNION ALL SELECT 4  UNION ALL SELECT 5  UNION ALL
   SELECT 6   UNION ALL SELECT 7  UNION ALL SELECT 8  UNION ALL
   SELECT 9   UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
   SELECT 12  UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL 
   SELECT 15;

CREATE OR REPLACE VIEW generator_256
AS SELECT ( ( hi.n << 4 ) | lo.n ) AS n
     FROM generator_16 lo, generator_16 hi;

CREATE OR REPLACE VIEW generator_4k
AS SELECT ( ( hi.n << 8 ) | lo.n ) AS n
     FROM generator_256 lo, generator_16 hi;

CREATE OR REPLACE VIEW generator_64k
AS SELECT ( ( hi.n << 8 ) | lo.n ) AS n
     FROM generator_256 lo, generator_256 hi;

CREATE OR REPLACE VIEW generator_1m
AS SELECT ( ( hi.n << 16 ) | lo.n ) AS n
     FROM generator_64k lo, generator_16 hi;
/*
mysql> select count(*) from generator_1m//
+----------+
| count(*) |
+----------+
|  1048576 |
+----------+*/


-- Практическое задание тема №10
-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

INCR ip:487.298.347.12
-- и так с каждым ip. Когда нам надо извлечь счетчик по каждому ip пишем
GET ip:487.298.347.12
-- получаем значение счетчика по этому ip

-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.

/* Можно информацию для фильтрации и поиска вставить в ключ, а подробную информацию в его значение. Если информации много, то используем хэши, в нашем случае достаточно просто SET*/

 SET leonid:lkashin@gmail.com 'Leonid Kashin'
 SET ivan:iivanov@gmail.com 'Ivan Ivanov'
 SET oleg:onabatov@gmail.com 'Oleg Nabatov'
 
 KEYS leonid*
 KEYS *:lkashin@gmail.com
 
 -- и всех найдем
 
-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.

-- то есть я понял так, что все позиции вбиваются по подобному принципу:
db.shop.insert({id: '000001'}, {$set: { name: 'Intel Core i3-8100', description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', price: '7890.00', category: 'Процессоры'}})

-- и дальше уже ищем по вложенным ключам...