
# Load packages -----------------------------------------------------------

library(tidyverse)
library(incidence2)

dat_validated <- rio::import(
  here::here("data","derived_data","simulated_ebola_validated.rds")
) %>%
  as_tibble()

dat_validated


# Aggregating and visualizing data --------------------------------------------

# TASK:
# - Aggregate the incidence without a grouping and plot
dat_incidence <- dat_validated %>%
  incidence2::incidence(
    date_index = "date_onset", # challenge: change to "date_sample"
    interval = "day", # challenge: change to "week" or "quarter" or "epiweek" or "isoweek"
    complete_dates = TRUE # challenge: change to FALSE
  )

dat_incidence

dat_incidence %>%
  plot(
    n_breaks = 5,
    title = "Incidence of cases by date of onset",
    legend = "bottom"
  )


# TASK:
# - We can aggregate incidence by a grouping. Let's use gender and the date of onset as the reference date and plot
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
    fill = "gender",
    angle = 45,
    n_breaks = 5,
    title = "Incidence of cases by date of onset",
    legend = "bottom"
  )

# TASK:
# - Aggregate incidnce by `"age_group"` and in weekly intervals and plot.
# - What do you observe?
dat_validated %>%
  incidence2::incidence(
    date_index = "date_onset", #
    groups = "age_group",
    interval = "week",
    complete_dates = TRUE #
  ) %>%
  plot(
    fill = "age_group", # challenge: change to "age_group"
    angle = 45, #
    n_breaks = 5, #
    title = "Incidence of cases by date of onset",
    legend = "bottom"
  )

# TIP:
# - If you do not specify the fill argument, the groups are facetted.
dat_validated %>%
  incidence2::incidence(
    date_index = "date_onset", #
    groups = "age_group",
    interval = "week",
    complete_dates = TRUE #
  ) %>%
  plot(
    angle = 45, #
    n_breaks = 5, #
    title = "Incidence of cases by date of onset",
    legend = "bottom"
  )
