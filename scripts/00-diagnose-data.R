
# Load packages -----------------------------------------------------------

library(rio)
library(dplyr)
library(here)

# Use paths relative to rproj
dat <- rio::import(
  here::here("data", "raw_data", "simulated_ebola_2.csv"),
  trust = TRUE
) %>%
  as_tibble()

# First look at the data

dat

# Alternatives
# 1. dat |> View()
# 2. dat |> dplyr::glimpse()

# challenge ---------------------------------------------------------------

#' task: list all inconsistencies in the data

dat
