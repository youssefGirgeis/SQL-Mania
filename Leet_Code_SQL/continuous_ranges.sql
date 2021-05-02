/**
Find the Start and End Number of Continuous Ranges

Table: Logs

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| log_id        | int     |
+---------------+---------+
id is the primary key for this table.
Each row of this table contains the ID in a log Table.

Since some IDs have been removed from Logs. 
Write an SQL query to find the start and end number of continuous ranges in table Logs.
Order the result table by start_id.

The query result format is in the following example:

Logs table:
+------------+
| log_id     |
+------------+
| 1          |
| 2          |
| 3          |
| 7          |
| 8          |
| 10         |
+------------+
**/

--- Solution ---

WITH log_diff AS (
    SELECT
        log_id,
        ABS(log_id - RANK() OVER(ORDER BY log_id)) log_rank_diff
FROM logs )

SELECT 
    MIN(log_id) AS start_id,
    MAX(log_id) AS end_id
FROM log_diff
GROUP BY log_rank_diff

/**
Result table:
+------------+--------------+
| start_id   | end_id       |
+------------+--------------+
| 1          | 3            |
| 7          | 8            |
| 10         | 10           |
+------------+--------------+
**/