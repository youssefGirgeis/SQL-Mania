

SELECT f.title AS film_title, c.name AS category_name, f.rental_duration,
       NTILE(4) OVER (ORDER BY rental_duration) AS standard_quartile
FROM film f 
JOIN film_category 
ON f.film_id = film_category.film_id
JOIN category c 
ON c.category_id = film_category.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')


