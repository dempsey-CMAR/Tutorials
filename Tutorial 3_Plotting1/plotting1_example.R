# March 4, 2021

# Load required libraries
library(data.table) # to read csv file
library(dplyr)      # piping and data manipulation functions
library(ggplot2)    # plotting
library(here)       # relative file paths
library(strings)    # to manipulate strings data

# Use the fread function to read in the data
string_data <- fread(here("data", "Pirate Harbour_2019-06-21_TEMP_DO_trimmed.csv"), header = TRUE) 

#Take a glimpse at the imported data
head(string_data)
glimpse(string_data)

# convert depth to an ordered factor (so colour scale will be discrete, not a gradient)
# & extract every 10th observation so easier to work with
string_data <- string_data %>% 
  convert_depth_to_ordered_factor() %>% 
  filter(row_number() %% 10 == 0)

glimpse(string_data)

string_data %>% distinct(VARIABLE)

# Plot --------------------------------------------------------------------

# aes() defines which data goes on the x and y axes 
# colour = DEPTH tells R to make data from each depth a different colour
p <- ggplot(string_data, aes(x = TIMESTAMP, y = VALUE, colour = DEPTH)) +  
  
  geom_point(size = 0.5) +                                             # to add points and define point size
  
  facet_wrap(~VARIABLE, ncol = 1, scales = "free_y")                  # to stack Temperature and Dissolved Oxygen
  
# show plot
p
 

# make plot prettier 
p_pretty <- p +    
  
  scale_x_datetime(breaks = "2 month",  
                   date_labels = "%y-%b",                             # adjust labels and ticks on x-axis
                   date_minor_breaks = "1 month") +
  
  scale_colour_manual(name = "Depth",                                 # manual colour scale
                        values = get_colour_palette(string_data)) +
  
  labs(title = "Pirate Harbour", x = "Timestamp", y = "Value") +      # titles
  
  guides(col = guide_legend(override.aes = list(size = 4))) +          # to resize the legend
  
  theme_light()                                                        # change background theme

# show pretty plot
p_pretty



# strings function --------------------------------------------------------

plot_variables_at_depth(string_data,
                        vars.to.plot = c("Dissolved Oxygen", "Temperature"))

