# April 7, 2021

# Iteration: Loops

# Inspiration from R for Data Science (Hadley Wickham)
# https://r4ds.had.co.nz/iteration.html?q=itera#iteration

# If you need to copy/paste code **more than twice** you should think about how
# you can reduce duplication. 
# 3 main benefits to reducing duplication:
## 1. Easier to read the code (don't have to look through for what is different)
## 2. Easier to modify (only need to make changes in 1 place)
## 3. Likely to have fewer bugs (because fewer lines of code)

# There are a couple of ways to reduce duplication:
## writing functions (to discuss in a future tutorial!)
## iteration (e.g., loops, apply functions, purrr package)

# Today we are going to talk about loops (imperative programming), because they
## make the iteration explicit (a good place to start!)

## NOTE: Loops are very "verbose" (need a lot of code) and can be slow, but are
## really useful in some situations and a good place to start


# packages -----------------------------------------------------------------

library(dplyr)
library(ggplot2)
library(praise)

# First example -----------------------------------------------------------

R_group <- c("Danielle", "Laila", "Leigh", "Nicole", "Ryan", "Kiersten")

# recall: extract elements using []
R_group[6]
R_group[3]

# give praise! 
print(
  paste0(R_group[1], ": ", praise())
)

# Give praise to EVERYONE! 
# copy/paste
print(
  paste0(R_group[1], ": ", praise())
)

print(
  paste0(R_group[2], ": ", praise())
)

print(
  paste0(R_group[3], ": ", praise())
)

print(
  paste0(R_group[4], ": ", praise())
)

## loop over all elements in R_group

for(i in 1:6){

  print(
    paste0(R_group[i], ": ", praise())
  )
  
}

# more generic
for(i in seq_along(R_group)){

  print(
    paste0(R_group[i], ": ", praise())
  )

}


# Motivation --------------------------------------------------------------

# create dataframe of random variables
df <- data.frame(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# find the median of each column:
# copy/paste
median(df$a)
median(df$b)
median(df$c)
median(df$d)

output <- median(df[[1]]) 

# for loop
output <- vector("double", ncol(df))  # 1. output

for (i in seq_along(df)) {            # 2. sequence

  output[[i]] <- median(df[[i]])      # 3. body

}

output

# Note1: can use any variable for counter - traditional to use i, j, or k

# Note2: use seq_along() instead of length() because it does the right thing 
## for zero-length vector)
## y <- vector("double", 0)
## seq_along(y)
## 1:length(y)

# Note3: while loops are also a thing, but we won't talk about them today

# Star Wars Example -------------------------------------------------------

# built-in Star wars dataset!
starwars_data <- starwars %>%
  filter(!is.na(mass), !is.na(height))

glimpse(starwars_data)

# what is the mean height and mass for each species?

# find the unique values of species (to loop over)
species <- unique(starwars_data$species) 

species_stats <- data.frame(NULL)  # 1. output

for(i in seq_along(species)){      # 2. sequence

  species.i <- species[i]          # 3. body

  data.i <- starwars_data %>%      # filter for the species of interest
    filter(species == species.i)

  row.i <- data.frame(             # calculate the stats on the filtered data
    species = species.i,
    mean_mass = mean(data.i$mass),
    mean_height = mean(data.i$height),
    n = nrow(data.i)
  )
  # bind together results
  # it can be really slow to do it this way, but it works!
  species_stats <- rbind(species_stats, row.i)
}

ggplot(species_stats, aes(x = mean_mass, y = mean_height)) +
  geom_point()


# the dplyr way -----------------------------------------------------------
# loops can often be avoided...

species_stats_dplyr <- starwars_data %>%
  dplyr::group_by(species) %>%
  dplyr::summarize(mean_mass = mean(mass),
                   mean_height = mean(height),
                   n = n()) %>%
  ungroup()


ggplot(species_stats_dplyr, aes(x = mean_mass, y = mean_height)) +
  geom_point(col = "purple")


# Just For Fun...
ggplot(starwars_data, aes(x = mass, y = height, col = sex)) +
  geom_point()


