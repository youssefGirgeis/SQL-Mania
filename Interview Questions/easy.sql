-- Project Budget Error --

/**
We're given two tables. One is named `projects` and the other maps employees to the projects they're working on. 

We want to select the five most expensive projects by budget to employee count ratio. 
But let's say that we've found a bug where there exists duplicate rows in the `employees_projects` table.

Write a query to account for the error and select the top five most expensive projects by budget to employee count ratio.
**/
SELECT 
    p.title,
    p.budget/count(DISTINCT e.employee_id) AS 'budget_per_employee'
FROM projects p
JOIN employees_projects e
ON e.project_id = p.id
GROUP BY p.id
ORDER BY 2 desc
LIMIT 5

-- Empty Neighborhoods --
/**
We're given two tables, a users table with demographic information and the neighborhood they live in and a neighborhoods table.

Write a query that returns all of the neighborhoods that have 0 users. 
**/

SELECT n.name neighborhood_name
FROM neighborhoods n 
LEFT JOIN users u 
ON n.id = u.neighborhood_id
WHERE u.id IS NULL

-- Salaries Differences --

/**
Write a query that calculates the difference between the highest salaries across the marketing and engineering departments. 
Output just the difference in salaries.
**/
WITH sub AS (
    SELECT d.department, MAX(e.salary) max_salary
FROM db_dept d 
JOIN db_employee e 
ON d.id = e.department_id
WHERE d.department IN ('marketing', 'engineering')
GROUP BY 1
)

SELECT 
    sub.max_salary - LEAD(sub.max_salary) OVER (ORDER BY sub.max_salary DESC) AS diff
FROM sub 
LIMIT 1

/**
Finding Updated Records

We have a table with employees and their salaries, however, 
some of the records are old and contain outdated salary information. 
Find the current salary of each employee assuming that salaries increase each year. 
Output their id, first name, last name, department ID, and current salary. 
Order your list by employee ID in ascending order.
**/

SELECT
    id,
    first_name,
    last_name,
    department_id,
    MAX(salary) current_salary
FROM ms_employee_salary
GROUP BY 1, 2, 3, 4
ORDER BY 1

-- better solution --
SELECT
    id,
    first_name,
    last_name,
    department_id,
    salary AS max_salary
FROM (
    SELECT *,
        DENSE_RANK(salary) OVER (PARTITION BY id ORDER BY salary DESC) rnk 
    FROM ms_employee_salary
) ranked_salaries
WHERE ranked_salaries.rnk = 1
ORDER BY id 

/**
Popularity of Hack

Facebook has developed a new programing language called Hack.To measure 
the popularity of Hack they ran a survey with their employees. 
The survey included data on previous programing familiarity as well as 
the number of years of experience, age, gender and most importantly satisfaction with Hack. 
Due to an error location data was not collected, 
but your supervisor demands a report showing average popularity of Hack by office location. 
Luckily the user IDs of employees completing the surveys were stored.
Based on the above, find the average popularity of the Hack per office location.
Output the location along with the average popularity.

Tables: facebook_employees, facebook_hack_survey
**/

SELECT
    e.location,
    AVG(s.popularity) average_popularity
FROM facebook_employees e
JOIN facebook_hack_survey s 
ON e.id = s.employee_id
GROUP BY 1
ORDER BY 2 DESC

/**
Top 5 States With 5 Star Businesses

Find the top 5 states with the most 5 star businesses. 
Output the state name along with the number of 5-star businesses 
and order records by the number of 5-star businesses in descending order. 
In case there are two states with the same result, sort them in alphabetical order.
**/

SELECT
    state,
    COUNT(business_id) five_star_count
FROM yelp_business
WHERE stars = 5
GROUP BY state
ORDER by 2 DESC, 1
LIMIT 5

/**
Average Salaries

Compare each employee's salary with the average salary of the corresponding department.
Output the department, first name, and salary of employees along with the average salary of that department.

Table: employee
**/
WITH department_average_salary AS (
    SELECT
        department,
        AVG(salary) average_salary
    FROM employee
    GROUP BY department
);

SELECT 
    e.first_name,
    e.salary,
    d.department,
    d.average_salary AS department_average_salaries
FROM employee e
JOIN department_average_salary d 
ON e.department = d.department

-- window function solution --

SELECT
    first_name, 
    salary,
    department,
    AVG(salary) OVER (PARTITION BY department)
FROM employee;

/**
Customer Details

Find the details of each customer regardless of whether the customer made an order not.
Output customer's first name, last name, and the city along with the corresponding order details.
Sort records based on the customer's first name and the order details in ascending order.

Tables: customers, orders
**/

SELECT
    c.first_name,
    c.last_name,
    c.city,
    o.order_details
FROM customers c 
LEFT JOIN orders o
ON c.id = o.cust_id
ORDER BY c.first_name, o.order_details

/**
Number Of Bathrooms And Bedrooms

Find the average number of bathrooms and bedrooms for each city’s property types. 
Output the result along with the city name and the property type.

Table: airbnb_search_details
**/

SELECT
    city,
    property_type,
    AVG(bathrooms) OVER (PARTITION BY city, property_type) average_bathrooms,
    AVG(Bedrooms) OVER (PARTITION BY city, property_type) average_bedrooms
FROM airbnb_search_details;

SELECT
    city,
    property_type,
    AVG(bathrooms) average_bathrooms,
    AVG(Bedrooms) average_bedrooms
FROM airbnb_search_details
GROUP BY city, property_type
