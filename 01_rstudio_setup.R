## RStudio Setup
## Adam Stone
## NTID Data Science Workshop, March 2019



# Make RStudio Yours! -----------------------------------------------------

# Personalize it to your heart's delight. 
# Tools Menu > Global Options > Appearance...
# Change your Editor Theme and/or font size. There's some cool color themes in there!
# Apply & Save. 
# Theme changes only applies to the project you're in. If you open a new project,
# and we will when we start the workshop, the theme there will be the default.)



# How to Run Code ---------------------------------------------------------

# Here, you will start running lines of code. 
# There are a few ways you can run a line of code.
# Running a line of code = telling the computer to execute that line 

# 1. Highlight the line of code, and press Cmd-Enter (Mac) or Ctrl-Enter (Windows)
# 2. Put the cursor anywhere in the line of code, and press Cmd-Enter (Mac) or Ctrl-Enter (Windows)
# 3. Type the code into the Console (the box below), next to the ">" then press Enter. 
# 4. For any of the steps above, you can use the "Run" button in this pane's upper-right corner. 


# Install the Tidyverse ---------------------------------------------------

# Run this line of code. It will install a lot of stuff onto the machine.
# You only have to do this once, ever, on any machine you're on.
# RStudio is helpful - it will scan code and show a warning message if it sees any
# libraries that aren't installed yet. For now, press "Don't Show Again."
# But if you already clicked "install," run this code anyway. 

install.packages("tidyverse")

# Lots of things will happen in the Console below. That's just tidyverse installing!
# When you see > that means it's finished and now it's waiting for you to do something. 



# Load the Tidyverse ------------------------------------------------------

# Run this line of code. It loads the core Tidyverse packages.
# library() is like checking out cookbook from the library, bringing it home, and saying,
# "Okay, now I'm ready to start using recipes in this book!"
# You need to load packages each time you open R or change R projects. 
# Ignore the conflicts for filter() and lag(), that's normal.

# Check out the tidyverse cookbook from the library and bring it home to cook with!
library(tidyverse)



# Make Sure Tidyverse Is Loaded -------------------------------------------

# Tidyverse comes with some datasets. To make sure Tidyverse was loaded correctly, 
# let's try looking at a dataset. 

starwars

# You should see a print-out in the Console with the first 10 rows of 
# Star Wars character data. Fun! 

# Want to see it in its own tab?

View(starwars)

# In the "starwars" tab, try clicking on different column names to sort the table. 
# Press the Filter button and try filtering various columns. 
# Some columns can't be filtered, like films, vehicles, and starships. 
# Try dragging the "starwars" pane out of the entire browser to turn it into a separate window. 



# Assigning Variables --------------------------------------------------------

# Let's practice how to assign variables in the environment
# Run this line.

x <- 5

# Look at the Environment tab on the right. It should show "x" and "5". 
# That means you've saved a variable, x, that contains the value, 5. 

# Try running x by itself. What does the console say? 

x

# Yep, it just shows you what's the value of x. Let's change that to 10. What happens? 

x <- 10
x

# Let's assign a new variable, y. 
# Maybe this time, try typing it out on the console and pressing Enter.

y <- 20
y

# Add x and y. 

x + y

# Assign x + y to a new variable.

z <- x + y
z

# Let's assign starwars to a variable too.

starwars_data <- starwars

# In the Environment pane...
# What do you see? How many observations (rows)? 
# How many variables (columns)? 
# What happens when you click on the blue arrow? 
# What happens when you click on the name "starwars_data" itself? 



# Getting Help ------------------------------------------------------------

# You can look up any function by running "?name_of_function_goes_here"
# Let's try View. (Remember it?)

?View

# What do you think read_csv does? 

?read_csv

# What about mean, median?

?mean
?median



# That’s It! --------------------------------------------------------------

# We'll do more fun stuff during the workshop. 
# You can look at the Files pane to see all the other files we're working with here. 
# You can also look in the data/ folder to see all the datasets we may be working with. 
# Many of them have been cleaned up for this workshop. 
# You can see how I did that in 99_data_cleaning.R. 
