-- Creating table for the data
CREATE TABLE la_crime (
    DR_NO BIGINT PRIMARY KEY,
    Date_Rptd DATE,
    DATE_OCC DATE,
    TIME_OCC TIME,
    AREA INT,
    AREA_NAME VARCHAR(255),
    Rpt_Dist_No INT,
    Part_1_2 INT,
    Crm_Cd INT,
    Crm_Cd_Desc VARCHAR(255),
    Mocodes VARCHAR(255),
    Vict_Age INT,
    Vict_Sex VARCHAR(20),
    Vict_Descent VARCHAR(20),
    Premis_Cd INT,
    Premis_Desc VARCHAR(255),
    Weapon_Used_Cd INT,
    Weapon_Desc VARCHAR(255),
    Status CHAR(2),
    Status_Desc VARCHAR(255),
    Crm_Cd_1 INT,
    LOCATION VARCHAR(255),
    LAT FLOAT,
    LON FLOAT
);

-- query for dropping table
drop table la_crime

-- copy data to table
SET datestyle = 'SQL, MDY';
COPY la_crime FROM 'D:\Projects\LACrimeDataAnalysis\data\cleaned_crime_data.csv' WITH (FORMAT csv, HEADER);

-- show all the data
select * from la_crime

-- 1. What is the most common type of crime (based on 'Crm Cd Desc') in each area (based on 'AREA NAME')?

WITH crime_counts AS (
	select area_name, crm_cd_desc, 
	count(*) as count_per_area_per_crime,
	ROW_NUMBER() OVER (PARTITION BY area_name ORDER BY COUNT(*) DESC) as rn
	from la_crime 
	group by area_name,crm_cd_desc 
)

SELECT area_name, crm_cd_desc as most_common_crime, count_per_area_per_crime 
from crime_counts
where rn=1


-- 2. How does the time of occurrence ('TIME OCC') relate to the type of crime ('Crm Cd Desc')? Are certain crimes more likely at certain times of day?
SELECT 
crm_cd_desc,
CASE
	WHEN EXTRACT(HOUR FROM time_occ) BETWEEN 0 AND 5 THEN 'Night'
	WHEN EXTRACT(HOUR FROM time_occ) BETWEEN 6 AND 11 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM time_occ) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END as time_period,
count(*) as crime_count
from la_crime
group by crm_cd_desc, time_period
order by crm_cd_desc, crime_count desc;

-- 3. What is the average age ('Vict Age') of victims for each type of crime ('Crm Cd Desc')?
SELECT 
crm_cd_desc as Crime , 
ROUND(AVG(vict_age)) AS "Average Age"
from la_crime
WHERE vict_age != 0
group by crm_cd_desc
 
-- 4. Are men, women, or non-binary individuals ('Vict Sex') more likely to be victims of certain types of crimes ('Crm Cd Desc')?
SELECT 
crm_cd_desc,
vict_sex,
count(*) as victim_count
from la_crime
group by crm_cd_desc, vict_sex
order by crm_cd_desc asc, victim_count desc

-- 5. How does crime rate change over the years? Is there an overall increasing or decreasing trend?

SELECT
EXTRACT(YEAR FROM date_occ) as Year,
COUNT(*) as Crime_Count,
COUNT(*) / MAX(EXTRACT(DOY FROM date_occ)) as Average_Crimes_Per_Day
FROM la_crime
GROUP BY Year
ORDER BY Year ASC


-- 6. How does the rate of crimes differ between different descents ('Vict Descent')?
SELECT
vict_descent,
COUNT(*) as Crime_Count
FROM la_crime
group by vict_descent
order by Crime_Count desc

-- 7. What percentage of crimes involve the use of weapons ('Weapon Used Cd' or 'Weapon Desc')?
SELECT 
weapon_desc,
count(*) as weapon_used_count,
(count(*) / (SELECT count(*) from la_crime)::float)*100 As Weapon_Used_percentage
from la_crime
group by weapon_desc
order by weapon_used_count desc


-- 8. What are the most common locations for crimes to occur (based on 'LOCATION')?
-- SELECT
-- area_name,
-- count(*) as crime_count
-- from la_crime
-- group by area_name
-- order by crime_count desc

-- -- 9. Are there certain crimes that are increasing or decreasing over time more than others?
-- with crime_over_time as (
-- 	SELECT
-- 	EXTRACT(YEAR from date_occ) as year,
-- 	crm_cd_desc,
-- 	count(*) as crime_count,
-- 	ROW_NUMBER() OVER (PARTITION by EXTRACT(YEAR from date_occ) order by count(*) desc ) as rn
-- 	from la_crime
-- 	group by year, crm_cd_desc
-- ) 

-- SELECT
-- year, crm_cd_desc,crime_count,rn
-- from crime_over_time
-- where rn <= 3



WITH crime_over_time AS (
  SELECT
    EXTRACT(YEAR FROM date_occ) AS year,
    crm_cd_desc,
    COUNT(*) AS crime_count,
    LAG(COUNT(*)) OVER (PARTITION BY crm_cd_desc ORDER BY EXTRACT(YEAR FROM date_occ)) AS previous_count
  FROM
    la_crime
  GROUP BY
    year, crm_cd_desc
)
SELECT
  year,
  crm_cd_desc,
  crime_count,
  previous_count,
  crime_count - previous_count AS count_change
FROM
  crime_over_time
ORDER BY
  count_change DESC;
  
-- 10. Are certain types of crime more prevalent in certain areas?
with total_crimes_by_area as (
Select
	area_name,
	count(*) as total_crime_count
	from la_crime
	group by area_name
),
crime_counts_by_area as (
	SELECT 
	area_name,
	crm_cd_desc,
	count(*) as crime_count,
	ROW_NUMBER() OVER (PARTITION BY area_name ORDER BY COUNT(*) desc) as rn
	from la_crime
	group by area_name, crm_cd_desc
)

select 
	cc.area_name, 
	cc.crm_cd_desc,
	cc.crime_count,
	cc.crime_count * 100.0 / tc.total_crime_count as crime_proportion
from crime_counts_by_area as cc
JOIN
	total_crimes_by_area as tc ON cc.area_name = tc.area_name
where rn <=5
ORDER BY 
    cc.area_name, 
    cc.crime_count DESC;
	
-- 11. Are certain crimes more likely to happen at certain times of the year?
SELECT
 crm_cd_desc,
 EXTRACT (MONTH from date_occ) as month_of_occurence,
 count(*) as crime_count
FROM la_crime
group by crm_cd_desc, month_of_occurence
order by crm_cd_desc, crime_count


-- 12. Which area has the most crimes?
SELECT
	area_name,
	count(*) as crime_count
FROM la_crime
group by area_name
order by crime_count desc
limit 1

-- 13. Which area has the least crimes?
SELECT
	area_name,
	count(*) as crime_count
FROM la_crime
group by area_name
order by crime_count asc
limit 1


-- 14. What is the distribution of victim's age for unsolved crimes?
SELECT
	CASE
		WHEN age_bucket=1 THEN '0-10'
		WHEN age_bucket=2 THEN '11-20'
		WHEN age_bucket=3 THEN '21-30'
	    WHEN age_bucket = 4 THEN '31-40'
        WHEN age_bucket = 5 THEN '41-50'
        WHEN age_bucket = 6 THEN '51-60'
        WHEN age_bucket = 7 THEN '61-70'
        ELSE '71+'
	END as age_range,
	count(*) as total_victims
FROM
	(select
		width_bucket(vict_age ,0,100,7) as age_bucket
	from la_crime
	where
		status='IC' and vict_age >0) sub
group by age_range

-- 15. How does the crime rate compare between different sexes and descents?
SELECT 
    vict_sex,
    count(*) as total_crimes,
    ROUND((count(*)::NUMERIC / (SELECT COUNT(*) FROM la_crime)::NUMERIC) * 100.0, 2) as crime_rate
FROM la_crime
GROUP BY vict_sex
ORDER BY crime_rate desc

SELECT 
    vict_descent,
    count(*) as total_crimes,
    ROUND((count(*)::NUMERIC / (SELECT COUNT(*) FROM la_crime)::NUMERIC) * 100.0, 2) as crime_rate
FROM la_crime
GROUP BY vict_descent
ORDER BY crime_rate desc








