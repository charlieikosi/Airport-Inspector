server <-function(input, output, session) {
  
   # Database Tab
  output$table <- DT::renderDataTable({
    db_table
  })
  
  
  # Survey tab leaflet map - 1
 
  observe({
    updateSelectInput(session, # this code handles the first selectInput and it is the parent of the second selectInput. Here we define the choices
                      "survey_region",
                      choices = unique(survey_strip$Prov_name))
  })

  observe({
    updateSelectInput( # The dependent selectInput is defined here. The choice is filtered down to select the airstrip name when inputs are made in the parent selectInput. The choices displayed will show airstrips in the province chosen in the parent selectInput
      session,
      "survey_airstrip",
      choices = survey_strip %>%
        filter(Prov_name == input$survey_region) %>%
        dplyr::select(name) %>%
        .[[1]]
    )
  })
  
  # Rendering the leaflet map for the survey tab. Here instructions are made using "if" and "return". What it means is that it is saying render a leaflet mapp if inputs are made
  # in the dependent selectInput and return a map which is defined further
  output$map1 <- renderLeaflet({
    if (input$survey_airstrip == "") {
      return()
    }
    
    
    # Using data from the survey strip the instructions above will use this to create the map. The code here uses the survey_strip data and filters it to names from inputs from the dependent
    # selectInput.The proceeding codes adds widgets to the leaflet map.
    survey_strip %>%
      filter(name == input$survey_airstrip) %>%
      leaflet() %>%
      addProviderTiles("Esri.WorldImagery", group = "Esri.WorldImagery") %>%
      addMeasure(position = "topleft", primaryLengthUnit = "meters") %>% 
      addMarkers(
        label = ~ name) 

  })
  
  # survey tab info box - 1
  # infobox Code for the Elevation  
  
  # note we subset the dataframe survey_strip using the [] then we pipe it to select the specific column. All this is wrapped in the dplyr function first() which displays the first value in the dataframe
  
  output$Elevation <- renderInfoBox({
    
    infoBox(input$survey_airstrip, title = "Elevation",
            value = h5(paste(first(survey_strip[survey_strip$name == input$survey_airstrip,] %>% dplyr::select(elevation_)))),
            fill = T, color = "green", icon = icon("mountain"), subtitle = "feet")
  })
  
  # infobox Code for llg
  output$LLG <- renderInfoBox({
    
    infoBox(input$survey_airstrip, title = "LLG",
            value = h5(paste(first(survey_strip[survey_strip$name == input$survey_airstrip,] %>% dplyr::select(LLG_Name)))),
            fill = T, color = "blue", icon = icon("flag"), subtitle = "")
  })
  
  # infobx Code for the district
  output$District <- renderInfoBox({
    
    infoBox(input$survey_airstrip, title = "District",
            value = h5(paste(first(survey_strip[survey_strip$name == input$survey_airstrip,] %>% dplyr::select(District_Name)))),
            fill = T, color = "yellow", icon = icon("flag"), subtitle = "")
  })
  
  # Statistics plot
  
  output$myplot <- renderPlotly(p2) # p2 is obtained from the global environment above
  output$boxplot_text <- renderText("Boxplots are a great way to display the spread or variability of data and is constructed using the 5 number summary in statistics which are the minimum, 
                                    first quartile (Q1), median, third quartile (Q3), and maximum. To understand what the boxplot is showing, it is important to understand what each part of the
                                    plot represents under the 5 number summary. The box represents where 50% of the data is clustered and are bounded between the lower 25th percentile (first quartile Q1) and the upper 75th
                                    percentile (third quartile Q3). The horizontal line that cuts this box is the median of the data. The verticle lines extending from the box represent the maximum and minimum values 
                                    that are greater than or less than Q1 and Q3. The dots outside of these lines represent data that are outliers. These outliers are data that are extreme and rare or are unique than the
                                    rest of the datasets.
                                     ") # this is the interpretation text for the boxplot. It is manually typed out through visual inspection
  
  
  output$boxplot_text2 <- renderText("There is very high variability in the distribution of airstrips in Papua New Guinea and is due to the rugged topography of the country.")
  
  
  # Variability map
  
  output$map2 <- renderTmap({var
  })
  
  # 360 degree window
  
  output$pano_iframe <- renderUI({
    
    ## Construct the iframe URL
    src_url <- paste0("pannellum.htm#panorama=",
                      input$imgs_fn,
                      "&autoLoad=true&autoRotate=-2")
    
    tags$iframe(src = URLencode(src_url), width = "690px", height = "300px")
  })
  
  # Tool Tab window
  # LPT
  
  reactive_button_1a <- eventReactive(input$prediction, {
    predictionVar <- tibble(Latitude = as.numeric(input$latitude),
                            Longitude = as.numeric(input$longitude),
                            Elevation = as.numeric(input$elevation))
    result <- predict(provinceModel, predictionVar) %>% as.character()
  })
  
  output$prediction_result <- renderText({
    reactive_button_1a()
  })
  
  reactive_button_1b <- eventReactive(input$prediction, {
    predictionVar2 <- tibble(Latitude = as.numeric(input$latitude),
                             Longitude = as.numeric(input$longitude))
  })
  
  output$map3 <- renderLeaflet({
    leaflet(reactive_button_1b()) %>%
      addTiles() %>%
      addMarkers(lng = ~Longitude, 
                 lat = ~Latitude) %>%
      setView(input$longitude, input$latitude, zoom = 6)
  })
  
  output$population_density_figures <- renderText({
   result <- reactive_button_1a() %>%
     pop_density()
  })
  
  # PARIAM
  # File upload
   map <- reactive({
    #req(input$filemap)
    
    shpdf <- input$upload
    
    tempdirname <- dirname(shpdf$datapath[1])
    
    for (i in 1:nrow(shpdf)) {
      file.rename(
        shpdf$datapath[i],
        paste0(tempdirname, "/", shpdf$name[i])
      )
    }
    
    map <- readOGR(paste(tempdirname,
                         shpdf$name[grep(pattern = "*.shp$", shpdf$name)],
                         sep = "/")) %>% st_as_sf()
    map
  })

  # selectinput
  
  reactive_button_2a <- eventReactive(input$crop, {
    xtent <- extent(pngmap %>% filter(ADM1_EN == input$province_input))
    x_min <- xtent@xmin
    x_max <- xtent@xmax
    y_min <- xtent@ymin
    y_max <- xtent@ymax
    df <- filter_function(airstrip,input$province_input)
    r <- density_coverage(df,x_min,x_max, y_min, y_max)
    r2 <- density_outer95_boundary(r)
    clips <- region_clip(r2,pngmap, input$province_input)
  })
  # Checkbox - checkbox 1
  
  reactive_button_2b <- eventReactive(input$crop, {
    Airports <- airstrip %>% filter(Prov_name == input$province_input) %>%
      dplyr::select(2, 4, 5, 13) %>% st_as_sf(coords = c("longitude_", "latitude_d"), crs = 4326)
    df_dots <- tm_shape(Airports) + tm_dots(legend.show = FALSE)
    if(input$checkbox1 == TRUE)
    {return(df_dots)}
  })
  
  # Map Output
  
  output$map4 <- renderTmap({
    reactive_button_2a() + reactive_button_2b() + tm_mouse_coordinates()
  })

 
  
}

