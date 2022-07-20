# November 25, 2021

# today we will look at two packages for MAPPING in R:
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
library(dplyr)        # piping and data manipulation functions
library(here)         # to automatically set path
library(readr)        # to read in data
library(RColorBrewer) # to make a nice colour palette

# Goal --------------------------------------------------------------------

# For this tutorial, our goal is to help Bob and Sue make a map showing the animals
# they found on their trip to beautiful Whycocomagh Basin in 2018. You will map 
# numbered "sites" where an ecological database records the presence of fantastical
# animals. You will then need to map the locations where animals were found, making
# it clear what type of animal was found and who found it.

# Note: the above scenario is fictional.

# Import data -------------------------------------------------------------

theme_set(theme_light())

path <- paste0(here(), "/Tutorial14_Mapping6")

dat <- read_csv(paste0(path, "/data/data_file.csv")) %>%
  filter(Location == "Whycocomagh Bay", Year == 2018) %>% 
  select(Location, Site, Lat, Long, Place_code, Animal_found) %>% 
  mutate(Animal_found = ordered(
    Animal_found, levels = c("Kraken", "Hydra", "Mermaid", "Siren"))
  )

class(dat)    # check the class of dat
glimpse(dat)  # take a look at dat 

# import site shapefile
sites_raw <- read_sf(paste0(path, "/Sites/habitat.shp"))
# Note: this dataset is adapted from the Nova Scotia Marine Aquaculture Leases dataset
# on the Nova Scotia Open Data Portal. 
# (https://data.novascotia.ca/Fishing-and-Aquaculture/Nova-Scotia-Marine-Aquaculture-Leases/h57h-p9mm)

glimpse(sites_raw)
class(sites_raw)
st_crs(sites_raw)      

sites <- sites_raw %>% filter(waterbody == "Whycocomagh Bay")

ggplot() + geom_sf(data = sites)

# Map ---------------------------------------------------------------------

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
# Data coordinates are recorded in NAD83 CSRS, which corresponds to 4617

crs <- 4617

dat_sf <- dat %>% 
  st_as_sf(coords = c("Long", "Lat"), crs = crs,
           remove = FALSE,  agr = "constant")

class(dat_sf)    # dat_sf is now an sf object! (and also a tibble / dataframe)
glimpse(dat_sf)  # what is different compared to glimpse(dat) ?

st_crs(dat_sf)      # take a more detailed look at the crs

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


# Zoom in ----------------------------------------------------------

# a bit too zoomed in. 
# let's add dummy points to zoom out

# dummy coordinates to control extent of map
dummy_points <- data.frame(Long = c(-61.15, -61.11), Lat = c(45.938, 45.963)) %>%
  st_as_sf(coords = c("Long", "Lat"), crs = crs)

ggplot() +                                
  annotation_map_tile(type = "cartolight", zoomin = 0) +          # basemap
  geom_sf(data = dummy_points, col = 2) +                         # to control map extent
  geom_sf(data = dat_sf) +                                        # observation locations
  annotation_scale(location = "br")    +                          # scale bar
  annotation_north_arrow(location = "tl", which_north = "true")   # North arrow

# Add sites --------------------------------------------------------------

# add sites
ggplot() +
  geom_sf(data = dummy_points) +                                  # to control map extent
  annotation_map_tile(type = "cartolight", zoomin = 0) +          # basemap
  geom_sf(data = sites) +
  geom_sf(data = dat_sf) +                                        # observation locations
  annotation_scale(location = "br") +                             # scale bar
  annotation_north_arrow(location = "tl", which_north = "true")   # North arrow

# need to crop sites
bbox <- c(xmin = -61.14,  ymin = 45.942, xmax = -61.11,  ymax = 45.955) # bounding box for Whycocomagh Basin

# animal sites
sites <- sites_raw %>%
  st_transform(crs = crs) %>%
  st_crop(bbox)

# add sites
ggplot() +
  geom_sf(data = dummy_points) +                                  # to control map extent
  annotation_map_tile(type = "cartolight", zoomin = 0) +          # basemap
  geom_sf(data = sites) +
  geom_sf(data = dat_sf) +                                        # observation locations
  annotation_scale(location = "br") +                             # scale bar
  annotation_north_arrow(location = "tl", which_north = "true")   # North arrow


# Colour points based on Animal_found column ---------------------------

ggplot() +
  geom_sf(data = dummy_points) +                                  # to control map extent
  annotation_map_tile(type = "cartolight", zoomin = 0) +          # basemap
  geom_sf(data = sites) +
  geom_sf(data = dat_sf, aes(col = Animal_found)) +               # observation locations
  annotation_scale(location = "br") +                             # scale bar
  annotation_north_arrow(location = "tl", which_north = "true")   # North arrow

# Make our own pretty basemap ---------------------------------------------

# some parameters we will use to map the make pretty
line_width <- 0.5
font_size <- 2.5
site_label_col <- "black"
map_ylabs = c(45.944, 45.948, 45.952)
map_xlabs = c(-61.135, -61.125, -61.115)
animal_cols <- brewer.pal(4, "Set1")
basemap <- "osm" 

# remember that the order of the layers matters!
map_base <- ggplot() +
  # basemap
  geom_sf(data = dummy_points) +                                  
  annotation_map_tile(type = basemap, zoomin = 0) +         
  # add sites
  geom_sf(data = sites, size = line_width, col = 1, fill = NA) +
  geom_sf_label(data = sites, 
                aes(label = site), 
                label.size = 0, fill = NA, col = site_label_col, size = font_size) +
  # make it pretty
  scale_x_continuous(name = NULL, breaks = map_xlabs) +
  scale_y_continuous(name = NULL, breaks = map_ylabs) + 
  annotation_scale(location = "br") +                             # scale bar
  annotation_north_arrow(location = "tl", which_north = "true")   # North arrow

# look what we created:
map_base  

# now let's add the animal found data
map_base +
  geom_sf(data = dat_sf, aes(col = Animal_found)) +
  scale_color_manual(name = "Animal Found", values = animal_cols, drop = FALSE)

# Export map
ggsave(filename = "NS_ggspatial_shapefiles.png", 
       device = "png",
       width = 20, height = 18, units = "cm",
       dpi = 600)

