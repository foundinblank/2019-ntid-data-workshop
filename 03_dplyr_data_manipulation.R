## Data manipulation with dplyr
## Adam Stone
## NTID Data Science Workshop, March 2019


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
# Apply some function over columns

# Uncomment group_by(). Try changing the variable in it. Re-comment. What do you notice?
got %>%
#  group_by(allegiance_last) %>%
  summarise(mean_exp = mean(exp_time_sec))

got %>%
  group_by(COD_text) %>%
  summarise(count_characters = n())

# Try group_by() with multiple variables. How can that be useful for your study?
# Think...grouping by gender AND hearing/deaf. Or graduate vs. undergraduates AND majors. 
got %>%
  group_by(allegiance_last, social_status) %>%
  summarise(count_characters = n())

# If you forget column names, just type glimpse(got) to see it again. 

# Exercises:
# 1. What’s the mean survival experience (in secs) for male vs. female characters?
# 2. How many characters died indoors vs. outdoors? 
# 3. How many highborns and lowborns of each house are there? 
# 4. What happens when you swap grouping variables (e.g., group_by(a, b) vs. group_by(b,a)? 
# 5. Challenge: Can you calculate the mean, median, and sd for #1 in one step?                                                   

# Filtering ---------------------------------------------------------------
# Remove or keep rows by a logical condition

got %>%
  filter(dth_flag == "Dead")

got %>%
  filter(dth_flag == "Dead") %>%
  filter(allegiance_last == "Lannister") %>%
  filter(social_status == "Highborn") %>%
  filter(sex == "Male") %>%
  group_by(COD_text) %>%
  summarise(n())

# Exercises:

# 1. How many characters from each House is now dead? 
# 2. Among deceased characters, what is the average survival experience (in episodes) for men vs. women? 
# 3. Among deceased Starks, what are their causes of death? 
# 4. What about among deceased highborn male Lannisters?
# 5. Among dead characters, how many switched allegiance? 
  

# Subsetting data ---------------------------------------------------------

live_only <- got %>%
  filter(dth_flag != "Dead")

live_only

loyal_targaryen_lives <- got %>%
  filter(allegiance_last == "Targaryen") %>%
  filter(prominence_cat == "High") %>%
  filter(allegiance_switched == "No")

loyal_targaryen_lives
  
# Create a separate dataset named "sig_dead_charactesr" with 
# 1. Only dead characters,
# 2. Excluding anyone with 1 or less featured episodes,
# 3. and Arya Stark (because she's miscoded as "lowborn") 
# 4. How many rows and columns are in this one? (Hint, look at Environment tab)
# 5. 137 x 32? You got it! 
# 6. Now filter that dataset to include only Starks.  


# Selecting ---------------------------------------------------------------
# Keeping removing, or re-arranging columns

got %>%
  filter(allegiance_last != "Other") %>%
  select(name, sex, religion, allegiance_last, exp_time_sec)

got %>%
  select(-ID)

got %>%
  select(-ID, -name)

got %>%
  select(name:allegiance_switched)


# Exercises:
# 1. What does - do? 
# 2. What does : do? 


# Mutating ----------------------------------------------------------------
# Creating new columns

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

# Exercises:
# 1. Using 'got', assume seasons were always 10 episodes long. Can you calculate each character's lifespan in seasons? (e.g., Lysa Arryn lived for 4.7 seasons)


# Arranging ---------------------------------------------------------------
# Re-ordering rows

# What does this do? 
# You can add %>% View() to see its output in a new pane. 
got %>%
  arrange(intro_episode)

# What does desc() wrapped around a column name do? 
# Run this, then remove the desc() part and try it again. 
got %>%
  arrange(desc(prominence))

# What happens if you arrange by two columns? 
got %>%
  arrange(allegiance_last, intro_episode)


# Exercises:
# 1. Go back to any of the above, and try arranging by one variable, or two variables.
# 1.5. Focus on those with summarise() in them. You can re-arrange by the new summary columns!
# 2. Among dead characters, which episode saw the most deaths? 



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
