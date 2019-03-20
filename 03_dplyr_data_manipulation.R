## Data manipulation with dplyr
## Adam Stone
## NTID Data Science Workshop, March 2019


# Explore the dataset -----------------------------------------------------

library(tidyverse)

# Load Game of Thrones Mortality dataset. This is made available to us via a 
# data sharing agreement with Dr. Reidar P. Lystad (Macquarie University) and 
# is for use only with this workshop. Please do not share or distribute this 
# dataset to others. Lystad RP, Brown BT. “Death is certain, the time is not”:
# mortality and survival in Game of Thrones. Injury Epidemiology 2018; 5:44.
# https://injepijournal.biomedcentral.com/articles/10.1186/s40621-018-0174-7

got <- read_csv("data/GoT_data.csv")

# Column Description
# ID: character ID
# Name: Character name
# Status: Dead or Alive
# Prominence: How prominent is the character? (High, Medium, Low)
# Sex: Male or Female
# Religion: Religion
# Social Staus: Highborn or Lowborn
# House_last: The last house they swore allegiance to before dying or end of Season 6
# Allegiance_switched: Did they switch allegiance at any point during the show?
# Intro_season: Season they first appeared (1 to 6)
# Intro_episode: Episode they first appeared (1 to 64)
# Intro_sec: Time they first appeared (1 to 192860
# Death_season, death_episode, death_sec: Same as above
# Lifespan_season, lifespan_episode, lifespan_sec: Difference between Intro & Death
# Death_how: How exactly did they die
# Diagnosis: Cause of death


# Basic ways to view data (I use all of them!)
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

# This will calculate the average lifespan_sec of all characters, called "avg_lifespan". 
# But we want to know the average lifespan for *each* house (house_last). 
# Uncomment the middle line by removing # from group_by(house_last). 
# What do you get?
# What if you changed house_last to religion, or to sex?
got %>%
  group_by(prominence) %>%
  summarise(avg_lifespan = mean(lifespan_sec))

got %>%
  group_by(diagnosis) %>%
  summarise(count_of_characters = n())

# Try group_by() with multiple variables. How can that be useful for your study?
# Think...grouping by gender AND hearing/deaf. Or graduate vs. undergraduates AND majors. 
got %>%
  group_by(house_last, social_status) %>%
  summarise(count_characters = n())

# If you forget column names, you can run glimpse(got) to see them again. 

# Exercises (you can put your code in between each exercise):
# 1. What’s the mean lifespan (in secs) for male vs. female characters?
# 2. How many highborns and lowborns of each religion are there? 
# 3. What happens when you swap grouping variables (e.g., group_by(a, b) vs. group_by(b,a)? 
# 4. Challenge: Can you also calculate the median and sd for #1 in one step? 
#    Hint: mean(), median(), sd()



# Filtering ---------------------------------------------------------------
# Remove or keep rows by a logical condition

# This will return all rows where status == "Dead"
# What happens if you change == to !=? 
got %>%
  filter(status == "Dead")

# Which character groups are included in this analysis? 
# Try changing "diagnosis" to "death_how"
got %>%
  filter(status == "Dead") %>%
  filter(house_last == "Lannister") %>%
  filter(social_status == "Highborn") %>%
  filter(sex == "Male") %>%
  group_by(diagnosis) %>%
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
  filter(status != "Dead")

live_only

# Try creating a new data frame with only well-known Targaryen loyalists.
loyal_targaryen_lives <- got %>%
  filter(house_last == "Targaryen") %>%
  filter(prominence == "High") %>%
  filter(allegiance_switched == "No")

loyal_targaryen_lives
  
# Exercise:
# 1. Create a separate dataset named "dead_characters" with 
#    -Only dead characters, and 
#    -Excluding anyone who showed up in Season 3 or later
# How many rows and columns are in this one? (Hint, look at Environment tab)
# 100 x 20? You got it! 
# 2. Now filter that dataset to include only those whose last house was Stark. 
# 19x20? You got it! 

dead_characters <- got %>%
  filter(status == "Dead") %>%
  filter(intro_season <= 2)

# Selecting ---------------------------------------------------------------
# Keeping removing, or re-arranging columns

# Which columns will be kept in this pipe?
got %>%
  filter(house_last != "Other") %>%
  select(name, sex, religion, house_last, lifespan_sec)

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
  filter(status == "Dead") %>%
  select(name, house_last, intro_sec, death_sec, intro_episode, death_episode)

to_mutate

# Now, use mutate() to calculate a lifespan in seconds, and then in hours. 
# Notice how I can pass the new variable, lifespan_sec, to the next line of code to be further mutated
to_mutate %>%
  mutate(lifespan_sec = death_sec - intro_sec) %>%
  mutate(lifespan_hour = lifespan_sec/60/60)

to_mutate %>%
  mutate(lifespan_episode = death_episode - intro_episode)

# What happens when you comment out group_by? (Add a # to the beginning of that line.)
to_mutate %>%
  mutate(lifespan_episodes = death_episode - intro_episode) %>%
  group_by(house_last) %>%
  summarise(mean_lifespan_episodes = mean(lifespan_episodes))

# Exercises:
# 1. Using 'got', assume seasons were always 10 episodes long. Can you calculate each character's lifespan in seasons? (e.g., Lysa Arryn lived for 4.7 seasons)


# Arranging ---------------------------------------------------------------
# Re-ordering rows

# What does this do? 
# You can add %>% View() to see its output in a new pane. 
got %>%
  select(name, house_last, intro_sec) %>%
  arrange(intro_sec)

# What does desc() wrapped around a column name do? 
# Run this, then change arrange(desc(name)) to just arrange(name)
got %>%
  arrange(desc(name))

# What happens if you arrange by two columns? 
got %>%
  arrange(house_last, intro_episode)


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
