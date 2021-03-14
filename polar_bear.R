library(tidyverse)

#setwd(paste0(dirname(rstudioapi::getSourceEditorContext()$path),"/"))
setwd("<local_drive>/Hack_The_Arctic/1_Data/Polar_Bear_Cubs/") # need this hard-coded for Phil to run the .Rmd file on his machine

pb<-read.csv("polar-bear-cubs-per-litter.csv")

pb<-pb[,-c(2,3)]
colnames(pb)[2:28]<-seq(1993, 2019)
#str(pb)
pbl<- pb[1,] %>% group_by(Series.name) %>% gather("year","litter.size", 2:28)
pbl$year<-as.numeric(as.character(pbl$year))

ggplot(pbl, aes(x=year, y=litter.size)) +
  geom_point(colour="blue4") +
  geom_line(colour="blue4") +
  geom_smooth(method="loess", fill="blue4", colour="blue4") +
  xlab("Year") +
  ylab("Polar Bear Litter Size") +
  scale_x_continuous(breaks=c(1995, 2000, 2005, 2010, 2015, 2020))

