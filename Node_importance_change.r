


setwd("C:/Thesis_analysis/Development_corridors/GIS/inputs/flat_file/hansenNew_eco_20km_passNew_kba_corr_floss1_wgs84")

Imp<- read.table("Node_importances.txt", h=TRUE)

Imp$change<- Imp$varPC1-Imp$varPC0
Imp$change[which(Imp$varPC1==0)]<- 0
Imp$change[which(Imp$change>0)]<- 1
Imp$change[which(Imp$change<0)]<- -1
