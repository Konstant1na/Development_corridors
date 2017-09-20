
############################################
########## Split Large Ecoregions ##########
############################################




		### GET NODES FOR EACH SPLIT ###
#first time
setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/node_splits_for_large_ecoregions")

file_list<- list.files()
file_list

file_list2<- lapply(file_list, read.csv)
file_list<- unlist(strsplit(file_list, ".csv"))
names(file_list2)<- file_list
file_list2<- lapply(file_list2, function(x) {x<- data.frame(x$nodiddiss4)})
file_list2<- lapply(file_list2, setNames, nm=c("node"))


	#sapply(names(file_list2), function(x) write.table(file_list2[[x]], 
	#file=paste0(x, ".txt"), col.names=F, row.names=F ))


#other times
setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/node_splits_for_large_ecoregions")

file_list<- list.files()
file_list

string_pattern<- "*.txt"
file_list<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]

file_list2<- lapply(file_list, read.table)
file_list<- unlist(strsplit(file_list, ".txt"))
names(file_list2)<- file_list

Leco<- file_list2
Eco_split<- file_list





		### SPLIT LARGE ECOREGIONS INTO SMALLER PARTS ###
mainDir<- "C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input"
setwd(mainDir)
Eco<- c("Eastern_Guinean_forests","Guinean_forest_savanna_mosaic","Western_Guinean_lowland_forests")

eco<- Eco[1]#change eco
time<- "t1" #change time
leco<- as.data.frame(Leco[2]) #change for different splits (node selection)
leco<- as.vector(leco[,1])
eco_split<- Eco_split[2] #change for different splits (eco split name)

setwd(paste0(mainDir,"/",eco,"/", time)) 

	dir.create(file.path(mainDir,eco,eco_split))
	dir.create(file.path(mainDir,eco,eco_split, time))




#nodes
file_list<- list.files()
file_list

string_pattern<- "nodes_*"
file_list<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]
file_list

file_list2<- lapply(file_list, read.table)
names(file_list2)<- file_list
file_list2<- lapply(file_list2, setNames, nm=c("node", "area"))
file_list2<- lapply(file_list2, function(x) x[(x$node %in% leco),])

sapply(names(file_list2), function(x) write.table(file_list2[[x]], 
	file=paste0(mainDir,"/",eco,"/",eco_split,"/", time,"/",x), 
	col.names=F, row.names=F ))
rm(file_list2)




#distances	
file_list<- list.files()
file_list

string_pattern<- "distances_*"
file_list<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]
file_list

file_list2<- lapply(file_list, read.table)
names(file_list2)<- file_list
file_list2<- lapply(file_list2, setNames, nm=c("from_node", "to_node", "distance"))
file_list2<- lapply(file_list2, function(x) x[(x$from_node %in% leco & x$to_node %in% leco),])

sapply(names(file_list2), function(x) write.table(file_list2[[x]], 
	file=paste0(mainDir,"/",eco,"/",eco_split,"/", time,"/",x), 
	col.names=F, row.names=F ))
rm(file_list2)	



