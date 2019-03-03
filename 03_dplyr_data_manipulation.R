# DESCRIPTION GOES HERE



# Explore the dataset -----------------------------------------------------

library(tidyverse)

# Load Game of Thrones Mortality dataset. This is made available to us via a data sharing agreement with Dr. Reidar P. Lystad (Macquarie University) and is for use only with this workshop. Please do not share or distribute this dataset to others. 
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
  summarise(mean_exp = mean(exp_time_sec))

got %>%
  group_by(COD_text) %>%
  summarise(count_characters = n())

got %>%
  group_by(allegiance_last, social_status) %>%
  summarise(count_characters = n())


# Filtering ---------------------------------------------------------------


got %>%
  filter(dth_flag == "Dead")

got %>%
  filter(dth_flag == "Dead") %>%
  filter(allegiance_last == "Lannister") %>%
  filter(social_status == "Highborn") %>%
  filter(sex == "Male") %>%
  group_by(COD_text) %>%
  summarise(n())



# Subsetting data ---------------------------------------------------------

got_cleaned <- got %>%
  filter(dth_flag == "Dead") %>%
  filter(featured_episode_count > 1) %>%
  filter(name != "Arya Stark")

got_cleaned

starks <- got %>%
  filter(allegiance_last == "Stark")



# Selecting ---------------------------------------------------------------

got %>%
  filter(allegiance_last != "Other") %>%
  select(name, sex, religion, allegiance_last, exp_time_sec)


got %>%
  select(-ID)

got %>%
  select(-ID, -name)

got %>%
  select(name:allegiance_switched)



# Mutating ----------------------------------------------------------------

to_mutate <- got %>%
  select(name, allegiance_last, intro_time_sec, dth_time_sec, intro_episode, dth_episode) %>%
  filter(!is.na(dth_time_sec))

to_mutate

to_mutate %>%
  mutate(lifespan_secs = dth_time_sec - intro_time_sec) %>%
  mutate(lifespan_hours = lifespan_secs/60/60)

to_mutate %>%
  mutate(lifespan_episodes = dth_episode - intro_episode)

# What happens when you comment out group_by
to_mutate %>%
  mutate(lifespan_episodes = dth_episode - intro_episode) %>%
  group_by(allegiance_last) %>%
  summarise(mean_lifespan_episodes = mean(lifespan_episodes))


# Arranging ---------------------------------------------------------------

# Go back to any of the above, and try arranging by one variable, or two variables.
# %>% arrange(desc(lifespan_episodes))




# Playtime ----------------------------------------------------------------

# Try a few manipulations of the Game of Thrones dataset, or try a new dataset here:
# ASL-LEX (http://asl-lex.org/) 
# Caselli, N., Sevcikova, Z., Cohen-Goldberg, A. M., & Emmorey, K. (2016). ASL-Lex: A Lexical Database for ASL. Behavior Research Methods. doi:10.3758/s13428-016-0742-0

asllex_raw <- read_csv("data/ASL-LEX_Sign_Data.csv")

glimpse(asllex_raw)

asllex <- asllex_raw %>%
  select(entry_id,
         sign_type,
         major_location,
         initialized,
         lexical_class,
         sign_frequency_m,
         iconicity_m,
         sign_length_ms)

asllex %>%
  group_by(lexical_class, initialized) %>%
  summarise(sign_length_avg = mean(sign_length_ms),
            sign_length_sd = sd(sign_length_ms),
            count = n())

asllex %>%
  filter(initialized == 1) %>%
  View()
