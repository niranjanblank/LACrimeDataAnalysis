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

