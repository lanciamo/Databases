-- Урок 6

-- 1. Переанализировал 100 раз, но пока это самое сложное ДЗ) Возможно из-за того, что исходные данные в таблицах все же надо более четко увязывать с заданиями, чтобы хотя бы проверить зарпос можно было)

-- 2.
SELECT lastname, @a := id, (
SELECT COUNT(*) FROM messages WHERE to_user_id = @a
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
) GROUP BY from_user_id
LIMIT 1
) AS number_messages
FROM users
ORDER BY number_messages DESC
;

-- 3.
SELECT
    CONCAT (lastname, ' ',
    firstname),
    (SELECT 2019 - SUBSTRING(birthday, 1, 4)
    FROM
    profiles p WHERE p.user_id = u.id) AS ages
FROM users u
ORDER BY ages;

SELECT id FROM likes WHERE like_type_id IN (1, 2, 4) AND item_id IN (
    SELECT id FROM media WHERE id;




UNION
SELECT 2019 - SUBSTRING(birthday, 1, 4)
    FROM
    profiles ORDER BY user_id
;

SELECT lastname, id from users ORDER BY id
JOIN RIGHT
SELECT 2019 - SUBSTRING(birthday, 1, 4) FROM profiles
;