
library(reshape)
library(plyr)
library(dplyr)
library(tidyr)


out_path= "C:/Thesis_analysis/Development_corridors/conefor/ecoregions/output/West_Sudanian_savanna/"


	
##PC and ECA 
setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/output/West_Sudanian_savanna/t1")
Indt1<- read.table("results_all_overall_indices.txt", h=FALSE)

setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/output/West_Sudanian_savanna/t2")
Indt2<- read.table("results_all_overall_indices.txt", h=FALSE)

Ind<- merge(Indt1, Indt2, by= c("V1","V2", "V3", "V4"))
colnames(Ind)<- c("prefix","distance","probability", "indice", "t1","t2")
Ind<- melt.data.frame(Ind, id.vars= c("prefix", "distance", "probability", "indice"),variable_name= "time")
Ind<- as.data.frame(Ind) %>% separate(prefix, into = c("id_no", "season"))

	write.table(Ind, paste0(out_path,"Indices.txt"))


	
	

	
##Node importances (lists), "Nimp0" and "Nimp1
# -t1
setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/output/West_Sudanian_savanna/t1/node_importances")
file_list<- list.files()
file_list
Nimp1<- lapply(file_list,function(x) read.table(x, header=TRUE, fill = TRUE))

nim1<- ldply(Nimp1, data.frame); nim1<- nim1[,c(1,4,8)]
colnames(nim1)<- c("node", "dPC1", "varPC1")

# -t2
setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/output/West_Sudanian_savanna/t2/node_importances")
file_list<- list.files()
file_list
Nimp2<- lapply(file_list,function(x) read.table(x, header=TRUE, fill = TRUE))

nim2<- ldply(Nimp2, data.frame); nim2<- nim2[,c(1,4,8)]
colnames(nim2)<- c("node", "dPC2", "varPC2")


Imp<- merge(nim1, nim2, by= "node", all= TRUE)
	write.table(Imp, paste0(out_path,"NodeImportance.txt"))


##Node area 
# -t1
setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/West_Sudanian_savanna/t1")
file_list<- list.files()
file_list
string_pattern<- "nodes_*"
Node1<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]

Narea<- lapply(Node1, read.table)
names<- c("node", "area");Narea<- lapply(Narea, setNames, nm=names)
Narea<- ldply(Narea, data.frame); Narea<- unique(Narea); Narea<- Narea[, c(1,2)]

N1<- Narea
# -t2
setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/West_Sudanian_savanna/t2")

file_list<- list.files()
file_list
string_pattern<- "nodes_*"
Node2<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]

Narea2<- lapply(Node2, read.table)
names<- c("node", "area");Narea<- lapply(Narea2, setNames, nm=names)
Narea<- ldply(Narea, data.frame); Narea<- unique(Narea); Narea<- Narea[, c(1,2)]

N2<- Narea


Narea<- merge(N1, N2, by= "node")
colnames(Narea)<- c("node", "area1", "area2")

#Nodes
setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/West_Sudanian_savanna/t1")
	# or
setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/West_Sudanian_savanna/t2")

file_list<- list.files()
file_list
string_pattern<- "distances_*"
Nodes<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]

Nodes<- lapply(Nodes, read.table)
Nodes<- ldply(Nodes, data.frame)
NodesR<- Nodes[, c(2,1,3)]
Nodes<- rbind(Nodes, NodesR)
Nodes<- Nodes[, c(1,3)]
Nodes<- data.frame(unique(Nodes[,1]))
colnames(Nodes)<- "node"

Nodes1<- Nodes; Nodes1$node1<- Nodes1$node
Nodes2<- Nodes; Nodes2$node2<- Nodes2$node

# combine nodes and area
NodeArea<- merge(Narea, Nodes1, by="node", all.y=TRUE)
NodeArea<- merge(NodeArea, Nodes2, by="node", all.x=TRUE)

NodeArea<- NodeArea[, c(4,5,2,3)]

	write.table(NodeArea, paste0(out_path,"NodeArea.txt"))




## Node area and ECA for each species









## Protected Areas
# -t0
setwd("")
file_list<- list.files()
file_list
string_pattern<- "nodes_*"
Node0<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]

Node0<- lapply(Node0, read.table)
names<- c("node", "area", "wdpa");Node0<- lapply(Node0, setNames, nm=names)
Node0<- ldply(Node0, data.frame); Node0<- unique(Node0)
Node0<- Node0[which(Node0$wdpa== "1")]; Node0<- Node0[,c(1,2)]

# -t1
setwd("")
file_list<- list.files()
file_list
string_pattern<- "nodes_*"
NodHe1<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]

Node1<- lapply(Node1, read.table)
names<- c("node", "area", "wdpa");Node1<- lapply(Node1, setNames, nm=names)
Node1<- ldply(Node1, data.frame); Node1<- unique(Node1)
Node1<- Node1[which(Node1$wdpa== "1")]; Node1<- Node1[,c(1,2)]



############################################


