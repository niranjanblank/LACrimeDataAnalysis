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
    Vict_Sex CHAR(1),
    Vict_Descent CHAR(1),
    Premis_Cd INT,
    Premis_Desc VARCHAR(255),
    Weapon_Used_Cd INT,
    Weapon_Desc VARCHAR(255),
    Status CHAR(2),
    Status_Desc VARCHAR(255),
    Crm_Cd_1 INT,
    Crm_Cd_2 INT,
    Crm_Cd_3 INT,
    Crm_Cd_4 INT,
    LOCATION VARCHAR(255),
    Cross_Street VARCHAR(255),
    LAT FLOAT,
    LON FLOAT
);

-- copy data to table
COPY la_crime FROM '/path/to/csv/ZIP_CODES.txt' WITH (FORMAT csv);