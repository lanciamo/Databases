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
    
--

SELECT
    id, name, catalog_id
FROM
    products
WHERE
    catalog_id IN (SELECT id FROM catalogs);
    
--

SELECT
    id, name, price, catalog_id
FROM
    products
WHERE
    catalog_id = 2 AND
    price < ANY /*SOME*/ (SELECT price FROM products WHERE catalog_id = 1);
    -- ALL - все значения должны выполнять условие
    
SELECT * FROM catalogs
WHERE EXISTS /* NOT*/ (SELECT * FROM products WHERE catalog_id = catalog.id);

--
SELECT id, price, catalog_id FROM products
WHERE (catalog_id, 5060.00) IN (SELECT id, price FROM catalog);
--
SELECT
    AVG(price)
FROM (SELECT * FROM products WHERE catalog_id = 1) AS prod; -- если вложено во FROM обязаны использовать AS

--
SELECT id, AVG(price) FROM (SELECT id, MIN(price) AS price FROM products GROUP BY catalog_id) AS prod;

--
SELECT
    p.name,
    p.price,
    c.name
FROM
    catalogs AS c JOIN products AS p
ON /*предпочтительнее чем WHERE*/
    c.id = p.catalog_id;
--
SELECT
    *
FROM
    catalogs AS fst
JOIN
    catalogs AS snd
USING(id); /* равно fst.id = snd.id*/

--
UPDATE
    catalogs
JOIN
    products
ON
    catalogs.id = product.catalog_id
SET
    price = price * 0.9
WHERE
    catalogs.name = 'мат платы';
--
DELETE
    products, catalogs
FROM
    catalogs
JOIN
    products
ON
    catalogs.id = product.catalog_id
WHERE
    catalogs.name = 'мат платы';

--
SHOW CREATE TABLE products\G;
--

