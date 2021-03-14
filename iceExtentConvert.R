
require(sf)

wd <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/") # if not running in RStudio, set wd to directory of this script, e.g. wd <- 'C:/Dir/'

files <- list.files(paste0(wd,"1_Data/","Ice_Extent/","shp_extent/"),pattern="polygon_v3\\.0\\.shp$")

for (i in files) {
  
  this_extent <- st_read(paste0(wd,"1_Data/","Ice_Extent/","shp_extent/",i),stringsAsFactors=F)
  this_extent_union <- st_union(this_extent,by_feature=F)
  plot(this_extent_union)
  st_write(this_extent_union,paste0(wd,"1_Data/","Ice_Extent/","shp_extent/","GPKGs/",gsub(".shp",".gpkg",i)))
  
}

