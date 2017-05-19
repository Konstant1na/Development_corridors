
library(reshape)
library(plyr)




out_path= "C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/data/"


	
##PC and ECA 
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/t0")
Indt0<- read.table("results_all_overall_indices.txt", h=FALSE)

setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/t1")
Indt1<- read.table("results_all_overall_indices.txt", h=FALSE)

Ind<- merge(Indt0, Indt1, by= c("V1","V2", "V3", "V4"))
colnames(Ind)<- c("id_no","distance","probability", "indice", "t0","t1")
Ind<- melt.data.frame(Ind, id.vars= c("prefix", "distance", "probability", "indice"),variable_name= "time")
Ind<- as.data.frame(Ind) %>% separate(prefix, into = c("id_no", "season"))

	write.table(Ind, paste0(out_path,"Indices.txt"))


	
	

	
##Node importances (lists), "Nimp0" and "Nimp1
# -t0
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/t0/node_importance")
file_list<- list.files()
file_list
Nimp0<- lapply(file_list,function(x) read.table(x, h=TRUE))

nim0<- ldply(Nimp0, data.frame); nim0<- nim0[,c(1,4,8)]
colnames(nim0)<- c("node", "dPC0", "varPC0")

# -t1
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/t1/node_importance")
file_list<- list.files()
file_list
Nimp1<- lapply(file_list,function(x) read.table(x, h=TRUE))

nim1<- ldply(Nimp1, data.frame); nim1<- nim1[,c(1,4,8)]
colnames(nim1)<- c("node", "dPC1", "varPC1")


Imp<- merge(nim0, nim1, by= "node", all= TRUE)
	write.table(Imp, "NodeImportance.txt")


##Node area 
# -t0
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/inputs/t0")
file_list<- list.files()
file_list
string_pattern<- "nodes_*"
Node0<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]

Narea<- lapply(Node0, read.table)
names<- c("node", "area");Narea<- lapply(Narea, setNames, nm=names)
Narea<- ldply(Narea, data.frame); Narea<- unique(Narea); Narea<- Narea[, c(1,2)]

N0<- Narea
# -t1
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/inputs/t1")

file_list<- list.files()
file_list
string_pattern<- "nodes_*"
Node1<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]

Narea1<- lapply(Node1, read.table)
names<- c("node", "area");Narea<- lapply(Narea, setNames, nm=names)
Narea<- ldply(Narea, data.frame); Narea<- unique(Narea); Narea<- Narea[, c(1,2)]

N1<- Narea


Narea<- merge(N0, N1, by= "node")
colnames(Narea)<- c("node", "area0", "area1")

#Nodes
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/inputs/t0")
	# or
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/inputs/t1")

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

Nodes0<- Nodes; Nodes0$node0<- Nodes0$node
Nodes1<- Nodes; Nodes1$node1<- Nodes1$node

# combine nodes and area
NodeArea<- merge(Narea, Nodes0, by="node", all.y=TRUE)
NodeArea<- merge(NodeArea, Nodes1, by="node", all.x=TRUE)

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


