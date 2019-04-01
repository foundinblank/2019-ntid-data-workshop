## Exercise Solutions
## Adam Stone
## NTID Data Science Workshop, March 2019
## There's lots of possible solutions for each exercise! Here are mine. 
## I also use some functions I didn't discuss in the workshop, as quicker ways
## of doing certain things, such as using count(groupname) instead of 
## group_by(groupname) %>% summarise(count_of_items = n()). 


# 02_ggplot2_data_visualization -------------------------------------------

# Visualizing 1 -----------------------------------------------------------

# 1.  Change the country. Think of one country that may outperform the United States, and one country that underperforms the United States. 

internet_usage %>%
  filter(country %in% c('United States of America', 'Japan')) %>% ### Japan
  ggplot(aes(x = year, y = value, color = country)) +
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

# 2. Put # before geom_point() or geom_line() and run. What happens?

internet_usage %>%
  filter(country %in% c('United States of America', 'Japan')) %>%
  ggplot(aes(x = year, y = value, color = country)) +
#  geom_line() +
  geom_point() +
  scale_y_continuous(limits = c(0,1), labels = scales::percent) +
  labs(x = "year", 
       y = "percentage of total population",
       title = "Internet Users by Country",
       subtitle = "2000 to 2016",
       color = "Country") +
  theme_gray() +
  theme(legend.position = 'right')

# 3. Change the title or labels. What happens?

internet_usage %>%
  filter(country %in% c('United States of America', 'Japan')) %>%
  ggplot(aes(x = year, y = value, color = country)) +
  #  geom_line() +
  geom_point() +
  scale_y_continuous(limits = c(0,1), labels = scales::percent) +
  labs(x = "",                                      # Using "" removes the label 
       y = "% total",                               # Changed
       title = "Countries' Internet Users",         # Changed
       subtitle = "2000 to 2016",
       color = "Country") +
  theme_gray() +
  theme(legend.position = 'right')

# 4. Change theme_gray() to theme_classic(). Or theme_dark(). Explore the other themes in the drop-down menu that pops up (press Tab if you don’t see it)

internet_usage %>%
  filter(country %in% c('United States of America', 'Japan')) %>%
  ggplot(aes(x = year, y = value, color = country)) +
  #  geom_line() +
  geom_point() +
  scale_y_continuous(limits = c(0,1), labels = scales::percent) +
  labs(x = "year", 
       y = "percentage of total population",
       title = "Internet Users by Country",
       subtitle = "2000 to 2016",
       color = "Country") +
  theme_dark() +
  theme(legend.position = 'right')


# 5. Can you move the legend to the bottom? 

internet_usage %>%
  filter(country %in% c('United States of America', 'Japan')) %>%
  ggplot(aes(x = year, y = value, color = country)) +
  #  geom_line() +
  geom_point() +
  scale_y_continuous(limits = c(0,1), labels = scales::percent) +
  labs(x = "year", 
       y = "percentage of total population",
       title = "Internet Users by Country",
       subtitle = "2000 to 2016",
       color = "Country") +
  theme_gray() +
  theme(legend.position = 'bottom')




# 03_dplyr_data_manipulation ----------------------------------------------

# Summarizing -------------------------------------------------------------

# 1. What’s the mean lifespan (in secs) for male vs. female characters?

got %>%
  group_by(sex) %>%
  summarise(avg_lifespan = mean(lifespan_sec))

# 2. How many highborns and lowborns of each religion are there? 

got %>%
  group_by(religion, social_status) %>%
  summarise(characters = n())

# 3. What happens when you swap grouping variables (e.g., group_by(a, b) vs. group_by(b,a)? 

got %>%
  group_by(house_last, sex) %>%
  summarise(characters = n())

got %>%
  group_by(sex, house_last) %>%
  summarise(characters = n())

# 4. Challenge: Can you also calculate the median and sd for #1 in one step? 
#    Hint: mean(), median(), sd()

got %>%
  group_by(sex) %>%
  summarise(avg_lifespan = mean(lifespan_sec),
            median_lifespan = median(lifespan_sec),
            sd_lifespan = sd(lifespan_sec))


# Filtering ---------------------------------------------------------------

# 1. How many characters from each House is now dead? 

got %>%
  filter(status == "Dead") %>%
  count(house_last)
  group_by(house_last) %>%
  summarise(characters = n())
  
# 2. Among dead characters, how many switched allegiance? 

got %>%
  filter(status == "Dead") %>%
  count(allegiance_switched)

# 3. Among deceased characters, what is the average lifespan (in episodes) for men vs. women? 

got %>%
  filter(status == "Dead") %>%
  group_by(sex) %>%
  summarise(avg_lifespan_episodes = mean(lifespan_episode))

# 4. Among deceased Starks, what are their causes of death? 

got %>%
  filter(status == "Dead",
         house_last == "Stark") %>%
  distinct(death_how)

# 5. What about among deceased highborn male Lannisters?

got %>%
  filter(status == "Dead") %>%
  filter(house_last == "Lannister") %>%
  distinct(death_how)


# Subsetting data ---------------------------------------------------------

# 1. Create a separate dataset named "dead_characters" with 
#    -Only dead characters, and 
#    -Excluding anyone who showed up in Season 3 or later
# How many rows and columns are in this one? (Hint, look at Environment tab)
# 100 x 20? You got it! 

dead_characters <- got %>%
  filter(status == "Dead") %>%
  filter(intro_season < 3)

# 2. Now filter that dataset to include only those whose last house was Stark. 
# 19x20? You got it! 

dead_characters %>%
  filter(house_last == "Stark")


# Mutating ----------------------------------------------------------------

# 1. Using 'got', assume seasons were always 10 episodes long. Can you calculate each character's lifespan in seasons? (e.g., Lysa Arryn lived for 4.7 seasons)

got %>%
  mutate(lifespan_seasons = lifespan_episode/10)  %>%
  select(name, lifespan_seasons) %>%
  View()
## Lysa Arryn really lived for 3.3 seasons...


# Arranging ---------------------------------------------------------------

# 1. Go back to any of the above, and try arranging by one variable, or two variables.

got %>%
  count(religion) %>%
  arrange(n)

got %>%
  group_by(religion, social_status) %>%
  summarise(characters = n()) %>%
  arrange(characters)

# 1.5. Focus on those with summarise() in them. You can re-arrange by the new summary columns!

got %>%
  group_by(religion, social_status) %>%
  summarise(characters = n()) %>%
  arrange(desc(characters))

# 2. Among dead characters, which episode saw the most deaths? 
# So this was an old question from an earlier version of the dataset! 
# Let's assume there's a column that says death_episode_number
# That indicates the epsiode number in which the character died

got %>%
  filter(status == "Dead") %>%
  count(death_episode_number) %>%
  arrange(desc(n))



# 04_tidyr_data_tidying ---------------------------------------------------

# Gathering & Spreading Visitor Data --------------------------------------

# Exercise:
# Try gathering this dataset, so all years are in one column.
# gather(x, y, z)
# x is the new name of the column that will contain the column names
# y is the new name of the column that will contain the values in those columns
# z is the range of column names, but notice how the column names look like `1995`. 
# So you will need to use backticks to refer to column names. (Hey, it's not tidy data!)
# Save it to visitors_long
# The visitors_long table will be 1284 x 3. 

visitors_long <- visitors %>%
  gather(year, visits, `1995`:`2016`)

visitors_long

# Try plotting visitors_long! Remember:

visitors_long %>%
  filter(country == "France" | country == "Germany") %>%
  ggplot(aes(x = year, y = visits, color = country, group = country)) +
  geom_line()



