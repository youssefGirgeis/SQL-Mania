/*
Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION.
Your result cannot contain duplicates
*/

SELECT DISTINCT(city)
FROM STATION
WHERE RIGHT(city,1) IN ('a', 'e', 'i', 'o', 'u');