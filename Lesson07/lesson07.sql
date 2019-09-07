-- 1.
SELECT name from users WHERE id IN (SELECT user_id from orders);

-- 2.

SELECT
    products.id,
    products.name,
    (SELECT
        catalogs.name
    FROM
        catalogs
    WHERE
        catalogs.id = products.catalog_id) AS 'catalog'
FROM
    products;
    
-- 3. 

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  where_from VARCHAR(255) COMMENT 'from',
  destination TEXT COMMENT 'to');
  
INSERT INTO flights
  (id, where_from, destination)
VALUES
  ('1', 'moscow', 'omsk'),
  ('2', 'novgorod', 'kazan'),
  ('3', 'irkutsk', 'moscow'),
  ('4', 'omsk', 'irkutsk'),
  ('5', 'moscow', 'kazan');
  
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255) COMMENT 'label',
  name TEXT COMMENT 'name');
  
INSERT INTO cities
  (id, label, name)
VALUES
  ('1', 'moscow', 'Москва'),
  ('2', 'novgorod', 'Новгород'),
  ('3', 'irkutsk', 'Иркутск'),
  ('4', 'omsk', 'Омск'),
  ('5', 'kazan', 'Казань');
  
SELECT
    flights.id,
    (SELECT
        cities.name
    FROM
        cities
    WHERE
        cities.label = flights.where_from) AS 'from',
    (SELECT
        cities.name
    FROM
        cities
    WHERE
        cities.label = flights.destination) AS 'to'
FROM
    flights;