-- Урок 10
-- Транзакции, переменные, представления
-- Хранимые процедуры и функции, триггеры
-- Индексы, денормализация

















-- Практическое задание по БД vk
-- Вариант решения Станислава Пологрудова

USE vk;

-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользоваетелем.

-- Вариант на JOIN:
-- Начал с самого начала - друзья в обе стороны:

SELECT CONCAT(u.firstname, ' ', u.lastname) as friend FROM
		users AS u
	INNER JOIN
		friendship AS f
			ON u.id = f.friend_id AND f.user_id = 1 
			OR u.id = f.user_id AND f.friend_id = 1;
		
-- friend              |
-- --------------------|
-- Merle Berge         |
-- Dedric Mayer        |
-- Dominique Morissette|

		
-- Теперь сообщения в обе стороны от этих друзей:
		
SELECT CONCAT(u.firstname, ' ', u.lastname) as friend FROM
		users AS u
	INNER JOIN
		friendship AS f
			ON u.id = f.friend_id AND f.user_id = 1 
			OR u.id = f.user_id AND f.friend_id = 1
	INNER JOIN
		messages AS m
			ON u.id = m.from_user_id AND m.to_user_id = 1 
			OR u.id = m.to_user_id AND m.from_user_id = 1;
		
-- friend              |
-- --------------------|
-- Dedric Mayer        |
-- Dedric Mayer        |
-- Dedric Mayer        |
-- Dedric Mayer        |
-- Dominique Morissette|
		
-- Ну и аггрегация, сортировка и лимит:

SELECT CONCAT(u.firstname, ' ', u.lastname) as friend, COUNT(*) as messages FROM
		users AS u
	INNER JOIN
		friendship AS f
			ON u.id = f.friend_id AND f.user_id = 1 
			OR u.id = f.user_id AND f.friend_id = 1
	INNER JOIN
		messages AS m
			ON u.id = m.from_user_id AND m.to_user_id = 1 
			OR u.id = m.to_user_id AND m.from_user_id = 1
GROUP BY friend
ORDER BY messages DESC
LIMIT 1;

-- friend      |messages|
-- ------------|--------|
-- Dedric Mayer|       4|

-- Вроде всё. Заметно чище и проще запрос получился.



-- 2. Количество лайков 10 самым молодым пользователям

-- Вариант через JOIN
-- Выводим лайки для 10 самых молодых пользователей, 
-- а также лайки для их медиа и сообщений.

SELECT 	
		CONCAT(u.firstname, ' ', u.lastname) as user, 
		count(l.id) as count, 
		TIMESTAMPDIFF(YEAR, p.birthday, NOW()) AS age
			FROM users AS u
		INNER JOIN profiles AS p
			ON p.user_id = u.id
		LEFT JOIN media as m
			ON m.user_id = u.id
		LEFT JOIN messages as t
			ON t.from_user_id = u.id
		LEFT JOIN
			likes AS l
				ON l.item_id = u.id AND l.like_type_id = 2 -- лайки для самих пользователей
				OR l.item_id = m.id AND l.like_type_id = 1 -- лайки для их медиа
				OR l.item_id = t.id AND l.like_type_id = 3 -- лайки для их сообщений
		GROUP BY u.id
		ORDER BY p.birthday DESC
	LIMIT 10;

-- user              |count|age|
-- ------------------|-----|---|
-- Evalyn Purdy      |    1|  0|
-- Faye Johns        |    0|  0|
-- Sheila Kulas      |    0|  0|
-- Lupe Nolan        |    1|  0|
-- Mohamed Williamson|    0|  1|
-- Corrine Toy       |    0|  2|
-- Shayne Kuhlman    |    1|  2|
-- Mable Wolf        |    1|  4|
-- Meggie Price      |    0|  4|
-- Jerrod Daugherty  |    1|  4|


-- Просуммируем

SELECT SUM(count) as overall FROM (
	SELECT 	
		CONCAT(u.firstname, ' ', u.lastname) as user, 
		count(l.id) as count, 
		TIMESTAMPDIFF(YEAR, p.birthday, NOW()) AS age
			FROM users AS u
		INNER JOIN profiles AS p
			ON p.user_id = u.id
		LEFT JOIN media as m
			ON m.user_id = u.id
		LEFT JOIN messages as t
			ON t.from_user_id = u.id
		LEFT JOIN
			likes AS l
				ON l.item_id = u.id AND l.like_type_id = 2
				OR l.item_id = m.id AND l.like_type_id = 1
				OR l.item_id = t.id AND l.like_type_id = 3
		GROUP BY u.id
		ORDER BY p.birthday DESC
	LIMIT 10) AS likes;

-- overall|
-- -------|
--       5|



-- 3. Кто больше поставил лайков, мужчины или женщины

-- Через JOIN:

SELECT CASE(p.sex)
		WHEN 'm' THEN 'male'
		WHEN 'f' THEN 'female'
	END AS sex, 
	COUNT(*) AS likes_count FROM 
			vk.likes AS l
		INNER JOIN 
			vk.profiles AS p 
		ON p.user_id = l.user_id
	GROUP BY sex;

-- sex   |likes_count|
-- ------|-----------|
-- female|         51|
-- male  |         47|



-- 4. 10 наименее активных пользователей
-- Вариант на JOIN:

SELECT CONCAT(u.firstname, ' ', u.lastname) AS user, 
	COUNT(l.id) + COUNT(m.id) + COUNT(t.id) AS overall_activity
		FROM users AS u
	LEFT JOIN
		likes AS l
			ON l.user_id = u.id
	LEFT JOIN
		media AS m
			ON m.user_id = u.id
	LEFT JOIN
		messages AS t
			ON t.from_user_id = u.id
	GROUP BY u.id
	ORDER BY overall_activity
	LIMIT 10;

-- user               |overall_activity|
-- -------------------|----------------|
-- Joseph Gleason     |               0|
-- Theresa Ryan       |               0|
-- Waylon Grady       |               0|
-- Carroll Blick      |               0|
-- Lupe Nolan         |               1|
-- Morgan Pfannerstill|               1|
-- Margarita Doyle    |               1|
-- Patricia Wyman     |               1|
-- Shayne Kuhlman     |               1|
-- Orlo Cassin        |               1|

-- Выборка получилась слегка отличающаяся, просто тех, у кого 1 публикация довольно много
-- Из них не выбрать наименее активных уже )

-- Другой критерий - насколько давно пользователь постил что-либо последний раз, лайкал или общался с кем-либо.
-- Вариант на JOIN:

SELECT CONCAT(u.firstname, ' ', u.lastname) AS user, GREATEST(
	IFNULL(MAX(l.created_at), 0), 
	IFNULL(MAX(m.created_at), 0),
	IFNULL(MAX(t.created_at), 0)) AS last_activity_date
		FROM users AS u
	LEFT JOIN 
		likes AS l
			ON l.user_id = u.id
	LEFT JOIN
		media AS m
			ON m.user_id = u.id
	LEFT JOIN
		messages AS t 
			ON t.from_user_id = u.id
	GROUP BY u.id
	ORDER BY last_activity_date
	LIMIT 10;

-- user           |last_activity_date |
-- ---------------|-------------------|
-- Carroll Blick  |0                  |
-- Theresa Ryan   |0                  |
-- Waylon Grady   |0                  |
-- Joseph Gleason |0                  |
-- Lupe Nolan     |1970-03-29 13:33:46|
-- Mozelle Bins   |1975-08-23 16:48:24|
-- Keyshawn Roob  |1977-03-30 09:56:06|
-- Orlo Cassin    |1977-04-26 08:08:16|
-- Margarita Doyle|1977-12-15 19:27:19|
-- Shayne Kuhlman |1980-10-28 19:17:09|

-- В этом методе всё один в один сходится..



-- Практическое задание по теме 6 “Транзакции, переменные, представления”
-- Варианты решения Николая Золотых

-- 1. В базе данных shop и sample присутствуют одни и те же таблицы,
-- учебной базы данных. Переместите запись id = 1 из таблицы shop.users
-- в таблицу sample.users. Используйте транзакции.

CREATE DATABASE IF NOT EXISTS shop;
USE shop;
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	age INT UNSIGNED
);

INSERT INTO users (name, age) VALUES ('Kasablanka', 45), ('Cheburashka', 7), ('VladimirVladimirovi4', 66);

CREATE DATABASE IF NOT EXISTS sample;
USE sample;
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	age INT UNSIGNED
);

INSERT INTO users (name, age) VALUES ('Obama', 33), ('Deniska', 11);

USE sample;
SELECT * FROM users;
USE shop;
SELECT * FROM users;

--  -----------------------------------------------------------------------------------
START TRANSACTION;

INSERT INTO sample.users (name, age) 
  SELECT name, age FROM shop.users WHERE id = 1;
      
DELETE FROM shop.users WHERE id = 1;
COMMIT;

USE sample;
SELECT * FROM users;
USE shop;
SELECT * FROM users;

-- 2. Создайте представление, которое выводит название name товарной
-- позиции из таблицы products и соответствующее название каталога name
-- из таблицы catalogs.

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

-- ------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW prod_cat_names AS
    SELECT p.name 'item', c.name 'catalog' 
      FROM products p 
        JOIN catalogs c 
          ON p.catalog_id = c.id;
           
SELECT * FROM prod_cat_names;

DROP VIEW prod_cat_names;

-- 3. (по желанию) Пусть имеется таблица с календарным полем created_at.
-- В ней размещены разряженые календарные записи за август 2018 года
-- '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос,
-- который выводит полный список дат за август, выставляя в соседнем поле
-- значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS aug;
CREATE TABLE aug (created_at DATE);
INSERT INTO aug VALUES ('2018-08-01'), ('2018-08-04'), ('2018-08-16'), ('2018-08-17');

DROP TABLE IF EXISTS aug_full;
CREATE TEMPORARY TABLE aug_full (created_at DATE);
INSERT INTO aug_full VALUES
	('2018-08-01'), ('2018-08-02'), ('2018-08-03'), ('2018-08-04'), ('2018-08-05'),
	('2018-08-06'), ('2018-08-07'), ('2018-08-08'), ('2018-08-09'), ('2018-08-10'),	
	('2018-08-11'), ('2018-08-12'), ('2018-08-13'), ('2018-08-14'), ('2018-08-15'),
	('2018-08-16'), ('2018-08-17'), ('2018-08-18'), ('2018-08-19'), ('2018-08-20'),
	('2018-08-21'), ('2018-08-22'), ('2018-08-23'), ('2018-08-24'), ('2018-08-25'),
	('2018-08-26'), ('2018-08-27'), ('2018-08-28'), ('2018-08-29'), ('2018-08-30'), ('2018-08-31');

SELECT 
    f.created_at AS created_at, 
    COUNT(a.created_at) AS is_in_aug
  FROM aug_full AS f 
  LEFT JOIN aug AS a 
    ON f.created_at = a.created_at 
 GROUP BY created_at 
 ORDER BY created_at;


-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at.
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя
-- только 5 самых свежих записей.

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS sample;
CREATE TABLE sample (id SERIAL PRIMARY KEY, created_at DATE);
INSERT INTO sample (created_at) VALUES 
    (FROM_UNIXTIME(RAND() * 2147483647)), 
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647)),
    (FROM_UNIXTIME(RAND() * 2147483647));
SELECT * FROM sample;

DROP TABLE IF EXISTS temp;
CREATE TEMPORARY TABLE temp (id SERIAL PRIMARY KEY, created_at DATE);
INSERT INTO temp SELECT * FROM sample ORDER BY created_at DESC LIMIT 5;
TRUNCATE TABLE sample;
INSERT INTO sample SELECT * FROM temp; 

DELETE FROM sample WHERE created_at NOT IN (SELECT created_at FROM temp);

SELECT * FROM sample;



-- Практическое задание по теме 7 “Администрирование MySQL”
-- (эта тема изучается по вашему желанию)

-- 1. Создайте двух пользователей которые имеют доступ к базе данных shop.
-- Первому пользователю shop_read должны быть доступны только запросы на
-- чтение данных, второму пользователю shop — любые операции в пределах
-- базы данных shop.

SELECT Host, User FROM mysql.user;

DROP USER IF EXISTS 'shop_read';
CREATE USER 'shop_read';
GRANT SELECT ON shop.* TO 'shop_read';

DROP USER IF EXISTS 'shop';
CREATE USER 'shop';
GRANT ALL ON shop.* TO 'shop';

SELECT Host, User FROM mysql.user;

-- 2. (по желанию) Пусть имеется таблица accounts содержащая три столбца
-- id, name, password, содержащие первичный ключ, имя пользователя и его
-- пароль. Создайте представление username таблицы accounts, предоставляющий
-- доступ к столбцам id и name. Создайте пользователя user_read, который бы
-- не имел доступа к таблице accounts, однако, мог бы извлекать записи из
-- представления username.

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	password VARCHAR(100)
);

INSERT INTO accounts (name, password) VALUES ('Deniska', '123'), ('Obama', 'qwerty'), ('4eburashka', 'HksdntR552_!');

SELECT * FROM accounts;

-- --------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW username AS
    SELECT a.id, a.name FROM accounts a; 
SELECT * FROM username;

SELECT Host, User FROM mysql.user;

DROP USER IF EXISTS 'user_read';
CREATE USER 'user_read';
GRANT SELECT ON shop.username TO 'user_read';

SELECT Host, User FROM mysql.user;

-- Практическое задание по теме 8 “Хранимые процедуры и функции, триггеры"

-- 1.Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна
-- возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать
-- фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DELIMITER //

DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
    DECLARE hour TIME DEFAULT HOUR(CURTIME());
    IF hour >= 6 AND hour < 12 THEN RETURN 'Доброе утро!';
    ELSEIF hour >= 12 AND hour < 18 THEN RETURN 'Добрый день!';
    ELSEIF hour >= 18 AND hour <= 23 THEN RETURN 'Добрый вечер!';
    ELSE RETURN 'Доброй ночи!';
    END IF;
END//

SELECT hello()//

DELIMITER ;

-- 2. В таблице products есть два текстовых поля: name с названием товара и
-- description с его описанием. Допустимо присутствие обоих полей или одно
-- из них. Ситуация, когда оба поля принимают неопределенное значение NULL
-- неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих
-- полей или оба поля были заполнены. При попытке присвоить полям NULL
---значение необходимо отменить операцию.

CREATE DATABASE IF NOT EXISTS shop;
USE shop;
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание'
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.'),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.'),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.');
SELECT * FROM products;

-- ------------------------------------------------------------------------------------------------------------------------
DELIMITER //

CREATE TRIGGER check_not_null_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF 'null_try' = COALESCE(NEW.name, NEW.description, 'null_try') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Canceled. Input name or description!';
    END IF;
END//

CREATE TRIGGER check_not_null_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF 'null_try' = COALESCE(NEW.name, NEW.description, 'null_try') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Canceled. Name or description required!';
    END IF;
END//

DELIMITER ;

INSERT INTO products (name, description) VALUES ('AMD 3600', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD');
SELECT * FROM products;
INSERT INTO products (name, description) VALUES (NULL, 'Процессор для настольных персональных компьютеров, основанных на платформе AMD');
SELECT * FROM products;
INSERT INTO products (name, description) VALUES (NULL, NULL);
SELECT * FROM products;
UPDATE products SET name = NULL WHERE id = 1;
SELECT * FROM products;
UPDATE products SET description = NULL WHERE id = 1;
SELECT * FROM products;

-- 3. (по желанию) Напишите хранимую функцию для вычисления произвольного
-- числа Фибоначчи. Числами Фибоначчи называется последовательность в
-- которой число равно сумме двух предыдущих чисел. Вызов функции
-- FIBONACCI(10) должен возвращать число 55.

CREATE DATABASE IF NOT EXISTS shop;
USE shop;

DELIMITER //

DROP FUNCTION IF EXISTS fib;
CREATE FUNCTION fib(num INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE x, y INT DEFAULT 1;
    DECLARE i INT DEFAULT 2;
    WHILE i < num DO
	SET y = x + y;
	SET x = y - x;
	SET i = i + 1;
    END WHILE;
    RETURN y;
END//

DELIMITER ;

SELECT fib(10);
SELECT fib(5);
SELECT fib(20);


DROP FUNCTION IF EXISTS friendship_direction;

DELIMITER //
CREATE FUNCTION friendship_direction(check_user_id INT)
RETURNS FLOAT READS SQL DATA

  BEGIN
    
    DECLARE requests_to_user INT;
    DECLARE requests_from_user INT;
    
    SET requests_to_user = 
      (SELECT COUNT(*) 
        FROM friendship
          WHERE friend_id = check_user_id);
    
    SET requests_from_user = 
      (SELECT COUNT(*) 
        FROM friendship
          WHERE user_id = check_user_id);
    
    RETURN requests_to_user / requests_from_user;
  END//
  
DELIMITER ;

SELECT TRUNCATE(friendship_direction(7), 2) AS friendship_direction;







DROP PROCEDURE IF EXISTS friendship_offers;

DELIMITER //

CREATE PROCEDURE friendship_offers (IN for_user_id INT)

  BEGIN 
    (
      SELECT pr2.user_id
        FROM profiles pr1
          JOIN profiles pr2
            ON pr1.hometown = pr2.hometown
        WHERE pr1.user_id = for_user_id
      
      UNION
      
      SELECT cu2.user_id
        FROM communities_users cu1
          JOIN communities_users cu2
            ON cu1.community_id = cu2.community_id
        WHERE cu1.user_id = for_user_id
      
      UNION
    
      SELECT DISTINCT(fr3.user_id)
        FROM friendship fr1
          JOIN friendship fr2
            ON fr1.friend_id = fr2.user_id
          JOIN friendship fr3
            ON fr2.friend_id = fr3.user_id
        WHERE fr1.user_id = for_user_id
          AND fr2.status IS TRUE
          AND fr3.status IS TRUE
    )
        
    ORDER BY RAND()
    LIMIT 5;
     
END//
  
DELIMITER ;

CALL friendship_offers(1);



SELECT id, firstname, lastname 
  FROM users 
    WHERE email = 'ullrich.adella@example.net';
    
    
CREATE INDEX users_email_idx ON users(email);


SELECT * FROM profiles ORDER BY birthday;

CREATE INDEX profiles_birthday_idx ON profiles(birthday);

CREATE UNIQUE INDEX users_email_uq ON users(email);

SELECT * FROM media WHERE user_id = 9 AND media_type_id = 3;

CREATE INDEX media_user_id_media_type_id_idx ON media(user_id, media_type_id);

SELECT * FROM media WHERE media_type_id = 9 AND user_id = 3;

media_user_id_media_type_id_idx
13
24
33
....


-- Приактика

-- Хранимые процедуры и функции

-- 1. Создаём функцию

-- Направленность дружбы
-- Кол-во приглашений в друзья к пользователю
-- /
-- Кол-во приглашений в друзья от пользователя

-- Чем больше - популярность выше
-- Если значение меньше единицы - пользователь инициатор связей.

USE vk;

DROP FUNCTION IF EXISTS friendship_direction;

DELIMITER //
CREATE FUNCTION friendship_direction(check_user_id INT)
RETURNS FLOAT READS SQL DATA

  BEGIN
    
    DECLARE requests_to_user INT;
    DECLARE requests_from_user INT;
    
    SET requests_to_user = 
      (SELECT COUNT(*) 
        FROM friendship
          WHERE friend_id = check_user_id);
    
    SET requests_from_user = 
      (SELECT COUNT(*) 
        FROM friendship
          WHERE user_id = check_user_id);
    
    RETURN requests_to_user / requests_from_user;
  END//
  
DELIMITER ;

SELECT TRUNCATE(friendship_direction(7), 2) AS friendship_direction;



-- 2. Создаём процедуру

-- Рассылка приглашений вида "Возможно, вам будет интересно пообщаться с ..."
-- Варианты:
-- из одного города
-- состоят в одной группе
-- друзья друзей
-- Из выборки показывать 5 человек в случайной комбинации.


DROP PROCEDURE IF EXISTS friendship_offers;

DELIMITER //

CREATE PROCEDURE friendship_offers (IN for_user_id INT)

  BEGIN 
    (
      SELECT pr2.user_id
        FROM profiles pr1
          JOIN profiles pr2
            ON pr1.hometown = pr2.hometown
        WHERE pr1.user_id = for_user_id
      
      UNION
      
      SELECT cu2.user_id
        FROM communities_users cu1
          JOIN communities_users cu2
            ON cu1.community_id = cu2.community_id
        WHERE cu1.user_id = for_user_id
      
      UNION
    
      SELECT DISTINCT(fr3.user_id)
        FROM friendship fr1
          JOIN friendship fr2
            ON fr1.friend_id = fr2.user_id
          JOIN friendship fr3
            ON fr2.friend_id = fr3.user_id
        WHERE fr1.user_id = for_user_id
          AND fr2.status IS TRUE
          AND fr3.status IS TRUE
    )
        
    ORDER BY RAND()
    LIMIT 5;
     
END//
  
DELIMITER ;

CALL friendship_offers(1);

-- Просмотр функций и процедур
SHOW FUNCTION STATUS LIKE 'friendship_direction'\G
SHOW CREATE FUNCTION friendship_direction;

SHOW PROCEDURE STATUS LIKE 'friendship_offers'\G
SHOW CREATE PROCEDURE friendship_offers;


-- Индексы

-- Допустим есть типичный запрос
SELECT id, firstname, lastname 
  FROM users 
    WHERE email = 'ullrich.adella@example.net';

-- Создадим индекс на столбец email
CREATE INDEX users_email_idx ON users(email);;

-- После этой операции MySQL начнет использовать индекс age для выполнения 
-- подобных запросов.

--Сортировка
SELECT * FROM profiles ORDER BY birthday;

-- действует такое же правило — создаем индекс на колонку, по которой происходит 
-- сортировка:
CREATE INDEX profiles_birthday_idx ON profiles(birthday);

-- После создания индекса на колонку email, MySQL сохранит все ее значения в 
-- отсортированном виде:

users_email_idx
acarroll@example.net        
alvera.terry@example.org    
alyce76@example.com         
arianna46@example.net       
arielle.murazik@example.org 
aurelio.abbott@example.org  
beatty.tommie@example.com   
bergnaum.asia@example.org   
bergnaum.donato@example.org 
blaise68@example.org  
.....      |

-- Уникальные индексы
SELECT * FROM users WHERE email = 'acarroll@example.net';

-- На колонку email необходимо создать уникальный индекс:
CREATE UNIQUE INDEX users_email_uq ON users(email);

-- Составные индексы
-- Рассмотрим такой запрос:

SELECT * FROM media WHERE user_id = 9 AND media_type_id = 3;

-- Нам следует создать составной индекс на обе колонки:
CREATE INDEX media_user_id_media_type_id_idx ON media(user_id, media_type_id);

-- Устройство составного индекса
media_user_id_media_type_id_idx
13
24
33
...

-- Сортировка
-- Составные индексы также можно использовать, если выполняется сортировка:

SELECT * FROM profiles WHERE sex = 'm' ORDER BY birthday;

В этом случае нам нужно будет создать индекс в порядке
WHERE ORDER BY

-- Удаление индекса
DROP INDEX media_user_id_media_type_id_idx ON media;


-- Денормализация

-- Задание на денормализацию
-- Разобраться как построен и работает следующий запрос:

SELECT SUM(count) as overall FROM (
	SELECT 	
		CONCAT(u.firstname, ' ', u.lastname) as user, 
		count(l.id) as count, 
		TIMESTAMPDIFF(YEAR, p.birthday, NOW()) AS age
			FROM users AS u
		INNER JOIN profiles AS p
			ON p.user_id = u.id
		LEFT JOIN media as m
			ON m.user_id = u.id
		LEFT JOIN messages as t
			ON t.from_user_id = u.id
		LEFT JOIN
			likes AS l
				ON l.item_id = u.id AND l.like_type_id = 2
				OR l.item_id = m.id AND l.like_type_id = 1
				OR l.item_id = t.id AND l.like_type_id = 3
		GROUP BY u.id
		ORDER BY p.birthday DESC
	LIMIT 10) AS likes;
	
-- Правильно-ли он построен?
-- Какие изменения, включая денормализацию, можно внести в структуру БД
-- чтобы существенно повысить скорость работы этого запроса?
 






