library(raster)
library(tmap)
library(sf)
#source("Raster_Tmap.R")

region_clip <- function(raster_file, polygon_file, region) {
  region_poly <- polygon_file %>%
    dplyr::filter(ADM1_EN == region )
  clip_extent <- raster::extent(region_poly)
  extent_raster <- raster::crop(x = raster_file, y = clip_extent)
  Reach <- raster::mask(x = extent_raster, mask = region_poly)
  #tm_basemap(leaflet::providers$Esri.WorldImagery) + 
    tm_shape(Reach) + tm_raster(n = 10, 
                                    style = "fisher",
                                    palette = "-RdYlBu", 
                                    midpoint = NA,
                                    alpha = 0.5, 
                                    title = "Airstrip Reach")
}

# Example
#region_clip(kdeprob,pngmap,"Western Province")

  

