#Polar bear data

#Source: https://data.npolar.no/dataset/132248b4-34fc-41e0-b34e-5772b52a8fdf

polarbear <- read.table("https://api.npolar.no/dataset/132248b4-34fc-41e0-b34e-5772b52a8fdf/_file/PBRS_CoastalLocations.txt", sep = '\t', header = TRUE)
write.csv(polarbear, "C:/Users/jualob/NERC/Taylor, Philip J. - Hack_The_Arctic/1_Data/Polar_Bear/polar_bear_seal.csv")
