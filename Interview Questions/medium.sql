/**
Top Search Results

You're given a table that contains search results. 
If the 'position' column represents the position of the search results, 
write a query to calculate the percentage of search results that were in the top 3 position.

Table: fb_search_results
**/

SELECT
    (COUNT(*) :: FLOAT/(SELECT count(*) FROM fb_search_results)) * 100 top_3_percentage
FROM fb_search_results
WHERE position <= 3

-- solution using case when --
SELECT 
    (SUM(CASE WHEN position <= 3 THEN 1 ELSE 0 END):: FLOAT /COUNT(*) * 100) AS top_3_percentage
FROM fb_search_results


/**
No Order Customers
Find customers who didn't place orders from 2019-02-01 to 2019-03-01. Output customer's first name.
Tables: customers, orders
**/

SELECT first_name
FROM customers
WHERE id NOT IN (
    SELECT orders.cust_id
    FROM orders
    WHERE order_date BETWEEN '2019-02-01' AND '2019-03-01'
)

/**
Highest Energy Consumption
Find the date with the highest total energy consumption from the Facebook data centers. 
Output the date along with the total energy consumption across all data centers.

Tables: fb_eu_energy, fb_asia_energy, fb_na_energy
**/

-- Solution 1 --
WITH all_energy_consumption AS (
    select *
    from fb_eu_energy
    union 
    select * from fb_asia_energy
    union
    select * from fb_na_energy
    ),
    total_energy AS (
        SELECT 
            date,
            SUM(consumption) total_energy_consumption
        FROM all_energy_consumption
        GROUP BY date
    )
SELECT 
    date,
    total_energy_consumption
FROM total_energy
WHERE total_energy_consumption = (
    SELECT MAX(total_energy_consumption) FROM total_energy
)

-- Solution 2 -- 
SELECT DATE, CONSUMPTION
FROM 
(
SELECT DATE
,SUM(CONSUMPTION) AS CONSUMPTION
,RANK() OVER (ORDER BY SUM(CONSUMPTION) DESC) AS RANK
FROM
(SELECT * FROM FB_EU_ENERGY UNION ALL
SELECT * FROM FB_ASIA_ENERGY UNION ALL
SELECT * FROM FB_NA_ENERGY) A
GROUP BY DATE
) B
WHERE RANK= 1


/**
Top Cool Votes
Find the business and the review_text that received the highest number of  'cool' votes.
Output the business name along with the review text.
Table: yelp_reviews
**/

SELECT
    business_name,
    review_text
FROM yelp_reviews
WHERE cool = (
    SELECT MAX(cool)
    FROM yelp_reviews
)

/**
Order Details
Find order details made by Jill and Eva.
Consider the Jill and Eva as first names of customers.
Output the order date, details and cost along with the first name.
Order records based on the customer id in ascending order.

Tables: customers, orders
***/
SELECT
    c.first_name,
    o.order_date,
    o.order_details,
    o.order_cost
FROM customers c 
JOIN orders o 
WHERE c.first_name = 'Jill' OR c.first_name = 'Eva'
ORDER BY o.cust_id

/**
Customer Revenue In March
Calculate the total revenue from each customer in March 2019. Revenue for each order is calculated by multiplying the order_quantity with the order_cost.
Output the revenue along with the customer id and sort the results based on the revenue in descending order.

Table: orders
**/

SELECT
    cust_id,
    SUM(order_quantity * order_cost) AS revenue
FROM orders 
WHERE DATE_PART('year', order_date :: date) = 2019 
AND DATE_PART('month', order_date :: date) IN (3, 03)
GROUP BY cust_id
ORDER BY revenue DESC

/**
Employee and Manager Salaries
-----------------------------
Find employees who are earning more than managers.
Output the employee name along with the corresponding salary.

Table: employee

Review again..
**/

WITH managers_salary AS (
    SELECT DISTINCT e1.id, e1.salary
    FROM employee e1
    JOIN employee e2
    ON e1.id = e2.manager_id
)

SELECT
    first_name,
    salary
FROM employee
WHERE salary >= (
    SELECT MAX(managers_salary.salary)
    FROM managers_salary
)

/**
Reviews of Categories
Find the top business categories based on the total number of reviews. 
Output the category along with the total number of reviews. Order by total reviews in descending order.

Table: yelp_business
**/

SELECT
     regexp_split_to_table(categories, ';') category,
     SUM(review_count) total_reviews
FROM yelp_business
GROUP BY category
ORDER BY total_reviews DESC;
FROM yelp_business

-- Another Solution --
-- unnest --> expand an array to set of rwos
-- string_to_array --> split a string into array elements using supplied delimiter and optional null string.
select
    unnest(string_to_array(categories, ';')) as category,
    sum(review_count) as review_count
from yelp_business
group by 1
order by 2 desc

/**
Classify Business Type
----------------------
Classify each business as either a restaurant, cafe, school, or other. 
A restaurant should have the word 'restaurant' in the business name. 
For cafes, either 'cafe' or 'coffee' can be in the business name. 
'School' should be in the business name for schools. All other businesses should be classified as 'other'.

Table: sf_restaurant_health_violations
**/

SELECT
    business_name,
    CASE 
        WHEN LOWER(business_name) LIKE '%restaurant%' THEN 'restaurant'
        WHEN LOWER(business_name) LIKE '%cafe%' 
            OR LOWER(business_name) LIKE '%coffee%' THEN 'cafe' 
        WHEN LOWER(business_name) LIKE '%school%' THEN 'school'
        ELSE 'other'
    END business_type
FROM sf_restaurant_health_violations

/**
Inspections That Resulted In Violations
You're given a dataset of health inspections. 
Count the number of inspections that resulted in a violation for 'Roxanne Cafe' for each year. 
If an inspection resulted in a violation, there will be a value in the 'violation_id' column. 
Output the number of inspections by year in ascending order.

Table: sf_restaurant_health_violations
**/

SELECT
    DATE_PART('year', inspection_date) inspection_year,
    COUNT(violation_id) violation_count
FROM sf_restaurant_health_violations
WHERE business_name = 'Roxanne Cafe'
GROUP BY 1
ORDER BY 1

/**
Highest Target Under Manager
Find the highest target achieved by the employee or employees who works under the manager id 13. 
Output the first name of the employee and target achieved. 
The solution should show the highest target achieved under manager_id=13 and which employee(s) achieved it.

Table: salesforce_employees
**/
SELECT
    first_name,
    target
FROM salesforce_employees
WHERE target = (
        SELECT MAX(target)
        FROM salesforce_employees
        WHERE manager_id = 13
    )
    
/**
Acceptance Rate By Date
What is the overall friend acceptance rate by date? 
Your output should have the rate of acceptances by the date the request was sent. 
Order by the earliest date to latest.

Assume that each friend request starts by a user sending (i.e., user_id_sender) 
a friend request to another user (i.e., user_id_receiver) that's logged in the table with action = 'sent'. 
If the request is accepted, the table logs action = 'accepted'. 
If the request is not accepted, no record of action = 'accepted' is logged.

Hint: For the SQL solution, cast your data types as a decimal rather than float in order for your solution to be validated properly. 
There is a rounding error if your solution is casted as a float.

Table: fb_friend_requests
**/
SELECT a.date,
       count(b.user_id_receiver)/count(a.user_id_sender)::decimal AS percentage_acceptance
FROM
  (SELECT date, user_id_sender,
                user_id_receiver
   FROM fb_friend_requests
   WHERE action='sent' ) a
LEFT JOIN
  (SELECT date, user_id_sender,
                user_id_receiver
   FROM fb_friend_requests
   WHERE action='accepted' ) b ON a.user_id_sender=b.user_id_sender
AND a.user_id_receiver=b.user_id_receiver
GROUP BY a.date

/**
Marketing Campaign Success [Simple]
You have a table of in-app purchases by user. 
Users that make their first in-app purchase are placed in a marketing campaign where they see call-to-actions for more in-app purchases. 
Find the number of users that made additional in-app purchases due to the success of the marketing campaign.

The marketing campaign doesn't start until one day after the initial in-app purchase so users 
that make multiple purchases on the same day do not count, nor do we count users that make only the same purchases over time. 
To simplify the scenario, you can also consider users that order multiple products on day 1 and then purchase one of those 
products in the future as beneficiaries of the marketing campaign (e.g., count users who orders product 
IDs 1, 2, 3 on day 1 and then orders only product id 1 a few days later).

Table: marketing_campaign
**/


/**
Given a table of job postings, 
write a query to breakdown the number of users that have posted their jobs once versus 
the number of users that have posted at least one job multiple times.

Column	    type
id	        integer
job_id	    integer
user_id	    integer
date_posted	datetime

Output
column	                                type
posted_jobs_once	                    int
posted_at_least_one_job_multiple_times	int
**/

WITH job_postings AS(
    SELECT
        job_id,
        user_id,
        COUNT(id) number_of_postings
    FROM job_postings
    GROUP BY job_id, user_id
    ORDER BY 3
)

SELECT
    SUM(CASE WHEN job_postings.number_of_postings = 1 THEN 1 ELSE 0) posted_jobs_once
    SUM(CASE WHEN job_postings.number_of_postings > 1 THEN 1 ELSE 0) posted_at_least_one_job_multiple_times
FROM 