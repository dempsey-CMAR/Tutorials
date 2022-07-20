# March 4, 2021

# to install stings package from GitHub:
# library(devtools)
# install_github("Centre-for-Marine-Applied-Research/strings")

# Load required libraries
library(data.table) # to read csv file
library(dplyr)      # piping and data manipulation functions
library(ggplot2)    # plotting
library(here)       # relative file paths
library(strings)    # to manipulate strings data

# Use the fread function to read in the data
path <- paste0(here(), "/Tutorial 3_Plotting1")

string_data <- fread(paste0(path, "/data/Pirate Harbour_2019-06-21.csv")) 

#Take a glimpse at the imported data
head(string_data)
glimpse(string_data)

# convert depth to an ordered factor 
## (so colour scale will be discrete, not a gradient)
string_data <- string_data %>% 
  convert_depth_to_ordered_factor() 

glimpse(string_data)

string_data %>% distinct(VARIABLE)

# Plot --------------------------------------------------------------------

# aes() defines which data goes on the x and y axes 
# colour = DEPTH tells R to make data from each depth a different colour
# the plot will be saved to the object p -- look for it in your Environment!
p <- ggplot(string_data, aes(x = TIMESTAMP, y = VALUE, colour = DEPTH)) +  
  # to add points and define point size
  geom_point(size = 0.5) +                                             
  # to stack Temperature and Dissolved Oxygen
  facet_wrap(~VARIABLE, ncol = 1, scales = "free_y")                
  
# show plot
p
 

# let's make the plot prettier 

p_pretty <- p +    
  # adjust labels and ticks on x-axis
  scale_x_datetime(breaks = "2 month",  
                   date_labels = "%y-%b-%d",                            
                   date_minor_breaks = "1 month") +
  # use manual colour scale
  scale_colour_manual(name = "Depth",                                 
                        values = get_colour_palette(string_data)) +
  # add titles
  labs(title = "Pirate Harbour", x = "Timestamp", y = "Value") +     
  # resize the legend
  guides(col = guide_legend(override.aes = list(size = 4))) +         
  # change background theme
  theme_light()                                                      

# show pretty plot
p_pretty


# strings function --------------------------------------------------------

plot_variables_at_depth(string_data)

