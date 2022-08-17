# April 29, 2021

# function to give random praise (basic version)

# arguments:
## name: character string of a person or thing you want to give praise to

## output: a character string in the format
## "name is adjective!"
## (where adjective is randomly assigned by the praise package)

give_praise <- function(name){
  
  paste0(name, praise(template = " is ${adjective}!"))
  
  
  
}


