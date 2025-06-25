
# Load packages -----------------------------------------------------------

library(tidyverse)
library(linelist)

dat_cleaned <- rio::import(
  here::here("data","derived-data","simulated-ebola-cleaned.rds")
) %>% 
  as_tibble()

dat_cleaned

# challenge ---------------------------------------------------------------

#' task
#' 1. run the whole script. What change between the input and output?
#' 2. modify one line #23: Activate `dplyr::mutate()`. What function can detect upstream changes?
#' 3. modify one line #28: Within `linelist::make_linelist()` change `"age"` to `"age_category"`.
#' 4. modify one line #32: Activate `dplyr::select()` How this affects the code downstream?

dat_cleaned %>% 
  #dplyr::mutate(age = as.character(age)) %>% # challenge: activate this
  linelist::make_linelist(
    id = "case_id",
    date_onset = "date_onset",
    gender = "gender",
    age = "age", # challenge: change to "age_category"
    date_reporting = "date_sample"
  ) %>% 
  linelist::validate_linelist() %>% 
  #dplyr::select(case_id, date_onset, gender) %>% #challenge: activate this
  #linelist::tags_df()
