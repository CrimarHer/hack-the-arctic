#Packages
library(sf)
library(raster)
library(ncdf4)
library(dplyr)
library(readr)
library(rgdal)

#Load tif files

wd <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/") 

r <- raster(paste0(wd, "/1_Data/nasa_clorophyll/2000_04_totCloroph.tif"))
crs(r) <- CRS("+init=epsg:4326")
r <- flip(r, 2)
r <- t(r) #transpose
r <- flip(r, 2)



#Load shapefile
shp <- readOGR("C:/Users/jualob/NERC/Taylor, Philip J. - Hack_The_Arctic/1_Data/Svalbard_Polygon/svalbard_polygon_osm_wgs84.gpkg")

#Check shapefile (projection, crs)
st_crs(shp)

#Converting shp to WGS84 (EPSG 4326) if it's not in that projection already (+proj=longlat +datum=WGS84 +no_defs)
shp <- spTransform(shp, st_crs(4326)$proj4string)
#or st)transform if shp is read with st_read instead or readOGR

#Create object that specifies extent of region (+ 1) for use below
extent_shp <- extent(shp) + 1


#Cropping tifs to extent of shp
r_crop <- crop(r, extent_shp)

