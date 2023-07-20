# LA Crime Data Analysis

## Project Overview
This project conducts a thorough exploratory data analysis (EDA) on Los Angeles crime data, aiming to uncover insights and trends that can inform law enforcement policies, community support strategies, and crime prevention initiatives.

The data was obtained from the city of Los Angeles' Open Data portal and provides detailed information about reported crimes from 2020 to 2023, including the nature of the crime, time and location of occurrence, and victim demographics.

_Note: The detailed explanation can be found in [DataAnalysisReport.md](DataAnalysisReport.md)._

## Data Cleaning and Preprocessing
The raw data was cleaned and preprocessed using R and the tidyverse package. This step involved dealing with missing values, data type conversion, removing duplicates, and data transformations. The clean, ready-for-analysis dataset was then loaded into a SQL database for exploratory data analysis.

## Exploratory Data Analysis (EDA)
The EDA process was carried out with SQL to answer a variety of research questions, such as:
* The most common type of crime in each area.
* The relationship between the time of crime occurrence and the type of crime.
* The average age of victims for each type of crime.
* The gender distribution of victims for different types of crimes.
* Trends in crime rates over the years.
* The distribution of crimes among different descents.
* The use of weapons in crimes.
* The most common locations for crimes.
* Changes in crime types over time.
* The distribution of victim's age for unsolved crimes.
* Crime rate comparison between different sexes and descents.

## Results and Interpretation
The findings were visualized and interpreted, revealing important insights such as the prevalence of vehicle theft across the city, the vulnerability of the 40-year age group to crime, an overall increasing trend in crime rates, and stark disparities in victimization rates among different racial and ethnic groups.

The findings are interpreted considering their implications for law enforcement, crime prevention strategies, and community support initiatives.

## Conclusion
While the analysis has shed light on crime patterns in Los Angeles, it is recognized that the findings are based on available data and may not capture the full complexity of crime patterns. Further research is necessary for a deeper understanding. Nonetheless, the project provides a starting point for data-driven strategies to improve public safety and community support.

## Detailed Analysis
To view the detailed analysis, you can read [DataAnalysisReport.md](DataAnalysisReport.md) file, which contains every step in details from introduction to conclusion, along with sql queries written for data analysis.

## Replicating the Project
1. To run the project, clone the repository and ensure you have the necessary packages installed (R with tidyverse for data cleaning, SQL for data manipulation, and Python with pandas, seaborn, and matplotlib for data visualization).
2. Download the LA Crime dataset which hasn't been included in the repo due to its large size from this [kaggle link](https://www.kaggle.com/datasets/chaitanyakck/crime-data-from-2020-to-present).
The dataset contains two files, we will be using the one which covers the time period of 2022 to present. After downloading the files, save them in "data" folder after creating it in the root directory.
3. Open [data_cleaning.R](data_cleaning.R) file to perform data cleaning.
4. Create a database in sql server(postgresql was used for this project), and follow the queries in [data_analysis.sql](data_analysis.sql) to create table, load data to it and perform the analysis.
5. The visualizations can be generated using python in jupyter notebook [visualizations.ipynb](visualizations.ipynb)
    * Create a .env file in the root folder and add required information about sql server to it:
    ```
    DB_NAME = replace_with_db_name
    DB_USER = replace_with_db_user
    DB_PASSWORD = replace_with_db_password
    DB_HOST = localhost
   ```
   * Install the required python libraries
   ```
   pandas
   matplotlib
   seaborn
   psycopg2
   python-dotenv
   ```
   * Open the [visualizations.ipynb](visualizations.ipynb) to generate the visualizations.
