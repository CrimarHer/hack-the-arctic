#Large mammal data

large_mammals<- read.csv("MMSDB_observations_1995-2016.csv", sep = ";")

large_mammals_species <- large_mammals %>% 
  filter(Species == c(" erignathus barbatus ", " odobenus rosmarus ", 
                      " phoca groenlandica ", " phoca vitulina ", 
                      " pusa hispida "," ursus maritimus "))

large_mammals_species<- large_mammals_species %>% select(1:5, 16)

write.csv(large_mammals_species, "C:/Users/jualob/NERC/Taylor, Philip J. - Hack_The_Arctic/1_Data/Polar_Bear/large_mammals.csv")
