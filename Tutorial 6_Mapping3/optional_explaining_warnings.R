# An explanation of the warning messages in the mapping tutorials.

library(ggspatial)  
library(sf)        
library(ggplot2)   
library(dplyr)        
library(here)

# You may have noticed that running this code produced a warning message.
path <- paste0(here(), "/Tutorial 6_Mapping3") 
sites_raw <- read_sf(paste0(path, "/Sites/habitat.shp"))
bbox <- c(xmin = -61.14,  ymin = 45.942, xmax = -61.11,  ymax = 45.955) # bounding box for Whycocomagh Basin
crs <- 4617                                                             # CRS of the data
sites <- sites_raw %>%
  st_transform(crs = crs) %>% 
  st_crop(bbox)

# The warning is caused by R making an assumption about the attribute-geometry relationship
# (agr) when st_crop affects the geometry of sites_raw. Look at sites_raw to learn more.
print(sites_raw)

# The geometry column specifies the shape and location of a site, while the attributes 
# (in the other columns) are other types of information relating to that site.
# There are three types of attribute-geometry relationships: constant, aggregate, and identity.

# A constant relationship means that the value of the attribute is applicable to
# every subgeometry of the geometry; for example, if a geometry represented an 
# area covered by forest, it would be appropriate to say that any given portion of that
# geometry was forested.

# An aggregate relationship means that the value of an attribute would actually 
# vary across the geometry; for example, the average age in the HRM is 41, but
# that is not necessarily true for every possible geometrical subset of the HRM.

# An identity relationship associates a geometry with an identifier attribute,
# for example, giving each geometry a unique ID.

# Let's take a look at the attribute-geometry relationships of sites_raw.
st_agr(sites_raw)

# The NAs means the agr is unknown, so R has to make an assumption that all are 
# constant, and warns us about it. To get rid of the message, we could insert one line.

st_agr(sites_raw) <- "constant" 
st_agr(sites_raw)
# The agr might not be constant for every attribute, but in our case it doesn't matter.
sites <- sites_raw %>%
  st_transform(crs = crs) %>% 
  st_crop(bbox)

# This site has more information:
# https://r-spatial.github.io/sf/articles/sf1.html#how-attributes-relate-to-geometries

########

# The second warning you likely encountered was caused by adding labels to the plot.

ggplot() +
  annotation_map_tile(type = "cartolight", zoomin = 0) +          
  geom_sf(data = sites, size = 1, col = 1, fill = NA) +
  geom_sf_label(data = sites, 
                aes(label = site), 
                label.size = 0, fill = NA)

# The geom_sf_label function tries to "attach" the label to a point on the corresponding 
# geometry. When doing so, it assumes that that the geometry is two-dimensional,
# when it is actually a shape on a sphere. This results in a warning, but there
# is no reason to worry in our case, since the sites are so small the approximation
# makes essentially no difference.
  

