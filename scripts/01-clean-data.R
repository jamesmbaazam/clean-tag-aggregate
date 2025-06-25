
# Load packages -----------------------------------------------------------

library(tidyverse)
library(cleanepi)
library(rio)

# Import the raw data
dat <- rio::import(
  here::here("data","raw_data","simulated_ebola_2.csv")
) %>% 
  as_tibble()

dat

# Step by step data cleaning pipeline
cleaned_data <- dat %>%
  # Questions:
  # - What does the function below do?
  # - How can we use the extra arguments provided?
  cleanepi::standardize_column_names() %>%
  # Questions:
  # - What does the function below do?
  # - How do you interpret the `cutoff` argument?
  cleanepi::remove_constants() %>% 
  # Questions:
  # - What does the function below do?
  # - How do you interpret the `target_columns` argument?
  cleanepi::remove_duplicates() %>%
  # Questions:
  # - What does the function below do?
  # - How are NA's represented in this data?
  # - How is NA usually represented in data that you have encountered?
  #       - Are they present in the results of  `cleanepi::common_na_strings`?
  cleanepi::replace_missing_values(na_strings = "") %>% 
  # Questions:
  # - What does the function below do?
  # - Do you have ideas of use cases of this function in your current work?
  # - Are there other inconsistencies in IDs that is not captured in this function?
  # - Are there any built in assumptions in this function that makes it not applicable to your case?
  cleanepi::check_subject_ids(
    target_columns = "case_id",
    range = c(0, 15000)
  ) %>% 
  # Questions:
  # - What does the function below do?
  # - Do you have ideas of use cases of this function in your current work?
  # - Are any of the arguments of particular interest to you?
  cleanepi::standardize_dates(
    target_columns = c("date_onset"), # challenge: add "date_sample" to the vector
    timeframe = c(
      as.Date("2014-01-01"), as.Date("2016-12-01") # challenge: from year 2016 to 2015
    ) 
  ) %>%
  # Questions:
  # - Do you have ideas of use cases of this function in your current work?
  # - Are any of the arguments of particular interest to you?
  cleanepi::convert_to_numeric(
    target_columns = "age"
  )

cleaned_data

# Discussion ---------------------------------------------------------------

# Is the data completely cleaned? If not, which column is still problematic?

cleaned_data










# SOLUTION: We'll use {cleanepi}'s dictionary-based cleaning

## Define a dictionary for gender
dat_dictionary <- expand_grid(
  options = c("1", "2", "M", "F", "m", "f"),
  values = rep(c("male", "female"), each = 3)
) %>%
  mutate(grp = "gender", orders = row_number())

dat_dictionary

# Run the function cleanepi::clean_using_dictionary()
cleaned_data_fin <- cleaned_data %>% 
  cleanepi::clean_using_dictionary(dictionary = dat_dictionary)

cleaned_data_fin

# Let's view the final cleaning report
cleaned_data_fin %>%
  cleanepi::print_report()


# Final steps -------------------------------------------------------------
# Save the cleaned data
rio::export(
  cleaned_data_fin,
  here::here("data", "derived_data", "simulated_ebola_cleaned.rds")
)
