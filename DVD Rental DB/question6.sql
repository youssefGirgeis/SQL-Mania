


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
    t2.pay_amount,
    t2.pay_amount - LAG(pay_amount) OVER (PARTITION BY t2.full_name ORDER BY t2.pay_mon) AS mon_diff
FROM t1
JOIN t2
ON t1.full_name = t2.full_name
ORDER BY 2,1