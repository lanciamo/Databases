-- 1. 
SELECT CONCAT(u.firstname, ' ', u.lastname) AS user,
COUNT(l.id) + COUNT(m.id) + COUNT(t.id) AS overall_activity
FROM users AS u
RIGHT JOIN
likes AS l
ON l.user_id = u.id
RIGHT JOIN
media AS m
ON m.user_id = u.id
RIGHT JOIN
messages AS t
ON t.from_user_id = u.id
GROUP BY u.id
ORDER BY overall_activity DESC
LIMIT 10;

Запрос не корректный, вместо LEFT нужен RIGHT так
как нам нужны к подсчету в том числе те значения u.id которых не было в предыдущих JOIN.

CREATE INDEX media_user_id_idx ON media(user_id);
CREATE INDEX messages_from_user_id_idx ON messages(from_user_id);
CREATE INDEX likes_user_id_idx ON likes(user_id);

после добавления индексов Query cost не изменилось. После установки RIGHT cost уменьшился.
Скрины в папке
