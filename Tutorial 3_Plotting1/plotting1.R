# March 4, 2021

# Review ------------------------------------------------------------------

# dataframes store data in rows and columns (like and Excel spreadsheet)
## Each column can have a different type of data (e.g., numeric, character, date) 
## A tibble is a fancy type of dataframe

# we need to use different functions to read in csv files vs. xlsx files
## csv files:
### read_csv (readr package)  
### fread (data.table package) - use for BIG files

## xlsx files:
### read_excel (readxl package)


# Today -------------------------------------------------------------------

# Today we will make some basic plots 
# There are built-in ways to make plots, but we will spend most of the time
## using the ggplot2 package

# Set Up ------------------------------------------------------------

# load package
library(ggplot2) # package for "elegant data visualizations using the Grammar of Graphics"

# load data
dat <- iris # the iris dataset

head(iris)   # take a quick look at the data

# Base R ------------------------------------------------------------------

# Scatter plots
# plot 1 
plot(x = dat$Sepal.Length, y = dat$Sepal.Width)

# plot 1 
plot(y = dat$Sepal.Width, x = dat$Sepal.Length)

# plot 2
plot(dat$Sepal.Length, dat$Sepal.Width, col = "red")

# plot 3
plot(dat$Sepal.Length, dat$Sepal.Width, col = "blue", pch = 3, 
     xlab = "Sepal Length", ylab = "Sepal Width",
     main = "Sepal Scatter Plot")


# histograms
hist(dat$Sepal.Length)

hist(dat$Sepal.Width)

# boxplots
boxplot(dat[, -5])


# ggplot ------------------------------------------------------------------

# ggplot2: package (Hadley Wickham!) based on the idea of 
## the Grammar of Graphics (Leland Wilkinson, 1999)

# Just likes elements of speech (nouns, adjectives, verbs, etc), we can think
## of elements of graphics
# 7 distinct layers of "grammatical elements" in ggplot:
## Data, Aesthetics, Geometries, Facets, Statistics, Coordinates, Themes

# Scatter plot (3 elements)
ggplot(dat, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()

# Scatter plot for each species (4 elements!)
# good for comparisons - automatically uses same scale on x & y axis!
ggplot(dat, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  facet_wrap(~Species, nrow = 1)

# Scatter plot for each species with linear model! (5 elements)
# good for comparisons - automatically uses same scale on x & y axis!
ggplot(dat, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  facet_wrap(~Species, nrow = 1) +
  geom_smooth(method = "lm", se = FALSE, col = "red")





