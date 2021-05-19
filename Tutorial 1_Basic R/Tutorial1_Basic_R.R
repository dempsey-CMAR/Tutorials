# February 17, 2021

# Basic R

# calculates 3 + 4 (press ctrl + enter or the green arrow to run)
# the answer will appear in the console
3 + 4


# Arithmetic --------------------------------------------------------------

# addition
5 + 5

# subtraction
12 - 1

# multiplication
3 * 4

# division
20 / 4

# exponentiation
2 ^ 4


# Variable Assignment -----------------------------------------------------

# assign the value of 42 to the variable my_variable:
my_variable <- 42

# print the value of my_variable
my_variable

# assign a value to the variable my_apples
my_apples <- 10

# assign a value to the variable my_oranges
my_oranges <- 9.3

# do you have more apples than oranges?
my_apples > my_oranges

my_apples - my_oranges

my_apples == my_oranges

# how much fruit do you have?
my_fruit <- my_apples + my_oranges


# Data types ---------------------------------------------------------------

# numeric
my_number <- 12

# character
my_character <- "CMAR rocks"

# logical (TRUE/FALSE)
my_logical <- TRUE

# check the data type of the variables we just made
class(my_number)
class(my_character)
class(my_logical)

# A couple of other data types -- for fun
# date
my_date <- Sys.Date() # <- this function looks up today's date!!
class(my_date)

# date-time
my_time <- Sys.time() # <- this function looks up the current time!!
class(my_time)

# Vectors -----------------------------------------------------------------

# vectors are "1-dimension arrays that can hold numeric, character, or logical data."
## In other words, a way to store data

numeric_vector <- c(1, 2, 3)
character_vector <- c("Danielle", "Laila", "Cody")

test <- c(2, "check")

character_vector[2]

# you can do math with vectors:

numeric_vector + 3 # adds 3 to every element in numeric_vector

numeric_vector * 3 # multiplies every element in numeric_vector by 3

numeric_vector + numeric_vector

mean(numeric_vector)

# Matrices ----------------------------------------------------------------

# a matrix is a collection of elements of the **same data type** arranged in rows and columns
# (2-dimensional array)

my_matrix <- matrix(1:9, byrow = TRUE, nrow = 3)
my_matrix
class(my_matrix)
dim(my_matrix)


# select an element with square brackets []: [row, column]
my_matrix[2, 3]

# find the sum of values in each row
rowSums(my_matrix)
# fund the sum of values in each column
colSums(my_matrix)

# add a row
new_row <- c(10, 11, 12)
my_matrix <- rbind(my_matrix, new_row)
dim(my_matrix)

# add a column
new_col <- c(13, 14, 15, 16)
my_matrix <- cbind(my_matrix, new_col)
dim(my_matrix)


# my_matrix2 <- matrix(1:9, byrow = FALSE, nrow = 3)
# my_matrix2

# you can also do math with matrices, but we won't go over that here


# A brief note on factors -------------------------------------------------

# factors are how R stores categorical data

color_vector <- c("Green", "Blue", "White", "Green", "Green", "Green", "White")
color_vector_factor <- factor(color_vector)
color_vector_factor

table(color_vector_factor)

# can also have ordered factors
temperature_vector <- c("High", "Low", "Low", "Medium", "High", "Medium", "Low")
temperature_vector_factor <- factor(temperature_vector, order = TRUE,
                                    levels = c("Low", "Medium", "High"))

temperature_vector_factor
table(temperature_vector_factor)


# Dataframes ... YAY ------------------------------------------------------

# variables as columns and observations as rows
# columns can be different data types!

# built-in data set
data <- iris

class(data)
head(data)
str(data)

# can extract elements from the dataframe in different ways

# can use square brackets, like with matrices
data[6, 2] # 6th observation from the 2nd column

# the whole third row
data[3, ]
data[3:6, ]

# the whole second column
col2 <- data[ , 2]
data[, "Sepal.Width"]
data$Sepal.Width

# we will work on manipulating (filtering, adding/removing columns, summarizing)
## dataframes in a future tutorial!






