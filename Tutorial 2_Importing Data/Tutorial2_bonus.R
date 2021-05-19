library(microbenchmark)
library(readr)
library(data.table)


path <- file.path("C:/Users/Danielle Dempsey/Desktop/RProjects/Tutorials/Tutorial 2_Importing Data/data")


microbenchmark(
  
  data3_readr <- read_csv(file = paste0(path, "/Digby_2021-01-07.csv")),
  
  data3_fread <- fread(file = paste0(path, "/Digby_2021-01-07.csv")),
  
  times = 5
  
)

#Unit: milliseconds
#expr                          min        lq      mean    median        uq       max     neval
#data3_readr <- read_csv() 1649.8405 1663.6951 2087.9017 1876.8494 2584.2521 2664.8715     5
#data3_fread <- fread()    533.7694  551.0478  681.4662  593.1626  843.4036  885.9474     5