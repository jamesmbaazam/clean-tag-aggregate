
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

# Data cleaning pipeline
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
  # - Do you have ideas of use cases of this fucntion in your current work?
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
  cleanepi::convert_to_numeric(
    target_columns = "age"
  ) %>% 
  cleanepi::clean_using_dictionary(dictionary = dat_dictionary) %>% # challenge: activate this
  # cleanepi::print_report() # challenge: activate this
  identity()

cleaned_data


# load data dictionary (collapse this) ----------------------------------------------------

# Read this dictionary and run the function cleanepi::clean_using_dictionary()
dat_dictionary <- tibble::tribble(
  ~options,  ~values,     ~grp, ~orders,
  "1",   "male", "gender",      1L, # remove this line: how does this affect the code downstream?
  "2", "female", "gender",      2L,
  "M",   "male", "gender",      3L,
  "F", "female", "gender",      4L,
  "m",   "male", "gender",      5L,
  "f", "female", "gender",      6L
)

dat_dictionary

# challenge ---------------------------------------------------------------

#' task: 
#' - Modify one line #47: Change `"2016-12-01"` to `"2014-12-01"`. What changes?
#' - Modify one line #54: Activate `cleanepi::clean_using_dictionary()`. What changes?
