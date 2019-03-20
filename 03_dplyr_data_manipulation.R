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
# dth_flag: is character alive or dead? 
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

# This will calculate the average exp_time_sec of all characters, called "avg_exp". 
# But we want to know the average exp_time_sec for *each* house (allegiance_last). 
# Uncomment the middle line by removing # from group_by(allegiance_last). 
# What do you get?
# What if you changed allegiance_last to religion, or to sex?
got %>%
  group_by(prominence_cat) %>%
  summarise(avg_exp = mean(exp_time_sec))

got %>%
  group_by(COD_text) %>%
  summarise(count_of_characters = n())

# Try group_by() with multiple variables. How can that be useful for your study?
# Think...grouping by gender AND hearing/deaf. Or graduate vs. undergraduates AND majors. 
got %>%
  group_by(allegiance_last, social_status) %>%
  summarise(count_characters = n())

# If you forget column names, you can run glimpse(got) to see them again. 

# Exercises (you can copy/paste the code above, or write new code):
# 1. What’s the mean survival experience (in secs) for male vs. female characters?
# 2. How many characters died indoors vs. outdoors? 
# 3. How many highborns and lowborns of each religion are there? 
# 4. What happens when you swap grouping variables (e.g., group_by(a, b) vs. group_by(b,a)? 
# 5. Challenge: Can you calculate the mean, median, and sd for #1 in one step?    



# Filtering ---------------------------------------------------------------
# Remove or keep rows by a logical condition

# This will return all rows where dth_flag == "Dead"
# What happens if you change == to !=? 
got %>%
  filter(dth_flag == "Dead")

# Who is included in this analysis? 
got %>%
  filter(dth_flag == "Dead") %>%
  filter(allegiance_last == "Lannister") %>%
  filter(social_status == "Highborn") %>%
  filter(sex == "Male") %>%
  group_by(COD_text) %>%
  summarise(n())

# Exercises:

# 1. How many characters from each House is now dead? 
# 2. Among dead characters, how many switched allegiance? 
# 3. Among deceased characters, what is the average lifespan (in episodes) for men vs. women? 
# 4. Among deceased Starks, what are their causes of death? 
# 5. What about among deceased highborn male Lannisters?
  

# Subsetting data ---------------------------------------------------------

# Run this, then look at the Environment pane. What's the difference between the two?
live_only <- got %>%
  filter(dth_flag != "Dead")

live_only

# Try creating a new data frame with only well-known Targaryen loyalists.
loyal_targaryen_lives <- got %>%
  filter(allegiance_last == "Targaryen") %>%
  filter(prominence_cat == "High") %>%
  filter(allegiance_switched == "No")

loyal_targaryen_lives
  
# Exercise:
# 1. Create a separate dataset named "sig_dead_charactesr" with 
#    -Only dead characters,
#    -excluding anyone with 1 or less featured episodes,
# How many rows and columns are in this one? (Hint, look at Environment tab)
# 137 x 32? You got it! 
# 2. Now filter that dataset to include only Starks.  


# Selecting ---------------------------------------------------------------
# Keeping removing, or re-arranging columns

# Which columns will be kept in this pipe?
got %>%
  filter(allegiance_last != "Other") %>%
  select(name, sex, religion, allegiance_last, exp_time_sec)

# What does this do? 
# Try removing the - 
got %>%
  select(-name)

got %>%
  select(-ID, -name, -religion)

# The colon : indicates a range. 
got %>%
  select(name:allegiance_switched)


# Mutating ----------------------------------------------------------------
# Creating new columns

# First, let's create a simpler dataset to work with, named "to_mutate."
to_mutate <- got %>%
  filter(dth_flag == "Dead") %>%
  select(name, allegiance_last, intro_time_sec, dth_time_sec, intro_episode, dth_episode)

to_mutate

# Now, use mutate() to calculate a lifespan in seconds, and then in hours. 
# Notice how I can pass the new variable, lifespan_secs, to the next line of code to be further mutated
to_mutate %>%
  mutate(lifespan_secs = dth_time_sec - intro_time_sec) %>%
  mutate(lifespan_hours = lifespan_secs/60/60)

to_mutate %>%
  mutate(lifespan_episodes = dth_episode - intro_episode)

# What happens when you comment out group_by? (Add a # to the beginning of that line.)
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
  select(name, allegiance_last, intro_time_sec) %>%
  arrange(intro_time_sec)

# What does desc() wrapped around a column name do? 
# Run this, then change arrange(desc(name)) to just arrange(name)
got %>%
  arrange(desc(name))

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
