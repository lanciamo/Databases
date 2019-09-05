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
SELECT lastname from users WHERE id IN(
SELECT user_id FROM profiles ORDER BY 2019 - SUBSTRING(birthday, 1, 4))
;
