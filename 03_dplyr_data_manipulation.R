# DESCRIPTION GOES HERE


# Filtering ---------------------------------------------------------------


library(tidyverse)

got <- read_csv("data/GoT_data.csv")

glimpse(got)

View(got)

# got <- got %>%
#   filter(dth_flag == "Dead")


got %>%
  group_by(social_status, allegiance_last) %>%
  summarise(count = n())
  