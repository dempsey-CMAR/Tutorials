library(here)
library(microbenchmark)
library(readr)
library(data.table)

path <- paste0(here(), "/Tutorial 2_Importing Data")


microbenchmark(
  
  data3_readr <- read_csv(file = paste0(path, "/data/Digby_2021-01-07.csv")),
  
  data3_fread <- fread(file = paste0(path, "/data/Digby_2021-01-07.csv")),
  
  times = 5
  
)

# Unit: milliseconds
# expr              min       lq      mean   median       uq      max     neval
# data3_readr    114.7271 114.8271 118.17038 117.3857 119.7465 124.1655     5
# data3_fread     23.3349  23.9876  34.29444  23.9884  24.6647  75.4966     5