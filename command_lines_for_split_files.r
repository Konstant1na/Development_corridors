


in_path1="C:/Thesis_analysis/Distances_comparison/merged_tables"
in_path2="C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/Eastern_Guinean_forests/Eastern_Guinean_forests_2/t1_splits"
out_path="C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/Eastern_Guinean_forests/Eastern_Guinean_forests_2/t1_splits"

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
#file_list

#opening vector lists up
suffix=c()
id_list=c()

#getting id_no (speceis id) from filename - this should be embedded in the filename string somehow 
#seperated by underscores - tweak the TRUE/ FALSE parameters accordingly
for (file in file_list){
  dt<- strsplit(file,"_")[[1]]#splits string
  dt<-dt[c(FALSE,TRUE,FALSE)]#chooses certain part to keep
  #print (dt)
  id_list<-append(id_list, dt)
  suffix<-append(suffix,gsub("nodes_", "", file))
  #print (suffix)
  suffix<-gsub(".txt", "", suffix)
}


#view ouptuts
#suffix# should contain species ID and Season including ".txt" at the end
#id_list# shoudl jsut be species ID

#make a dataframe from the vectors bt column binding 
id_list<-data.frame(cbind(id_list,suffix))
#name columns
names(id_list)<-c("id_no","suffix")

#view datframe structure
#str(id_list)

#inner join of dataframe with distnace CSV, based on the species id (id_no) 
Com<- merge(id_list, Dist, by="id_no")
#str(Com)

Com$prefix<- gsub("_[0-9]*$","",Com$suffix)

# comparing row numbers before and after - a simple check to find how many files have been dropped due to missing diseprsal links (no matching IDs)
#missed_joins=length(id_list[,1])-length(Com[,1])
#missed_joins
###N.B. if more missing_joins is >0 then invsetigate using outerjoins to see which ones and find their dispersal distances


conversion<-1000

x<-Com

command_list=c()
nodeCount=c()



#loop through and make commands based on dataframe
for (i in 1:length(Com[,1])){
  count<-length(read.table(paste0("nodes_",x[i,2],".txt"))[,1])
  #if (length(nodeList[,1])<1000){
  line<-paste0("-nodeFile nodes_",x[i,2],".txt -conFile distances_", x[i,4],".txt -t dist notall -confProb ",x[i,3]*conversion," 0.36788 -PC -nodetypes -prefix ", x[i,2])  
 # print (line)
 # print (count)    
  nodeCount<-append(nodeCount,count)
  command_list<-append(command_list,line)
  
  # write.table(line, paste0(out_path, "/","command_line_",x[i,2]),col.names=F, row.names=F, quote = FALSE)
}


command_dframe<-data.frame(cbind(command_list))
#command_dframe

	
 write.table(command_dframe, paste0(out_path, "/","command_line.txt"),col.names=F, row.names=F, quote = FALSE)

 
  
  
#####################################################################