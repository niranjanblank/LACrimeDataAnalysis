library(tidyverse)

# loading the data
crime_data <- read_csv('data/Crime_Data_from_2020_to_Present.csv')

dim(crime_data)

# total null in the columns
colSums(is.na(crime_data))

# percentage
round(colSums(is.na(crime_data))/dim(crime_data)[1] * 100,2)

# Crm cd2 , Crm cd 3, crm cd 4 and crross street have very high number of null values, so removing those columns
cleaned_crime_data <- crime_data %>% select(-c("Crm Cd 2", "Crm Cd 3", "Crm Cd 4", "Cross Street"))

# Cleaning other null values
# Since not having any code or having null values might mean no weapon, we just set desc to unknown and code to 0
cleaned_crime_data <- cleaned_crime_data %>%
  mutate(`Weapon Used Cd` = replace_na(`Weapon Used Cd`, 0))

cleaned_crime_data <- cleaned_crime_data %>%
  mutate(`Weapon Desc` = replace_na(`Weapon Desc`, "Unknown"))

# Replacing NA values in Vict Sex with Unknown
cleaned_crime_data <- cleaned_crime_data %>%
  mutate(`Vict Sex` = replace_na(`Vict Sex`, 'Unknown'))

# Drop rows where 'Premis Cd', 'Status Desc', or 'Crm Cd 1' are NA
cleaned_crime_data <- cleaned_crime_data %>%
  drop_na(`Premis Cd`, `Status Desc`, `Crm Cd 1`)

write_csv(cleaned_crime_data, 'data/cleaned_crime_data.csv')
