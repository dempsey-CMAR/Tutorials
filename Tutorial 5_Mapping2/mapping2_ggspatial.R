
# today we will look at a couple of packages for MAPPING in R (woohoo!)
## sf: functions for working with spatial data 
### sf stands for "simple feature"
### sf functions all start with st_ (which stands for "spatial type")
### similar to PostGIS

## ggspatial: to provide basemaps, scalebars, and North arrow

# mapping packages
library(ggspatial)  # for basemaps, scalebars, and North arrow
library(sf)         # to manipulate simple features (spatial data)
library(ggplot2)    # plotting (including maps)

# helper packages
library(dplyr)      # piping and data manipulation functions
library(here)       # to automatically set path
library(readr)      # to read in data

# Goal --------------------------------------------------------------------

# For this tutorial, you will map sites around Nova Scotia where an ecological
# database has recorded the presence of certain fantastical animals.

# Note: the above scenario is fictional.

# Import and explore data -------------------------------------------------

path <- paste0(here(), "/Tutorial 5_Mapping2") # automatically sets the path 

# read in the data (if this doesn't work, trying pasting in the path manually)
dat <- read_csv(paste0(path, "/data/data_file.csv"))

# dat includes some columns and rows that we are not interested
## in mapping right now.

# We are going to use some dplyr functions to subset the data
# select columns of interest & keep 1 row for each place
dat <- dat %>% 
  select(Location, Site, Lat, Long, Place_code) %>%    # selects columns of interest
  distinct(Place_code, .keep_all = TRUE)                # keeps unique place codes

class(dat)    # check the class of dat
glimpse(dat)  # take a look at dat  

# try to plot
# geom_sf() is the ggplot geometry for adding simple feature (spatial) data
# the annotation_*_*() functions are from the ggspatial package
ggplot() +
  annotation_map_tile(type = "cartolight", zoomin = -1) +
  geom_sf(data = dat) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tl", which_north = "true")


# Add geometry! -----------------------------------------------------------

# add a geometry column based on the "Long" and "Lat" columns
# st_as_sf() is a function from the sf package that converts other objects to sf
## objects (adds a geometry column and other spatial features)
# need to specify a coordinate reference system (crs)
dat_sf <- dat %>% 
  st_as_sf(coords = c("Long", "Lat"), remove = FALSE, crs = 4617, agr = "constant")

class(dat_sf)    # dat_sf is now an sf object! (and also a tibble / dataframe)
glimpse(dat_sf)  # what is different compared to glimpse(dat) ?

st_crs(dat_sf)      # take a more detailed look at the crs
st_geometry(dat_sf) # take another look at the geometry

# Map ---------------------------------------------------------------------

# now plot!
ggplot() +
  annotation_map_tile(type = "cartolight", zoomin = -1) +       # basemap
  geom_sf(data = dat_sf) +                                      # observation locations
  annotation_scale(location = "br") +                           # scale bar
  annotation_north_arrow(location = "tl", which_north = "true") # North arrow

# what happens if we change the order of the first two lines?
ggplot() +
  geom_sf(data = dat_sf) +                                       # observation locations
  annotation_map_tile(type = "cartolight", zoomin = -1) +        # basemap
  annotation_scale(location = "br") +                            # scale bar
  annotation_north_arrow(location = "tl", which_north = "true")  # North arrow
# where did all the points go????


# ggspatial: supports different base maps! --------------------------------

# osm
ggplot() +
  annotation_map_tile(type = "osm", zoomin = -1) +  # the zoomin parameter controls the resolution
  geom_sf(data = dat_sf) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tl", which_north = "true")

# stamenwatercolor
ggplot() +
  annotation_map_tile(type = "stamenwatercolor", zoomin = 0) +
  geom_sf(data = dat_sf) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tl", which_north = "true")

# hotstyle
ggplot() +
  annotation_map_tile(type = "hotstyle", zoomin = -1) +
  geom_sf(data = dat_sf) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tl", which_north = "true")

# to see all the available tiles type:  
library(rosm)
osm.types()  


# Export Map --------------------------------------------------------------
map_output <- ggplot() +
  annotation_map_tile(type = "cartolight", zoomin = -1) +       # basemap
  geom_sf(data = dat_sf) +                                      # observation locations
  annotation_scale(location = "br") +                           # scale bar
  annotation_north_arrow(location = "tl", which_north = "true") # North arrow

ggsave(filename = "NS_ggspatial.png",
       plot = map_output,
       device = "png",
       width = 18, 
       height = 18,
       units = "cm",
       dpi = 600)


                             



