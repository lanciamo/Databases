-- Урок 4

-- ДЗ
-- 1. Повторить все действия по доработке БД vk
-- 2. Заполнить новые таблицы
-- 3. Повторить все действия CRUD.
-- 

-- 4. Сервис для копирования и последующей модификации для курсового проекта.

--	AmoCRM - одна из самых удобных на рынке CRM систем. Примерная схема организации таблиц внутри БД:
-- 1.таблица хранения контактной и сопутствующей информации о персоналиях;
-- 2. таблица хранения контактной и сопутствующей информации о юрлицах;
-- 3. таблица взаимосвязей и отношений персональной информации и юрлиц;
-- 4. таблица особых ролей и взаимосвязей - аффилированные лица, учредители, члены СД, реальные бенефициары;
-- 5. таблица хранения ссылок с инфоповодами персоналий и юрлиц;
-- 6. таблица хранения взаимодействий - письма, сообщений, звонки, описания и комментарии;
-- 7. таблица хранения персональной информации о сотрудниках и их ролях, компании, от имени которой, ведет работу отдел продаж.

-- отчеты для "кросс-табличного" формирования:
  -- календарь событий и взаимодействий по компании/клиенту;
  -- календарь задач по клиенту;
  -- календарь задач по менеджерам;

  
-- По опыту своей работы с разными CRM системами, могу сказать, что на рынке нет ни одной, которая бы
-- устраивала отдел продаж работающий в режиме активного поиска (без входящих заявок) на рынке b2b.
-- Предполагаю, что одна из крупнейших проблем это отсутствие возможности учесть многоуровневые 
-- юридические и отношенческие нюансы внутри компаний - например таблицы за номером 4 в моем списке, 
-- нет ни в одной из CRM. Мне было бы интересно заниматься этой темой, если у вас нет вопросов 
-- к сложности такой задачи)








-- CRUD операции

-- Рекомендации по улучшению структуры БД vk

--1) Т.к. пользователей социальной сети больше чем может вместить в себя тип 
--unsigned int предлагаю во всех таблицах где идет генерация первичного ключа 
--сделать поле id типа GUID.

-- 4294967295 - вроде-бы хватает
-- Числовые значения обрабатываются быстрее

--2) Сделать связь между таблицами по внешнему ключу, например, для того, 
--чтобы в таблицу profiles в поле photo_id нельзя было внеси значение, 
--которого нет в таблице media.

--Верно, будем делать позже.
 
--3) В таблицу messages в первичный ключ добавить поле to_user_id: 
--PRIMARY KEY (from_user_id, to_user_id, created_at). 
--Т.к. может возникнуть ситация когда один и тоже пользователь в одно и тоже 
--время отправит сообщения двум и более людям и возникнет ошибка СУБД, 
--о том, что запись с такими ключевыми полями уже существует.
--Имеет смысл
DESC messages;
ALTER TABLE messages DROP PRIMARY KEY;
ALTER TABLE messages ADD PRIMARY KEY (from_user_id, to_user_id, created_at);

-- 4) В таблицу media в первичный ключ добавить поле user_id, для того, 
-- чтобы в запросах быстрее получать контент конкретного пользователя.
-- Имеет смысл добавить индекс, сделаем позже.

-- Добавить таблицу posts
CREATE TABLE `posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` int(10) unsigned NOT NULL,
  `community_id` int(10) unsigned NOT NULL,
  `body` text COLLATE utf8_unicode_ci NOT NULL,
  `media_id` int(10) unsigned NOT NULL,
  `number_votes` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
--Имеет смысл, добавим

-- 1. VK отказались от хранения даты рождения. Хранят отдельно день, месяц, год – это
-- дает возможность осуществлять индексированный поиск по полям без функций типа
-- MONTH (дата). Изменена таблица :
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY,
  sex CHAR(1) NOT NULL,
  birthday date,
  birthday_year int,
  birthday_moth int,
  birthday_day int,
  hometown VARCHAR(100),
  photo_id INT UNSIGNED NOT NULL
);
CREATE TRIGGER insert_profile BEFORE INSERT ON profiles
  FOR EACH ROW SET NEW.birthday_year = year(NEW.birthday), NEW.birthday_moth
= month(NEW.birthday), NEW.birthday_day = day(NEW.birthday);

CREATE TRIGGER update_profile BEFORE UPDATE ON profiles
  FOR EACH ROW SET NEW.birthday_year = year(NEW.birthday), NEW.birthday_moth
= month(NEW.birthday), NEW.birthday_day = day(NEW.birthday);
-- Идея интересная, но мы пока реализовывать не будем.

--добавил поле user_role в communities_users и таблицу goods, отражающую товары в вк.
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  user_role VARCHAR(20) NOT NULL,
  PRIMARY KEY (community_id, user_id)
);
-- Обе идеи интересные, но реализация ролей в таком виде не соответствует третьей нормальной форме.

/* 1. Проанализировав структуру БД и сайт vk.com, предлагаю разнести понятия "Сообщения в ленте" и "Сообщения между пользователями".
 * Дело в том, что если присмотреться, то окажется, что у них довольно отличающийся функционал. 
 * 
 * Ниже перечислю некоторые отличия.
 * 1.1. "Сообщения между пользователями" нельзя лайкать, тогда как "Сообщения в ленте" можно.
 * 1.2. Для "Сообщений между пользователями" актуальны признаки "важное" (поле important) и "доставлено" (поле delivered), 
 * тогда как для "Сообщений в ленте" эти поля не актуальны.
 * 1.3. Для "Сообщений в ленте" можно оставлять комментарии, а для "Сообщений между пользователями" нельзя.
 * 1.4. "Сообщения в ленте" пользователи могут "репостить".
 * 1.5. Если сюда ещё подключить задачу проставления лайков (и учитывая пункты 3 и 4), то для "Сообщений в ленте" напрашивается искусственный ключ, 
 * тогда как для "Сообщений между пользователями" он не нужен.
*/
CREATE TABLE news (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL, -- Пользователь, который написал новость
  body TEXT NOT NULL,
  created_at DATETIME DEFAULT NOW()
);

-- Давайте создадим newsline
CREATE TABLE newsline (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL, -- Пользователь, который написал новость
  body TEXT NOT NULL,
  created_at DATETIME DEFAULT NOW()
);

-- В таблице profiles есть поле photo_id, предполагается, видимо, что есть отдельная 
-- таблица для фото. Наверно, надо сослаться на таблицу media, соответственно, 
-- поле будет media_id



-- Варианты создания таблицы лайков

-- Кодирование получателя лайка при помощи символа
CREATE TABLE `likes` (
  `user_id` int(10) unsigned NOT NULL,
  `target_id` int(10) unsigned NOT NULL,
  `entity_type` char(1) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`,`target_id`,`entity_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
-- Где увидеть соответствие символа типу?
-- Как выбирать все существующие значения?
-- Как проверять допустимость значений?

-- С использованием дополнительной таблицы типов
-- Для всех сущностей нужен id
-- Таблица лайков
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  likes_type_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  metadata JSON,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Таблица типов лайков
CREATE TABLE likes_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE
);
-- Соответствует третьей нормальной форме
-- Легко расширяется
-- Легко организовать проверку допустимых значений
-- Легко получить все допустимые варианты
-- Немного изменим
-- Таблица лайков
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  like_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- Таблица типов лайков
CREATE TABLE like_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE
);

-- Создание отдельных таблиц лайков для каждой сущности
CREATE TABLE `posts_like` (
  `post_id` int(10) unsigned NOT NULL,
  `from_user_id` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`post_id`,`from_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users_like` (
  `to_user_id` int(10) unsigned NOT NULL,
  `from_user_id` int(10) unsigned NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`to_user_id`,`from_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
-- Простая идея в основе
-- Для каждой сущности нужно будет создавать отдельную таблицу - усложнение логики приложения
-- Чтобы получить лайки одного пользователя нужно будет обратиться к нескольким таблицам
 
-- Создание таблицы лайков с аггрегационной таблицей
-- Таблица лайков
CREATE TABLE likes (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
item_id INT UNSIGNED NOT NULL,
media_type_id INT UNSIGNED NOT NULL,
owner_id INT UNSIGNED NOT NULL
);

-- Таблица агрегатов лайков
CREATE TABLE agg (
likes_item_id INT UNSIGNED NOT NULL,
likes_count INT UNSIGNED NOT NULL
);

-- Здесь при добавлении всегда создаем нулевую запись что б в триггерах агрегирования
-- не вычислять наличие записи в принципе
CREATE TRIGGER insert_media BEFORE INSERT ON media
  FOR EACH ROW insert into agg (likes_item_id, likes_count) values (NEW.id, 0);
CREATE TRIGGER insert_likes BEFORE INSERT ON likes
FOR EACH ROW update agg set likes_count = likes_count + 1 where likes_item_id =
NEW.item_id;
CREATE TRIGGER delete_likes BEFORE DELETE ON likes
  FOR EACH ROW update agg set likes_count = likes_count 1 1 where likes_item_id =
OLD.item_id;
-- Так делают на практике
-- Можео лайкать только медиаконтент
-- Триггеры пока не трогаем

-- Вариант с созданием ссылочного столбца для каждой сущности
CREATE TABLE likes (
  id int unsigned NOT NULL AUTO_INCREMENT,
  from_user_id int unsigned NOT NULL,
  to_user_id int unsigned DEFAULT NULL,
  to_message_id int unsigned DEFAULT NULL,
  to_media_id int unsigned DEFAULT NULL,
  PRIMARY KEY (id)
);
-- Простая идея
-- Получаем сильно разреженую тублицу
-- При добавлении новой сущности придётся добавлять новый столбец и менять логику приложения

-- Вариант с применением тиа ENUM
-- Таблица лайков
CREATE TABLE upvotes (
  media_id INT UNSIGNED NOT NULL,
  entity_type ENUM('Media', 'Post', 'User') NOT NULL,
  entity_id INT UNSIGNED NOT NULL
);
-- Так делают на практике
-- Денормализация - неатомарные значения
-- Пока не изучали ENUM

-- Вариант с сохранением имени целевой таблицы
CREATE TABLE ranking (
content_id INT NOT NULL,
user_id INT NOT NULL,
content_table VARCHAR(50) NOT NULL,
is_positive boolean NOT NULL,
created_at DATETIME DEFAULT NOW(),
PRIMARY KEY (content_id, user_id, content_table)
);
-- Простая идея
-- Не соответствует третьей нормальной форме



-- CRUD операции
-- однострочная и многострочная вставка
SHOW TABLES;
DESC like_types;
SELECT * FROM like_types;
INSERT INTO like_types VALUES (1, 'media');

-- проверка уникальности
INSERT INTO like_types (name) VALUES ('media');

-- ключевое слово DEFAULT
INSERT INTO like_types VALUES (DEFAULT, 'media');
INSERT INTO like_types (name) VALUES ('newsline'), ('user');
SELECT * FROM like_types;

-- игнорирует ошибки
INSERT IGNORE INTO like_types (name) VALUES ('media');
-- просмотреть предупреждения
SHOW WARNINGS;

-- SET указывает на имена столбцов явно
INSERT INTO like_types SET name = 'community';

-- REPLACE копия INSERT IGNORE но работает немного по другому 
REPLACE INTO like_types (name) VALUES ('community');

-- вывести всё
SELECT * FROM like_types;
SELECT ALL * FROM like_types;

-- вывести только уникальные строки
SELECT DISTINCT * FROM like_types;

-- использование LIMIT
SELECT ALL * FROM like_types LIMIT 1;

-- обновление данных
UPDATE like_types SET id = id * 10;

-- обновление по условию
UPDATE like_types SET name = 'group' WHERE name = 'community';

-- применение с IGNORE
UPDATE like_types SET name = 'group' WHERE name = 'user';
UPDATE IGNORE like_types SET name = 'group' WHERE name = 'user';
SHOW WARNINGS:

-- удаление по условию
DELETE FROM like_types WHERE name = 'group';

-- удаление слимитом LIMIT
DELETE FROM like_types LIMIT 1;

-- удалить все записи
DELETE FROM like_types;
-- и смотрим счётчик
INSERT INTO like_types VALUES (DEFAULT, 'media');

-- более быстый способ
TRUNCATE like_types;
-- сбрасывает счётчики, проверим
INSERT INTO like_types VALUES (DEFAULT, 'media');

-- ДЗ
-- 1. Повторить все действия по доработке БД vk
-- 2. Заполнить новые таблицы
-- 3. Повторить все действия CRUD.
-- 4. Подобрать сервис-образец для курсовой работы. 

-- MySQL8 на русском
-- http://www.rldp.ru/mysql/mysql80/index.htm


