-- Пункт 1.
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;

ALTER TABLE likes MODIFY like_type_id INT(10) UNSIGNED;
ALTER TABLE likes MODIFY user_id INT(10) UNSIGNED;
ALTER TABLE likes MODIFY item_id INT(10) UNSIGNED;

ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT profiles_like_types_id_fk
    FOREIGN KEY (like_type_id) REFERENCES like_types(id)
      ON DELETE SET NULL;

ALTER TABLE communities_users
  ADD CONSTRAINT communities_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT communities_type_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE CASCADE;

ALTER TABLE messages
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id)
      ON DELETE CASCADE;

ALTER TABLE friendship
  ADD CONSTRAINT friendship_to_user_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT friendship_from_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE;

ALTER TABLE media MODIFY media_type_id INT(10) UNSIGNED;

ALTER TABLE media
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
      ON DELETE SET NULL;

-- Пункт 2. Скрин в каталоге Lesson08 на GitHub
-- Пункт 3. 
-- 6.1
-- 6.2
-- 6.3

-- 6.4

(SELECT 'male', COUNT(*)
FROM likes l
JOIN profiles p1
ON l.user_id = p1.user_id AND p1.sex = 'm')
UNION (
SELECT 'female', COUNT(*)
FROM likes l
JOIN profiles p1
ON l.user_id = p1.user_id AND p1.sex != 'm');


SELECT COUNT(p1.user_id), COUNT(p2.user_id)
FROM likes l
INNER JOIN profiles p1
ON l.user_id = p1.user_id AND p1.sex = 'm'
INNER JOIN profiles p2
ON l.user_id = p2.user_id AND p2.sex != 'm';
-- 6.5
  SELECT CONCAT (u.lastname, ' ', u.firstname) AS name,
         COUNT(*) AS likes
    FROM users u
    JOIN likes l
      ON l.user_id = u.id
GROUP BY name
ORDER BY likes
   LIMIT 10;
  
-- 7.1
    SELECT users.name, orders.created_at
      FROM users
      JOIN orders
        ON users.id = orders.user_id;
      
-- 7.2
    SELECT products.id,
           products.name,
           catalogs.name AS 'catalog'
      FROM products
      JOIN catalogs
        ON catalogs.id = products.catalog_id;

-- 7.3
    SELECT flights.id,
           c1.name AS 'from',
           c2.name AS 'to'
      FROM flights
      LEFT JOIN cities c1
        ON c1.label = flights.where_from
      LEFT JOIN cities c2
        ON c2.label = flights.destination;

    