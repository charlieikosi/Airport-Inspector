library(tidyverse)
library(rvest)
library(xml2)

pop_density <- function(province) {
  url <- "https://en.wikipedia.org/wiki/Provinces_of_Papua_New_Guinea"
  table <- read_html(url) %>%
  html_nodes(xpath='//*[@id="mw-content-text"]/div[1]/table[3]') %>%
  html_table()
  df <- as_tibble(table[[1]]) %>%
    dplyr::select(3,8)
  df$Province[13] <- "Northern (Oro)"
  df$Province[19] <- "West Sepik (Sandaun)"
  prov <- c(df$Province)
  ind <- 1
  for (old_name in df$Province)
  {df$Province[ind] <- paste(old_name, "Province", sep = " ")
  ind <- ind+1}
  df$Province[14] <- "Autonomous Region of Bougainville"
  df$Province[20] <- "National Capital District"
  prov_list <- c(df$Province)
  dens_list <- c(df$`Density(pop/km2)`)
  counter <- 1
  for (i in prov_list)
  {if(i == province)
  {result <- dens_list[counter] %>% as.character()
   return(result)}
    else
    {counter <- counter+1}}}


# Example
#pop_density("Central Province")

