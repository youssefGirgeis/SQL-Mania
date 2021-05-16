

SELECT DISTINCT(city)
FROM 
    STATION
WHERE
    LEFT(city,1) IN ('a', 'e', 'i', 'o', 'u') 
AND 
    RIGHT(city,1) IN ('a', 'e', 'i', 'o', 'u');