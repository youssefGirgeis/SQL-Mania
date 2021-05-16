

SELECT 
    DATE_PART('month', r.rental_date) AS rental_month, 
    DATE_PART('year', r.rental_date) AS rental_year,
    s.store_id,
    COUNT(*) AS count_rentals
FROM store s 
JOIN staff
ON staff.staff_id = s.manager_staff_id
JOIN payment p 
ON staff.staff_id = p.staff_id
JOIN rental r 
ON r.rental_id = p.rental_id
GROUP BY 1,2,3
ORDER BY 4 DESC