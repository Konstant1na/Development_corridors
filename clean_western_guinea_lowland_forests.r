
#################################################
#####  Clean Western Guinea Lowland Forests #####
#################################################


library(foreign)

mainDir<- "C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/Western_Guinean_lowland_forests"

#dir.create(file.path(mainDir,"clean"))
#dir.create(file.path(newDir, "t0"))
#dir.create(file.path(newDir, "t1"))
#dir.create(file.path(newDir, "t2"))

rem<- read.dbf("C:/Thesis_analysis/Development_corridors/GIS/inputs/flat_file/to_remove_from_flatfile/to_remove_from_flatfile.dbf")
rem<- rem$nodiddiss4

folder<- "t2"
newDir<- paste0(mainDir, "/clean")
#nodes
setwd(paste0(mainDir,"/",folder))

file_list<- list.files()
file_list

string_pattern<- "nodes_*"
file_list<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]
file_list

file_list2<- lapply(file_list, read.table)
names(file_list2)<- file_list
file_list2<- lapply(file_list2, setNames, nm=c("node", "area"))
file_list2<- lapply(file_list2, function(x) x[!(x$node %in% rem),])

sapply(names(file_list2), function(x) write.table(file_list2[[x]], 
	file=paste0(newDir,"/",folder,"/",x), 
	col.names=F, row.names=F ))
rm(file_list2)

#distances	
setwd(paste0(mainDir,"/",folder))

file_list<- list.files()
file_list

string_pattern<- "distances_*"
file_list<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]
file_list

file_list2<- lapply(file_list, read.table)
names(file_list2)<- file_list
file_list2<- lapply(file_list2, setNames, nm=c("from_node", "to_node", "distance"))
file_list2<- lapply(file_list2, function(x) x[!(x$from_node %in% rem | x$to_node %in% rem),])

sapply(names(file_list2), function(x) write.table(file_list2[[x]], 
	file=paste0(newDir,"/",folder,"/",x), 
	col.names=F, row.names=F ))
rm(file_list2)	

	
##############################################################