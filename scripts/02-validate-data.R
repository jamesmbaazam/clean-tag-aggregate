
# Load packages -----------------------------------------------------------

library(tibble)
library(linelist)

dat_cleaned_df <- rio::import(
  here::here("data","derived_data","simulated_ebola_cleaned.rds")
) %>% 
  as_tibble()

dat_cleaned_df

# Question
# - What is the class of the dat_cleaned?

# Safeguarding your data 
# 
## Create a linelist and inspect
data_cleaned_ll <- dat_cleaned_df %>%
  linelist::make_linelist(
    id = "case_id",
    gender = "gender",
    age = "age",
    date_onset = "date_onset"
  )

data_cleaned_ll

# Question
# - What are some notable differences between data_cleaned_ll and dat_cleaned_df?

# Check that the new linelist is valid
data_cleaned_ll |> 
  linelist::validate_linelist()

# Question
# - What checks were performed on the object?

#' TASK:
#' - Modify the class of the age column.
#'    - What do you think will happen?

# Let's see
dat_cleaned %>% 
  dplyr::mutate(age = as.character(age)) %>% # we added this new line
  linelist::make_linelist(
    id = "case_id",
    gender = "gender",
    age = "age",
    date_onset = "date_onset"
  ) %>% 
  linelist::validate_linelist()

#' TASK: Select some of the tagged columns with `dplyr::select()`. How does this affect the code downstream?

# Let's see
dat_cleaned %>%
  linelist::make_linelist(
    id = "case_id",
    gender = "gender",
    age = "age",
    date_onset = "date_onset"
  ) %>%
  dplyr::select(case_id, date_onset, gender)

# Note that we can tighten the consequences of losing a tag by making it error instead
## Before that, let's check the current action
linelist::get_lost_tags_action()

## Let's change the current action and run the pipeline above again
linelist::lost_tags_action("error")

## This was for demo purposes, so let's return it to a wanring
linelist::lost_tags_action("warning")

# FINALLY: let's run the whole safeguarding pipeline and generate a df of tags used
dat_cleaned %>%
  linelist::make_linelist(
    id = "case_id",
    gender = "gender",
    age = "age",
    date_onset = "date_onset"
  ) %>%
  linelist::validate_linelist() %>%
  linelist::tags_df()

# A LAST TIP

# You can add your own tags to the linelist object.
# Let's create a new column and tag it.
 dat_cleaned |> 
   dplyr::mutate(
     age_category = base::cut(
       x = age,
       breaks = c(0, 20, 30, 50),
       include.lowest = TRUE,
       right = FALSE
     )
   ) |> 
   make_linelist(
     id = "case_id",
     gender = "gender",
     age = "age",
     date_onset = "date_onset",
     age_group = "age_category", # new tag
     allow_extra = TRUE # this must be set to TRUE when adding new tags
   ) |> 
   validate_linelist(
     allow_extra = TRUE,
     ref_types = linelist::tags_types(
       age_group = c("factor"),
       allow_extra = TRUE
     )
   )
