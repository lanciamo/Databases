-- "Операторы, фильтрация, сортировка и ограничения"
-- 1.
UPDATE users SET created_at = NOW();
UPDATE users SET updated_at = NOW();

-- 2.
UPDATE users
    SET created_at = str_to_date(created_at, '%d.%m.%Y %h%%i'),
        updated_at = str_to_date(updated_at, '%d.%m.%Y %h%%i');
ALTER TABLE users
    MODIFY created_at DATETIME,
    MODIFY updated_at DATETIME;
    

-- 3.
INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (1, 1, 50), (1, 1, 25), (1, 1, 2), (1, 1, 30), (1, 1, 20), (1, 1, 1
50), (1, 1, 0);
SELECT * FROM storehouses_products ORDER BY IF(value > 0,1,0) DESC, value ASC;

-- 4.
SELECT * FROM users WHERE SUBSTRING(birthday_at, 7, 1) = 5 OR substring(birthday_at, 7, 1) = 8;

-- 5.
SELECT * FROM catalogs WHERE id IN(5, 1, 2) ORDER BY FIELD(id,'5','1','2');

-- "Агрегация данных"
-- 1.
SELECT AVG(2019 - substring(birthday_at, 1, 4)) FROM users;

-- 2.
SELECT COUNT(*) as total, dayname(CONCAT_WS('-', '2019', substring(birthday_at, 6, 5))) as wd FROM users GROUP BY wd ORDER BY wd;

-- 3.
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES (1, 1, 1), (1, 1, 2), (1, 1, 3), (1, 1, 4), (1, 1, 5);

SELECT ROUND(EXP(SUM(LOG(value)))) FROM storehouses_products;
