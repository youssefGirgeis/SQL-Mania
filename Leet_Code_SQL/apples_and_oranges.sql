/**
Table: Sales

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_date     | date    |
| fruit         | enum    | 
| sold_num      | int     | 
+---------------+---------+
(sale_date,fruit) is the primary key for this table.
This table contains the sales of "apples" and "oranges" sold each day.

Sales table:
+------------+------------+-------------+
| sale_date  | fruit      | sold_num    |
+------------+------------+-------------+
| 2020-05-01 | apples     | 10          |
| 2020-05-01 | oranges    | 8           |
| 2020-05-02 | apples     | 15          |
| 2020-05-02 | oranges    | 15          |
| 2020-05-03 | apples     | 20          |
| 2020-05-03 | oranges    | 0           |
| 2020-05-04 | apples     | 15          |
| 2020-05-04 | oranges    | 16          |
+------------+------------+-------------+

Write an SQL query to report the difference between number of apples and oranges sold each day.

Return the result table ordered by sale_date in format ('YYYY-MM-DD').
**/

------ Solution 1 ---------

WITH sales_diff AS(
    SELECT
        sale_date,
        sold_num - LEAD(sold_num) OVER (PARTITION BY sale_date) diff 
    FROM sales
)
SELECT 
    sale_date,
    diff
FROM sales_diff
WHERE diff IS NOT NULL

-------- Solution 2 -----------

SELECT
    apple.sale_date,
    (apple.sold_num - orange.sold_num) diff 
FROM sales apple 
JOIN sales orange 
ON apple.sale_date = orange.sale_date
WHERE apple.fruit = 'apples' 
    AND orange.fruit = 'oranges' 

------ Solution 3 -------
SELECT
    sale_date,
    SUM(CASE WHEN fruit = 'apples'
        THEN sold_num 
        ELSE -sold_num END) AS diff
FROM Sales
GROUP BY 1