# March 11, 2021

# Last week: intro to ggplot
## add elements together to build up beautiful graphics

# leaflet: a package for INTERACTIVE maps!
## basic maps are pretty easy to make, 
## but eventually you need to start using html for customization

# mapping packages
library(leaflet)      # to make interactive maps
library(htmlwidgets)  # to save maps

# helper packages
library(dplyr)      # piping and data manipulation functions
library(here)       # to automatically set path - make sure to install this!
library(readr)      # to read in data

# Import and explore data -------------------------------------------------

path <- paste0(here(), "/Tutorial 05_Mapping1_leaflet")  # automatically sets the path 

# read in the data (if this doesn't work, trying pasting in the path manually)
dat <- read_csv(paste0(path, "/data/data_file.csv")) %>% 
  filter(row_number() %% 10 == 0)

# select columns of interest & keep 1 row for each station
dat <- dat %>% 
  select(location, site, latitude, longitude, place_code) %>% # selects columns of interest
  distinct(place_code, .keep_all = TRUE)             # keeps unique place codes


class(dat)    # check the class of dat
glimpse(dat)  # take a look at dat  

# Basic Map ---------------------------------------------------------------------

# leaflet can handle lat/long data (don't need to convert to sf object)

leaflet(dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%  # basemap
  addMarkers(~longitude, ~latitude)                           # observation locations


# Customize Markers -------------------------------------------------------

# change to circle marker
leaflet(data = dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(~longitude, ~latitude, 
                   color= "green",
                   radius = 4, 
                   fillOpacity = 1, 
                   stroke = FALSE) 


# add a label (hover) based on a column in dat
leaflet(data = dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(~longitude, ~latitude, 
                   label = ~location,
                   color = "magenta",
                   radius = 4, 
                   fillOpacity = 1, 
                   stroke = FALSE) 

# add a popup label (click to see) based on a column in dat
leaflet(data = dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(~longitude, ~latitude, 
                   popup = ~location,
                   color = "green",
                   radius = 4, 
                   fillOpacity = 1, 
                   stroke = FALSE) 


# add scale bar
leaflet(data = dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(~longitude, ~latitude, 
                   popup = ~location,
                   color = "green",
                   radius = 4, 
                   fillOpacity = 1, 
                   stroke = FALSE) %>% 
  addScaleBar(
    position = "bottomright", 
    options = scaleBarOptions(imperial = FALSE)
  )

# Add info from multiple columns to label ----------------------------------
# need a little bit of html!

# add a new column to dat with all the information you want to display
dat <- dat %>% 
  mutate(label = paste(location, site, place_code, sep = "</br>")) 
# </br> is html for start on a new line

# add a popup label (click to see) based on a column in dat
leaflet(data = dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(~longitude, ~latitude, 
                   popup = ~label,
                   color = "green",
                   radius = 4, 
                   fillOpacity = 1, 
                   stroke = FALSE) 

# So many basemaps! -------------------------------------------------------

# see http://leaflet-extras.github.io/leaflet-providers/preview/ and
# https://github.com/leaflet-extras/leaflet-providers)


# German map?
leaflet(dat) %>%
  addProviderTiles(providers$OpenStreetMap.DE) %>%
  addMarkers(~longitude, ~latitude)  

# ESRI World Imagery
leaflet(dat) %>%
  addProviderTiles(providers$Esri.WorldImagery) %>%
  addMarkers(~longitude, ~latitude)  

# topo map
leaflet(dat) %>%
  addProviderTiles(providers$OpenTopoMap) %>%
  addMarkers(~longitude, ~latitude)  


# Export map --------------------------------------------------------------

map_output <- leaflet(dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(~longitude, ~latitude, 
                   popup = ~label,
                   color = "green",
                   radius = 4, 
                   fillOpacity = 1, 
                   stroke = FALSE) 

# export using the saveWidget function from the htmlwidgets package
saveWidget(map_output, file = paste0(path, "/NS_leaflet.html"))





