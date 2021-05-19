# April 22, 2021

# https://dplyr.tidyverse.org/
# dplyr is a "grammar of data manipulation" 
# functions are called "verbs" and they do what you would expect:
## select() picks variables based on their names
## filter() picks rows based on their value
## summarise() reduces multiple values into a single summary
## arrange() changes the order of the rows
## mutate() adds new variables that are functions of existing variables
## group_by() to perform operations by group

library(dplyr)     # for data manipulation
library(babynames) # for data to play with
library(ggplot2)   # for data to play with

# set up data -------------------------------------------------------------

starwars <- starwars

glimpse(starwars)

babynames <- babynames

glimpse(babynames)

# select() ----------------------------------------------------------------

# pick columns based on their name (note order)
starwars %>% select(name,  homeworld, species)

# pick multiple columns based on their order
starwars %>% select(name, hair_color:gender)

# pick multiple columns based on their name
# select helpers: contains(), starts_with(), ends_with(), everything() 
# ?select_helpers
starwars %>% select(name, contains("color"))

# drop columns based on their name
starwars %>% select(-films, -vehicles, -starships, -homeworld)


# filter() ----------------------------------------------------------------

# one condition
babynames %>% filter(name == "Danielle")

# compare to base R 
babynames[which(babynames$name == "Danielle"), ]

# multiple conditions
babynames %>% filter(name == "Danielle", year == 1990)

# compare to base R 
babynames[which(babynames$name == "Danielle" & babynames$year == 1990), ]

babynames %>% filter(name == "Danielle", year >= 1990)

# quick plot!
babynames %>% 
  filter(name == "Danielle", 
         year >= 1990, 
         sex == "F") %>% 
  ggplot(aes(x = year, y = n)) +
  geom_line() +
  geom_point() +
  labs(title = "Annual number of female babies named Danielle")


# match multiple values: the %in% operator
cmar_names <- c("Danielle", "Ryan", "Leigh", "Nicole", "Kiersten")

cmar_dat <- babynames %>% filter(name %in% cmar_names)

ggplot(cmar_dat, aes(year, n, group = name, col = name)) +
  geom_line()

cmar_1960 <- cmar_dat %>% 
  filter(year >= 1960)

ggplot(cmar_1960, aes(year, n, group = name, col = sex)) +
  geom_point() +
  facet_wrap(~name)

# summarise() & group_by() ---------------------------------------------------------------

# average babies named X over all years since 1960
# (of both sexes)
cmar_1960 %>% 
  group_by(name) %>% 
  summarise(mean_number = mean(n))

# sort low to high
cmar_1960 %>% 
  group_by(name) %>% 
  summarise(mean_number = mean(n)) %>% 
  arrange(mean_number)

# sort high to low
cmar_1960 %>% 
  group_by(name) %>% 
  summarise(mean_number = mean(n)) %>% 
  arrange(desc(mean_number))

# separate out by sex
cmar_1960 %>% 
  group_by(name, sex) %>% 
  summarise(mean_number = mean(n)) %>% 
  arrange(desc(mean_number))

# how many observations in each mean?
# n() counts the number of rows in each group
cmar_1960 %>% 
  group_by(name, sex) %>% 
  summarise(
    mean_number = mean(n), 
    n_obs = n()) %>% 
  arrange(desc(mean_number))




# mutate() ---------------------------------------------------------------
# prop = n divided by total number of applicants in that year,
# which means proportions are of people of that sex with that 
# name born in that year.

# What percent of babies were named x in 2017?
# calculate PERCENT from the proportion column
cmar_1960 %>% 
  mutate(percent_names = prop*100) %>% 
  filter(year == 2017) %>% 
  arrange(desc(percent_names))


# other mutate examples?? starwars?


