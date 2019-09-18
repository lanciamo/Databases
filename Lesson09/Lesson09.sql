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


-- 1. разобрался)

DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello()
RETURNS VARCHAR(255) DETERMINISTIC

BEGIN
  
  DECLARE times INT;
  SET times = DATE_FORMAT(NOW(), "%H");
  
      IF times BETWEEN 05 AND 11
        THEN RETURN 'Good morning!';
      ELSEIF times BETWEEN 12 AND 16
        THEN RETURN 'Good afternoon!';
      ELSEIF times BETWEEN 17 AND 23
        THEN RETURN 'Good evening!';
      ELSE RETURN 'Good night!';
      END IF;
END//

-- 2.

CREATE TRIGGER check_product_nn_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
 IF NEW.name = NULL AND OLD.description = NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
  ELSEIF NEW.description = NULL AND OLD.name = NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
  ELSEIF NEW.description = NULL AND NEW.name = NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
  END IF;
END//

CREATE TRIGGER check_product_nn_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  IF NEW.name = NULL AND OLD.description = NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled';
  ELSEIF NEW.description = NULL AND OLD.name = NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UPDATE canceled';
  ELSEIF NEW.description = NULL AND NEW.name = NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled';
  END IF;
END//

-- 3.

-- Практическое задание по теме “Администрирование MySQL” 

-- 1.

-- 2.
