####Result aggregation### 
library(rgdal) 
library(sp)
library(rgeos)
library(raster) 



mainDir<- "C:/Thesis_analysis/Development_corridors/conefor/ecoregions/output/"
setwd(mainDir)
eco<- list.files()
eco<- eco[9]
time<- "t0"

###aim: read in results from conefor and aggregate ###simple aggregation for PAs when ids match 
in_path1=paste0(mainDir, eco,"/", time)
#in_path2="C:/Data/cci_connectivity/scratch/nodes"
out_path=paste0(mainDir, "Node_importances")

#if nested
#selection_code<-c(TRUE,TRUE,TRUE,FALSE,FALSE)

#if normal run 
selection_code<-c(TRUE,TRUE,FALSE,FALSE)



#get species ids from node files
setwd(in_path1)

#make list of node and distance files for conefor in the in_path2 folder
file_list <- list.files()

#selecting files, based on string recognition to select outputs
stringPattern="_node_importances.txt*"
file_list<-file_list[lapply(file_list,function(x) length(grep(stringPattern,x,value=FALSE))) == 1]
#file_list
x<-file_list


agg_res<-data.frame()

for (i in 1:length(x)){
  res<-read.table(x[i],header=TRUE)
  #str(res)
  x[i]
  #res<-subset(res,res$varPC>0)
  #res<-droplevels(res)
  dt<- strsplit(x[i],"_")[[1]]#splits string
  dt<-dt[c(selection_code)]#chooses certain part to keep
  #print (dt)
  res$id_no<-paste0(dt[1],"_",dt[2])
  #print (res)
  agg_res<-rbind(agg_res,res)
  agg_res<-subset(agg_res,agg_res[2]>=-99)
}

#write output
write.table(agg_res,paste0(eco,".txt"))



#open output

agg_res_vals<-read.csv("conefor_outputs.csv")


###############
#comparing outputs
agg_res_vals<-read.csv("conefor_outputs.csv")

agg_res_vals2<-read.csv("conefor_outputs2.csv")
str(agg_res_vals.merge)
#join nested to normal outputs
agg_res_vals.merge<-merge(agg_res_vals,agg_res_vals2,by=c("Node","id_no"))
#plot varPCs for each against each other - using log due to orger of magnitude difference.
plot(log(agg_res_vals.merge$varPC.x)~log(agg_res_vals.merge$varPC.y))
#subset if needed
#agg_res_vals.merge<-subset(agg_res_vals.merge,id_no=="22680659_1")
#find those outliers
(subset(agg_res_vals.merge,(agg_res_vals.merge$varPC.x/agg_res_vals.merge$varPC.y)>100))

################
#adding columns
agg_res_vals_sub<-subset(agg_res_vals,agg_res_vals$varPC>0)
agg_res_vals_sub$ratio_varPC<-(agg_res_vals_sub$dA/agg_res_vals_sub$varPC)
agg_res_vals_sub$ratio_dPC<-(agg_res_vals_sub$dA/agg_res_vals_sub$dPC)
agg_res_vals_sub$count<-1
head(agg_res_vals_sub)
###############

nodeOutVals<-aggregate(. ~ Node, agg_res_vals_sub,FUN=mean)
head(nodeOutVals)

list.files(, pattern='\\.shp$')
setwd(in_path2)

shp<-"grid_pas_trees_40postcent_30agg_diss_ovr1ha_subset_guinea"
spdf<-readOGR(".",shp)

head(spdf@data)

spdfMerge<-merge(spdf,nodeOutVals,by.x="nodeiddiss",by.y="Node")
head(spdfMerge@data)
spdfMerge@data$ratio1<-spdfMerge@data$varPC/spdfMerge@data$AREA_GEO
spdfMerge<-subset(spdfMerge,spdfMerge@data$ratio1>0)
plot(spdfMerge@data$ratio1~spdfMerge@data$varPC)

plot(spdfMerge@data$ratio_varPC~spdfMerge@data$dPC)

shapes<-spdfMerge

setwd(out_path)

writeOGR(shapes, ".", "nodes_out_res1", "ESRI Shapefile")
#shapefile("nodes_out_varPC.shp", object=shapes, overwrite=TRUE, verbose=FALSE)
