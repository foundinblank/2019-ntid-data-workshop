## Data tidying with tidyr
## Adam Stone
## NTID Data Science Workshop, March 2019



# Gathering fNIRS Data ----------------------------------------------------

library(tidyverse)

# Is this data long or wide? Is it tidy? 
fnirs <- read_csv("data/AT273_individualdata_wavelet.csv") %>%
  select(-c(group, onset, mark, valid, rep, type, prune))

# I want to plot the HbO & HbR signal in channel 1 during the first trial. Derrrr
ch1 <- fnirs %>%
  filter(chnum == 1) %>% # channel 1
  filter(trialnum == 1) # first trial

ch1 %>%
  ggplot(aes(x = ..., y = ...)) 

# Changing wide to long format is called "gathering"
# I want to put all column names from time1 to time160 in a new "time" column 
# And I want to put all values in time1:time160 (that's a range) in a new "hb_value" column
ch1_long <- ch1 %>%
  gather(time, hb_value, time1:time160) %>%
  mutate_at(vars(trialnum:hbx), as.factor) %>%
  mutate(time = str_remove(time, "time")) %>%
  mutate(time = as.double(time))

# Now let's try again with plotting
ch1_long %>%
  ggplot(aes(x = time, y = hb_value, color = hbx)) +
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
