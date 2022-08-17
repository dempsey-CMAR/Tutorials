
#' Plot variables at depth with faceted ggplot
#'
#' @param dat.tidy Tidy data
#' @param superchill Logical
#' @param heatstress Threshold where heat stress begins
#' @param trending_up Logical
#' @return ggplot object
#' @import ggplot2
#' @import dplyr
#'
#' @export
#'


ggplot_variables_at_depth <- function(dat.tidy,
                                      superchill = FALSE,
                                      heatstress = NULL,
                                      trending_up = FALSE){

  dat.tidy <- dat.tidy %>%
    convert_depth_to_ordered_factor()

  color.pal <- get_colour_palette(dat.tidy)
  axis.breaks <- get_xaxis_breaks(dat.tidy)

  p <- ggplot(dat.tidy, aes(x = TIMESTAMP, y = VALUE, col = DEPTH)) +
    geom_point(size = 0.25) +
    scale_x_datetime(
      breaks = axis.breaks$date.breaks.major,
      minor_breaks = axis.breaks$date.breaks.minor,
      date_labels =  axis.breaks$date.labels.format
    ) +
    scale_colour_manual(name = "Depth",
                        values = color.pal,
                        drop = FALSE) +
    guides(color = guide_legend(override.aes = list(size = 4))) +
    theme_light()

  if("VARIABLE" %in% colnames(dat.tidy)){

    if(length(unique(dat.tidy$VARIABLE)) > 1) {

      p <- p + facet_wrap(~VARIABLE, ncol = 1, scales = "free_y")
    }
  }

  if(isTRUE(superchill)){
    p <- p + geom_hline(yintercept = -0.7, col = "deepskyblue", lty = 2)
  }

  if(isTRUE(trending_up)){
    p <- p + geom_hline(yintercept = 4, col = "grey", lty = 2)
  }

  p <- p + geom_hline(yintercept = heatstress, col = "red", lty = 2)

  p


}


