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
library(RColorBrewer) # colour palette
library(readr)      # to read in data

# Import and explore data -------------------------------------------------

path <- paste0(here(), "/Tutorial 05_Mapping1_leaflet")  # automatically sets the path 

source(paste0(path, "/functions/add_map_layers.R"))


# read in the data (if this doesn't work, trying pasting in the path manually)
dat <- read_csv(paste0(path, "/data/data_file.csv")) %>% 
  filter(row_number() %% 10 == 0)

# select columns of interest & keep 1 row for each station
dat <- dat %>% 
  select(location, attendant, latitude, longitude, animal) %>%  # selects columns of interest
  mutate(label = paste(location, attendant,  sep = "</br>")) 
  
  
class(dat)    # check the class of dat
glimpse(dat)  # take a look at dat  


# Basic Map ---------------------------------------------------------------------

leaflet(dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%  # basemap
  addCircleMarkers(~longitude, ~latitude, 
                   popup = ~label,
                   weight = 1,
                   fillOpacity = 0.75,
                   radius = 5, stroke = FALSE)     # observation locations


# add a layer for each animal -------------------------------------------------------

unique(dat$animal)

animal_pal <- colorFactor(
  palette = brewer.pal(length(unique(dat$animal)), "Set2"),
  domain = unique(dat$animal)
)

# the long way:
leaflet(dat) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%  # basemap
  addCircleMarkers(
    data = filter(dat, animal == "Kraken"),
    ~longitude, ~latitude, 
    fillColor = ~animal_pal(animal),
    group = "Kraken",
    popup = ~label,
    weight = 1,
    fillOpacity = 0.75,
    radius = 5, stroke = FALSE
  ) %>% 
  addCircleMarkers(
    data = filter(dat, animal == "Hydra"),
    ~longitude, ~latitude, 
    fillColor = ~animal_pal(animal),
    group = "Hydra",
    popup = ~label,
    weight = 1,
    fillOpacity = 0.75,
    radius = 5, stroke = FALSE
  ) %>% 
  addCircleMarkers(
    data = filter(dat, animal == "Siren"),
    ~longitude, ~latitude, 
    fillColor = ~animal_pal(animal),
    group = "Siren",
    popup = ~label,
    weight = 1,
    fillOpacity = 0.75,
    radius = 5, stroke = FALSE
  ) %>% 
  addCircleMarkers(
    data = filter(dat, animal == "Mermaid"),
    ~longitude, ~latitude, 
    fillColor = ~animal_pal(animal),
    group = "Mermaid",
    popup = ~label,
    weight = 1,
    fillOpacity = 0.75,
    radius = 5, stroke = FALSE
  ) %>% 
  addLegend(
    "topright", pal = animal_pal, 
    values = unique(dat$animal),
    title = "Animal",
    opacity = 0.75
  ) %>% 
  addLayersControl(
   # baseGroups = "Animal",
    overlayGroups = unique(dat$animal),
    options = layersControlOptions(collapsed = FALSE),
    position = "bottomright"
  ) %>% 
  addScaleBar(
    position = "bottomleft", 
    options = scaleBarOptions(imperial = FALSE)
  )


# shorter way:
dat_map <- split(dat, dat$animal)

add_map_layers(
  dat_map, 
  ~animal_pal(animal),
  popup = ~label,
  size = 5
)  %>%
  addLegend(
    "topright", pal = animal_pal, 
    values = unique(dat$animal),
    title = "Animal",
    opacity = 0.75
  ) %>% 
  addLayersControl(
    baseGroups = "Animal",
    overlayGroups = unique(dat$animal),
    options = layersControlOptions(collapsed = FALSE),
    position = "bottomright"
  ) %>% 
  addScaleBar(
    position = "bottomleft", 
    options = scaleBarOptions(imperial = FALSE)
  )







