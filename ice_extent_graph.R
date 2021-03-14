library(lubridate)
library(tidyverse)
theme_set(theme_classic())

setwd("<local_drive>/Hack_The_Arctic/1_Data/Ice_Extent/") # need this hard-coded for Phil to run the .Rmd file on his machine

ice<-read.csv("svalbard_ice_extent_area_means.csv", row.names=1)
ice$date<-as.Date(ice$date)

ice$thkm<-ice$ice_area_mean_km2/1000

ggplot(ice, aes(x=date, y=thkm)) +
  geom_point(colour="gray50") + 
  geom_line(colour="gray50") +
  geom_smooth(method="loess", fill="blue4", colour="blue4") +
  ylab("Mean ice area extent (thousand km2)") +
  scale_x_date(expand=c(0.01,0)) +
  xlab("Year") +
  scale_y_continuous(breaks=c(0,50,100,150,200,250,300))

ice$month<-month(as.POSIXlt(ice$date, format="%Y-%m-%d"))
mar_ice<-ice[ice$month==3,]

ggplot(mar_ice, aes(x=date, y=thkm)) +
  geom_point(colour="gray50") + 
  geom_line(colour="gray50") +
  geom_smooth(method="loess", fill="blue4", colour="blue4") +
  ylab("Mean ice area extent in March (thousand km2)") +
  scale_x_date(expand=c(0.01,0)) +
  xlab("Year") +
  scale_y_continuous(breaks=c(0,50,100,150,200,250,300))
