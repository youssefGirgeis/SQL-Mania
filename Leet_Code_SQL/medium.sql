/**
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+

employee_id is the primary key for this table.
Each row of this table indicates that the employee with ID employee_id 
and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.

Write an SQL query to find employee_id of all employees that directly or 
indirectly report their work to the head of the company.
The indirect relation between managers will not exceed 3 managers as the company is small.
Return result table in any order without duplicates.
**/
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