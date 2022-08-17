# In this tutorial, we use the rnaturalearth package to make a basemap for mapping the world's eelgrasses.
# (The data is from the IUCN Red List.)

library(dplyr)
library(ggplot2)
library(ggspatial)
library(here)           # package to assist in finding files
library(sf)             # package for GIS in R, loading shapefiles, projections, etc
library(rnaturalearth)  # package for basemaps

# Map params --------------------------------------------------------------
# https://www.mango-solutions.com/50-shades-of-grey-according-to-r/
land_colour <- "grey40"
water_colour <- "grey97"
lat_long_colour <- "grey80"

# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf?utm_source=twitterfeed&utm_medium=twitter
# grass_colour <-"forestgreen"
grass_colour <-"green3"


# Eelgrass data -----------------------------------------------------------

path <- paste0(here(), "/Tutorial 7_Office Hours")

eelgrass <- read_sf(paste0(path, "/data/SEAGRASSES.shp"))

class(eelgrass)

# World map ---------------------------------------------------------------

world <- ne_countries(returnclass = "sf")

ggplot() +
  geom_sf(data = world, fill = land_colour, col = land_colour) 

# Fancy World Map ---------------------------------------------------------

crs_robinson <- "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"

world_robinson <- world %>% st_transform(crs = crs_robinson)

ggplot() +
  geom_sf(data = world_robinson, fill = land_colour, col = land_colour) 

# Pretty & Fancy World Map ---------------------------------------------------------
ggplot() +
  geom_sf(data = world_robinson, fill = land_colour, col = land_colour) +
  theme(
    panel.background = element_rect(fill = water_colour),
    panel.grid = element_line(
      colour = lat_long_colour, 
      linetype = "dashed", size = 0.25
    )
  ) 

# Add eelgrass data -------------------------------------------------------

eelgrass_robinson <- eelgrass %>% st_transform(crs = crs_robinson)

p1 <- ggplot() +
  geom_sf(data = eelgrass_robinson, fill = grass_colour, col = NA) +
  geom_sf(data = world_robinson, fill = land_colour, col = land_colour) +
  theme(
    panel.background = element_rect(fill = water_colour),
    panel.grid = element_line(
      colour = lat_long_colour, 
      linetype = "dashed", size = 0.25)
  ) 

# Export map
ggsave(
  filename = paste0(path, "/maps/World_eelgrass.png"),
  plot = p1,
  device = "png",
  dpi = 600)


# Zostera -----------------------------------------------------------------

zostera <- eelgrass_robinson %>% filter(genus == "Zostera")

p2 <- ggplot() +
  geom_sf(data = zostera, fill = grass_colour, col = NA) +
  geom_sf(data = world_robinson, fill = land_colour, col = land_colour) +
  theme(
    panel.background = element_rect(fill = water_colour),
    panel.grid = element_line(
      colour = lat_long_colour, 
      linetype = "dashed", size = 0.25)
  ) 

# Export map
ggsave(
  filename = paste0(path, "/maps/World_eelgrass_zostera.png"),
  plot = p2,
  device = "png",
  dpi = 600)



# JFF ---------------------------------------------------------------------

p3 <- ggplot() +
  geom_sf(data = eelgrass_robinson, col = NA,
          aes(fill = genus)) +
  geom_sf(data = world_robinson, fill = land_colour, col = land_colour) +
  theme(
    panel.background = element_rect(fill = water_colour),
    panel.grid = element_line(
      colour = lat_long_colour, 
      linetype = "dashed", size = 0.25)
  ) 

# Export map
ggsave(
  filename = paste0(path, "/maps/World_eelgrass_species.png"),
  plot = p3,
  device = "png",
  dpi = 600
)

# Now go into the maps folder to view your creations!
