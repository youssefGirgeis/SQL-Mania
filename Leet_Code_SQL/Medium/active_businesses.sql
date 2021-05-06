/*
Table: Events

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| business_id   | int     |
| event_type    | varchar |
| occurences    | int     | 
+---------------+---------+
(business_id, event_type) is the primary key of this table.
Each row in the table logs the info that an event of some type occured at some business for a number of times.
 

Write an SQL query to find all active businesses.

An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

The query result format is in the following example:

Events table:
+-------------+------------+------------+
| business_id | event_type | occurences |
+-------------+------------+------------+
| 1           | reviews    | 7          |
| 3           | reviews    | 3          |
| 1           | ads        | 11         |
| 2           | ads        | 7          |
| 3           | ads        | 6          |
| 1           | page views | 3          |
| 2           | page views | 12         |
+-------------+------------+------------+
*/

------- Solution 1 --------

SELECT 
    business_id
FROM events
JOIN (
    SELECT
        event_type,
        avg(occurences) occurence_avg
    FROM events
    GROUP BY event_type
) event_avg
ON events.event_type = event_avg.event_type
WHERE events.occurences > event_avg.occurence_avg
GROUP BY business_id
HAVING count(business_id) > 1 


--------- Solution 2 -------------

WITH r2 AS(
SELECT *, 
    CASE WHEN occurences > AVG(occurences) OVER (PARTITION BY event_type) THEN 1 ELSE 0 END AS chosen
FROM Events)
SELECT business_id
FROM r2
GROUP BY business_id
HAVING SUM(chosen) >1;

/*
Result table:
+-------------+
| business_id |
+-------------+
| 1           |
+-------------+ 
*/