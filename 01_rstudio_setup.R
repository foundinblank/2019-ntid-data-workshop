## RStudio Setup
## Adam Stone
## NTID Data Science Workshop, March 2019



# Make RStudio Yours! -----------------------------------------------------

# Personalize it to your heart's delight. 
# Tools Menu > Global Options...
# Change your editor theme and/or font size. 
# Apply & Save. 



# How to Run Code ---------------------------------------------------------

# There are a few ways you can run a line of code.
# Running a line of code = telling the computer to execute that line 
# 1. Highlight the line of code, and press Cmd-Enter (Mac) or Ctrl-Enter (Windows)
# 2. Put the cursor anywhere in the line of code, and press Cmd-Enter (Mac) or Ctrl-Enter (Windows)
# 3. Copy-paste the code into the Console (the box below), next to the ">" then press Enter. 


# Install the Tidyverse ---------------------------------------------------

# Run this line of code. It will install a lot of stuff onto the machine.
# You only have to do this once, ever, on any machine you're on.

install.packages("tidyverse")



# Load the Tidyverse ------------------------------------------------------

# Run this line of code. It loads the core Tidyverse packages.
# You do this each time you open R or change R projects. 
# Ignore the conflicts for filter() and lag(), that's normal.

library(tidyverse)



# Make Sure Tidyverse Is Loaded -------------------------------------------

# Tidyverse comes with some datasets. To make sure Tidyverse was loaded correctly, let's try looking at a dataset. 

starwars

# You should see a print-out in the Console with the first 10 rows of Star Wars character data. Fun! 

# Want to see it in its own tab?

View(starwars)

# In the "starwars" tab, try clicking on different column names to sort the table. 
# Press the Filter button and try filtering various columns. 

# Try dragging the pane out of Rstudio to turn it into a separate window. 



# Assigning Variables --------------------------------------------------------

# Let's practice how to assign variables in the environment

x <- 5

# Look at the Environment tab on the right. It should show "x" and "5". That means you've saved a variable, x, that contains the value, 5. 

# Try running x by itself. What does the console say? 

x

# Yep, it just shows you what's the value of x. Let's change that to 10. What happens? 

x <- 10
x

# Let's add y. 

y <- 20
y

# Add x and y. 

x + y

# Assign x + y to a new variable.

z <- x + y
z

# Let's assign starwars to a variable too.

starwars_data <- starwars

# What do you see? How many observations (rows)? How many variables (columns). What happens when you click on the blue arrow? What happens when you click on the name itself? 



# Getting Help ------------------------------------------------------------

# You can look up any function by running "?function_name"
# Let's try View.

?View

# What do you think read_csv does? 

?read_csv

# What about mean, median?

?mean
?median



# That’s It! --------------------------------------------------------------

# We'll do more fun stuff now. You can look at the Files pane to see all the other files we're working with here. You can also look in the data/ folder to see all the datasets we may be working with. Many of them have been cleaned up for this workshop. You can see how I did that in 99_data_cleaning.R. 
