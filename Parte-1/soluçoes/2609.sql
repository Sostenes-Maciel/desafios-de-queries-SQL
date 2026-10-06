SELECT categories.name, SUM(products.amount) AS amount
FROM products
JOIN categories ON products.id_categories = categories.id
GROUP BY categories.name;
