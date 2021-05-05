/*
 Immediate Food Delivery I

Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 

If the preferred delivery date of the customer is the same as the order date then the order is called immediate otherwise it's called scheduled.

Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal places.

The query result format is in the following example:

Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 5           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-11                  |
| 4           | 3           | 2019-08-24 | 2019-08-26                  |
| 5           | 4           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
+-------------+-------------+------------+-----------------------------+
*/

----- Solution 1 -------
SELECT
    ROUND((SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 
         ELSE 0 END) / COUNT(*)) * 100, 2) AS immediate_percentage 
FROM delivery

----- Solution 2 -------

SELECT
    ROUND((immediate_count/COUNT(*)) * 100, 2) AS immediate_percentage
FROM delivery,
    (SELECT
        COUNT(delivery_id) immediate_count
    FROM delivery
    WHERE order_date = customer_pref_delivery_date) immediate


/*
Result table:
+----------------------+
| immediate_percentage |
+----------------------+
| 33.33                |
+----------------------+
*/