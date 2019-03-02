library(tidyverse)


# CSV Cleaning ------------------------------------------------------------

# df <- read_csv("data/SYB61_T29_Internet Usage.csv",
#                skip = 2,
#                col_names = c("id",
#                              "area",
#                              "year",
#                              "series",
#                              "value",
#                              "footnotes",
#                              "source")) %>%
#   mutate(value = value/100) %>%
#   write_csv("data/Internet_Usage_by_Country.csv")


# Visualizing 1 -----------------------------------------------------------

# Data from http://data.un.org/ (Communication: Internet Usage)
internet_usage <- read_csv("data/Internet_Usage_by_Country.csv")

glimpse(internet_usage)

internet_usage %>%
  filter(area %in% c('United States of America', 'Liberia')) %>%
  ggplot(aes(x = year, y = value, color = area)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(limits = c(0,1), labels = scales::percent) +
  labs(x = "year", 
       y = "percentage of total population",
       title = "Internet Users by Country",
       subtitle = "2000 to 2016",
       color = "Country") +
  theme_gray() +
  theme(legend.position = 'right')



# Visualizing 2 -----------------------------------------------------------

got <- readxl::read_xlsx("~/Downloads/GoTdata_FINAL.xlsx")


# Visualizing 3 -----------------------------------------------------------
#
#This is for umm...figuring out all the different geom_things 
# Load packages ----------------------------------------------------------------
library(tidyverse)
library(unvotes)
library(lubridate)

# Make a plot ------------------------------------------------------------------
# Erik Voeten "Data and Analyses of Voting in the UN General Assembly" Routledge Handbook of International Organization, edited by Bob Reinalda (published May 27, 2013)

un_votes %>%
  filter(country %in% c("United States of America", "Israel")) %>%
  inner_join(un_roll_calls, by = "rcid") %>%
  inner_join(un_roll_call_issues, by = "rcid") %>%
  group_by(country, year = year(date), issue) %>%
  summarize(
    votes = n(),
    percent_yes = mean(vote == "yes")
  ) %>%
  filter(votes > 5) %>%  # only use records where there are more than 5 votes
  ggplot(mapping = aes(x = year, y = percent_yes, color = country)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE) +
  facet_wrap(~ issue) +
  labs(
    title = "Percentage of 'Yes' votes in the UN General Assembly",
    subtitle = "1946 to 2015",
    y = "% Yes",
    x = "Year",
    color = "Country"
  )










# Ehhhh -----------------------------------------------------------

library(tidyverse)
library(dslabs)

# Look at what data's in dslabs
data(package = "dslabs")

# Load data
diseases <- as_tibble(us_contagious_diseases) %>%
  filter(state != "Hawaii" & state != "Alaska") %>%
  mutate(rate = count / population * 10000 * 52 / weeks_reporting)

diseases %>%
  filter(disease == "Rubella") %>%
  ggplot(aes(x = year, y = state, fill = rate)) +
  geom_tile(color = "grey50") +
  scale_fill_viridis_c() +
  facet_wrap("disease") 
