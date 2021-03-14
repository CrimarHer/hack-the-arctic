### Script by JS
### 2021-03-13
### merra_ta

library(ncdf4)
library(lubridate)
library(raster)
library(rgdal)
library(dplyr)

#  shapefile stuff
dir2 <- paste0("<local_drive>/Hack_The_Arctic/","/1_Data/Svalbard_Polygon/")

shp <- readOGR(paste0(dir2, "/svalbard_polygon_osm_wgs84.gpkg"))
#st_crs(shp)
shp <- spTransform(shp, st_crs(4326)$proj4string)
extent_shp <- extent(shp)


dir <- "<local_drive>/Hack_The_Arctic/1_Data/"

pat_select <- c("200003","200009","201503","201509")

for (i in 1:length(pat_select)){
  file <- list.files(path = paste0(dir,"merra_aod/"),pattern = paste0(pat_select[1],".nc4$"))
  
  r <- raster(paste0(dir,"merra_aod/",file),varname="AODANA")
  crs(r) <- CRS("+init=epsg:4326")
  
  #finally... crop
  r_cropped<-crop(r, extent(shp))
  
  if (i==1){plot(r_cropped)}
  
  #writeRaster(r_cropped,paste0(dir,"merra_aod/",pat_select[i],"_AODANA.tif"),overwrite=TRUE)
  

}


#file <- files[1]
#month <- substr(file,28,33)

#nc <- nc_open(paste0(dir,"merra_aod/",file))

r <- raster(paste0(dir,"merra_aod/",file),varname="AODANA")
crs(r) <- CRS("+init=epsg:4326")

shp <- readOGR(paste0(dir2, "/svalbard_polygon_osm_wgs84.gpkg"))
#st_crs(shp)
shp <- spTransform(shp, st_crs(4326)$proj4string)
extent_shp <- extent(shp)

#
#st_crs(shp)
shp <- spTransform(shp, st_crs(4326)$proj4string)

#finally... crop
r_cropped<-crop(r, extent(shp))

#plot(r_cropped)

#writeRaster(r_cropped,paste0(dir,"merra_aod/",month,"_AODANA.tif"))

#### temperature (not working)

dir <- "<local_drive>/Hack_The_Arctic/1_Data/mls_ta/"

name <- "/MLS-Aura_L2GP-Temperature_v04-22-c01_2015d364_temp.nc"

nc <- nc_open(paste0(dir,name))
temp <- ncvar_get(nc,varid="L2gpValue_Temperature")
lat <- ncvar_get(nc,varid="Latitude_Temperature")
lon <- ncvar_get(nc,varid="Longitude_Temperature")
time <- ncvar_get(nc,varid="Time_Temperature")

r <- raster(paste0(dir,name),varname="L2gpValue_Temperature")

crs(r) <- CRS("+init=epsg:4326")


