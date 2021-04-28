/**

Table: Departments
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key of this table.
The table has information about the id of each department of a university.
 

Table: Students
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| department_id | int     |
+---------------+---------+
id is the primary key of this table.
The table has information about the id of each student at a university and the id of the department he/she studies at.
 
Write an SQL query to find the id and the name of all students who are enrolled in departments that no longer exists.

Return the result table in any order.
**/

------ Solution 1--------

SELECT
    id,
    name 
FROM students
WHERE department_id NOT IN (
    SELECT id
    FROM departmentss
)

------- Solution 2 ----------

SELECT 
    s.id,
    s.name 
FROM students s 
JOIN departments d 
ON d.id = s.department_id
WHERE d.id IS NULL