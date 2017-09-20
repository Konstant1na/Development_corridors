
########################################
######### Find Missing Files ###########
########################################

library(stringr)
library(tidyr)
library(dplyr)


mainDir<- "C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/"

setwd(mainDir)
eco<- list.files()
time<- "/t1"


for (i in eco){

setwd(paste0(mainDir,i,time))


file_list<- list.files()

stringPattern="nodes_*"
file_listN<-file_list[lapply(file_list,function(x) length(grep(stringPattern,x,value=FALSE))) ==1]
file_listN
file_listN<- unlist(strsplit(file_listN, ".txt"))

stringPattern="distances_*"
file_listD<-file_list[lapply(file_list,function(x) length(grep(stringPattern,x,value=FALSE))) ==1]
file_listD
file_listD<- unlist(strsplit(file_listD, ".txt"))

Nodes<- as.data.frame(file_listN)
colnames(Nodes)<- "names"
Nodes<- separate(Nodes,names, into = c("type", "id", "season"), sep = "_")
Nodes<- unite(Nodes, "prefix", c("id", "season"), sep="_")

Dist<- as.data.frame(file_listD)
colnames(Dist)<- "names"
Dist<- separate(Dist,names, into = c("type", "id", "season"), sep = "_")
Dist<- unite(Dist, "prefix", c("id", "season"), sep="_")

Miss<- merge(Nodes, Dist, by= "prefix", all=TRUE)
Miss<- filter(Miss, is.na(type.x) | is.na(type.y))

write.table(Miss, paste0("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/missing_input_files",time, "_",i,".txt"), col.names=F, row.names=F, quote = FALSE)

}

