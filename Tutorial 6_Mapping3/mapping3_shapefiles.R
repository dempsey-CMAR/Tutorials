
# We are going to continue using ggspatial, sf, and ggplot to make maps

# Today we will learn how to import shapefiles and add them to our map
# We can import shapefiles using the read_sf() function from the sf package
# We can add shapefiles to maps using the geom_sf() function 

# We will also import lat/long data and convert it to polygons to add to the map

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
# they found on their trip to beautiful Whycocomagh Basin in 2019. You will map 
# numbered "sites" where an ecological database records the presence of fantastical 
# animals, as well as zones to search for animals recommended to Bob and Sue by 
# a local naturalist.

# You will then need to map the locations where animals were found, making it clear 
# what type of animal was found and who found it.

# Note: the above scenario is fictional.

# Import data -------------------------------------------------

path <- paste0(here(), "/Tutorial 6_Mapping3")  # automatically sets the path 

# read in the data (if this doesn't work, trying pasting in the path manually)
dat <- read_csv(paste0(path, "/data/data_file.csv"))

# Subset the data for Whycocomagh Bay observations from 2019 and add geometry column
dat_sf <- dat %>% 
  filter(Location == "Whycocomagh Bay", Year == 2019) %>% 
  mutate(Animal_found = ordered(Animal_found, levels = c("Kraken", "Hydra", "Mermaid", "Siren"))) %>% 
  st_as_sf(coords = c("Long", "Lat"), remove = FALSE, crs = 4617, agr = "constant")
  
class(dat_sf)    # check the class of dat_sf
glimpse(dat_sf)  # take a look at dat_sf

# now plot!
ggplot() +
  annotation_map_tile(type = "cartolight", zoomin = 0) +        # basemap
  geom_sf(data = dat_sf) +                                      # animal locations
  annotation_scale(location = "br") +                           # scale bar
  annotation_north_arrow(location = "tl", which_north = "true") # North arrow
  
# # a bit too zoomed in. Let's zoom out a bit using dummy points

dummy_points <- data.frame(Long = c(-61.15, -61.10), Lat = c(45.935, 45.965)) %>%
  st_as_sf(coords = c("Long", "Lat"), crs = 4617)

ggplot() +
  annotation_map_tile(type = "cartolight", zoomin = 0) +          # basemap
  geom_sf(data = dummy_points, col = 2) +                         # to control map extent
  geom_sf(data = dat_sf) +                                        # animal locations
  annotation_scale(location = "br") +                             # scale bar
  annotation_north_arrow(location = "tl", which_north = "true")   # North arrow

# Read in Shapefiles ------------------------------------------------------

# import animal recording site shapefile
sites_raw <- read_sf(paste0(path, "/Sites/habitat.shp"))
# Note: this dataset is adapted from the Nova Scotia Marine Aquaculture Leases dataset
# on the Nova Scotia Open Data Portal. 
# (https://data.novascotia.ca/Fishing-and-Aquaculture/Nova-Scotia-Marine-Aquaculture-Leases/h57h-p9mm)

glimpse(sites_raw)

class(sites_raw)
st_crs(sites_raw)     # extract CRS
st_geometry(sites_raw) # extract info about the geometry col

# let's take a quick look at the sites
ggplot() + geom_sf(data = sites_raw) 


# Transform & Crop ---------------------------------------------------------------------

# try adding a geom_sf layer with the shapefiles to our previous map
ggplot() +
  annotation_map_tile(type = "cartolight", zoomin = -1) +  # basemap
  geom_sf(data = dat_sf, col = "red") +               # sample locations
  geom_sf(data = sites_raw)                               # add sites

# We need to crop the shapefiles to a bounding box around Whycocomagh: st_crop 
# and make sure they all have the same crs: st_transform
bbox <- c(xmin = -61.14,  ymin = 45.942, xmax = -61.11,  ymax = 45.955) # bounding box for Whycocomagh Basin
crs <- 4617                                                         # CRS of the data

# animal recording sites
sites <- sites_raw %>%
  st_transform(crs = crs) %>%
  st_crop(bbox)


# Read in searching zone data -------------------------------------------------

# zones recommended for searching 
zones_raw <- read_csv(paste0(path, "/data/zone_locations.csv"))

# convert to sf object and create polygon for each array for each year
zones <- zones_raw %>% 
  st_as_sf(coords = c("LONGITUDE", "LATITUDE"), crs = crs) %>%
  group_by(SITE) %>%
  summarise(geometry = st_combine(geometry)) %>%
  st_cast("POLYGON")

glimpse(zones)
class(zones)

# Put it all together: Map ---------------------------------------------------------------------

# some parameters we will use to map the make pretty
line.width <- 0.5
font.size <- 2.5
site.label.col <- "black"
map_ylabs = c(45.94, 45.945, 45.95, 45.955, 45.96)
map_xlabs = c(-61.14, -61.13, -61.12, -61.11)
animal.cols <- brewer.pal(4, "Set1")
col.zones <- "#9C179EFF" 

# remember that the order of the layers matters!
map_base <- ggplot() +
  geom_sf(data = dummy_points) +
  # basemap
  annotation_map_tile(type = "cartolight", zoomin = 0) +          
 
  # add animal sites
  geom_sf(data = sites, size = line.width, col = 1, fill = NA) +
  geom_sf_label(data = sites, 
                aes(label = site), 
                label.size = 0, fill = NA, col = site.label.col, size = font.size) +
  
  # add searching zones
  geom_sf(data = zones, size = 0.5, col = col.zones, fill = NA) +
  
  # make it pretty
  scale_x_continuous(name = NULL, breaks = map_xlabs) +
  scale_y_continuous(name = NULL, breaks = map_ylabs) + 
  annotation_scale(location = "br") +                             # scale bar
  annotation_north_arrow(location = "tl", which_north = "true")   # North arrow
  
# look what we created:
map_base  

# now let's add the animal found data
map_base +
  geom_sf(data = dat_sf)

# let's colour code the samples based on the type of animal that was found
map_base +
  geom_sf(data = dat_sf, aes(col = Animal_found)) +
  scale_color_manual(name = "Animal Found", values = animal.cols)

# some finishing touches:
map_base +
  geom_sf(data = dat_sf, 
          aes(fill = Animal_found, shape = Finder), size = 2) +
  scale_fill_manual(name = "Animal Found", values = animal.cols, drop = FALSE) +
  scale_shape_manual(name = "Finder", values = c(21, 24, 22), drop = TRUE) +
  guides(fill = guide_legend(override.aes = list(size = 4, shape = 21)),
         shape = guide_legend(override.aes = list(size = 4))) +
  theme_light() 

# Export map
ggsave(filename = "NS_shapefiles.png",
       device = "png",
       width = 20, height = 18, units = "cm",
       dpi = 600)

# -------------------------------------------------------------------------

#https://community.rstudio.com/t/how-to-project-crs-correctly/48595/3
