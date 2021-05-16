/**
Create a View called “forestation” by joining all three tables - forest_area, land_area and regions in the workspace.
The forest_area and land_area tables join on both country_code AND year.
The regions table joins these based on only country_code.
In the ‘forestation’ View, include the following:

All of the columns of the origin tables
A new column that provides the percent of the land area that is designated as forest.
Keep in mind that the column forest_area_sqkm in the forest_area table and 
the land_area_sqmi in the land_area table are in different units (square kilometers and square miles, respectively), 
so an adjustment will need to be made in the calculation you write (1 sq mi = 2.59 sq km). **/

CREATE VIEW forestation
AS 
SELECT 
    f.country_code,
    f.country_name,
    f.year,
    f.forest_area_sqkm,
    (l.total_area_sq_mi * 2.59) total_area_sqkm,
    (f.forest_area_sqkm/(l.total_area_sq_mi * 2.59)) * 100 forest_percent,
    r.region,
    r.income_group
FROM forest_area f 
JOIN land_area l 
ON f.country_code = l.country_code AND f.year = l.year 
JOIN regions r 
ON r.country_code = l.country_code

/**
What was the total forest area (in sq km) of the world in 1990? 
Please keep in mind that you can use the country record denoted as “World" in the region table.
**/

SELECT
    year,
    forest_area_sqkm
FROM forestation
WHERE year = 1990 AND country_name = 'World'

/**
What was the total forest area (in sq km) of the world in 2016? 
Please keep in mind that you can use the country record in the table is denoted as “World.”
**/

SELECT
    year,
    forest_area_sqkm
FROM forestation
WHERE year = 2016 AND country_name = 'World'
/**
What was the change (in sq km) in the forest area of the world from 1990 to 2016?
**/
SELECT
    forest_area_sqkm - LEAD (forest_area_sqkm) OVER(ORDER BY year) change_in_forest_area
FROM forestation
WHERE (year = 1990 OR year = 2016) AND country_name = 'World'
LIMIT 1

/**
What was the percent change in forest area of the world between 1990 and 2016?
**/
SELECT  
	(l.forest_area_sqkm - r.forest_area_sqkm)/l.forest_area_sqkm *100 change_in_forest_area_percent
FROM forest_area l
JOIN forest_area r
ON (l.year = 1990 AND r.year = 2016) 
AND (l.country_name = 'World' AND r.country_name = 'World')
/**
 If you compare the amount of forest area lost between 1990 and 2016, 
 to which country's total area in 2016 is it closest to?
**/
WITH t1 AS (SELECT
	year,
	country_name,
    total_area_sqkm,
    ABS(total_area_sqkm - (SELECT
            forest_area_sqkm - LEAD (forest_area_sqkm) OVER(ORDER BY year) change_in_forest_area
        FROM forestation
        WHERE (year = 1990 OR year = 2016) AND country_name = 'World'
        LIMIT 1
        )) difference
FROM forestation
WHERE year = 2016)
        
SELECT t1.country_name, t1.total_area_sqkm
    FROM t1
    WHERE t1.difference = (select min(t1.difference) from t1)


/**
Create a table that shows the Regions and their percent forest area
(sum of forest area divided by sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km).
**/

WITH t1 as (
    SELECT
        year,
        region,
	    ROUND(CAST(SUM(forest_area_sqkm)/SUM(total_area_sqkm) * 100 as numeric), 2) AS forest_per_region_1990
    FROM forestation
    WHERE year = 1990
    GROUP BY year, region
), t2 AS (
    SELECT
        year,
        region,
	    ROUND(CAST(SUM(forest_area_sqkm)/SUM(total_area_sqkm) * 100 as numeric), 2) AS forest_per_region_2016
    FROM forestation
    WHERE year = 2016
    GROUP BY year, region
)

SELECT
    t1.region, 
    t1.forest_per_region_1990, 
    t2.forest_per_region_2016
INTO forest_per_region_1990_2016
FROM t1 
JOIN t2 
ON t1.region = t2.region 

/**What was the percent forest of the entire world in 2016? 
Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?
**/
SELECT
    region,
    forest_per_region_2016
FROM forest_per_region_1990_2016
WHERE region = 'World'

/**Which region had the HIGHEST percent forest in 2016**/
SELECT
    region,
    forest_per_region_2016
FROM forest_per_region_1990_2016
ORDER BY 2 DESC
LIMIT 1

/** and which had the LOWEST, to 2 decimal places?**/
SELECT
    region,
    forest_per_region_2016
FROM forest_per_region_1990_2016
ORDER BY 2
LIMIT 1

/**
What was the percent forest of the entire world in 1990? 
Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?
**/
SELECT
    region,
    forest_per_region_1990
FROM forest_per_region_1990_2016
WHERE region = 'World'

/** Which region had the HIGHEST percent forest in 1990 **/
SELECT
    region,
    forest_per_region_1990
FROM forest_per_region_1990_2016
ORDER BY 2 DESC
LIMIT 1

/** and which had the LOWEST, to 2 decimal places **/
SELECT
    region,
    forest_per_region_1990
FROM forest_per_region_1990_2016
ORDER BY 2
LIMIT 1

/**
Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?
**/

SELECT
    region,
    forest_per_region_1990,
    forest_per_region_2016,
    (forest_per_region_2016 - forest_per_region_1990) difference_in_forest
FROM forest_per_region_1990_2016
ORDER BY 4

/**
Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? 
What was the difference in forest area for each?
**/
WITH t1 AS (
    SELECT
  		region,
        year,
        country_name, 
        forest_area_sqkm,
        forest_area_sqkm - LAG(forest_area_sqkm) OVER(PARTITION BY country_name ORDER BY year) decreased_forest_area
    FROM forestation
    WHERE year in (1990, 2016) AND country_name != 'World'),
    t2 AS (
    SELECT 
      	t1.region,
        t1.country_name,
        t1.decreased_forest_area
    FROM t1
    order by 3
    LIMIT 5
)

SELECT 
    t2.country_name,
    t2.region,
    ABS(t2.decreased_forest_area) absolute_forest_area_change
FROM t2;


/** SUCESS Stroies **/

/** Top 5 countries increased in forest area from 1990 to 2016 **/
WITH t1 AS (
    SELECT
  		region,
        year,
        country_name, 
        forest_area_sqkm,
        forest_area_sqkm - LAG(forest_area_sqkm) OVER(PARTITION BY country_name ORDER BY year) difference_in_forest
    FROM forestation
    WHERE year in (1990, 2016) AND country_name != 'World')

    SELECT 
      	t1.region,
        t1.country_name,
        t1.difference_in_forest
    FROM t1
    WHERE t1.difference_in_forest is not null
    order by 3 DESC
    LIMIT 2

    
/* largest percent change in forest area from 1990 to 2016 */
WITH t1 AS (
    SELECT
 		l.region,
        l.country_name,
        l.year year_1990, 
        l.forest_area_sqkm area_1990, 
        r.year year_2016, 
        r.forest_area_sqkm area_2016,
        ((r.forest_area_sqkm - l.forest_area_sqkm) / (l.forest_area_sqkm))* 100 as pct_forest_area_change
    FROM forestation l
    JOIN forestation r
    ON (l.year = 1990 AND r.year = 2016) AND (l.country_name = r.country_name)
    ORDER BY 7 DESC)

SELECT 
    t1.country_name,
    t1.region,
    (t1.pct_forest_area_change) pct_forest_area_change
FROM t1
WHERE t1.pct_forest_area_change IS NOT NULL
LIMIT 1;

/**
Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? 
What was the percent change to 2 decimal places for each?
**/


WITH t1 AS (
    SELECT
 		l.region,
        l.country_name,
        l.year year_1990, 
        l.forest_area_sqkm area_1990, 
        r.year year_2016, 
        r.forest_area_sqkm area_2016,
        ((r.forest_area_sqkm - l.forest_area_sqkm) / (l.forest_area_sqkm))* 100 as pct_forest_area_change
    FROM forestation l
    JOIN forestation r
    ON (l.year = 1990 AND r.year = 2016) AND (l.country_name = r.country_name)
    ORDER BY 7)

SELECT 
    t1.country_name,
    t1.region,
    ABS(t1.pct_forest_area_change) pct_forest_area_change
FROM t1 
LIMIT 5;

/**
If countries were grouped by percent forestation in quartiles, 
which group had the most countries in it in 2016?
**/
WITH t1 AS (
    SELECT 
        country_name, year,
        CASE WHEN forest_percent <= 25 THEN 'First Quartile 0 - 25'
        WHEN forest_percent > 25 AND forest_percent <= 50 THEN 'Second Quartile 25 - 50'
        WHEN forest_percent > 50 AND forest_percent <= 75 THEN 'Third Quartile 50 - 75'
        ELSE 'Fourth Quartile 75 - 100' END AS Quartiles
    FROM forestation
    WHERE forest_percent is not null)
    
SELECT t1.quartiles, count(*) quartiles_count
FROM t1
WHERE t1.year = 2016
GROUP BY 1
ORDER BY 2 DESC

/**
List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.
**/

WITH t1 AS (
    SELECT 
        country_name, year, region, forest_percent,
        CASE WHEN forest_percent <= 25 THEN 'First Quartile 0 - 25'
        WHEN forest_percent > 25 AND forest_percent <= 50 THEN 'Second Quartile 25 - 50'
        WHEN forest_percent > 50 AND forest_percent <= 75 THEN 'Third Quartile 50 - 75'
        ELSE 'Fourth Quartile 75 - 100' END AS quartiles
    FROM forestation
    WHERE forest_percent is not null)
    
SELECT 
    	t1.country_name,
        t1.region,
        t1.forest_percent
FROM t1
WHERE t1.quartiles = 'Fourth Quartile 75 - 100' AND year = 2016
ORDER BY 3 DESC

/**
How many countries had a percent forestation higher than the United States in 2016?
**/

SELECT
    year,
    country_name,
    forest_percent
FROM forestation
WHERE year = 2016 
AND forest_percent > (
    SELECT forest_percent
    FROM forestation
    WHERE year = 2016 AND country_name = 'United States'
)
ORDER BY 3
