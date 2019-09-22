-- Урок 12
-- Оптимизация запросов

-- Разбор ДЗ
-- Вариант Гульнары Сыч

-- Практическое задание тема №9
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
-- catalogs и products в таблицу logs помещается время и дата создания записи, название
-- таблицы, идентификатор первичного ключа и содержимое поля name.

CREATE TABLE Logs (
    id bigint UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    tablename varchar(50) NOT NULL,
    id_value INT UNSIGNED NOT NULL,
    name_value varchar(255)
) ENGINE = Archive;

CREATE TRIGGER products_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "products", NEW.id, NEW.name);
END;

CREATE TRIGGER users_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "users", NEW.id, NEW.name);
END;

CREATE TRIGGER catalogs_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
    INSERT INTO Logs VALUES (NULL, DEFAULT, "catalogs", NEW.id, NEW.name);
END;

-- 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

DROP PROCEDURE IF EXISTS add_users;
CREATE PROCEDURE add_users(IN count_users INT)
BEGIN
    WHILE count_users > 0 DO
        INSERT INTO users VALUES (NULL, CONCAT("name",count_users), CURRENT_DATE, DEFAULT, DEFAULT);
        SET count_users = count_users - 1;
    END WHILE;
END;

CALL add_users(1000000);
select * from users limit 20;

-- Предлагаемый вариант

CREATE TABLE samples (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO samples (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29'),
  ('Аркадий', '1994-03-17'),
  ('Ольга', '1981-07-10'),
  ('Владимир', '1988-06-12'),
  ('Екатерина', '1992-09-20');

SELECT
  COUNT(*)
FROM
  samples AS fst,
  samples AS snd,
  samples AS thd,
  samples AS fth,
  samples AS fif,
  samples AS sth;

SELECT COUNT(*) FROM users;

SELECT * FROM users LIMIT 10;


-- Практическое задание тема №10
-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
ubuntu@ip-172-31-23-78:~$ redis-cli
127.0.0.1:6379> HSET visit ip1 12
(integer) 1
127.0.0.1:6379> HSET visit ip2 20
(integer) 1
127.0.0.1:6379> HSET visit ip3 40
(integer) 1
127.0.0.1:6379> HVALS visit
1) "12"
2) "20"
3) "40"

-- Предлагаемый вариант

HINCRBY addresses '127.0.0.1' 1
HGETALL addresses

HINCRBY addresses '127.0.0.2' 1
HGETALL addresses

HGET addresses '127.0.0.1'

-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному
-- адресу и наоборот, поиск электронного адреса пользователя по его имени.

ubuntu@ip-172-31-23-78:~$ redis-cli
127.0.0.1:6379> hset users:1 name "Andrew"
(integer) 1
127.0.0.1:6379> hset users:1 email "andrew@example.com"
(integer) 1
127.0.0.1:6379> hkeys users:1
1) "name"
2) "email"
127.0.0.1:6379> hvals users:1
1) "Andrew"
2) "andrew@example.com"
127.0.0.1:6379> hgetall users:1
1) "name"
2) "Andrew"
3) "email"
4) "andrew@example.com"

-- Предлагаемый вариант

HSET emails 'igor' 'igorsimdyanov@gmail.com'
HSET emails 'sergey' 'sergey@gmail.com'
HSET emails 'olga' 'olga@mail.ru'

HGET emails 'igor'

HSET users 'igorsimdyanov@gmail.com' 'igor'
HSET users 'sergey@gmail.com' 'sergey'
HSET users 'olga@mail.ru' 'olga'

HGET users 'olga@mail.ru'

-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.

-- Вариант Гульнары mongo_example.png
-- Предлагаемый вариант

show dbs

use shop

db.createCollection('catalogs')
db.createCollection('products')

db.catalogs.insert({name: 'Процессоры'})
db.catalogs.insert({name: 'Мат.платы'})
db.catalogs.insert({name: 'Видеокарты'})

db.products.insert(
  {
    name: 'Intel Core i3-8100',
    description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
    price: 7890.00,
    catalog_id: new ObjectId("5b56c73f88f700498cbdc56b")
  }
);

db.products.insert(
  {
    name: 'Intel Core i5-7400',
    description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.',
    price: 12700.00,
    catalog_id: new ObjectId("5b56c73f88f700498cbdc56b")
  }
);

db.products.insert(
  {
    name: 'ASUS ROG MAXIMUS X HERO',
    description: 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX',
    price: 19310.00,
    catalog_id: new ObjectId("5b56c74788f700498cbdc56c")
  }
);

db.products.find()

db.products.find({catalog_id: ObjectId("5b56c73f88f700498cbdc56bdb")})


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
        LEFT JOIN likes AS l
            ON l.item_id = u.id 
			   AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 3
    GROUP BY u.id
    ORDER BY p.birthday DESC
LIMIT 10) AS likes;

DESC messages;

-- Меняем messages на posts
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
        LEFT JOIN posts as t
            ON t.user_id = u.id
        LEFT JOIN likes AS l
            ON l.item_id = u.id 
			   AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 3
    GROUP BY u.id
    ORDER BY p.birthday DESC
LIMIT 10) AS likes;

-- Имя не нужно
SELECT * FROM (
    SELECT
        count(l.id) as count,
        TIMESTAMPDIFF(YEAR, p.birthday, NOW()) AS age
    FROM users AS u
        INNER JOIN profiles AS p
            ON p.user_id = u.id
        LEFT JOIN media as m
            ON m.user_id = u.id
        LEFT JOIN posts as t
            ON t.user_id = u.id
        LEFT JOIN likes AS l
            ON l.item_id = u.id 
			   AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 3
    GROUP BY u.id
    ORDER BY p.birthday DESC
LIMIT 10) AS likes;

-- Таблица users тогда тоже не нужна
SELECT * FROM (
    SELECT
        count(l.id) as count,
        TIMESTAMPDIFF(YEAR, p.birthday, NOW()) AS age
    FROM profiles AS p
        LEFT JOIN media as m
            ON m.user_id = p.user_id
        LEFT JOIN posts as t
            ON t.user_id = p.user_id
        LEFT JOIN likes AS l
            ON l.item_id = p.user_id AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 3
    GROUP BY p.user_id
    ORDER BY p.birthday DESC
LIMIT 10) AS likes;


-- Вычислять возраст тоже не нужно
SELECT * FROM (
    SELECT
        count(l.id) as count,
        p.birthday
    FROM profiles AS p
        LEFT JOIN media as m
            ON m.user_id = p.user_id
        LEFT JOIN posts as t
            ON t.user_id = p.user_id
        LEFT JOIN likes AS l
            ON l.item_id = p.user_id AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 3
    GROUP BY p.user_id
    ORDER BY p.birthday DESC
LIMIT 10) AS likes;

-- Проверяем что мы вообще джоиним
SELECT p.user_id AS 'user.id', m.id AS 'media.id', t.id AS 'post.id', l.item_id AS 'like.item_id'
    FROM profiles AS p
        LEFT JOIN media as m
            ON m.user_id = p.user_id
        LEFT JOIN posts as t
            ON t.user_id = p.user_id
        LEFT JOIN likes AS l
            ON l.item_id = p.user_id AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 3
    ORDER BY l.item_id;

-- Корректируем типы и добавим вывод типа лайка
SELECT * FROM like_types;
+----+---------+
| id | name    |
+----+---------+
|  1 | media   |
|  3 | message |
|  4 | post    |
|  2 | user    |
+----+---------+

SELECT p.user_id AS 'user.id', m.id AS 'media.id', 
    t.id AS 'post.id', 
    l.item_id AS 'like.item_id',
    l.like_type_id AS 'like.like_type_id'
    FROM profiles AS p
        LEFT JOIN media as m
            ON m.user_id = p.user_id
        LEFT JOIN posts as t
            ON t.user_id = p.user_id
        LEFT JOIN likes AS l
            ON l.item_id = p.user_id AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 4
    ORDER BY l.item_id;

-- Определили что подсчёт неверен
-- Проверяем с выводом id лайков

SELECT p.user_id AS 'user.id', m.id AS 'media.id', 
    t.id AS 'post.id', 
    l.id AS 'like.id',
    l.like_type_id AS 'like.like_type_id'
    FROM profiles AS p
        LEFT JOIN media as m
            ON m.user_id = p.user_id
        LEFT JOIN posts as t
            ON t.user_id = p.user_id
        LEFT JOIN likes AS l
            ON l.item_id = p.user_id AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 4
    ORDER BY l.id;
    
-- Выводим только уникальные строки
SELECT DISTINCT p.user_id AS 'user.id',
    l.id AS 'like.id'
    FROM profiles AS p
        LEFT JOIN media as m
            ON m.user_id = p.user_id
        LEFT JOIN posts as t
            ON t.user_id = p.user_id
        LEFT JOIN likes AS l
            ON l.item_id = p.user_id AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 4
    ORDER BY l.id;
    
-- Делаем проверку
+---------+---------+
| user.id | like.id |
+---------+---------+
|      47 |       2 |
|      99 |       3 |

SELECT * FROM likes WHERE id = 2;
-- Видим что это файл медиа с id 47
SELECT * FROM media WHERE id = 47;
-- Видим что пользователь также 47, верно

-- Возвращаем запрос к исходному виду
-- Ставим правильную сортировку и подсчёт количества лайков

SELECT p.user_id, p.birthday, count(DISTINCT l.id)
    FROM profiles AS p
        LEFT JOIN media as m
            ON m.user_id = p.user_id
        LEFT JOIN posts as t
            ON t.user_id = p.user_id
        LEFT JOIN likes AS l
            ON l.item_id = p.user_id AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 4
    GROUP BY p.user_id
    ORDER BY p.birthday DESC
    LIMIT 10;
    
-- Проверим пользователя с id 94
SELECT media.id FROM media WHERE user_id = 94;
+----+
| id |
+----+
| 94 |
+----+

SELECT posts.id FROM posts WHERE user_id = 94; 
+----+
| id |
+----+
| 10 |
| 24 |
| 74 |
+----+

SELECT * FROM likes WHERE item_id IN (
 SELECT media.id FROM media WHERE user_id = 94
   UNION
 SELECT posts.id FROM posts WHERE user_id = 94
);

-- Выбрались лайки только для пользователей, нужный - 94

-- Сводим запрос

SELECT SUM(count) as overall 
  FROM (
		SELECT count(DISTINCT l.id) AS count
    FROM profiles AS p
        LEFT JOIN media as m
            ON m.user_id = p.user_id
        LEFT JOIN posts as t
            ON t.user_id = p.user_id
        LEFT JOIN likes AS l
            ON l.item_id = p.user_id AND l.like_type_id = 2
               OR l.item_id = m.id AND l.like_type_id = 1
               OR l.item_id = t.id AND l.like_type_id = 4
    GROUP BY p.user_id
    ORDER BY p.birthday DESC
    LIMIT 10
		) AS likes;
		
-- Сравниваем исходный и исправленный запросы
-- Синтаксис EXPLAIN http://www.mysql.ru/docs/man/EXPLAIN.html

-- Исходный
EXPLAIN SELECT SUM(count) as overall FROM (
    SELECT 
	    CONCAT(users.firstname, ' ', users.lastname) as user,
        count(likes.id) as count,
        TIMESTAMPDIFF(YEAR, profiles.birthday, NOW()) AS age
    FROM users
        INNER JOIN profiles
            ON profiles.user_id = users.id
        LEFT JOIN media
            ON media.user_id = users.id
        LEFT JOIN posts
            ON posts.user_id = users.id
        LEFT JOIN likes
            ON likes.item_id = users.id 
			   AND likes.like_type_id = 2
               OR likes.item_id = media.id AND likes.like_type_id = 1
               OR likes.item_id = posts.id AND likes.like_type_id = 4
    GROUP BY users.id
    ORDER BY profiles.birthday DESC
LIMIT 10) AS likes_total;

-- Исправленый
EXPLAIN SELECT SUM(count) as overall 
  FROM (
		SELECT COUNT(DISTINCT likes.id) AS count
    FROM profiles
        LEFT JOIN media
            ON media.user_id = profiles.user_id
        LEFT JOIN posts
            ON posts.user_id = profiles.user_id
        LEFT JOIN likes
            ON likes.item_id = profiles.user_id AND likes.like_type_id = 2
               OR likes.item_id = media.id AND likes.like_type_id = 1
               OR likes.item_id = posts.id AND likes.like_type_id = 4
    GROUP BY profiles.user_id
    ORDER BY profiles.birthday DESC
    LIMIT 10
		) AS likes_total;
		
CREATE INDEX media_user_id_idx ON media(user_id);
CREATE INDEX posts_user_id_idx ON posts(user_id);

CREATE INDEX likes_item_id_like_type_id_idx 
  ON likes(item_id, like_type_id);
  
CREATE INDEX profiles_birthday_idx ON profiles(birthday);

DROP INDEX media_user_id_idx ON media; 
DROP INDEX posts_user_id_idx ON posts; 
DROP INDEX likes_item_id_like_type_id_idx ON likes;
DROP INDEX profiles_birthday_idx ON profiles;  

-- Документация по Workbench execution plan
-- Используем графический анализатор плана выполнения
-- https://dev.mysql.com/doc/workbench/en/wb-performance-explain.html

-- А если использовать вложенные запросы?
-- Сразу выбираем только нужных пользователей
SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10; 

-- Компонуем запрос
EXPLAIN SELECT SUM(count) as overall 
  FROM (
		SELECT COUNT(DISTINCT likes.id) AS count
    FROM profiles
        LEFT JOIN media
            ON media.user_id = profiles.user_id
        LEFT JOIN posts
            ON posts.user_id = profiles.user_id
        INNER JOIN likes
            ON likes.item_id = profiles.user_id AND likes.like_type_id = 2
               OR likes.item_id = media.id AND likes.like_type_id = 1
               OR likes.item_id = posts.id AND likes.like_type_id = 4
    WHERE profiles.user_id IN (
      SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10
    )
    GROUP BY profiles.user_id
		) AS likes_total;
		
-- Но не работает
-- Попробуем другим способом
SELECT SUM(count) as overall 
  FROM (
		SELECT COUNT(DISTINCT likes.id) AS count
    FROM (
      SELECT * FROM profiles ORDER BY birthday DESC LIMIT 10
    ) AS profiles_selected
        LEFT JOIN media
            ON media.user_id = profiles_selected.user_id
        LEFT JOIN posts
            ON posts.user_id = profiles_selected.user_id
        LEFT JOIN likes
            ON likes.item_id = profiles_selected.user_id AND likes.like_type_id = 2
               OR likes.item_id = media.id AND likes.like_type_id = 1
               OR likes.item_id = posts.id AND likes.like_type_id = 4
    GROUP BY profiles_selected.user_id
		) AS likes_total;

  