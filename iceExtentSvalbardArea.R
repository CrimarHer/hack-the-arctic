
require(sf)
require(sp)
require(lubridate)
r
wd <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/") # if not running in RStudio, set wd to directory of this script, e.g. wd <- 'C:/Dir/'

svalbard <- st_read(paste0(wd,"1_Data/","Svalbard_Polygon/","svalbard_polygon_osm_wgs84.gpkg"),crs=4326)
svalbard <- st_transform(svalbard,3411)
svalbard <- st_as_sf(as(extent(svalbard), 'SpatialPolygons'))
svalbard <- st_set_crs(svalbard,3411)


files <- list.files(paste0(wd,"1_Data/","Ice_Extent/","shp_extent/","GPKGs/"),pattern="\\.gpkg$")

ice_means <- data.frame(date = character(), ice_area_mean_km2 = numeric())

for (i in 1:length(files)) {
  this_extent <- st_read(paste0(wd,"1_Data/","Ice_Extent/","shp_extent/","GPKGs/",files[i]),crs=3411,quiet=T)
  this_extent_sval <- st_intersection(this_extent,svalbard)
  this_extent_sval_area <- as.numeric(st_area(this_extent_sval)/1000000)
  if (length(this_extent_sval_area)==0) {this_extent_sval_area <- 0}
  year <- substr(files[i],10,13)
  month <- substr(files[i],14,15)
  date <- paste0(year,"-",month,"-15")
  ice_means[i,] <- c(date,this_extent_sval_area)
}

ice_means$date <- ymd(ice_means$date)

#output monthly means
write.csv(ice_means,paste0(wd,"1_Data/","Ice_Extent/","svalbard_ice_extent_area_means.csv"))

#output most-recent spatial dataset
st_write(this_extent,paste0(wd,"1_Data/","Ice_Extent/","shp_extent/","GPKGs/","Examples/",files[i]))
st_write(this_extent_sval,paste0(wd,"1_Data/","Ice_Extent/","shp_extent/","GPKGs/","Examples/",gsub(".gpkg","_svalbard.gpkg",files[i])))
