####
library(tidyverse)
theme_set(theme_classic())

setwd("<local_drive>/Hack_The_Arctic/1_Data/zooplankton/") # need this hard-coded for Phil to run the .Rmd file on his machine

zoo<-read.csv("zooplankton_yearly.csv")
zoo<-zoo[,-c(2,3)]
colnames(zoo)[2:33]<-seq(1988, 2019)
#str(zoo)
zool<- zoo %>% group_by(Series.name) %>% gather("year","pop", 2:33)
zool$Series.name<-as.factor(zool$Series.name)
zool$year<-as.numeric(as.character(zool$year))
zoo_tot<-zool[(zool$Series.name=="Total"),]
zool<-zool[!(zool$Series.name=="Total"),]

ggplot(zool, aes(x=year, y=pop)) +
  geom_point(aes(colour=Series.name)) +
  geom_line(aes(colour=Series.name)) +
  geom_smooth(method="loess", aes(colour=Series.name, fill=Series.name)) +
  xlab("Year") +
  ylab("Population (g/m^2)") +
  labs(colour="Size") +
  guides(fill=FALSE) +
  scale_x_continuous(expand=c(0,0.5), breaks=c(1990,1995, 2000, 2005, 2010, 2015)) +
  scale_y_continuous(breaks=c(0,1,2,3,4,5))

ggplot(zoo_tot, aes(x=year, y=pop)) +
  geom_point(colour="blue4") +
  geom_line(colour="blue4") +
  geom_smooth(method="loess", fill="blue4", colour="blue4") +
  xlab("Year") +
  ylab("Total Population (g/m^2)")
