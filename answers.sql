SELECT order_id, order_status FROM orders WHERE order_status = 'COMPLETE';

SELECT product_id, product_price, product_name FROM products;
SELECT 
    order_item_order_id, 
    order_item_product_id, 
    order_item_quantity, 
    order_item_product_price FROM order_items
  LEFT JOIN orders
    ON  order_items.order_item_order_id = orders.order_id
    
    ;

SELECT product_name, order_item_quantity, order_item_product_price, order_item_quantity*order_item_product_price AS temp
 FROM order_items 
 INNER JOIN orders ON order_items.order_item_order_id = orders.order_id 
 INNER JOIN products ON order_items.order_item_product_id= products.product_id
 WHERE order_status = 'COMPLETE';
      
      SELECT * FROM log_data
    WHERE url NOT LIKE '%/add%'
    ORDER BY hits DESC
    LIMIT 10;

      
      
SELECT product_name, 
    ROUND(CAST(SUM(
      order_item_quantity * order_item_product_price
    ) AS NUMERIC), 2) AS sales
    FROM order_items 
 INNER JOIN orders ON order_items.order_item_order_id = orders.order_id 
 INNER JOIN products ON order_items.order_item_product_id= products.product_id
 WHERE order_status = 'COMPLETE'
 GROUP BY product_name
 ORDER BY sales DESC
 LIMIT 10;
 
 
 SELECT product_name FROM (
       SELECT url as product_name FROM log_data
    WHERE url NOT LIKE '%/add%'
    ORDER BY hits DESC
    LIMIT 10
 ) AS browser_data
    
 WHERE product_name NOT IN (
 SELECT product_name FROM (
 SELECT product_name, 
    ROUND(CAST(SUM(
      order_item_quantity * order_item_product_price
    ) AS NUMERIC), 2) AS sales
    FROM order_items 
 INNER JOIN orders ON order_items.order_item_order_id = orders.order_id 
 INNER JOIN products ON order_items.order_item_product_id= products.product_id
 WHERE order_status = 'COMPLETE'
 GROUP BY product_name
 ORDER BY sales DESC
 LIMIT 10
 
 ) AS salesdata);
 
 
SELECT product_name FROM (
  SELECT url as product_name FROM log_data
    WHERE url NOT LIKE '%/add%'
    ORDER BY hits DESC
    LIMIT 10
) AS browser_data
    
WHERE product_name NOT IN 
(

SELECT product_name FROM (
 SELECT product_name, 
    ROUND(CAST(SUM(
      order_item_quantity * order_item_product_price
    ) AS NUMERIC), 2) AS sales
    FROM order_items 
 INNER JOIN orders ON order_items.order_item_order_id = orders.order_id 
 INNER JOIN products ON order_items.order_item_product_id= products.product_id
 WHERE order_status = 'COMPLETE'
 GROUP BY product_name
 ORDER BY sales DESC
 LIMIT 10
) AS salesdata
 
) 
UNION 

SELECT product_name FROM (
 SELECT product_name, 
    ROUND(CAST(SUM(
      order_item_quantity * order_item_product_price
    ) AS NUMERIC), 2) AS sales
    FROM order_items 
 INNER JOIN orders ON order_items.order_item_order_id = orders.order_id 
 INNER JOIN products ON order_items.order_item_product_id= products.product_id
 WHERE order_status = 'COMPLETE'
 GROUP BY product_name
 ORDER BY sales DESC
 LIMIT 10
) AS salesdata
    
WHERE product_name NOT IN 
(

SELECT product_name FROM (
  SELECT url as product_name FROM log_data
    WHERE url NOT LIKE '%/add%'
    ORDER BY hits DESC
    LIMIT 10
) AS browser_data
 
)
ORDER BY product_name; 
 
 
 
SELECT url as product_name
 INTO top_viewed FROM log_data
  WHERE url NOT LIKE '%/add%'
  ORDER BY hits DESC
  LIMIT 10;

  
SELECT product_name, 
    ROUND(CAST(SUM(
      order_item_quantity * order_item_product_price
    ) AS NUMERIC), 2) AS sales
    INTO top_sales
    FROM order_items 
 INNER JOIN orders ON order_items.order_item_order_id = orders.order_id 
 INNER JOIN products ON order_items.order_item_product_id= products.product_id
 WHERE order_status = 'COMPLETE'
 GROUP BY product_name
 ORDER BY sales DESC
 LIMIT 10;  

 
 
 
SELECT product_name FROM top_sales EXCEPT SELECT product_name FROM top_viewed;


SELECT product_name FROM top_sales WHERE product_name NOT IN (SELECT product_name FROM top_viewed) UNION
SELECT product_name FROM top_viewed WHERE product_name NOT IN (SELECT product_name FROM top_sales);


