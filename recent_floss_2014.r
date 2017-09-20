library(foreign)
library(sp)

setwd("C:/Thesis_analysis/Development_corridors/GIS/inputs/flat_file/All_20km")

list_df_aggloss2014<- read.csv("list_df_aggloss2014.csv")

#select top 5%
n<-20
list_df_agg2014_top5pc<- subset(list_df_aggloss2014, loss2014 > quantile(loss2014, prob = 1 - n/100))
nrow(list_df_agg2014_top5pc)
#write to csv
help("write.csv")
write.csv(list_df_agg2014_top5pc,"list_df_aggloss2014_top20pc.csv",row.names=FALSE)
#listS<- lapply(list, function(x) aggregate(x, by= list(x$OBJECTID), sum))
