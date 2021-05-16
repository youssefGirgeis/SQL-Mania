/*
We would like to know who were our top 10 paying customers, how many payments they made on 
a monthly basis during 2007, and what was the amount of the monthly payments. 
Can you write a query to capture the customer name, month and year of payment, 
and total payment amount for each month by these top 10 paying customers?
*/

WITH t1 AS (
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    SUM(p.amount) total
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
), 
t2 AS (
SELECT 
    DATE_TRUNC('month', p.payment_date) AS pay_mon,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    count(p.amount) pay_countpermon,
    SUM(p.amount) pay_amount
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY 1, 2
)

SELECT
    t2.pay_mon,
    t2.full_name,
    t2.pay_countpermon,
    t2.pay_amount
FROM t1
JOIN t2
ON t1.full_name = t2.full_name
ORDER BY 2,1





