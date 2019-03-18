## Data Visualizing using ggplot2
## Adam Stone
## NTID Data Science Workshop, March 2019


# Visualizing 1 -----------------------------------------------------------

library(tidyverse)

# Data from UN Data (Communication: Internet Usage)
# http://data.un.org/
internet_usage <- read_csv("data/Internet_Usage_by_Country.csv")

glimpse(internet_usage)

# Compare internet usage across countries
internet_usage %>%
  filter(area %in% c('United States of America', 'Canada')) %>%
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

library(tidyverse)

# Data from FiveThirtyEight's Comic Characters dataset
# https://github.com/fivethirtyeight/data/tree/master/comic-characters
# Article: https://fivethirtyeight.com/features/women-in-comic-books/
marvel <- read_csv("data/Marvel_Characters.csv") 
  
glimpse(marvel)

# Which are the most frequent characters?
# What if you changed "fill" to "color"?
# What happens if you change the filter argument? 
marvel %>%
  mutate(name = fct_reorder(name, desc(appearances))) %>%
  filter(appearances > 1500) %>%
  ggplot(aes(x = name, y = appearances, fill = sex, label = appearances)) +
  geom_col() +
  geom_text(size = 2, nudge_y = -100) +
  labs(x = "",
       y = "appearances",
       title = "Marvel Character Appearances") +
  theme(axis.text.x = element_text(angle = -45, hjust = 0))

# How many characters get introduced per year? 
# Try adding color = "black" to geom_bar. What happens? What about fill = "black"?
# Undo that, then add fill = sex to aes(). 
marvel %>%
  ggplot(aes(x = year)) +
  geom_bar(width = 1) +
  labs(x = "year",
       y = "characters", 
       title = "New Marvel Characters Introduced Per Year") +
  theme_linedraw()

# Gender parity 
# You can run part of the code, not all of it. 
# Where does the ggplot code begin? 
marvel %>%
  mutate(sex = recode(sex, "Female" = "F", .default = "Other", .missing = "Other")) %>%
  group_by(year, sex) %>%
  summarise(characters = n()) %>%
  spread(sex, characters) %>%
  ungroup() %>%
  arrange(year) %>%
  mutate(F = coalesce(F, 0L),
         Other = coalesce(Other, 0L)) %>%
  mutate(f_sum = cumsum(F),
         o_sum = cumsum(Other),
         total = f_sum + o_sum,
         ratio = f_sum/total) %>% 
  ggplot(aes(x = year, y = ratio)) +
  geom_line(color = "dark red", size = 1, linetype = "longdash") +
  geom_hline(yintercept = .5) +
  scale_y_continuous(limits = c(0,1), labels = scales::percent) +
  labs(x = "year",
       y = "percent of female characters",
       title = "Gender Ratio in Marvel Universe") +
  theme_bw()

# Character Alignment
# What happens if you comment out coord_flip()
# The bunch of theme() code at the bottom - comment it out
marvel %>%
  filter(sex == "Male" | sex == "Female") %>%
  filter(!is.na(align)) %>%
  group_by(sex, align) %>%
  janitor::tabyl(sex, align) %>%
  janitor::adorn_percentages() %>%
  gather(align, percent, Bad:Neutral) %>%
  mutate(align = fct_relevel(align, "Bad", "Neutral", "Good")) %>%
  ggplot(aes(x = sex, y = percent, fill = align)) +
  geom_col(width = 0.75, color = "black") +
  geom_text(aes(label = scales::percent(percent)), position = position_fill(vjust = 0.5)) +
  coord_flip() +
  labs(x = "",
       y = "",
       title = "Marvel Character Alignment",
       fill = "") +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        panel.grid = element_blank(),
        axis.text.y = element_text(size = 14),
        legend.position = "bottom")
  
  

# Visualizing 3 -----------------------------------------------------------

library(lubridate)
library(unvotes)

# Dataset: Erik Voeten "Data and Analyses of Voting in the UN General Assembly" Routledge Handbook of International Organization, edited by Bob Reinalda (published May 27, 2013)
# Code: Mine Centinkaya-Rundel (2018), http://bit.ly/let-eat-cake

# Organize the data (don't worry about this yet!)
un_votes_data <- un_votes %>%
  filter(country %in% c("United States of America", "Israel")) %>%
  inner_join(un_roll_calls, by = "rcid") %>%
  inner_join(un_roll_call_issues, by = "rcid") %>%
  group_by(country, year = year(date), issue) %>%
  summarize(
    votes = n(),
    percent_yes = mean(vote == "yes")
  ) %>%
  filter(votes > 5)  # only use records where there are more than 5 votes

# Plot the data
un_votes_data %>%
  ggplot(aes(x = year, y = percent_yes, color = country)) +
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
