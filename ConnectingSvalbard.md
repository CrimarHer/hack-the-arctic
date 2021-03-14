
---
title: "Connecting Svalbard"
author: "R-ctic Explorers   2021-03-13"
output:
  github_document:
    toc: true
    toc_depth: 3
    toc_float:
      collapsed: false
    theme: united
    highlight: tango
    code_folding: show
---

```{r code_section_global_options, include=FALSE}

proj_dir <- "/Hack_The_Arctic/"

knitr::opts_chunk$set(echo=TRUE, eval=FALSE, warning=FALSE, message=FALSE)

```

![]`r paste0("(",proj_dir,"svalbard.jpg",")")`

<style type="text/css">
.col-md-12>.pull-right{float:none !important;}
h2{margin-top:50px;}
h3{margin-top:42px;}
h4{margin-top:35px;}
h4.author{margin-top:11px;}
p{margin-top:14px; margin-bottom:18px;}
.toggle {height: 1.9em; overflow-y: hidden; overflow-x: hidden;}
.toggle.open {height: auto;}
</style>
<br>
<br>
This document shows our project outputs from the [Hack The Arctic](https://hackthearctic.com/) hack-a-thon for the _Focus on Svalbard_ challenge. R code is shown by default, but can be shown / hidden using the buttons above code snippets or at the top-right of the page.<br><br>

### Team Members: R-ctic Explorers

* Juan Pablo Lobo-Guerrero Villegas – (Tropical) Ecology
* Cristina Martin Hernandez - Data Scientist
* Beth Raine – (Tropical) Ecology
* Janice Scheffler – Meteorology & Climate Scientist
* Philip Taylor - Data Scientist


### The Challenge

The Arctic is warming. But how much and how quickly? Can you help us to determine trends of changes in environmental parameters measured on this beautiful island in the Arctic ocean?


### Our Mentors

We had a ~15 minute discussion with the following four scientists, each helping steer and hone our idea into something useful and interesting for research in Svalbard:

* Anna Franck
* Lisa Beck
* Janne-Markus Rintala
* Dariusz Ignatiuk


### Initial Proposal

Arctic research produces a plethora of data from many different institutes, but joining it up can often be a difficult process meaning interactions and patterns in the data can get lost. We'll document a workflow of connecting oceanic, meteorological and biological data to produce an interactive map helping to show data trends over time, focusing on Svalbard and its environment. The resulting output will help everyone better understand the data that's being collected, as well as guiding people on how to easily connect data up for themselves.

### Scientific Context: Arctic Food Chain

Mean temperature increase in the Arctic as a result of climate change is having cascading effects on local food chains. The consequences of this are perhaps most clearly seen in changing polar bear feeding patterns, which often result in intrusions into local urban areas and close encounters with people. We gathered data from various sources to understand and visualise how changing meteorological patterns affect phytoplankton at the base of the Arctic food chain, resulting in detrimental effects on polar bears. We opted for a bottom-up approach to understand and highlight the pervasive effects that climate change has on Arctic food chains as a whole.

Phytoplankton blooms occur on a seasonal cycle. When ice melts in the Northern spring, cold water sinks to the bottom, forcing nutrient rich water to the surface, thus providing ideal conditions for phytoplankton blooms. As sea ice melt onset occurs earlier in the year, krill and other aquatic invertebrates that feed on phytoplankton blooms have increasingly limited access to their food source. Krill populations are further diminished in the absence of ice because juveniles lack the protection offered by ice sheets. Crustaceans and fish species such as Arctic cod, Saffron cod, also spawn under sea ice, so reducing sea fields reduces their population, thus reducing the availability of prey to Ringed and Bearded seals. Polar bears need to build up fat to be able to rear and feed their young, in addition to surviving hibernation over winter. In the absence of abundant seals and sea ice as a platform to hunt them, they need to further venture into human settlements looking for food sources. Unsurprisingly, polar bear populations are decreasing as a result.

The aim was to give scientists access to data to help them to understand the extent to which the tropic levels are influenced by temperature or ice extent changes.

![]`r paste0("(",proj_dir,"food_chain.jpg",")")`

### Map of Study Area (OSM)

Open Street Map polygons were downloaded from geofabrik to give context to the data analysis:

```{r echo=FALSE, eval=TRUE, width="100%", out.width="100%", height="500px", out.height="500px"}
require(leaflet)
require(knitr)
require(sf)
require(sp)
require(rgdal)
require(dplyr)
require(RColorBrewer)

wd <- proj_dir

svalbard_poly <- st_read(paste0(wd,"1_Data/","Svalbard_Polygon/","svalbard_polygon_osm_wgs84.gpkg"),stringsAsFactors=F,crs=4326,quiet=T)

labs <- lapply(seq(nrow(svalbard_poly)), function(i) {
  paste0('<strong>',svalbard_poly[i,]$name,'</strong>')
})

leaflet() %>%
  
  setView(lat=78.836065, lng=21.556140, zoom = 05) %>%
  
  addProviderTiles(providers$Esri.WorldImagery) %>%
  
  addPolygons(
    data = svalbard_poly,
    label = lapply(labs, htmltools::HTML),
    fillColor = '#f5a52c',
    color = '#FFFFFF',
    fillOpacity = 0.2,
    stroke = TRUE,
    weight = 1.4
  )
```


### Ice Extent Data - Conversion

Sea Ice extent data was downloaded from the [NSIDC](https://nsidc.org/data/search/#keywords=G02135) and converted into GeoPackages for ease-of-use.

```{r, code = readLines(paste0(proj_dir,"iceExtentConvert.R"))}
```

### Ice Extent - Svalbard Areas

Using the OSM polygon of Svalbard, a bounding box polygon was created to represent the Svalbard area, then this was used to crop the sea ice extent data into the area of interest, allowing changes in local sea ice area to be calculated and mapped.

```{r code = readLines(paste0(proj_dir,"iceExtentSvalbardArea.R"))}
```

![]`r paste0("(",proj_dir,"sea_ice_map.jpg",")")`

### Ice Extent - Plotting Months

Here we present the fluctuation in sea ice extent over time from 1980 to present day. This first figure presents all data recorded monthly from satellite data, with a mean trend line showing the decline in sea ice extent across the 40 year period. The following chart shows only data from March for each year which is easier to visualise the chart. This data from March shows the largest extent of the ice from the year.


```{r eval=TRUE, code = readLines(paste0(proj_dir,"1_Data/","Ice_Extent/","ice_extent_graph.R"))}
```


### Polar Bears - Litter Size

This figure shows the change over time in the number of cubs born per litter in Svalbard. Based on increasing temperatures and decreasing sea ice extent, we predicted that polar bear litter sizes may decline over time. This would be due to polar bears receiving insufficient nutrients from key food sources that are also strongly affected by temperature/ice extent (seals, fish) to successfully rear offspring. This data shows a relatively stable litter size for the population recorded over the last 25 years. This variable was chosen as it was not possible to find data sources to directly map the population of polar bears on Svalbard. This index can be used (to some extent) as a proxy for the polar bear population dynamics. The figure seems to suggest stability in the polar bear population, however litter size does not capture all aspects of polar bear population – cub mortality rates can have a strong impact on whether this measure is reflective of polar bear population size. 

```{r eval=TRUE, code = readLines(paste0(proj_dir,"1_Data/","Polar_Bear_Cubs/","polar_bear.R"))}
```


### NDVI Conversion

We downloaded satellite data for the normalised difference vegetation index (NDVI) to plot together with other factors relating to the food chain of the polar bear. The available data we global, but when cropped to the Svalbard region we noticed some issues with the data that we were not able to solve in time. We don't have a plot of NDVI for the Svalbard region.

```{r eval=TRUE, code = readLines(paste0(proj_dir,"hdf_to_tif.R"))}
```


### Chlorophyll Data - Global

Global chlorophyll data from NASA was downloaded and explored for use in analysing the food chain and displaying data on an interactive map:

```{r code = readLines(paste0(proj_dir,"NC_to_df.R"))}
```

Global chlorophyll maps were output at monthly timesteps, but the coverage for Svalbard was limited:

![]`r paste0("(",proj_dir,"chlorophyll.png",")")`


### Polar Bears / Seals - GPS Tracking

A Shiny App was then built to explore these datasets through space and time. This interactive map shows polar bear and seal GPS data in a Svalbard and indicates the Cod population on a table below the map. Our initial intention was to plot data for the whole food chain of the polar bear. We tried chlorophyll A  data as Cod feed on plankton, however the data we get from  NASA Ocean Biogeochemical Model but it the extent didn't reach our Study area. We tried to get geo-located cod population data as it is essential food for seals but unfortunately getting that data was more difficult that we initially tought. The app has the capacity of adding more data layers and features but we had limited time.

```{r code = readLines(paste0(proj_dir,"polar_bear_seal_script.R"))}
```

![]`r paste0("(",proj_dir,"shiny_app.png",")")`


### AOD / Satellite Temperature Data

We downloaded Aerosol Optical Depth (AOD) data and cropped it to the Svalbard region to compare against data to investigate if there might be unexpected connections between Air Pollution and the food chain of the polar bear. We can plot AOD around Svalbard for the time periods selected for our example.
We also attempted to get satellite data for temperature but struggled to convert the specific format of the data to something we can work with. We were not successful on obtaining spatial temperature data around Svalbard. 

```{r eval=TRUE, code = readLines(paste0(proj_dir,"nc4_to_tiff_aod.R"))}
```


### Zeppelin Temperature

We downloaded temperature data from the weather station at Zeppelin to plot against time:

```{r eval=TRUE, code = readLines(paste0(proj_dir,"nas_to_df.R"))}
```


### Large Mammals - Frequency

Didn't cover Svalbard.

```{r code = readLines(paste0(proj_dir,"large_mammals_script.R"))}
```


### Zooplankton (Barents Sea)

The data for zooplankton represents a time series for the biomass per m2 in the Barents sea. We estimated that zooplankton biomass would decline with increasing temperature and decreasing sea ice extent, as these events would have a negative impact on the availability of phytoplankton on which zooplankton feed. However zooplankton shows an increase in population size in the 90s which levelled off before increasing again in 2015. This data is likely may well be impacted factors such as sample intensity. 

```{r eval=TRUE, code = readLines(paste0(proj_dir,"1_Data/","zooplankton/","zooplankton.R"))}
```


### Arctic Cod (Barents Sea)

This data set shows the long term trends in arctic cod stocks from the 1950s. As a key commercial fishing stock, the data is a longer time series than other datasets gathered. Total arctic cod stocks show a strong decline into the 1990s, before increasing to present day. As the recruitment numbers remain constant, this suggests this is due to reduced fishing pressures on the arctic cod. These trends may also be due to other factors beyond commercial fishing, such as food availability and abiotic conditions. 

```{r eval=TRUE, code = readLines(paste0(proj_dir,"1_Data/","Arctic_Cod/","arctic_cod_graph.R"))}
```


### Compilation Graphs

We lsatly began exploring more connections between the data, seeing whether there were significant association between each of the variables plotted together with a linear model. If there had been more time available, we would have explored this data using generalised linear models as it may well be that the association between the variables is non linear. We found no significant association between the sea ice extent and zooplankton biomass. We also found no significant association between zooplankton biomass and arctic cod stocks. Finally, we found no significant association between polar bear litter size and arctic cod stocks. This suggests that from the limited datasets we were able to compile within the hackathon that there is no accociation between temperature increase and the polar bear food chain. However, from the extent of information available about the effects of climate change globally and particularly in arctic ecosystems, this seems unlikely. What is more probable is the amount of data we were able to collate within the hackathon was insufficient to show such trends.

```{r eval=TRUE, code = readLines(paste0(proj_dir,"1_Data/","compilation/","compilation.R"))}
```


### Data

* Global monthly chlorophyll: Watson Gregg and Cecile Rousseaux (2017), NASA Ocean Biogeochemical Model assimilating satellite chlorophyll data global monthly VR2017, Edited by Watson Gregg and Cecile Rousseaux, Greenbelt, MD, USA, Goddard Earth Sciences Data and Information Services Center (GES DISC), Accessed: [Data Access Date], 10.5067/BHCFDIICIOU5

* Merra temperature citation: Global Modeling and Assimilation Office (GMAO) (2015), MERRA-2 instM_2d_gas_Nx: 2d,Monthly mean,Instantaneous,Single-Level,Assimilation,Aerosol Optical Depth Analysis V5.12.4, Greenbelt, MD, USA, Goddard Earth Sciences Data and Information Services Center (GES DISC), Accessed: [Data Access Date], 10.5067/XOGNBQEPLUC5

* Zooplankton dataset: Hop H, Wold A, Vihtakari M, Daase M, Kwasniewski S, Gluchowska M, Lischka S, Buchholz F, Falk-Petersen S (2019) Zooplankton in Kongsfjorden (1996-2016) in relation to climate change. In "The ecosystem of Kongsfjorden, Svalbard" (eds. Hop H, Wiencke C), Advances in Polar Ecology, Springer Verlag.
•Polar Bear/ Ringed Seal Data: Lydersen, C., Kovacs, K. M., Aars, J., Hamilton, C., & Ims, R. (2017). Tracking data from polar bears (N=67, 2002-2004 & 2010-2013) and ringed seals (N=60, 2002-2004 & 2010-2012) [Data set]. Norwegian Polar Institute. https://doi.org/10.21334/npolar.2017.132248b4

* AOD: Global Modeling and Assimilation Office (GMAO) (2015), MERRA-2 instM_2d_gas_Nx: 2d,Monthly mean,Instantaneous,Single-Level,Assimilation,Aerosol Optical Depth Analysis V5.12.4, Greenbelt, MD, USA, Goddard Earth Sciences Data and Information Services Center (GES DISC), Accessed: [Data Access Date], 10.5067/XOGNBQEPLUC5

* NDVI: GES DISC Northern Eurasian Earth Science Partnership Initiative Project (2006), MODIS/Aqua Monthly Vegetation Indices Global 1x1 degree V005, Greenbelt, MD, USA, Goddard Earth Sciences Data and Information Services Center (GES DISC), Accessed: [Data Access Date], 10.5067/L52A2U212BBC

* Meiofauna: Bluhm BA, Hop H, Vihtakari M, Gradinger R, Iken K, Melnikov IA, Søreide J. Sea ice meiofauna distribution on local to pan- Arctic scales. Ecol Evol. 2018;00:1–15.https://doi.org/10.1002/ece3.3797
