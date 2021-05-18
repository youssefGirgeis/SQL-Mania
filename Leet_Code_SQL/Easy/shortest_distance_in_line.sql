/*
Table point holds the x coordinate of some points on x-axis in a plane, which are all integers.
 

Write a query to find the shortest distance between two points in these points.
 

| x   |
|-----|
| -1  |
| 0   |
| 2   |
 

The shortest distance is '1' obviously, which is from point '-1' to '0'. So the output is as below:
*/

------- Solution 1 -------
SELECT 
    MIN(diff) shortest
FROM (
   SELECT
        ABS(ABS(x) - ABS(LEAD(x) OVER(ORDER BY x))) diff
    FROM point 
) distance


--------- Solution 2 ------------

SELECT
    MIN(a.x - b.x) shortest
FROM point a, point b
WHERE a.x > b.x

/*
| shortest|
|---------|
| 1       |
*/