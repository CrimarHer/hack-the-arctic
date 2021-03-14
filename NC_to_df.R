#Script by CMH. 12/10/2020
#Checking that the varibles from .nc files are the same as the variables form the sup. doc. tables (it needs to copy-paste manually from sup. doc. tables to a .csv file)

library(ncdf4)
library(raster)
library(rgdal)
library(dplyr)

#enter your path below: example dir <- "N:/EIDC/dataset_A/" - note the / at the end
#dir <- "C:/Users/crimar/NERC/Taylor, Philip J. - Hack_The_Arctic/1_Data/Met_Data/" 
dir <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/1_Data/nasa_clorophyll/") # if not running in RStudio, set wd to directory of this script, e.g. wd <- 'C:/Dir/'

year <- 2013

nc_files<-list.files(dir,pattern=".nc4$",recursive = T)
nc_files
# if you run nc_files you will see each netCDF file has a number, that number is the identifyer you will use in nc_files[number_here]
#nc$dim$time
#open NetCDF: change the nc_files[number] to open different files.
#nc files to get: 29, 34, 209, 214
#change nc_files[1] to open the first file, nc_files[2] to open the second one,...
nc<-nc_open(paste0(dir,nc_files[209]))
variable_names_file <- names(nc$var)
variable_names_file
#See general info abaout the file chosen
print(nc)
r <- raster(paste0(dir,nc_files[1:12]), varname="tot") #run this if you have more than one layer(band) per variable. for example: each variable is one day of the year.
writeRaster(r, paste0(dir, "2015_09_totCloroph.tif"))
r <- flip(r, direction = "x")
r <- flip(r, direction = "y")
plot(r)
#

#Loop to read all files
nc_files<-list.files(dir,pattern=".nc4$",recursive = T)
df <- data.frame(x = numeric(), y = numeric(), total.chlorophyll = numeric(), month = numeric(), year = numeric())

for (i in 1:length(nc_files)){
  
  r <- raster(paste0(dir,nc_files[i]), varname = "tot")

  df_r <- as.data.frame(r, xy = TRUE)
  
  df_r$month <- substr(nc_files[i], 8, 9)
  df_r$year <- substr(nc_files[i],4,7)
  df <- rbind(df, df_r)
  
}

clorophyll_annual_mean <- drop_na(df)

clorophyll_annual_mean <- clorophyll_annual_mean %>% 
  filter(year == c(2002, 2003, 2004, 2010, 2011, 2013)) 

write.csv(clorophyll_annual_mean, paste0(dir, "/clorophyll_data.csv"))


#clorophyll_annual_mean <- clorophyll_annual_mean %>% 
 # group_by(c(x, y)) %>%
  #summarise(annual_mean = mean(total.chlorophyll))


r_clorophyll <- clorophyll_annual_mean %>% select(-c(month, year))
r_clorophyll <- rasterFromXYZ(clorophyll_annual_mean, digits = 3)
plot(r_clorophyll)
crs(r_clorophyll) <- CRS("+init=epsg:4326")
r_clorophyll_flip <- flip(r_clorophyll, 2)
r_clorophyll_flip <- t(r_clorophyll_flip) #transpose
r_clorophyll_flip <- flip(r_clorophyll_flip, 2)
plot(r_clorophyll_flip$layer.1)

#df <- as.data.frame(r, xy = TRUE)

############For weather stations: 

variable_names_file <- names(nc$var)


ncvar_get(nc, "time")
days_since <- as.Date("1970-01-01 00:00:00")

df <- data.frame(Date = as.Date( origin = "1970-01-01 00:00:00",ncvar_get(nc, varid = "time")), 
                 lat = ncvar_get(nc, varid = "latitude"),
                 lng = ncvar_get(nc, varid = "longitude"),
                 station_wmonr = ncvar_get(nc, varid = "station_wmonr"),
                 Air_temp = ncvar_get(nc, varid = "TA"),
                 Dew_temp = ncvar_get(nc, varid = "TD"),
                 seaSurfaceTemperature = ncvar_get(nc, varid = "TW"),
                 pressure = ncvar_get(nc, varid = "PR"),
                 
                 precipitation = ncvar_get(nc, varid = "RR_6"),
                 snow_depth = ncvar_get(nc, varid = "SA")
)

write.csv(df, paste0(dir, "1_Data/Met_Data/Met_", year, ".csv"))




######Cropping clorophyll data to extent of Svalbard 

#Load tif files
r <- raster(paste0(dir, "/2000_04_totCloroph.tif"))
crs(r) <- CRS("+init=epsg:4326")
r <- flip(r, 2)
r <- t(r) #transpose
r <- flip(r, 2)
plot(r)

#Load shapefile
dir2 <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/1_Data/Svalbard_Polygon/") 
shp <- readOGR(paste0(dir2, "/svalbard_polygon_osm_wgs84.gpkg"))
st_crs(shp)
shp <- spTransform(shp, st_crs(4326)$proj4string)
extent_shp <- extent(shp)+1

#Cropping tifs to extent of shp
r_crop <- crop(r, extent_shp)
df <- data.frame(year = numeric())
