/*
Managers with at Least 5 Direct Reports

The Employee table holds all employees including their managers. 
Every employee has an Id, and there is also a column for the manager Id.

+------+----------+-----------+----------+
|Id    |Name 	  |Department |ManagerId |
+------+----------+-----------+----------+
|101   |John 	  |A 	      |null      |
|102   |Dan 	  |A 	      |101       |
|103   |James 	  |A 	      |101       |
|104   |Amy 	  |A 	      |101       |
|105   |Anne 	  |A 	      |101       |
|106   |Ron 	  |B 	      |101       |
+------+----------+-----------+----------+
Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. 
For the above table, your SQL query should return:

+-------+
| Name  |
+-------+
| John  |
+-------+
Note:
No one would report to himself.

*/

-------------- Solution 1 ----------

SELECT 
    name 
FROM employee
WHERE id IN (
    SELECT
        managerId
    FROM employee
    GROUP BY managerId
    HAVING COUNT(managerId) >= 5
)

----------- Solution 2 -------------

WITH five_or_more_reports AS (
    SELECT
        managerId,
        COUNT(Id) number_of_staff
    FROM employee
    WHERE managerId IS NOT NULL
    GROUP BY 1
    HAVING COUNT(Id) >= 5
)

SELECT
    employee.name
FROM employee
JOIN five_or_more_reports
ON employee.id = five_or_more_reports.managerId