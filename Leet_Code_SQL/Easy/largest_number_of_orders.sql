/**
 Customer Placing the Largest Number of Orders
 Table: Orders

+-----------------+----------+
| Column Name     | Type     |
+-----------------+----------+
| order_number    | int      |
| customer_number | int      |
+-----------------+----------+
order_number is the primary key for this table.
This table contains information about the order ID and the customer ID.
 

Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.

It is guaranteed that exactly one customer will have placed more orders than any other customer.

The query result format is in the following example:

 

Orders table:
+--------------+-----------------+
| order_number | customer_number |
+--------------+-----------------+
| 1            | 1               |
| 2            | 2               |
| 3            | 3               |
| 4            | 3               |
+--------------+-----------------+
**/

--------- Solution 1 ----------

WITH customer_orders AS (
    select
        customer_number,
        count(order_number) number_of_orders
    FROM orders
    GROUP BY customer_number
)

SELECT 
    customer_number
FROM customer_orders
WHERE number_of_orders = (select max(number_of_orders) from customer_orders)


------- Solution 2 -------------
SELECT
    customer_number
FROM orders
GROUP BY customer_number
ORDER BY COUNT(customer_number) DESC
LIMIT 1



/*
Result table:
+-----------------+
| customer_number |
+-----------------+
| 3               |
+-----------------+
*/