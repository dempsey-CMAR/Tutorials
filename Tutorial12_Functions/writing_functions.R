# April 28, 2021

# References: 
# R for Data Science
# https://www.earthdatascience.org/courses/earth-analytics/multispectral-remote-sensing-data/source-function-in-R/
# DataCamp "Writing Functions in R"

# "Functions allow you to automate common tasks in a more powerful and general 
# way than copy-and-pasting." -HW

# Remember: if copy/paste more than twice want to reduce duplication!

# 3 main advantages (similar to loops)
## 1. Only need to update code in one place
## 2. Eliminate chance of copy-paste error
## 3. Makes code easier to read (reduce lines of code)

# Tips

#### Save functions in a separate script -- source them
# Reusable: Don't have to copy/paste the function into new scripts).
# Easy to Maintain: Only have to fix bugs once.
# Share-able: First step towards creating an R package!

#### Function name should be short and clearly state what function does
# (clarity > brevity because of autofill!)
# Should include a verb: get, calculate, run, process, import, clean, draw...
# Use snake_case to separate multiple words

#### Use comments to explain WHY you did what you did
# Document arguments (input) and output

# basic structure
function_name <- function(data_arguments, detail_arguments){
  
  code
  
  object_to_return
  
}

# data arguments: what you compute on (should be first argument(s))
# detail arguments: how you perform the computation


# Load packages -----------------------------------------------------------

library(here)        # for relative file paths

# for "Simple Example"
library(praise)      # generate random praise

# for "Plot Example"
library(data.table)  # fast read csv files
library(dplyr)       # data manipulation
library(strings)     # for example data and functions
library(ggplot2)     # to plot data

path <- paste0(here(), "/Tutorial12_Functions")

# Simple Example ----------------------------------------------------------

# recall the praise function:
praise()

# let's give praise to Ryan!
paste0("Ryan", ": ", praise())

# let's give praise to everyone!
paste0("Danielle", ": ", praise())
paste0("Nicole", ": ", praise())
paste0("Kiersten", ": ", praise())
paste0("Leigh", ": ", praise())
paste0("Laila", ": ", praise())

# if we want to change the format of the praise, we need to change every line!
# error-prone if lines scattered through script or MULTIPLE scripts!
paste0("Danielle", praise(template = " is ${adjective}!"))

# to future-proof our code, let's write a function!
# save it in a different script to keep the main script easy to read

# source the script to make the function available here 
## (can click Run or Source, but best to use the source() function)
# (should do this at the top of your script after you load all your packages)

source(paste0(path, "/functions/give_praise.R"))

give_praise("Ryan")
give_praise("Danielle")
give_praise("Nicole")
give_praise("Kiersten")
give_praise("Laila")

# now if we want to change the format of the praise, we only have to change
## in one place!!
paste0("Danielle", praise(template = " is ${adverb} ${adjective}!"))

# modify give_praise()
# source() the function again

source(paste0(path, "/functions/give_praise.R"))

give_praise("Ryan")
give_praise("Danielle")
give_praise("Nicole")
give_praise("Kiersten")
give_praise("Laila")


# Plot Example ------------------------------------------------------------

# make a faceted plot of data measured by sensor strings

data(tidy_data)

dat <- tidy_data %>% 
  convert_depth_to_ordered_factor()

color.pal <- get_colour_palette(dat)
axis.breaks <- get_xaxis_breaks(dat)

ggplot(dat, aes(x = TIMESTAMP, y = VALUE, col = DEPTH)) +
  geom_point(size = 0.25) +
  scale_x_datetime(
    breaks = axis.breaks$date.breaks.major,
    minor_breaks = axis.breaks$date.breaks.minor,
    date_labels =  axis.breaks$date.labels.format
  ) +
  facet_wrap(~VARIABLE, scale = "free_y", ncol = 1) +
  scale_colour_manual(name = "Depth",
                      values = color.pal,
                      drop = FALSE) +
  guides(color = guide_legend(override.aes = list(size = 4))) +
  theme_light()


# for multiple areas...
# a bummer to copy/paste into different scripts
# a lot of code to look at in the same script

# write a function!

# source function
source(paste0(path, "/functions/plot_strings_data.R"))

# plot using the new function
plot_strings_data(dat)

# try on different areas
birchy_head <- fread(paste0(path, "/data/Birchy Head_2019-05-02_TEMP_DO_SAL_trimmed.csv")) 

old_point <- fread(paste0(path, "/data/Old Point Channel_2016-11-26_TEMP_trimmed.csv")) 


plot_strings_data(birchy_head, "Birchy Head")

plot_strings_data(old_point, "Old Point")









