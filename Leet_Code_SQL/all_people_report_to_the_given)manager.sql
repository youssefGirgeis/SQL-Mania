/**
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+

Employees table:
+-------------+---------------+------------+
| employee_id | employee_name | manager_id |
+-------------+---------------+------------+
| 1           | Boss          | 1          |
| 3           | Alice         | 3          |
| 2           | Bob           | 1          |
| 4           | Daniel        | 2          |
| 7           | Luis          | 4          |
| 8           | Jhon          | 3          |
| 9           | Angela        | 8          |
| 77          | Robert        | 1          |
+-------------+---------------+------------+

employee_id is the primary key for this table.
Each row of this table indicates that the employee with ID employee_id 
and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.

Write an SQL query to find employee_id of all employees that directly or 
indirectly report their work to the head of the company.
The indirect relation between managers will not exceed 3 managers as the company is small.
Return result table in any order without duplicates.
**/

-----Solution 1------
SELECT employee_id
FROM employees
WHERE manager_id = 1 AND employee_id != 1
UNION
SELECT employee_id
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE manager_id = 1 AND employee_id != 1
    )
UNION
SELECT employee_id
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE manager_id IN (
        SELECT employee_id
        FROM employees
        WHERE manager_id = 1 AND employee_id != 1
        )
    )

-------- Solution 2 ------------
SELECT a.employee_id
FROM Employees a
JOIN Employees b ON a.manager_id = b.employee_id
JOIN Employees c ON b.manager_id = c.employee_id
WHERE a.employee_id != 1 AND (b.manager_id = 1 or c.manager_id =1)