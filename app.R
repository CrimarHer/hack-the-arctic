library(shiny)
library(leaflet)
library(rgdal)
library(raster)
library(sp)
library(dplyr)
library(lubridate)
library(colorRamps)
library(RColorBrewer)

#load the data
wd <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/") 

#bears and seals
bears_seals <- read.csv(paste0("../../1_Data/Polar_Bear/polar_bear_seal.csv"))
bears_seals$year <- substring(bears_seals$Date,1,4)
bears_seals$month <- substring(bears_seals$Date,6,7)

bears <- bears_seals %>% filter(Species ==  "polar_bear")
seals <- bears_seals %>% filter(Species ==  "ringed_seal")
choices_bears <- as.character(unique(bears$ID))
choices_seals <-  as.character(unique(seals$ID))

#cod 
cod <- read.csv(paste0(wd, "../../1_Data/Arctic_Cod/stock-of-northeast-arctic-cod-in-the-barents-sea.csv"))
cod <- t(cod)
cod <- as.data.frame(cod)
cod <- cod[-c(1:3), ]
names(cod) <- c( "Series name",    "Recruits",       "Total stock" ,   "Spawning stock")

#Reading AOD tif files
#r <- raster(paste0(wd,"/1_Data/merra_aod/201509/AODANA.tif"))


#Clorophyll data 
#C_d <- read.csv( paste0(wd, "../../1_Data/nasa_clorophyll/clorophyll_data.csv"))


## coordinates(bears) <- ~Longitude + Latitude
## proj4string(bears) <- CRS("+init=epsg:4324") #specfiying current projection

#Load large mammal data
#large_mammals <- read.csv(paste0(wd, "../../1_Data/Polar_Bear/large_mammals.csv"))

#large_mammals$Date <- as.POSIXct(large_mammals$Date)
#large_mammals$Date <- year(large_mammals$Date)
#large_mammals <- rename(large_mammals, year = Date)
#large_mammals$Latitude <- as.numeric(large_mammals$Latitude)
#large_mammals$Longitude <- as.numeric(large_mammals$Longitude)

#large_mammals$Species <- as.character(large_mammals$Species)
#bears <- large_mammals %>% filter(Species ==  " ursus maritimus ")
#seals <- large_mammals %>% filter(Species == c(" erignathus barbatus ", 
#                                  " odobenus rosmarus ", " phoca groenlandica ", 
 #                                 " phoca vitulina ", " pusa hispida "))
#choices_seals <- as.character(unique(seals$Species))



ui <-  fluidPage(
  titlePanel("Connecting SvalbaRd!"),
  #dashboardPage( dashboardHeader(),dashboardSidebar(), dashboardBody(),title = "Pollution Removal by Vegetation"

  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "year",
        label = "Choose a year",
        choices = c( "2002", "2003", "2004","2012", "2013", "2011", "2010"),
        selected = 2002
        ),
      selectInput(
        inputId = "month",
        label = "Choose a month",
        #choices = c("01", "02", "03", "04", "05", "06", "07", "08", "09", 10:12),
        choices = c(1:12)
        #selected = "March"
      ),

      radioButtons(
        inputId = "species",
        label = "select your species: ",
        choices = c("Ringed Seal", "Polar bear")#,
        
           )
      #  selectInput(
      #    inputId = "idsbear",
      #    label = "Filter by bear ID: " , 
      #   choices = choices_bears, 
      #    selected = "3,717,523,944"
      #  ),
      #  selectInput(
      #   inputId = "idsSeals",
      #    label = "Filter by seal ID: " , 
      #    choices = choices_seals, 
      #    selected = ""
      # 
      # )

    ),
    mainPanel(
      leafletOutput("map"), 
      p(), 
      p(), 
      img(src='cod_2.png',  height="10%", width="10%"),
      h2("cod numbers:"),
      
      textOutput(outputId = "cod_Numbers"),
      
      tableOutput("table")
      
    
    )
  
  )
) 


server <- function(input,output, session) {
  
  output$map <- renderLeaflet ({
    
    leaflet(options = leafletOptions(maxZoom = 12)) %>% 
      
      addTiles(group="OpenStreetMap.Mapnik", options = providerTileOptions(zIndex=0)) %>%
      addProviderTiles("Esri.WorldImagery", group="Esri.WorldImagery",options = providerTileOptions(zIndex=0, noWrap = TRUE)) %>%
      hideGroup("Esri.WorldImagery") %>%
      #addCircleMarkers( fillOpacity = 0.5, radius = 9, fillColor = "blue",stroke = T,  data = bears, lng=bears$Longitude, lat=bears$Latitude) %>%
      #addCircleMarkers( fillOpacity = 0.5, radius = 9, fillColor = "grey",stroke = F,  data = seals, lng=seals$Longitude, lat=seals$Latitude) %>%
      setView( lng =16.787109,lat = 78.903929 , zoom=4)
  })
  
  
  observeEvent( c(input$species,
                  input$year),{
    bears2 <- bears %>%  filter(year == input$year)
    seals2 <- seals %>%  filter(year == input$year)
    # r <- C_d %>% filter(year == input$year) %>% filter(month == input$month) %>% select(x, y, total.chlorophyll)
    # #r <- as.numeric(r)
    # #coordinates(r) <- ~x + y
    # #spTransform(r, CRS("+init=epsg:4324")) #<- CRS("+init=epsg:4324")
    # r <- rasterFromXYZ(r, digits = 3)
    # 
    # crs(r) <- CRS("+init=epsg:4326")
    # 
    # r <- flip(r, 2)
    # r <- t(r) #transpose
    # r <- flip(r, 2)
    
  
   # col<- colorNumeric(blue2red(30),na.color = "transparent", values(r), reverse=TRUE)
    #, d
    #specfiying current projection
    if (input$species == "Ringed Seal"){
      leafletProxy("map", session) %>% clearMarkers() %>%
        addMarkers( data = seals2, lng=seals2$Longitude, lat=seals2$Latitude)#%>%
        #addRasterImage(r, col= col, group = "Raster_Image")
      #fillOpacity = 0.5, radius = 9,
      } else{# if (input$species == "Polar bear"){
      leafletProxy("map", session) %>% clearMarkers() %>%
        addCircleMarkers( fillOpacity = 0.5, radius = 9, fillColor = "blue",stroke = T,  data = bears2, lng=bears2$Longitude, lat=bears2$Latitude) #%>%
        #addRasterImage(r, col= col, group = "Raster_Image")
    } #else {#if ((input$species == "Polar bear") & (input$species == "Ringed Seal")){
      # leafletProxy("map", session) %>%  clearMarkers() %>%
      #   addCircleMarkers( fillOpacity = 0.5, radius = 9, fillColor = "grey",stroke = F,  data = seals, lng=seals$Longitude, lat=seals$Latitude) %>%
      #   addCircleMarkers( fillOpacity = 0.5, radius = 9, fillColor = "blue",stroke = T,  data = bears, lng=bears$Longitude, lat=bears$Latitude)

    #}
  })
  
  observeEvent(input$year,{
   # output$cod_Numbers <- renderText({ cod[ cod$`Series name` == input$year, c("Total stock")] })
    output$table <- renderTable({cod[cod$`Series name` == input$year,]})
    
    
   
    
  })
  
  
  
}

shinyApp(ui = ui, server=server)