/**
Premium vs Freemium
Find the total number of downloads for paying and non-paying users by date. 
Include only records where non-paying customers have more downloads than paying customers. 
The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads.

Tables: ms_user_dimension, ms_acc_dimension, ms_download_facts
**/


WITH paying as(
    select 
    d.date,
    SUM(d.downloads) downloads
from ms_user_dimension u
join ms_acc_dimension a
on u.acc_id = a.acc_id
join ms_download_facts d
on u.user_id = d.user_id
where a.paying_customer = 'yes'
group by d.date),

non_paying as(
    select 
    d.date,
    SUM(d.downloads) downloads
from ms_user_dimension u
join ms_acc_dimension a
on u.acc_id = a.acc_id
join ms_download_facts d
on u.user_id = d.user_id
where a.paying_customer = 'yes'
group by d.date
)

select 
    paying.date,
    non_paying.downloads as non_paying_customers,
    paying.downloads as paying_cusotmers
from non_paying
left join paying
on paying.date = non_paying.date
where non_paying.downloads > paying.downloads

-- Solution 2--

---TO DO

/**
Highest Salary In Department
Find the employee with the highest salary per department.
Output the department name, employee's first name along with the corresponding salary.

Table: Employee
**/

-- Solution 1 --

WITH department_salary AS (
    SELECT 
        department, 
        MAX(salary) highest_salary
    FROM Employee
    GROUP BY department
)

SELECT 
    department_salary.department,
    employee.first_name,
    department_salary.highest_salary
FROM employee
JOIN department_salary
ON employee.department = department_salary.department
    AND employee.salary = department_salary.highest_salary


-- Solution 2 --

SELECT
    department,
    first_name,
    salary
FROM employee
WHERE (department, salary) IN 
    (
        SELECT 
            department,
            MAX(salary)
        FROM employee
        GROUP BY department
    );

/**
Host Popularity Rental Prices
You’re given a table of rental property searches by users. 
The table consists of search results and outputs host information for searchers. 
Find the minimum, average, maximum rental prices for each host’s popularity rating. 
The host’s popularity rating is defined as below:
    0 reviews: New
    1 to 5 reviews: Rising
    6 to 15 reviews: Trending Up
    16 to 40 reviews: Popular
    more than 40 reviews: Hot

Tip: The `id` column in the table refers to the search ID. 
You'll need to create your own host_id by concating price, room_type, host_since, zipcode, and number_of_reviews.
**/


/**
Highest Cost Orders
Find the customer with the highest total order cost between 2019-02-01 to 2019-05-01. Output their first name, total cost of their items, and the date.

For simplicity, you can assume that every first name in the dataset is unique.
tables: customers, orders
**/
-- Solution 1 --
SELECT
    first_name,
    order_date,
    SUM(total_order_cost)
FROM
    (
        SELECT
            c.first_name,
            (o.order_cost * o.order_quantity) total_order_cost,
            o.order_date
        FROM customers c
        JOIN orders o 
        ON c.id = o.cust_id 
        WHERE o.order_date BETWEEN '2010-02-01' AND '2019-05-01'
    ) t1 
GROUP BY 1, 2
HAVING SUM(total_order_cost) = 
    (   
        SELECT
            MAX(total_order_cost)
        FROM 
            (
                SELECT SUM(order_cost * order_quantity) total_order_cost
                FROM orders 
                WHERE o.order_date BETWEEN '2010-02-01' AND '2019-05-01'
                GROUP BY cust_id, order_date
            ) t2
    )

-- Solution 2 -- 