# Plot variables at depth with faceted ggplot

# arguments:
## string_dat - dataframe with columns TIMESTAMP (POSIXct), VALUE (numeric),
## VARIABLE (character), DEPTH (ordered factor)
## Other columns will be ignored

# output
## ggplot faceted by VARIABLE, coloured by DEPTH 
## (viridis colour scale, theme_light)

plot_strings_data <- function(string_data, plot_title = NULL){
  
  string_data <- string_data %>% 
    convert_depth_to_ordered_factor()
  
  color.pal <- get_colour_palette(string_data)
  axis.breaks <- get_xaxis_breaks(string_data)
  
  ggplot(string_data, aes(x = TIMESTAMP, y = VALUE, col = DEPTH)) +
    geom_point(size = 0.25) +
    scale_x_datetime(
      breaks = axis.breaks$date.breaks.major,
      minor_breaks = axis.breaks$date.breaks.minor,
      date_labels =  axis.breaks$date.labels.format
    ) +
    facet_wrap(~VARIABLE, scale = "free_y", ncol = 1) +
    scale_colour_manual(name = "Depth",
                        values = color.pal,
                        drop = FALSE) +
    guides(color = guide_legend(override.aes = list(size = 4))) +
    theme_light() +
    ggtitle(plot_title)
  
}




















# plot_strings_data <- function(dat){
#   
#   dat <- dat %>% 
#     convert_depth_to_ordered_factor()
#   
#   color.pal <- get_colour_palette(dat)
#   axis.breaks <- get_xaxis_breaks(dat)
#   
#   ggplot(dat, aes(x = TIMESTAMP, y = VALUE, col = DEPTH)) +
#     geom_point(size = 0.25) +
#     scale_x_datetime(
#       breaks = axis.breaks$date.breaks.major,
#       minor_breaks = axis.breaks$date.breaks.minor,
#       date_labels =  axis.breaks$date.labels.format
#     ) +
#     facet_wrap(~VARIABLE, scale = "free_y", ncol = 1) +
#     scale_colour_manual(name = "Depth",
#                         values = color.pal,
#                         drop = FALSE) +
#     guides(color = guide_legend(override.aes = list(size = 4))) +
#     theme_light()
#   
#   
# }



