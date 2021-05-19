# March 4, 2021

library(ggplot2) # package for "elegant data visualizations using the Grammar of Graphics"

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

# Load in Data ------------------------------------------------------------

data <- iris # the iris dataset

head(iris)   # take a quick look at the data

# Base R ------------------------------------------------------------------

# Scatter plots
# plot 1 
plot(x = data$Sepal.Length, y = data$Sepal.Width)

# plot 1 
plot(y = data$Sepal.Width, x = data$Sepal.Length)

# plot 2
plot(data$Sepal.Length, data$Sepal.Width, col = "red")

# plot 3
plot(data$Sepal.Length, data$Sepal.Width, col = "blue", pch = 3, 
     xlab = "Sepal Length", ylab = "Sepal Width",
     main = "Sepal Scatter Plot")


# histograms
hist(data$Sepal.Length)

hist(data$Sepal.Width)

# boxplots
boxplot(data[, -5])

data[, 5]
data[, -5]

# ggplot ------------------------------------------------------------------

# ggplot2: package (Hadley Wickham's PhD!) based on the idea of 
## the Grammar of Graphics (Leland Wilkinson, 1999)

# Just likes elements of speech (nouns, adjectives, verbs, etc), we can think
## of elements of graphics
# 7 distinct layers of "grammatical elements" in ggplot:
## Data, Aesthetics, Geometries, Facets, Statistics, Coordinates, Themes


# Scatter plot (3 elements)
ggplot(data, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()

# Scatter plot for each species (4 elements!)
# good for comparisons - automatically uses same scale on x & y axis!
ggplot(data, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  facet_wrap(~Species, nrow = 1)

# Scatter plot for each species with linear model! (5 elements)
# good for comparisons - automatically uses same scale on x & y axis!
ggplot(data, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  facet_wrap(~Species, nrow = 1) +
  geom_smooth(method = "lm", se = FALSE, col = "red")





