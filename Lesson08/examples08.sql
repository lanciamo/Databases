-- Урок 8

-- Сложные запросы с использованием JOIN
-- Транзакции, переменные, представления

-- ДЗ по уроку 6 (БД Вконтакте) 
-- Вариант Станислава Пологрудова

-- Задание 2
-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользоваетелем.

-- Уфф.. похоже получился некий франкенштейн.. Думаю как-то это можно изящнее и проще наверняка рещить.. итак:
-- Сообщения считаем только от друзей. Получить друзей пользователя №1 (в обе стороны) мы можем как демонстрировалось на лекции

SELECT user_id FROM friendship 
	WHERE friend_id=1
	AND confirmed_at IS NOT NULL
	UNION 
	SELECT friend_id FROM friendship 
	WHERE user_id=1 
	AND confirmed_at IS NOT NULL;

-- +---------+
-- | user_id |
-- +---------+
-- |      23 |
-- |      50 |
-- |      53 |
-- +---------+
-- 3 rows in set (0.00 sec)

-- Далее.. Сообщения тоже могут быть в две стороны (пользователю от друга и другу от пользователя)
-- Это сообщения от друзей -> пользователю №1

SELECT (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id=from_user_id) AS username 
	FROM messages 
	WHERE from_user_id IN 
	(SELECT user_id FROM friendship 
		WHERE friend_id=1 
		AND confirmed_at IS NOT NULL
		UNION 
		SELECT friend_id FROM friendship 
		WHERE user_id=1
		AND confirmed_at IS NOT NULL
		) 
	AND to_user_id=1;

-- +----------------------+
-- | username             |
-- +----------------------+
-- | Dedric Mayer         |
-- | Dedric Mayer         |
-- | Dominique Morissette |
-- +----------------------+
-- 3 rows in set (0.00 sec)

-- Теперь наоборот. От пользователя №1 -> друзьям:

SELECT (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id=to_user_id) AS username 
	FROM messages 
	WHERE to_user_id IN 
	(SELECT user_id FROM friendship 
		WHERE friend_id=1 
		AND confirmed_at IS NOT NULL
		UNION 
		SELECT friend_id FROM friendship 
		WHERE user_id=1
		AND confirmed_at IS NOT NULL
		) 
	AND from_user_id=1;

-- +--------------+
-- | username     |
-- +--------------+
-- | Dedric Mayer |
-- | Dedric Mayer |
-- +--------------+
-- 2 rows in set (0.00 sec)

-- Всё это надо объединить.. Не знал, что UNION может работать в разных режимах, чуть голову не сломал, пока не нагуглил что есть UNION ALL и UNION DISTINCT..
-- Итак:

SELECT user FROM (
	SELECT (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id=from_user_id) AS user FROM messages 
		WHERE from_user_id IN 
			(SELECT user_id FROM friendship 
				WHERE friend_id=1 
				AND confirmed_at IS NOT NULL
			UNION 
			SELECT friend_id FROM friendship 
				WHERE user_id=1
				AND confirmed_at IS NOT NULL) 
		AND to_user_id=1
	UNION ALL
	SELECT (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id=to_user_id) AS user FROM messages 
		WHERE to_user_id IN 
			(SELECT user_id FROM friendship 
				WHERE friend_id=1
				AND confirmed_at IS NOT NULL
			UNION 
			SELECT friend_id FROM friendship 
				WHERE user_id=1
				AND confirmed_at IS NOT NULL
			)
		AND from_user_id=1
) dummy_table;

-- +----------------------+
-- | user                 |
-- +----------------------+
-- | Dedric Mayer         |
-- | Dedric Mayer         |
-- | Dominique Morissette |
-- | Dedric Mayer         |
-- | Dedric Mayer         |
-- +----------------------+
-- 5 rows in set (0.00 sec)

-- Дальше просто, аггрегация, сортировка и лимит на 1 запись.

SELECT user, COUNT(*) AS messages FROM (
	SELECT (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id=from_user_id) AS user FROM messages 
		WHERE from_user_id IN 
			(SELECT user_id FROM friendship 
				WHERE friend_id=1 
				AND confirmed_at IS NOT NULL
			UNION 
			SELECT friend_id FROM friendship 
				WHERE user_id=1
				AND confirmed_at IS NOT NULL) 
		AND to_user_id=1
	UNION ALL
	SELECT (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id=to_user_id) AS user FROM messages 
		WHERE to_user_id IN 
			(SELECT user_id FROM friendship 
				WHERE friend_id=1
				AND confirmed_at IS NOT NULL
			UNION 
			SELECT friend_id FROM friendship 
				WHERE user_id=1
				AND confirmed_at IS NOT NULL
			)
		AND from_user_id=1
) dummy_table
GROUP BY user
ORDER BY messages DESC
LIMIT 1;

-- +--------------+----------+
-- | user         | messages |
-- +--------------+----------+
-- | Dedric Mayer |        4 |
-- +--------------+----------+
-- 1 row in set (0.00 sec)

-- Задание 3
-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

-- 10 самых молодых (очевидно в нашем приложении нет возрастного ограничения. Куда только смотрят соответствующие органы :))

SELECT (SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id=user_id) AS user, 
	TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age FROM profiles
	ORDER BY age
	LIMIT 10;

-- +--------------------+------+
-- | user               | age  |
-- +--------------------+------+
-- | Evalyn Purdy       |    0 |
-- | Lupe Nolan         |    0 |
-- | Faye Johns         |    0 |
-- | Sheila Kulas       |    0 |
-- | Mohamed Williamson |    1 |
-- | Corrine Toy        |    2 |
-- | Shayne Kuhlman     |    2 |
-- | Mable Wolf         |    3 |
-- | Meggie Price       |    4 |
-- | Jerrod Daugherty   |    4 |
-- +--------------------+------+
-- 10 rows in set (0.00 sec)

-- Считаем лайки.

SELECT COUNT(*) AS likes_count FROM likes WHERE item_id IN (SELECT user_id FROM (
	SELECT user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age 
	FROM profiles
	ORDER BY age
	LIMIT 10) dummy_table
) AND like_type_id = 2; -- Type of Like for user

-- +-------------+
-- | likes_count |
-- +-------------+
-- |           1 |
-- +-------------+
-- 1 row in set (0.01 sec)

-- Не густо.. проверил, действительно только один лайк есть у одного пользователя из этой выборки.


-- Ну или более дескриптивно..

SELECT COUNT(*) AS likes_count 
  FROM likes 
    WHERE item_id IN 
      (SELECT user_id FROM (
	      SELECT user_id, TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age 
	        FROM profiles
	        ORDER BY age
	        LIMIT 10
	      ) dummy_table
) AND (SELECT name FROM like_types WHERE id=like_type_id) LIKE 'users';

-- +-------------+
-- | likes_count |
-- +-------------+
-- |           1 |
-- +-------------+
-- 1 row in set (0.01 sec)

-- Задание 4
-- Определить кто больше поставил лайков (всего) - мужчины или женщины?


SELECT CASE(sex)
		WHEN 'm' THEN 'male'
		WHEN 'f' THEN 'female'
	END AS sex, 
	COUNT(*) as likes_count FROM 
	(SELECT user_id as user, 
		(SELECT sex FROM profiles WHERE user_id=user) as sex FROM likes) dummy_table 
GROUP BY sex;

-- +--------+-------------+
-- | sex    | likes_count |
-- +--------+-------------+
-- | female |          51 |
-- | male   |          47 |
-- +--------+-------------+
-- 2 rows in set, 1 warning (0.00 sec)

-- Мужчины меньше лайков поставили (хоть их и больше количественно):

SELECT COUNT(*) AS count, 
	CASE(sex)
		WHEN 'm' THEN 'male'
		WHEN 'f' THEN 'female'
	END AS sex
	FROM profiles
    GROUP BY sex;

-- +-------+--------+
-- | count | sex    |
-- +-------+--------+
-- |    47 | female |
-- |    53 | male   |
-- +-------+--------+
-- 2 rows in set, 1 warning (0.00 sec)

-- Задание 5
-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

-- Критерии неактивности могут быть разными.. первый вариант - кто из пользователей поставил меньше всего лайков,
-- Запостил меньше всего медиа, и отправил меньше всего сообщений.. 

SELECT CONCAT(firstname, ' ', lastname) AS user, 
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id) + 
	(SELECT COUNT(*) FROM media WHERE media.user_id = users.id) + 
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) 
	AS overall_activity 
	FROM users
	ORDER BY overall_activity
	LIMIT 10;

-- +---------------------+------------------+
-- | user                | overall_activity |
-- +---------------------+------------------+
-- | Bridie Rogahn       |                1 |
-- | Aida Macejkovic     |                1 |
-- | Waylon Grady        |                1 |
-- | Russel Daugherty    |                1 |
-- | Carroll Blick       |                1 |
-- | Gianni Fritsch      |                1 |
-- | Evalyn Purdy        |                1 |
-- | Joseph Gleason      |                1 |
-- | Theresa Ryan        |                1 |
-- | Morgan Pfannerstill |                1 |
-- +---------------------+------------------+
-- 10 rows in set (0.00 sec)

-- Другой критерий - насколько давно пользователь постил что-либо последний раз, лайкал или общался с кем-либо.

SELECT CONCAT(firstname, ' ', lastname) AS user, GREATEST(
	IFNULL((SELECT MAX(created_at) FROM likes WHERE likes.user_id = users.id), 0), 
	IFNULL((SELECT MAX(created_at) FROM media WHERE media.user_id = users.id), 0),
	IFNULL((SELECT MAX(created_at) FROM messages WHERE messages.from_user_id = users.id), 0)
) AS last_activity_date 
FROM users
ORDER BY last_activity_date
LIMIT 10;

-- +-----------------+---------------------+
-- | user            | last_activity_date  |
-- +-----------------+---------------------+
-- | Joseph Gleason  | 1971-04-07 14:01:11 |
-- | Carroll Blick   | 1973-07-05 11:27:13 |
-- | Mozelle Bins    | 1975-08-23 16:48:24 |
-- | Lupe Nolan      | 1976-11-15 19:49:39 |
-- | Keyshawn Roob   | 1977-04-09 01:59:02 |
-- | Orlo Cassin     | 1977-10-01 22:00:58 |
-- | Margarita Doyle | 1977-12-15 19:27:19 |
-- | Waylon Grady    | 1978-07-16 11:17:33 |
-- | Shayne Kuhlman  | 1980-10-28 19:17:09 |
-- | Theresa Ryan    | 1981-04-26 04:37:09 |
-- +-----------------+---------------------+
-- 10 rows in set (0.01 sec)



-- ДЗ урока 7
-- Вариант Романа Семёнова 

-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в
-- интернет магазине.

-- Не знаю какой из запросов будет работать быстрее, поэтому перечислю два варианта. 

-- Первый через JOIN
SELECT DISTINCT u.name
  FROM users AS u
  INNER JOIN orders AS o ON o.user_id = u.id;

-- Второй через EXISTS
SELECT u.name
  FROM users AS u
  WHERE EXISTS (SELECT 1 FROM orders WHERE user_id = u.id LIMIT 1);


-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT p.name, c.name
  FROM products AS p
  LEFT JOIN catalogs AS c ON c.id = p.catalog_id;

-- 3. Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label,
-- name). Поля from, to и label содержат английские названия городов, поле name — русское.
-- Выведите список рейсов flights с русскими названиями городов.

SELECT f.id, cf.name, ct.name
  FROM flights AS f
  LEFT JOIN cities AS cf ON cf.label = f.from
  LEFT JOIN cities AS ct ON ct.label = f.to; 
  

-- Добавляем внешние ключи в БД vk
-- Для таблицы профилей
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;

-- Для таблицы сообщений
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);

-- Использование JOIN

-- CROSS JOIN
SELECT users.*, orders.* FROM users, orders;

SELECT users.id, users.name, users.birthday_at, orders.id, orders.user_id
  FROM users, orders;

-- CROSS JOIN с условием  
SELECT users.id, users.name, users.birthday_at, orders.id, orders.user_id
  FROM users, orders
  WHERE users.id = orders.user_id;
  
-- Указание связи с помощью ON  
SELECT users.id, users.name, users.birthday_at, orders.id, orders.user_id
  FROM users
    JOIN orders
  ON users.id = orders.user_id;

-- INNER JOIN с явным указанием типа
SELECT users.id, users.name, users.birthday_at, orders.id, orders.user_id
  FROM users
    INNER JOIN orders
  ON users.id = orders.user_id;

-- INNER JOIN с агрегирующей функцией
-- Подсчёт заказов пользователя  
SELECT users.name, COUNT(orders.user_id) AS total_orders
  FROM users
    JOIN orders
  ON users.id = orders.user_id
  GROUP BY orders.user_id
  ORDER BY total_orders;

-- Аналогично запросу выше, но с сокращением записи имён таблиц
SELECT u.name, COUNT(o.user_id) AS total_orders
  FROM users u
    JOIN orders o
  ON u.id = o.user_id
  GROUP BY o.user_id
  ORDER BY total_orders;

-- LEFT OUTER JOIN (LEFT JOIN)
SELECT users.id, users.name, users.birthday_at, orders.id, orders.user_id 
  FROM users
    LEFT OUTER JOIN orders
  ON users.id = orders.user_id;

-- Пользователи, у которых нет заказов
-- Подумайте, какой тип JOIN тут нужен  
SELECT users.id, users.name, users.birthday_at, orders.id, orders.user_id 
  FROM users
    LEFT OUTER JOIN orders
  ON users.id = orders.user_id
  WHERE orders.id IS NULL;
  
-- RIGHT OUTER JOIN (RIGHT JOIN)
SELECT users.id, users.name, users.birthday_at, orders.id, orders.user_id 
  FROM orders
    RIGHT JOIN users
  ON users.id = orders.user_id;
  
  
-- Запросы на БД Vk

-- Выборка данных по пользователю
SELECT firstname, lastname, email, sex, birthday, hometown
  FROM users
    LEFT JOIN profiles
      ON users.id = profiles.user_id
  WHERE users.id = 1;
  
-- Выборка медиафайлов пользователя
SELECT media.user_id, media.filename, media.created_at
  FROM media
    JOIN users
      ON media.user_id = users.id     
  WHERE media.user_id = 1;

-- Выборка медиафайлов друзей пользователя
SELECT media.user_id, media.filename, media.created_at
  FROM media
    JOIN friendship
      ON media.user_id = friendship.friend_id
    JOIN users
      ON friendship.user_id = users.id     
  WHERE friendship.user_id = 1;

-- Сообщения от пользователя
SELECT messages.body, users.firstname, users.lastname, messages.created_at
  FROM messages
    JOIN users
      ON users.id = messages.to_user_id
  WHERE messages.from_user_id = 1;
  
-- Сообщения к пользователю
SELECT body, firstname, lastname, messages.created_at
  FROM messages
    JOIN users
      ON users.id = messages.from_user_id
  WHERE messages.to_user_id = 1;
  
-- Количество друзей у пользователя с сортировкой
SELECT firstname, lastname, COUNT(*) AS total_friends
  FROM users
    LEFT JOIN friendship
      ON users.id = friendship.user_id
  GROUP BY friendship.user_id
  ORDER BY total_friends DESC;

-- Список медиафайлов пользователя с количеством лайков
SELECT media.filename,
  media_types.name,
  COUNT(*) AS total_likes,
  CONCAT(firstname, ' ', lastname) AS owner
  FROM media
    JOIN media_types
      ON media.media_type_id = media_types.id
    JOIN likes
      ON media.id = likes.item_id
    JOIN users
      ON users.id = media.user_id
  WHERE users.id = 2
  GROUP BY media.id;

-- 10 пользователей с наибольшим количеством лайков за медиафайлы
SELECT firstname, lastname, COUNT(*) AS total_likes
  FROM users
    JOIN media
      ON users.id = media.user_id
    JOIN likes
      ON media.id = likes.item_id
  GROUP BY users.id
  ORDER BY total_likes DESC
  LIMIT 10;