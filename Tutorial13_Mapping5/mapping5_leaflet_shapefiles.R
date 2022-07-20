# November 19, 2021

# Today we will learn how to import shapefiles and them to our leaflet map
# We can import shapefiles using the read_sf() function from the sf package
# We can add shapefiles to maps using the addPolygons() function 

# mapping packages
library(leaflet)    # to make interactive map
library(sf)         # to manipulate simple features (spatial data)
library(ggplot2)

# helper packages
library(dplyr)        # piping and data manipulation functions
library(here)         # to automatically set path
library(readr)        # to read in data

# Goal --------------------------------------------------------------------

# In 2017, Bob and Sue searched for animals in St. Ann's Harbour. You will map the
# locations where they found fantastical animals and the sites where an ecological database
# records animals in an interactive map.

# Note: the above scenario is fictional.

# Import data -------------------------------------------------

path <- paste0(here(), "/Tutorial13_Mapping5")  # automatically sets the path 

dat <- read_csv(paste0(path, "/data/data_file.csv"))

class(dat)    # check the class of dat
glimpse(dat)  # take a look at dat 

# leaflet plot with label (hover) based on a column in dat
leaflet(data = dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(~Long, ~Lat, 
                   label = ~Location,
                   color = "gold",
                   radius = 4, 
                   fillOpacity = 1, 
                   stroke = FALSE) 


# Subset the data for St. Ann's observations from 2017 and add geometry column
st_ann <- dat %>% 
  filter(Location == "St. Ann's Harbour", Year == 2017) %>% 
  select(Location, Site, Lat, Long, Place_code) %>% # selects columns of interest
  distinct(Place_code, .keep_all = TRUE)             # keeps unique place codes
  

# add a label (hover) based on a column in dat
leaflet(data = st_ann) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(~Long, ~Lat, 
                   label = ~Place_code,
                   color = "magenta",
                   radius = 4, 
                   fillOpacity = 0.75, 
                   stroke = FALSE) 


# Read in Shapefiles ------------------------------------------------------

# import site shapefile
sites_raw <- read_sf(paste0(path, "/Sites/habitat.shp"))
# Note: this dataset is adapted from the Nova Scotia Marine Aquaculture Leases dataset
# on the Nova Scotia Open Data Portal. 
# (https://data.novascotia.ca/Fishing-and-Aquaculture/Nova-Scotia-Marine-Aquaculture-Leases/h57h-p9mm)


glimpse(sites_raw)
class(sites_raw)
st_crs(sites_raw)      # extract CRS
st_geometry(sites_raw) # extract info about the geometry col

# let's take a quick look at the sites
ggplot() + geom_sf(data = sites_raw) 

# filter for St. Ann's 
sites <- sites_raw %>% filter(waterbody == "St. Anns Harbour")

ggplot() + geom_sf(data = sites) 


# add sites to leaflet plot ----------------------------------------------
leaflet(data = st_ann) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(data = sites,
              color = "#444444", weight = 1, smoothFactor = 0.5,
              label = ~site,
              labelOptions = labelOptions(permanent = FALSE),
              opacity = 1.0, fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE)) %>%
  addCircleMarkers(~Long, ~Lat, popup =  ~Place_code,
                   radius = 4, fillOpacity = 1, stroke = FALSE) 


# add sites to leaflet plot ----------------------------------------------
crs_leaflet <- "+proj=longlat +datum=WGS84"

sites <- sites %>% 
  st_transform(crs = crs_leaflet)


leaflet(data = st_ann) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%

  addPolygons(data = sites,
              color = "#444444", weight = 1, smoothFactor = 0.5,
              label = ~site,
              labelOptions = labelOptions(permanent = FALSE),
              opacity = 1.0, fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE)) %>% 
  addCircleMarkers(~Long, ~Lat, popup =  ~Place_code,
                   radius = 4, fillOpacity = 1, stroke = FALSE) 





