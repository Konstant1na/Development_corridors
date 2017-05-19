


in_path1="C:/Thesis_analysis/Distances_comparison/merged_tables"
in_path2="C:/Thesis_analysis/Development_corridors/distances_raw/t0"
out_path="C:/Thesis_analysis/Development_corridors/conefor/commands"

#get dispersal distances from csv
setwd(in_path1)
Dist<- read.csv("Dispersal_estimates.csv", h=T)
Dist<- Dist[,c(5,20)]
colnames(Dist) [1]<- "id_no"
colnames(Dist) [2]<- "Disp_mean"


#get species ids from node files
setwd(in_path2)

#make list of node and distance files for conefor in the in_path2 folder
file_list <- list.files()

#selecting files for nodes only, based on string recognition
stringPattern="nodes_*"
file_list<-file_list[lapply(file_list,function(x) length(grep(stringPattern,x,value=FALSE))) ==1]
file_list

#keep id_no
file_list2<- lapply(file_list, strsplit, "nodes_")
file_list3<- lapply(file_list2,function(x) mapply(`[`,x,2))
file_list3<- lapply(file_list3, strsplit, ".txt")
file_list3<- lapply(file_list3,function(x) mapply(`[`,x,1))






Com <- paste(Com$suffix, Com$Disp_mean)
Com_list<- as.list(Com)

Com_list<- strsplit(file_list, " ")
a<- lapply(dt, function(x) {paste0("shell('C:/Users/Konstantina/Desktop/Distance/Comparison/Conefor_analysis/data/circuitscape/coneforWin64.exe -nodeFile Nodes_",x[1],".txt -conFile Distances_", x[1],".txt -t dist notall -confProb ",x[2]," 0.36788 -PC -removal -prefix ", x[1],"')")} )

a<- (unlist(lapply(a, paste, collapse=" ")))

write.csv(a, "command_line_E.csv")










b<- mapply(c, file_list, file_list2, SIMPLIFY=FALSE, USE.NAMES=FALSE)

for (file in file_list){
  dt<- strsplit(file,"_")[[1]]#splits string
  dt<-dt[c(FALSE,TRUE,FALSE)]#chooses certain part to keep
  print (dt)
  id_list<-append(id_list, dt)
  suffix<-append(suffix,gsub("nodes_", "", file))
  print (suffix)
  suffix<-gsub(".txt", "", suffix)
}

id_list<-data.frame(cbind(id_list,suffix))
id_list<- as.list(id_list)


for (i in unique(id_list$id_no)){##change here

	dt<- subset(Com, id_no==i)##here
	#print(dt)
	
	a<- unique(dt$Disp_mean)##here
	print(a)
	
	write.table(dt, paste0(out_path,"/", i, "_",a))
	
	}



