# February 17, 2021

# Importing data from Excel (csv and xlsx files)

# There are some built-in ways to import data from Excel, but we are going
## to learn how to use 2 packages from the tidyverse: readr and readxl
## and one package not from the tidyverse: data.table

# Recall that packages are bundled functions + documentation that can be installed from
## CRAN or GitHub (and sometimes other places)

# The tidyverse is a group of packages that work really well together.
# These packages include functions to help with many data science tasks, including
## data import, data cleaning, data manipulation, plotting, and analysis


# install packages
# (You only need to run this once to install the packages. After that you can comment
## out or delete these lines)
install.packages("readr")
install.packages("readxl")
install.packages("data.table")
install.packages("dplyr")
install.packages("here")

# Set Up ------------------------------------------------------------------

# load the packages (otherwise R won't recognize the functions)
# it is good practice to load ALL packages that you will need for a script at the
## top of the script
library(dplyr)       # for data manipulation
library(here)        # to tell R where to look for the data
library(readr)       # for importing / exporting csv files
library(readxl)      # for importing .xlsx files
library(data.table)  # for FAST importing/exporting csv files


# set the path (tell R where on your computer to look for the data)
path <- file.path("C:/Users/Danielle Dempsey/Desktop/RProjects/Tutorials/Tutorial 2_Importing Data/data")


# readr ----------------------------------------------------------------

# let's start with the read_csv function from the readr package
# first we can look at the help file for the function
?read_csv

# read in the data
data1 <- read_csv(file = paste0(path, "/Borgles Island_2019-05-30_TEMP_DO_trimmed.csv"))

# take a quick look at the data -- make sure all columns/rows were read in
glimpse(data1)

# take a closer look at some columns. . ..
# let's see which VARIABLES are in this dataset (don't worry about understanding the code)
data1 %>% distinct(VARIABLE)

# let's see what DEPTHS are in this dataset
data1 %>% distinct(DEPTH)

# let's take a quick look at Temperature
data1 %>% filter(VARIABLE == "Temperature") %>% select(VALUE) %>%  summary()


# readxl ----------------------------------------------------------------

# let's try reading in the Pirate Harbour Data
data2 <- read_excel(path = paste0(path, "/Pirate Harbour_2019-06-21_TEMP_DO_trimmed.xlsx"),
                                  sheet = "ALL_Data")

# take a quick look at the data -- make sure all columns/rows were read in
glimpse(data2)

# note that the read_csv and read_excel functions behave slightly differently
# read_csv read the TIMESTAMP column in as a date-time object, while read_excel
## read the TIMESTAMP column in as a character
class(data1$TIMESTAMP)
class(data2$TIMESTAMP)

# take a closer look at some columns. . ..
# let's see which VARIABLES are in this dataset
data2 %>% distinct(VARIABLE)

# let's see what DEPTHS are in this dataset
data2 %>% distinct(DEPTH)

# let's take a quick look at Temperature
data2 %>% filter(VARIABLE == "Temperature") %>% select(VALUE) %>%  summary()

# we could also read in a different sheet from the workbook
data_random <- read_excel(path = paste0(path, "/Pirate Harbour_2019-06-21_TEMP_DO_trimmed.xlsx"),
                    sheet = "Random_Nums")

glimpse(data_random)


# data.table ----------------------------------------------------------------

# this package includes functions for FAST importing of csv files
# this is helpful when reading in BIG files, for example all of the Coastal Monitoring Program
# data for a county

data3 <- fread(paste0(path, "/Digby_2021-01-07.csv"))

# take a quick look at the data -- make sure all columns/rows were read in
glimpse(data3)

# take a closer look at some columns. . ..
# let's see which STATIONS are in this dataset (don't worry about understanding the code)
data3 %>% distinct(STATION)

# let's see which VARIABLES are in this dataset (don't worry about understanding the code)
data3 %>% distinct(VARIABLE)

# let's see what DEPTHS are in this dataset
data3 %>% distinct(DEPTH) %>% arrange()










