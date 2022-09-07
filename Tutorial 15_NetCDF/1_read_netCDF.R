# September 7, 2022

# This Tutorial covers how to read in a netCDF file and export a csv of the 
# relevant data
# Follows this RPUbs article:
# https://pjbartlein.github.io/REarthSysSci/netCDF.html

# Example data: chlorphyll a data downloaded from Giovanni

# set up ------------------------------------------------------------------

library(ncdf4)           # working with netCDFs
library(data.table)      # writing csv files

library(lattice)         # level plot (see plot_netCDF.R for plot with map)
library(RColorBrewer)    # colour palette

library(here)            # relative file paths

# file path to where the /data folder is
path <- here("Tutorial 15_NetCDF")

# name of the netCDF file
file_name <- "/data/g4.timeAvgMap.MODISA_L3m_CHL_2018_chlor_a.20020801-20021231.64W_45N_63W_45N.nc"

# full path to the netCDF file, including file extension
full_path <- paste0(path, file_name)

# Open file ---------------------------------------------------------------

nc <- nc_open(full_path) # opens the netCDF file in the R environment as a list

print(nc)                # skim through to get a sense of what is in the file

# data exploration --------------------------------------------------------

# extract the latitude and longitude
lon <- ncvar_get(nc, "lon")
lat <- ncvar_get(nc, "lat")

# dimensions match output from print(nc)!

# if there was time:
# time <- ncvar_get(nc, "time") 

# extract the chlorophyll data
chl <- ncvar_get(nc, "MODISA_L3m_CHL_2018_chlor_a")

dim(chl) # dimensions match what we would expect based on the coordinate data

# other info from the file
ncatt_get(nc, "MODISA_L3m_CHL_2018_chlor_a", "long_name")

ncatt_get(nc, "MODISA_L3m_CHL_2018_chlor_a", "units")

# the fill value is a number that is used in place of NA
fillvalue <- ncatt_get(nc, "MODISA_L3m_CHL_2018_chlor_a", "_FillValue")


# global attributes -------------------------------------------------------

# not all of these have entries in this dataset
ncatt_get(nc, 0, "title")
ncatt_get(nc, 0, "institution")
ncatt_get(nc, 0, "source")
ncatt_get(nc, 0, "references")
ncatt_get(nc, 0, "history")
ncatt_get(nc, 0, "Conventions")

# close the netCDF (this means functions from the ncdf4 function can't access the file anymore)
nc_close(nc)

# replace fillvalue with NAs so that R will recognize 
chl[chl == fillvalue$value] <- NA

# simple plots --------------------------------------------------------

# These simple plots are not very informative for this dataset
# Note that not all grid cells have data
# See 2_plot_netCDF.R for better maps

# plot1
image(lon, lat, chl)

# plot2 
grid <- expand.grid(lon = lon, lat = lat)
levelplot(
  chl ~ lon * lat, 
  data = grid, 
  cuts = 11, 
  pretty = TRUE, 
  col.regions=(rev(brewer.pal(10,"RdBu")))
)

# export csv --------------------------------------------------------------

# create a data frame
lonlat <- as.matrix(expand.grid(lon, lat))
dim(lonlat) # number of rows should be length(lon) * length(lat)

# vector of chl values (stacks the columns of chl on top of each other)
chl_vec <- as.vector(chl)
length(chl_vec)

chl_df <- data.frame(cbind(lonlat, chl_vec))
names(chl_df) <- c("lon", "lat", "chl")

# not all grid cells have data, as shown in the figures above
# use na.omit() to only view the cells with data
head(na.omit(chl_df))

# export the data in csv file
# exclude rows that have NA values
fwrite(na.omit(chl_df), file = paste0(path, "/output/chl_data.csv"))


