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

