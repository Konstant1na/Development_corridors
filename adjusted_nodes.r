

##change t0 to t1 and vice versa in row 5 and 29

setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/try/eco3")

file_list<- list.files()
file_list

string_pattern<- "nodes_*"
#choose only the distance files
file_list<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]
file_list

#read data frames
file_list2<- lapply(file_list, read.table)

#set dataframe names
file_list<- strsplit(file_list, ".txt")
file_list<- lapply(file_list, function(x) gsub("nodes", "nodes_adj",x))

names(file_list2)<- file_list

#create the format for conefor
file_list2<- lapply(file_list2, function(x) x[c(1,2)]) 

#write new files in the conefor folder
sapply(names(file_list2), function(x) write.table(file_list2[[x]], 
	file=paste0("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/try/eco3", "/",x,".txt"), 
	col.names=F, row.names=F ))


