
library(foreign)


setwd("C:/Thesis_analysis/Development_corridors/GIS/scratch/resolution/10km")
km10<- read.dbf("All_10km.dbf")
setwd("C:/Thesis_analysis/Development_corridors/GIS/scratch/resolution/20km")
km20<- read.dbf("All_20km.dbf")
setwd("C:/Thesis_analysis/Development_corridors/GIS/scratch/resolution/30km")
km30<- read.dbf("All_30km.dbf")
setwd("C:/Thesis_analysis/Development_corridors/GIS/scratch/resolution/40km")
km40<- read.dbf("All_40km.dbf")


list<- list(km10, km20, km30, km40)
names(list)<- c("km10", "km20", "km30", "km40")

listS<- lapply(list, function(x) aggregate(x, by= list(x$OBJECTID), sum))
loss<- data.frame(sapply(listS, function(x) apply(x, 2, max)))

loss$km10 <- (loss$km10*100)/100000000
loss$km20 <- (loss$km20*100)/400000000
loss$km30 <- (loss$km30*100)/900000000
loss$km40 <- (loss$km40*100)/1600000000

apply(loss, 1, max)

loss<- round(loss, 2)


