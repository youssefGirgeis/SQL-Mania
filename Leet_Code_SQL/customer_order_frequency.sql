/**
Table: Customers
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| country       | varchar |
+---------------+---------+
customer_id is the primary key for this table.
This table contains information of the customers in the company.

Table: Product
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| description   | varchar |
| price         | int     |
+---------------+---------+
product_id is the primary key for this table.
This table contains information of the products in the company.
price is the product cost.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| product_id    | int     |
| order_date    | date    |
| quantity      | int     |
+---------------+---------+
order_id is the primary key for this table.
This table contains information on customer orders.
customer_id is the id of the customer who bought "quantity" products with id "product_id".
Order_date is the date in format ('YYYY-MM-DD') when the order was shipped.

Write an SQL query to report the customer_id and customer_name of customers who have spent at least $100 in each month of June and July 2020.

Return the result table in any order.
**/

---Solution-----
WITH customer_greater_than_100 AS (
    SELECT    
        o.customer_id,
        c.name,
        (p.price * o.quantity) cost
    FROM customers c 
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN product p 
    ON p.product_id = o.product_id
    WHERE MONTH(o.order_date) IN (6, 7)
    GROUP BY 1
    HAVING SUM(CASE WHEN MONTH(o.order_date) = 6 THEN (p.price * o.quantity) END) >= 100
        AND SUM(CASE WHEN MONTH(o.order_date) = 7 THEN (p.price * o.quantity) END) >= 100
)

SELECT
    customer_id,
    name 
FROM customer_greater_than_100
    

