

setwd("C:/Thesis_analysis/Development_corridors/distances_raw/t1")


file_list<- list.files()
file_list

string_pattern<- "distances_adj_*"
#choose only the distance files
file_list<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]

#read data frames
file_list2<- lapply(file_list, read.table)

#set names
Colnames<- c("from_node", "to_node", "dist", "dist_over_corridor")
file_list2<- lapply(file_list2,setNames,nm=Colnames)

#create new column
file_list2<- lapply(file_list2, cbind, dist2= c(""))

#calculations, new distance
file_list2<- lapply(file_list2, within, dist2<- dist+2*dist_over_corridor)

#set dataframe names
file_list<- strsplit(file_list, ".txt")
file_list<- lapply(file_list, function(x) gsub("adj", "adj2",x))

names(file_list2)<- file_list

#create the format for conefor
file_list2<- lapply(file_list2, function(x) x[c(1,2,5)]) 

#write new files in the conefor folder
sapply(names(file_list2), function(x) write.table(file_list2[[x]], 
	file=paste0("C:/Thesis_analysis/Development_corridors/conefor/data/t1", "/",x,".txt"), 
	col.names=F, row.names=F ))

##################################################################################################
