# DESCRIPTION GOES HERE



# Explore the dataset -----------------------------------------------------

library(tidyverse)

# Load Game of Thrones Mortality dataset. This is made available to us via a data sharing agreement with Dr. Reidar P. Lystad (Macquarie University) and is for use only with this workshop. Please do not share/distribute this dataset to others. 
# Lystad RP, Brown BT. “Death is certain, the time is not”: mortality and survival in Game of Thrones. Injury Epidemiology 2018; 5:44.
# https://injepijournal.biomedcentral.com/articles/10.1186/s40621-018-0174-7

got <- read_csv("data/GoT_data.csv")

# Description for non-obvious columns
# allegiance_switched: did character switch allegiance at any point during their show?
# intro_*: season/episode/time in which the character appeared
# dth_*: season/episode/time in which the character died
# exp_*: survival experience; span of seasons/episodes/time
# featured_episode_count: number of episodes in which character appeared
# prominence: metric of "importance" of character
# diagnosis: how death occurred
# COD: cause of death
# place: where death occurred
# location: indoors or outdoors

# Basic ways
got # Easy, fast, pretty good
View(got) # Show table in Rstudio
head(got) # Show first 10 rows (or head(got, n) to show n rows)
summary(got) # Base R function
glimpse(got) # Preview data (good for knowing column names)
unique(got$religion) # See unique values in a column

# Packages for more data exploration
skimr::skim(got) # Nifty descriptive statistics
got %>% mutate_if(is.character, as.factor) %>% skimr::skim() # For factor counts
DT::datatable(got) # Searchable table (you also get this with View())



# Summarizing -------------------------------------------------------------

got %>%
#  group_by(allegiance_last) %>%
  summarise(min_exp = min(exp_time_sec),
            mean_exp = mean(exp_time_sec),
            median_exp = median(exp_time_sec),
            max_exp = max(exp_time_sec),
            count_characters = n())

# Filtering ---------------------------------------------------------------



# got <- got %>%
#   filter(dth_flag == "Dead")


got %>%
  group_by(social_status, allegiance_last) %>%
  summarise(count = n())
  