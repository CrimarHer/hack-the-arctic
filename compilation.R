##combining the different datasets:
rm(list=ls())
library(lubridate)
library(tidyverse)
library(corrplot)
theme_set(theme_classic())

#setwd(paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/"))
setwd("<local_drive>/Hack_The_Arctic/1_Data/compilation/") # need this hard-coded for Phil to run the .Rmd file on his machine

ac<-read.csv("stock_fish.csv")
ice<-read.csv("svalbard_ice_extent_area_means.csv", row.names=1)
zoo<-read.csv("zooplankton_yearly.csv")
pb<-read.csv("polar-bear-cubs-per-litter.csv", header=FALSE)

####Cod
ac<-data.frame(t(ac))
ac<-ac[-c(1:3),c(1,3)]
colnames(ac)<-c("year", "ac")
ac[,1:2]<-sapply(ac[,1:2], as.numeric)

###ice
ice$date<-as.Date(ice$date)
ice$thkm<-ice$ice_area_mean_km2/1000
ice_sp<-ice[,-2]
colnames(ice_sp)[1:2]<-c("year", "ice")

zoo<-zoo[,-c(2,3)]
colnames(zoo)[2:33]<-seq(1988, 2019)
zool<- zoo %>% group_by(Series.name) %>% gather("year","zoo", 2:33)
zool$year<-as.numeric(as.character(zool$year))
zoo_tot<-zool[(zool$Series.name=="Total"),2:3]

pb<-pb[c(1:2),-c(1:3)]
pb<-data.frame(t(pb))
colnames(pb)<-c("year", "pb")
pb[,1:2]<-sapply(pb[,1:2], as.numeric)

all_sp<-left_join(ac, zoo_tot, by="year")
all_sp<-left_join(all_sp, pb, by="year")
all_sp$year<-paste0(all_sp$year, "-03-15")
all_sp$year<-as.Date(all_sp$year)
all_sp<-full_join(all_sp, ice_sp, by="year")

ggplot(all_sp, aes(x=ice, y=zoo)) +
  geom_point() +
  scale_x_continuous(limits=c(100, 275)) +
  xlab("Mean ice area extent in March (thousand km2)") +
  ylab("Zooplankton biomass (g/m2)")

ggplot(all_sp, aes(x=zoo, y=ac)) +
  geom_point() +
  xlab("Zooplankton biomass (g/m2)") +
  ylab("Arctic Cod stocks")

ggplot(all_sp, aes(x=ac, y=pb)) +
  geom_point() +
  xlab("Arctic Cod stocks") +
  ylab("Polar Bear Litter Size")

all_sp_noz<-all_sp[rowSums(is.na(all_sp))==0,2:5]
sp_mat<-cor(all_sp_noz)
corrplot(sp_mat, method="square", type="lower", diag=FALSE, tl.col="black")
