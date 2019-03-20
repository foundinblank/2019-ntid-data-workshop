## Data tidying with tidyr
## Adam Stone
## NTID Data Science Workshop, March 2019



# Gathering fNIRS Data ----------------------------------------------------

library(tidyverse)

# Is this data long or wide? Is it tidy? 
fnirs <- read_csv("data/AT273_individualdata_wavelet.csv") %>%
  select(-c(group, onset, mark, valid, rep, type, prune))

# I want to plot the HbO signal in channel 1 during the first trial.
# So I make a small dataset with just this data 
ch1 <- fnirs %>%
  filter(chnum == 1) %>% # channel 1
  filter(trialnum == 1) %>% # first trial
  filter(hbx == 1) # Just HbO data
  
ch1 %>%
  ggplot(aes(x = ..., y = ...)) 

# Changing wide to long format is called "gathering"
# I want to put all column names in a new "time" column.
# And I want to put all values in a new "hb_value" column.
# And I want this to operate over the columns time1 to time160. 
ch1_long <- ch1 %>%
  gather(time, hb_value, time1:time160) %>%
  mutate(time = str_remove(time, "time")) %>% # this removes "time"
  mutate(time = as.double(time)) # this makes "time" a numeric variable

# Now let's try again with plotting
ch1_long %>%
  ggplot(aes(x = time, y = hb_value)) +
  geom_line()




# Gathering Visitor Data --------------------------------------------------

visitors <- read_csv("data/Tourism_Visitor_Arrivals.csv")

# How big is this table? What's the size of it? 
visitors
glimpse(visitors)

# Exercise:
# Try gathering this dataset, so all years are in one column.
# gather(x, y, z)
# x is the new name of the column that will contain the column names
# y is the new name of the column that will contain the values in those columns
# z is the range of column names, but notice how the column names look like `1995`. 
# So you will need to use backticks to refer to column names. (Hey, it's not tidy data!)
# Save it to visitors_long

# The visitors_long table will be 1284 x 3. 

# Try plotting visitors_long! Remember:
# 1. Start with data %>%
# 2. Define aesthetics, ggplot(aes(x..., y...)) +
# 3. Pick a geometric layer, geom_line() 




# Spreading data ----------------------------------------------------------

# Let's spread visitor_long, so you can compare year by year changes easily. 
# You may have to change the names in spread() depending on how you named the new columns in gather()
visitor_long %>%
  spread(year, visitors)

# Same data, right? You're just reshaping it between long and wide!




# Simon Data --------------------------------------------------------------

# Do you know the Simon task? https://en.wikipedia.org/wiki/Simon_effect
# This is a dataset of 35 participants doing the Simon Task, with 16 trials each.
# Values are reaction times in milliseconds. 
simon <- read_csv("data/Simon_data.csv")

glimpse(simon)

# Let's try calculating the average reaction time per participant.
simon %>%
  group_by(subject) %>%
  summarise(mean_rt = mean(trial_1, trial_10, trial_11, trial_12, trial_.....))

# I'm tired already. I can't type out all of those. 
# This is one good reason to tidy the data and make it tall.
simon_long <- simon %>%
  gather(trial, reaction_time, trial_1:trial_9)

# Much easier, right? 
simon_mean <- simon_long %>%
  group_by(subject) %>%
  summarise(mean_rt = mean(reaction_time))

simon_mean

# And it's easier to plot the mean values too:
simon_mean %>%
  ggplot(aes(x = subject, y = mean_rt)) +
  geom_col()

simon_mean %>%
  ggplot(aes(y = mean_rt)) +
  geom_boxplot()


