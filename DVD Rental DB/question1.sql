/*
Question 1
We want to understand more about the movies that families are watching. 
The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.

Create a query that lists each movie, the film category it is classified in, 
and the number of times it has been rented out.
*/


SELECT 
    f.title AS film_title, 
    c.name AS category_name, 
    count(r.inventory_id) AS rental_count
FROM film f 
JOIN film_category 
ON f.film_id = film_category.film_id
JOIN category c 
ON c.category_id = film_category.category_id
JOIN inventory i 
ON f.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP by 1,2
ORDER BY 3 DESC
LIMIT 10;