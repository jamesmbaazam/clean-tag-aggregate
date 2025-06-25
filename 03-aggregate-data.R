
# Load packages -----------------------------------------------------------

library(tidyverse)
library(incidence2)

dat_validated <- rio::import(
  here::here("data","derived-data","simulated-ebola-validated.rds")
) %>% 
  as_tibble()

dat_validated


# challenge ---------------------------------------------------------------

#' task
#' 1. run the whole script. Inspect `dat_incidence`. What changes?
#' 2. modify one line #26: Replace `"gender"` by `"age_group"`. How does this affect the code downstream?
#' 3. modify one line #27: Replace `"day"` by `"epiweek"`. How does this affect the code downstream?
#' 4. modify one line #35: Block `fill = "gender"`. How does this affect the code downstream?

dat_incidence <- dat_validated %>% 
  incidence2::incidence(
    date_index = "date_onset", # 
    groups = "gender", # challenge: change to "age_group"
    interval = "day", # challenge: change to "week" or "quarter" or "epiweek" or "isoweek"
    complete_dates = TRUE # 
  )

dat_incidence

dat_incidence %>% 
  plot(
    fill = "gender", # challenge: change to "age_group"
    angle = 45, # 
    n_breaks = 5, # 
    title = "Incidence of cases by date of onset",
    legend = "bottom"
  )
