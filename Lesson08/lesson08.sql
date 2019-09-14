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
-- 6.1 --
-- 6.2
SELECT COUNT(*),
       m.from_user_id
  FROM messages m
  LEFT JOIN friendship f1
    ON f1.user_id = m.from_user_id
  LEFT JOIN friendship f2
    ON f2.friend_id = m.from_user_id
       WHERE m.to_user_id = 23
         AND (f1.friend_id = m.to_user_id OR f2.user_id = m.to_user_id)
GROUP BY m.from_user_id
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 6.3
  SELECT CONCAT (u.lastname, ' ', u.firstname) AS name,
         COUNT(l.user_id) AS likes_count,
         p.birthday AS ages
    FROM users u
    JOIN profiles p
      ON p.user_id = u.id
    LEFT JOIN media m
      ON m.user_id = u.id
    LEFT JOIN likes l
      ON l.item_id = m.id WHERE l.like_type_id IN (1, 2, 4)
GROUP BY u.id
ORDER BY ages DESC
   LIMIT 10;


-- 6.4    
       (
SELECT 'male' AS 'sex', COUNT(*) AS 'total likes'
  FROM likes l
  JOIN profiles p1
    ON l.user_id = p1.user_id AND p1.sex = 'm'
       )
 UNION 
       (
SELECT 'female', COUNT(*)
  FROM likes l
  JOIN profiles p1
    ON l.user_id = p1.user_id AND p1.sex != 'm'
       );
/* не получилось у меня собрать таблицу где разбито не по строкам а по столбцам(
      
SELECT COUNT(lm.user_id) AS 'men likes',
       COUNT(lw.user_id) AS 'women likes'   
  FROM likes lm
  JOIN profiles pm
    ON lm.user_id = pm.user_id AND pm.sex = 'm'
 RIGHT JOIN likes lw
 -- profiles pw
--    ON lw.user_id = pw.user_id AND pw.sex != 'm'
;*/

-- 6.5
  SELECT CONCAT (u.lastname, ' ', u.firstname) AS name,
         COUNT(l.user_id) + COUNT(m.user_id) + COUNT(me.from_user_id) AS activity
    FROM users u
    LEFT JOIN likes l
      ON l.user_id = u.id
    LEFT JOIN media m
      ON m.user_id = u.id
    LEFT JOIN messages me
      ON me.from_user_id = u.id
GROUP BY name
ORDER BY activity
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



UPDATE messages SET from_user_id = from_user_id + RAND(5);
UPDATE likes SET user_id = user_id + RAND(5);
UPDATE media SET user_id = user_id + RAND(5);