#setwd("F:/Projects/Airport Inspector")

library(shiny)
library(shinydashboard)
library(leaflet)
library(tidyverse)
library(sf)
library(htmltools)
library(dplyr)
library(tidyr)
library(rsconnect)
library(ggplot2)
library(plotly)
library(tmap)
library(caret)
library(rgdal)
library(raster)
library(shinycssloaders)
library(vroom)
source("Population_Density.R")
source("Province_Clip_Function.R")
source("Filter_Density_Function.R")
#source("ML_Province_Prediction_Model.R")
#install.packages("shinycssloaders")

# Data for png map
pngmap <- st_read("arcgis/png_adm_nso_20190508_shp/png_admbnda_adm1_nso_20190508.shp")
var <- tm_shape(pngmap)+ tm_fill("IQR",id="ADM1_EN", alpha = 0.5) + tm_view(set.view = c(145.920000,-6.500000,5.5)) + tm_polygons(alpha = 0.1)

# Below is the required data for the map:
airstrip <- read_csv("data/airports_geocoded.csv")# this is the data from which the airstrip information is obtained
airstrip_sf <- st_as_sf(airstrip, coords = c("longitude_", "latitude_d"), crs = 4326) # Geocoded the airstrip object using st_as_sf()

airstrip2 <- vroom("data/airports_geocoded.csv")

# data required for static info box.
airstrip_count <- count(airstrip, "name") # counted the number of airstrips in the column titled "name".
total_count <- airstrip_count %>% dplyr::select(n) %>% filter(n == airstrip_count$n) # Then filtered to only display the value of the count

# data required for dynamic info box
survey_strip <- read_csv("data/airports_survey_report.csv") %>% st_as_sf(coords = c("longitude_", "latitude_d"), crs = 4326)

# data required for boxplots
p1 <- ggplot(airstrip_sf, aes(x=Prov_name, y=elevation_)) + 
  geom_boxplot(fill = "red")
p2 <- p1 + theme(plot.title = element_text(size = 20, face="bold", margin = margin(10,0,10,0), hjust = 0.5),
                 axis.text.x = element_text(angle = 75, hjust = 1)) + 
  labs(y="Elevation (feet)", x = "Province") + 
  ggtitle("Boxplot of Airstrips vs Elevation")

# Data required for 360 degree photos in the selector input
imgs_fn <- list.files("www", pattern = "JPG$|JPEG$", ignore.case = TRUE)

# Load trained model for location prediction
#load("fit.rf.rda")
provinceModel <- readRDS("provinceModel.rds")

# Province list
prov_list <- c(pngmap$ADM1_EN)

# Elevation raster in ft
#dem <- raster("data/PNG_dem_feet.tif")
#save(dem, file = "dem1.rda")
load("dem1.rda")

# Elevation in meters
#dem_meters1 <- brick("data/PNG_dem_meters.tif")
#save(dem_meters, file ="dem2_meters.rda")
load("dem2_meters.rda")



