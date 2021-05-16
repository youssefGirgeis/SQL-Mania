/*
Query the list of CITY names from STATION that do not start with vowels.
Your result cannot contain duplicates.
*/

SELECT DISTINCT (city)
FROM
    STATION 
WHERE
    LEFT(city,1) NOT IN ('a', 'e', 'i', 'o', 'u');