### JS
### 2021-03-13
### read in NDVI data and crop to Svalbard region
### issues: cropped data has no data

library(rgdal)
library(gdalUtils)
library(raster)
library(sp)
library(sf)

dir <- "<local_drive>/Hack_The_Arctic/1_Data/modis_ndvi/"

#read raster
r <- raster(paste0(dir,"MYDVI.201509.005.nc"),varname="NDVI")

r <- flip(r,direction = "y")
plot(r)

#read shapefile
#shp <- st_read("file")

#make sure crs projections match 
#st_crs(shp)
#crs(r)

#if they don't match...
#shp <- spTransform(shp, st_crs(4326)$proj4string)

crs(r) <- CRS("+init=epsg:4326")

# 
dir2 <- "<local_drive>/Hack_The_Arctic/1_Data/Svalbard_Polygon/"
shp <- readOGR(paste0(dir2, "svalbard_polygon_osm_wgs84.gpkg"))
#st_crs(shp)
shp <- spTransform(shp, st_crs(4326)$proj4string)
extent_shp <- extent(shp)

#
#st_crs(shp)
shp <- spTransform(shp, st_crs(4326)$proj4string)

#finally... crop
r_cropped<-crop(r, extent(shp))

#plot(r_cropped)
