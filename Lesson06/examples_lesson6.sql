-- Урок 6

-- 1. Переанализировал 100 раз, но пока это самое сложное ДЗ) Возможно из-за того, что исходные данные в таблицах все же надо более четко увязывать с заданиями, чтобы хотя бы проверить зарпос можно было)

-- 2.
SET @a = /* ...  перепробовал очень много своих юзеров, но везде empty set. А как собрать запрос, чтобы перебрать разом всех юзеров, чтобы найти тех, у кого хотя бы не empty set, не додумался)*/

SELECT COUNT(*), from_user_id FROM messages WHERE to_user_id = @a
AND from_user_id IN (
  (SELECT friend_id 
  FROM friendship 
  WHERE user_id = @a
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
  )
  UNION
  (SELECT user_id 
    FROM friendship 
    WHERE friend_id = @a
      AND confirmed_at IS NOT NULL 
      AND status IS NOT NULL
  )
) GROUP BY from_user_id limit 1
;

-- 3.
SELECT lastname, 2019 - SUBSTRING(profiles.birthday, 1, 4) AS ages from users WHERE id IN(
SELECT user_id FROM profiles ORDER BY (2019 - SUBSTRING(birthday, 1, 4)) AS ages)
;







SELECT body FROM messages WHERE user_id IN (
  (SELECT friend_id 
  FROM friendship 
  WHERE user_id = 1
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
  )
  UNION
  (SELECT user_id 
    FROM friendship 
    WHERE friend_id = 1
      AND confirmed_at IS NOT NULL 
      AND status IS NOT NULL
  )
);

SELECT item_id AS mediafile, COUNT(*) AS likes,  
  FROM likes 
    WHERE item_id IN (
      SELECT id FROM media WHERE user_id = 2
        UNION
      SELECT id FROM media WHERE user_id IN (
        SELECT friend_id 
          FROM friendship 
            WHERE user_id = 2 AND status IS NOT NULL)
)
GROUP BY item_id;


SELECT firstname, COUNT(*) FROM users WHERE id IN (
    (SELECT friend_id 
        FROM friendship 
        -- WHERE -- user_id = 1
        -- AND confirmed_at IS NOT NULL 
        -- AND status IS NOT NULL
    )
    UNION
    (SELECT user_id 
        FROM friendship 
        -- WHERE -- friend_id = 1
        -- AND confirmed_at IS NOT NULL 
        -- AND status IS NOT NULL
    )
)
GROUP BY id;







-- Примеры на основе базы данных vk
USE vk;

-- Получаем данные пользователя
SELECT * FROM users WHERE id=1;

SELECT firstname, lastname, 'main_photo', 'city' FROM users WHERE id=1;

SELECT
  firstname,
  lastname,
  (SELECT filename FROM media WHERE id = 
    (SELECT photo_id FROM profiles WHERE user_id = 1)
  ),
  (SELECT hometown FROM profiles WHERE user_id = 1)
  FROM users
    WHERE id = 1;           

-- Получаем фотографии пользователя
SELECT filename FROM media
  WHERE user_id = 1
    AND media_type_id = (
      SELECT id FROM media_types WHERE name LIKE '%photo%'
    );

-- Выбираем историю по добавлению фотографий пользователем
SELECT CONCAT(
  'Пользователь добавил фото ', 
  filename, 
  ' ', 
  created_at) AS news 
    FROM media 
    WHERE user_id = 1 
      AND media_type_id = (
        SELECT id FROM media_types WHERE name LIKE 'photo'
);

-- Улучшаем запрос
SELECT CONCAT(
  'Пользователь ', 
  (SELECT CONCAT(firstname, ' ', lastname)
    FROM users WHERE id=1),
  ' добавил фото ', 
  filename, ' ', 
  created_at) AS news 
    FROM media 
    WHERE user_id = 1 
      AND media_type_id = (
        SELECT id FROM media_types WHERE name LIKE 'photo'
);

-- Найдём кому принадлежат 10 самых больших медиафайлов
SELECT user_id, filename, size 
  FROM media 
  ORDER BY size DESC
  LIMIT 10;

-- Улучшим запрос
SELECT 
  filename, 
  size,
  (SELECT CONCAT(firstname, ' ', lastname) 
    FROM users u 
      WHERE u.id = m.user_id) AS owner 
  FROM media m
  ORDER BY size DESC
  LIMIT 10;
  
 -- Выбираем друзей пользователя
(SELECT friend_id FROM friendship WHERE user_id = 1)
UNION
(SELECT user_id FROM friendship WHERE friend_id = 1);

-- Выбираем только друзей с подтверждённым статусом
(SELECT friend_id 
  FROM friendship 
  WHERE user_id = 1
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
)
UNION
(SELECT user_id 
  FROM friendship 
  WHERE friend_id = 1
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
);


-- Выбираем медиафайлы друзей
SELECT filename FROM media WHERE user_id IN (
  (SELECT friend_id 
  FROM friendship 
  WHERE user_id = 1
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
  )
  UNION
  (SELECT user_id 
    FROM friendship 
    WHERE friend_id = 1
      AND confirmed_at IS NOT NULL 
      AND status IS NOT NULL
  )
);

-- Объединяем медиафайлы пользователя и его друзей для создания ленты новостей
SELECT filename, user_id, created_at FROM media WHERE user_id = 1
UNION
SELECT filename, user_id, created_at FROM media WHERE user_id IN (
  (SELECT friend_id 
  FROM friendship 
  WHERE user_id = 1
    AND confirmed_at IS NOT NULL 
    AND status IS NOT NULL
  )
  UNION
  (SELECT user_id 
    FROM friendship 
    WHERE friend_id = 1
      AND confirmed_at IS NOT NULL 
      AND status IS NOT NULL
  )
)
ORDER BY user_id DESC
LIMIT 1;

-- Определяем пользователей, общее занимаемое место медиафайлов которых 
-- превышает 1МБ

SELECT user_id, SUM(size) AS total
  FROM media
  GROUP BY user_id
  HAVING total > 1000
  ORDER BY total DESC;

-- Подсчитываем лайки для медиафайлов пользователя и его друзей

SELECT item_id AS mediafile, COUNT(*) AS likes 
  FROM likes 
    WHERE item_id IN (
      SELECT id FROM media WHERE user_id = 2
        UNION
      SELECT id FROM media WHERE user_id IN (
        SELECT friend_id 
          FROM friendship 
            WHERE user_id = 2 AND status IS NOT NULL)
)
GROUP BY item_id;

-- Начинаем создавать архив новостей для медиафайлов по месяцам
SELECT COUNT(id) AS arhive, MONTHNAME(created_at) AS month 
  FROM media
  GROUP BY month;
  
-- Архив с правильной сортировкой новостей по месяцам
SELECT COUNT(id) AS news, MONTHNAME(created_at) AS month 
  FROM media
  WHERE YEAR(created_at) = YEAR(NOW())
  GROUP BY month
  ORDER BY FIELD(month, 
    'January', 'February', 'March', 'April', 'May', 'June', 
    'July', 'August', 'September', 'October', 'November', 'December') DESC;

SELECT COUNT(id) AS news, MONTHNAME(created_at) AS month 
  FROM media
  WHERE YEAR(created_at) = YEAR(NOW())
  GROUP BY month
  ORDER BY FIELD(month, 
    'January', 'February', 'March', 'April', 'May', 'June', 
    'July', 'August', 'September', 'October', 'November', 'December') DESC;

SELECT COUNT(id) AS news, MONTHNAME(created_at) AS month 
  FROM media
  GROUP BY month
  ORDER BY FIELD(month, 
    'January', 'February', 'March', 'April', 'May', 'June', 
    'July', 'August', 'September', 'October', 'November', 'December') DESC;
    

-- Выбираем сообщения от пользователя и к пользователю
SELECT from_user_id, to_user_id, body, delivered, created_at 
  FROM messages
    WHERE from_user_id = 1
      OR to_user_id = 1
    ORDER BY created_at DESC;
    
-- Непрочитанные сообщения
SELECT from_user_id, 
  to_user_id, 
  body, 
  IF(delivered, 'delivered', 'not delivered') AS status 
    FROM messages
      WHERE to_user_id = 2
        AND delivered IS NOT TRUE
    ORDER BY created_at DESC;
    
 -- Выводим друзей пользователя с преобразованием пола и возраста 
SELECT 
    (SELECT CONCAT(firstname, ' ', lastname) 
      FROM users 
      WHERE id = user_id) AS friend, 
      
    CASE (sex)
      WHEN 'P' THEN 'man'
      WHEN 'M' THEN 'man'
      WHEN 'D' THEN 'women'
    END AS sex,
    
    TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age
     
  FROM profiles
  
  WHERE user_id IN (
    SELECT friend_id 
    
      FROM friendship
      WHERE user_id = 1
        AND confirmed_at IS NOT NULL
        AND status IS NOT NULL
  );
    
-- Поиск пользователя по шаблонам имени  
SELECT CONCAT(firstname, ' ', lastname) AS fullname  
  FROM users
  HAVING fullname LIKE 'M%';
  
-- Используем регулярные выражения
SELECT CONCAT(firstname, ' ', lastname) AS fullname  
  FROM users
  HAVING fullname RLIKE '^M.*s$';
  
  

  
