ui <- dashboardPage(
  dashboardHeader(title = "Airport Inspector"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Airports", tabName = "Survey1", icon = icon("arrow-alt-circle-right")),
      menuItem("Statistics", tabName = "Survey2", icon = icon("chart-bar")),
      menuItem("Variability", tabName = "Survey3", icon = icon("map")),
      menuItem("Panorama", tabName = "Survey4", icon = icon("images")),
      menuItem("Tools", icon = icon("wrench"),
               menuSubItem("LPT",
                           tabName = "Survey5",
                           icon = icon("creative-commons-remix")),
               menuSubItem("PARIAM",
                           tabName = "Survey6",
                           icon = icon("creative-commons-remix")),
               menuSubItem("Feature Detection",
                           tabName = "Survey7",
                           icon = icon("creative-commons-remix"))))
    
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css") # This css adds a custom font change to the main header. note to use this, a "www" folder must be created in the working directory and a "custom.css file stored in there
    ),
    tabItems(
      
      # Survey Tab Elements - sub menu 1
      
      tabItem(tabName = "Survey1",
              
              box(infoBoxOutput("Elevation", width = 4),
                  infoBoxOutput("LLG", width = 4),
                  infoBoxOutput("District", width = 4), width = 8, height = 200),
              
              box("Any selection made here will show corresponding airstrips in that province", selectInput("survey_region", "Province",
                                                                                                            choices = "", multiple = F),
                  selectInput("survey_airstrip", "Airport", # The second selectInput is conditional and will depend on the first selectInput changes made by the user. Refer to the server side that controls this
                              choices = "", multiple = F), width = 4),
              
              box(leafletOutput("map1", height = 300), width = 12)
      ),
      
      # Statistics Tab Elements
      
      tabItem(tabName = "Survey2",
              box(plotlyOutput("myplot", height = 550), width = 12),
              box(h4("BOX PLOT INTERPRETATION"), width = 12, height = 150,
                  textOutput("boxplot_text")),
              box(h4("AIRSTRIP DISTRIBUTION"), width = 12, height = 150,
                  textOutput("boxplot_text2"))),
      
      # Variability Tab elements
      
      tabItem(tabName = "Survey3",
              box(tmapOutput("map2", height = 400), width = 12), width = 12, height = 650,
              tabsetPanel(type = "tabs", 
                          tabPanel("Plot",plotOutput("plot")))),
      
      # 360 Degree photos Tab elements
      
      tabItem(tabName = "Survey4",
              box(selectInput("imgs_fn", "Image", choices = imgs_fn, selected = NULL), width = 3),
              box(uiOutput("pano_iframe", height = 100),width = 8)),
      
      # Tool Tab elements
      # LPT
      
      tabItem(tabName = "Survey5",
              titlePanel("Location Predictor Tool (LPT)"),
              box(em("Prediction tool works by taking input coordinates in decimal
                  degree (dd) format along with elevation in feet (ft) to predict the most likely
                  province it represensts in Papua New Guinea. This prediction tool was developed
                  using a machine learning approach in which the Randon Forest algorthim was
                  used. The algorithm was trained on 475 data points of airstrip locations
                  spread around the country attaining a 90% precision in its prediction."), width = 100),
              box(textInput("latitude",label = h3("Latitude"), placeholder = "Enter Latitude.."),
                  textInput("longitude", label = h3("Longitude"), placeholder  = "Enter Longitude.."),
                  textInput("elevation", label = h3("Elevation"), placeholder = "Enter Elevation (ft)"),
                  actionButton("prediction", "Predict!")),
              box(title = "Prediction",textOutput("prediction_result")),
              box(title = "Population Density (pop/km2)",textOutput("population_density_figures")),
              box(leafletOutput("map3", height = 200))),

      # PARIAM
      
      tabItem(tabName = "Survey6",
              titlePanel("Predictive Aerodrome Reach and Impact Area Model (PARIAM)"),
              sidebarLayout(
                sidebarPanel(#fileInput("upload",
                                       #"Upload a shape file containing polygons",
                                       #multiple = TRUE,
                                       #accept = c('.shp','.dbf','.sbn','.sbx',
                                                  #'.shx','.prj', '.cpj', '.csv')),
                             #fileInput("upload2",
                                       #"Upload .csv file containing coordinates (DD foramt)",
                                       #multiple = TRUE,
                                       #accept = c(".csv")),
                             checkboxInput("checkbox1", "Show Airstrips",
                                           value = FALSE),
                             selectInput("province_input",
                                         "Select Region",
                                         choices = unique(prov_list), multiple = F),
                             actionButton("crop", "Plot")),
                mainPanel(
                  box(
                    em("The Predictive Aerodrome Reach and Impact Area Model (PARIAM) 
                        creates an interpolated surface from input gps location of airstrips. This surface
                        models reach of airstrips within a region where it assumes the proximity distance people prefer 
                        to travel."), width = 100),
                  box(withSpinner(tmapOutput("map4")), type = 5, width = 318),
                  box(textOutput("cover"))))),
      
      # FEATURE DETECTION
      
      tabItem(tabName = "Survey7",
              titlePanel("Feature Detection"),
              #box("Currently under development"),
             box(DT::dataTableOutput("table")))
    )
  )
)
