### Script by JS
### 2021-03-13
### read in Zeppelin temp data and plot

library(readr)
library(lubridate)
library(dplyr)
library(ggplot2)

#dir <- paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/1_Data/")
dir <- "<local_drive>/Hack_The_Arctic/1_Data/" # need this hard-coded for Phil to run the .Rmd file on his machine

files <- list.files(path = paste0(dir,"Ebas_210311_1457/"),pattern = ".nas$")

# each file contains daily data for 1 year
# the time vector starts from 0 for each file
# to combine the files, the time vector has to be adjusted before merging the data

# create empty df temp
temp <- data.frame(time = character(), T = character(), flag_T=character())
# 
# for all the files, do 
for (i in 1:length(files)){
  
  file <- paste0(files[i])

  # read in data table, skip header
  raw <- read_table2(paste0(dir,"Ebas_210311_1457/",file),skip=53,na="999.9")
  # get reference year for time vector from filename
  refyear <- substr(file,9,12)

  # set new date vectors
  raw$time <- as.POSIXct(as.Date(raw$starttime, origin=paste0(refyear,"-01-01")), tz="UTC")
  
  raw <- raw %>% dplyr::select("time","T","flag_T")
  
  temp <- rbind(temp,raw)
}

temp$year <- year(temp$time)
temp$month <- month(temp$time)

# filter out data with flag > 0
# temp <- temp %>% filter(flag_T==0)

#
temp_mm <- temp %>% group_by(month,year) %>% 
  summarise(T_mm = mean(T,na.rm=TRUE),.groups = 'drop')
temp_mm$time <- as.Date(paste(temp_mm$year,"-",temp_mm$month,"-01",sep=""))
temp_mm <- dplyr::select(temp_mm,"time","T_mm")
temp_mm$year <- year(temp_mm$time)
temp_mm$month <- month(temp_mm$time)

# save csv
write_csv(temp_mm,"1_Data/Ebas_210311_1457/Ebas_Zeppelin_1998_2019_T_mm.csv",append = FALSE)
write_csv(temp,"1_Data/Ebas_210311_1457/Ebas_Zeppelin_1998_2019_T_dm.csv",append = FALSE)

# plot all years
ggplot(temp_mm,aes(x=time,y=T_mm)) +
  geom_line(colour="blue") +
  theme_classic()+
  labs(x="",y=expression("Monthly mean Temperature ("*~degree*C*")"),caption = "")

# choose a year to plot
plotyear="2015"
# monthly mean data
ggplot(temp_mm[temp_mm$year==plotyear,],aes(x=time,y=T_mm)) +
  geom_line(colour="blue") +
  theme_classic()+
  labs(x="",y=expression("Monthly mean Temperature ("*~degree*C*")"),caption = "")

# daily mean data
ggplot(temp[temp$year==plotyear,],aes(x=time,y=T)) +
  geom_line(colour="blue") +
  theme_classic()+
  labs(x="",y=expression("Daily mean Temperature ("*~degree*C*")"),caption = "")
