####Atlantic Cod graph
library(tidyverse)
theme_set(theme_classic())

setwd("<local_drive>/Hack_The_Arctic/1_Data/Arctic_Cod/") # need this hard-coded for Phil to run the .Rmd file on his machine

ac<-read.csv("stock_fish.csv")
colnames(ac)<-ac[1,]
colnames(ac)[1]<-"series_name"
ac<-ac[-1,-c(2,3)]
acl<- ac %>% group_by(series_name) %>% gather("year","pop", 2:75)
acl$s_n<-as.factor(acl$series_name)
acl$year<-as.numeric(as.character(acl$year))

ggplot(acl, aes(x=year, y=pop)) +
  geom_point(aes(colour=series_name)) +
  geom_line(aes(colour=series_name)) +
  geom_smooth(method="loess", aes(colour=series_name, fill=series_name)) +
  xlab("Year") +
  ylab("Population") +
  labs(colour="Life Stage") +
  guides(fill=FALSE)
