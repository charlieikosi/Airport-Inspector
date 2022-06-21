library(raster)

plot_raster <- function(raster_file, legend_title) {
  tm_shape(raster_file) + 
    tm_raster(n = 10, 
              style = "jenks",
              palette = "-RdYlBu", 
              midpoint = NA,
              alpha = 0.5, 
              title = legend_title)
}
