# September 7, 2022

# Code to read in csv file of exported netCDF data and plot on a map of NS

# set up ------------------------------------------------------------------

library(cmocean)            # ocean colour palettes
library(data.table)         # read in the csv file
library(dplyr)              # data manipulation (here mainly the %>% operator)
library(ggplot2)            # plots
library(leaflet)            # interactive maps
library(rnaturalearth)      # basemap for static map
library(sf)                 # spatial data functions

# get base map of North America from rnaturalearth
can <- ne_countries(
  continent = "north america", returnclass = "sf", scale = "large"
)

# read in chl data and convert to spatial df
path <- here("Tutorial 15_NetCDF")

chl <- fread(paste0(path, "/output/chl_data.csv"))

# spatial dataframe (note the geometry column)
chl_sp <- chl %>% 
  st_as_sf(coords = c("lon", "lat"), crs = st_crs(can)) 

# static map --------------------------------------------------------------

# map extents (box around Nova Scotia)
x_min <- -66.5
x_max <- -59.8
y_min <- 43.5
y_max <- 47

# static map
ggplot() +
  # basemap of North America
  geom_sf(data = can, size = 0.5, fill = "grey") + 
  # add chlorphyll data
  geom_sf(data = chl_sp, aes(col = chl)) +
  # zoom in to NS
  scale_x_continuous(limits =  c(x_min, x_max), breaks = c(seq(-60, -66, -2))) +
  scale_y_continuous(limits = c(y_min, y_max), breaks = c(seq(43, 47, 1))) +
  # add custom colour scale
  scale_color_cmocean(name = "algae") +
  # make bakground white
  theme_light()


# interactive map ---------------------------------------------------------

# set up colour palette
pal <- colorNumeric(palette = "Greens", domain = chl$chl)

# leaflet map
leaflet(data = chl) %>%
  # basemap
  addProviderTiles(providers$CartoDB.Positron) %>%  
  # map extent will automatically zoom to the data points
  addCircleMarkers(
    ~lon, ~lat, 
    color = ~pal(chl),
    fillOpacity = 1, 
    stroke = FALSE
  )  %>% 
  addLegend(
    "bottomright", pal = pal, values = ~chl,
    title = "Chl (mg / m^3)",
    opacity = 1
  )



