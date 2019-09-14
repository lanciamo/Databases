-- Практическое задание по теме “Транзакции, переменные, представления”

-- 1.

START TRANSACTION;

SELECT * FROM sample.users WHERE sample.users.id = 1;

SELECT * FROM shop.users WHERE shop.users.id = 1;

UPDATE shop.users SET shop.users.id = 10 WHERE shop.users.id = 1;

INSERT INTO shop.users
SELECT * 
  FROM sample.users
 WHERE sample.users.id = 1;
 
SELECT * FROM shop.users;

DELETE 
  FROM sample.users
 WHERE sample.users.id = 1;

SELECT * FROM sample.users;

COMMIT;

-- 2.

CREATE OR REPLACE VIEW namedog
    AS SELECT p.name AS specific_name, c.name AS basic_name
         FROM products p
         LEFT JOIN catalogs c
           ON p.catalog_id = c.id;

SELECT * FROM namedog;

-- 3.

-- 4.

-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
DELIMITER //


-- 1. не очень работает

DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello(seconds INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
  DECLARE mornings, days, evenings, nights, returniamo VARCHAR(255);

  SET mornings = 'Good morning!';
  SET days = 'Good afternoon!';
  SET evenings = 'Good evening!';
  SET nights = 'Good night!';
  SET returniamo = 'default';
  
      IF DATE_FORMAT(NOW(), "%H:") IN (05, 11)
        THEN SET returniamo = mornings;
      ELSEIF DATE_FORMAT(NOW(), "%H:") IN (12, 16)
        THEN SET returniamo = days;
      ELSEIF DATE_FORMAT(NOW(), "%H:") IN (17, 23)
        THEN SET returniamo = evenings;
      ELSE SET returniamo = nights;
      
  RETURN returniamo;

END//

-- 2.

CREATE TRIGGER check_product_nn_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF NEW.name = NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DELETE canceled';
  ELSEIF NEW.description = NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DELETE canceled';
  END IF;
END//

CREATE TRIGGER check_product_nn_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  IF NEW.name = NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DELETE canceled';
  ELSEIF NEW.description = NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DELETE canceled';
  END IF;
END//

-- 3.

-- Практическое задание по теме “Администрирование MySQL” 

-- 1.

-- 2.
