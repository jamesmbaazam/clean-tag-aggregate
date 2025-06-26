
# Load packages -----------------------------------------------------------

library(tidyverse)
library(incidence2)

dat_validated <- rio::import(
  here::here("data","derived_data","simulated_ebola_validated.rds"),
  trust = TRUE
) %>%
  as_tibble()

dat_validated


# Aggregating and visualizing data --------------------------------------------

# TASK:
# - Aggregate the incidence without a grouping
dat_incidence <- dat_validated %>%
  incidence2::incidence(
    date_index = "date_onset",
    interval = "day",
    complete_dates = TRUE
  )

dat_incidence

# Plot the results
dat_incidence %>%
  plot(
    title = "Incidence of cases by date of onset",
    legend = "bottom",
    color = "black",
    angle = 45
  )


# TASK:
# - We can aggregate incidence by a grouping.
# Let's use "gender" and the "date_onset" as the reference date and plot
dat_incidence <- dat_validated %>%
  incidence2::incidence(
    date_index = "date_onset",
    groups = "gender",
    interval = "day",
    complete_dates = TRUE
  )

dat_incidence

# TIP:
# Without fill sepcified, the data is facetted
dat_incidence %>%
  dplyr::filter(!is.na(gender)) |>
  plot(
    title = "Incidence of cases by date of onset",
    angle = 45,
    legend = "bottom"
  )

# With fill, the data is plotted together
dat_incidence %>%
  dplyr::filter(!is.na(gender)) |>
  plot(
    fill = "gender",
    angle = 45,
    title = "Incidence of cases by date of onset",
    legend = "bottom"
  )

# TASK:
# - Aggregate incidence by `"age_group"` and in weekly intervals and plot.
# - What do you observe?
dat_validated %>%
  dplyr::filter(!is.na(age_group)) |>
  incidence2::incidence(
    date_index = "date_onset",
    groups = "age_group",
    interval = "week",
    complete_dates = TRUE
  ) %>%
  plot(
  # fill = "age_group",
    angle = 45,
    n_breaks = 5,
    title = "Incidence of cases by date of onset and age groups",
    legend = "bottom"
  ) +
  labs(x = "Date of onset")

# TIP:
# - We can estimate the peak of the epidemic (no grouping)
peaks_no_group <- dat_validated %>%
  incidence2::incidence(
    date_index = "date_onset",
    interval = "day",
    complete_dates = TRUE
  ) |>
  incidence2::estimate_peak()

peaks_no_group

# Peak by age_group
peaks_by_age_group <- dat_validated %>%
  incidence2::incidence(
    date_index = "date_onset",
    groups = "age_group",
    interval = "day",
    complete_dates = TRUE
  ) |>
  incidence2::estimate_peak()

peaks_by_age_group
