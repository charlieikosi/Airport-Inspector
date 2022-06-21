library(tidyverse)
library(dplyr)
library(MASS) 

filter_function <- function(df, value_to_filter){
  filter_df <- df %>% dplyr::select(2,4,5,13) %>%
    filter(Prov_name == value_to_filter)
  return(filter_df)
}

# Example
#filter_function(airstrip,"Western Province")

density_coverage <- function(df, x_min, x_max, y_min, y_max){
  dens_raster <- raster(kde2d(df$longitude_,df$latitude_d,n=500,h=.4,
                              lims = c(x_min,x_max,y_min,y_max)))
   #plot(dens_raster)
}

# Example
#df1 <- filter_function(airstrip,"Western Province")
#density_coverage(df1)


density_outer95_boundary <- function(density_raster) {
  prob <- 0.95
  density_raster[density_raster == 0]<-NA
  # create a vector of raster values
  kde_values <- raster::getValues(density_raster)
  # sort values 
  sortedValues <- sort(kde_values[!is.na(kde_values)],decreasing = TRUE)
  # find cumulative sum up to ith location
  sums <- cumsum(as.numeric(sortedValues))
  # binary response is value in the probabily zone or not
  p <- sum(sums <= prob * sums[length(sums)])
  # Set values in raster to 1 or 0
  kdeprob <- raster::setValues(density_raster, kde_values >= sortedValues[p])
  # return new kde
  return(kdeprob) 
}

# Example
#df <- filter_function(airstrip,"Milne Bay Province")
#r <- density_coverage(df)
#r2 <- density_outer95_boundary(r)
#plot(r2)
