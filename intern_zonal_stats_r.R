library(sp)
library(raster)
library(rgdal)
library(spatialEco)
library(maptools)
library(grid)
library(ggplot2)
library(rasterVis)
ogrDrivers()

#zonal statistics for buffers around euclidean distances


##rm(list=ls()) #clear workspace

wkspace1="C:/Users/Konstantina/Desktop/Distance/Comparison/buffer_euclidean/split"
wkspace2="C:/Users/Konstantina/Desktop/Distance/Comparison/buffer_euclidean/projected_res_rast/projected"
wkspace3="C:/Users/Konstantina/Desktop/Distance/Comparison/buffer_euclidean/zonal_euclid"

setwd(wkspace1)

fcList<-list.files(".",pattern=".shp",)


fcList<-grep(glob2rx("*.xml*"), fcList, value=TRUE, invert=TRUE)
fcList


#calculate mean resistance in buffers
for (i in fcList[-3]) {
  setwd(wkspace1)
  i=gsub(".shp", "", i)
  shp3 = readOGR(dsn=wkspace1,layer=i)
  j<-as.character(i)
  setwd(wkspace2)
  j<-strsplit(j, "_")
  j<-unlist(j)
  j<-j[2]
  j = paste(j,".tif",sep = "")
  print(j)
  rst = raster(j)
  
  shp3@data$mean<- zonal.stats(x=shp3, y=rst, stat=mean, trace = TRUE, plot = FALSE)
  shp3$effectDist1<-shp3$mean*shp3$distance
  setwd(wkspace3)
  write.csv(shp3,i,)
  write.csv(shp3,paste0(wkspace3,"/",i,".csv"),row.names=FALSE )
  }


  
setwd(wkspace3)
Files<- list.files(path=".", pattern= "*.csv*")
out_path1= "C:/Users/Konstantina/Desktop/Distance/Comparison/buffer_euclidean/zonal_euclid_newdist"
#calculate effective distances
for (i in Files){
	
	a<- read.csv(i, h=T)

	a$effectDist1.5<- ifelse(a$mean > 1.5, a$mean*a$distance,a$distance/a$mean)
	a$effectDist2<- ifelse(a$mean < 2, a$distance/a$mean, a$distance)
	i<- strsplit(i,".csv")
	i<- unlist(i)
	i<- i[1]	
	j<- strsplit(i, "_cell")
	j<- unlist(j); j<- j[2]
	
	a<- a[-c(3,4)]
	a$to_node_id<- paste0(j,a$to_node_id)
	a$link_id<- paste0(a$from_node_,"_", a$to_node_id)
	a$link_id2<- paste0(a$to_node_id,"_",a$from_node_)
	
	write.table(a,paste0(out_path1,"/",i,".txt"))
	}	

	
	
setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/buffer_euclidean/zonal_euclid_newdist")
file_names <- dir("C:/Users/Konstantina/Desktop/Distance/Comparison/buffer_euclidean/zonal_euclid_newdist")
bufferDist<- do.call(rbind,lapply(file_names,read.table))
str(bufferDist)

#clean NAs
na.ind = which(is.na(bufferDist$effectDist1))
bufferDist$effectDist1[na.ind] = bufferDist$distance[na.ind]
bufferDist$effectDist1.5[na.ind] = bufferDist$distance[na.ind]
bufferDist$effectDist2[na.ind] = bufferDist$distance[na.ind]
#write complete dataset
out_path2="C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables"
bufferDist<- bufferDist[c(4,1,2,10,11,5,3,6:9)]
write.table(bufferDist,paste0(out_path2,"/","bufferDist.txt"))


#create a dataset with circuitscape and buffer distances
CS<- read.table("CSnE_Disp.txt", h=T)

CSnBuf<- merge(CS, buf, by= "id_no", "link_id", "link_id2")
write.table(CSnBuf, "CSnBuf.txt")



############################################################







