


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

#opening vector lists up
suffix=c()
id_list=c()

#getting id_no (speceis id) from filename - this should be embedded in the filename string somehow 
#seperated by underscores - tweak the TRUE/ FALSE parameters accordingly
for (file in file_list){
  dt<- strsplit(file,"_")[[1]]#splits string
  dt<-dt[c(FALSE,TRUE,FALSE)]#chooses certain part to keep
  print (dt)
  id_list<-append(id_list, dt)
  suffix<-append(suffix,gsub("nodes_", "", file))
  print (suffix)
  suffix<-gsub(".txt", "", suffix)
}


#view ouptuts
suffix# should contain species ID and Season including ".txt" at the end
id_list# shoudl jsut be species ID

#make a dataframe from the vectors bt column binding 
id_list<-data.frame(cbind(id_list,suffix))
#name columns
names(id_list)<-c("id_no","suffix")

#view datframe structure
str(id_list)

#inner join of dataframe with distnace CSV, based on the species id (id_no) 
Com<- merge(id_list, Dist, by="id_no")
str(Com)



#######################
#make Com a list with elements contaning suffix and diseprsal mean
Com <- as.character(paste0(Com$suffix, ",", Com$Disp_mean))
Com_list<- as.list(Com)
Com_list<-  lapply(Com_list, strsplit, ",")

#write command 
a<- lapply(Com_list, function(x) {paste0("shell('C:/Thesis_analysis/Development_corridors/conefor/data/t0/conefor_1_0_86_bcc_x86.exe -nodeFile nodes_",x[1],".txt -conFile distances_", x[1],".txt -t dist notall -confProb ",x[2]," 0.36788 -PC -nodetypes -prefix ", x[1],"')")})
a<- (unlist(lapply(a, paste, collapse=" ")))

write.csv(a, paste0(out_path,"/","command_line_t0.csv"))
#######################






# comparing row numbers before and after - a simple check to find how many files have been dropped due to missing diseprsal links (no matching IDs)
missed_joins=length(id_list[,1])-length(Com[,1])
missed_joins
###N.B. if more missing_joins is >0 then invsetigate using outerjoins to see which ones and find their dispersal distances

#not sure what this does
# for (i in unique(Com$id_no)){
#   
#   dt<- subset(Com, id_no==i)
#   print(dt)
#   a<- unique(dt$Disp_mean)
#   print(a)
#   write.table(dt, paste0(out_path,"/", i, "_",a))
# }

conversion<-1000

x<-Com
###test on first row
i=1
test<-paste0("shell('C:/Thesis_analysis/Development_corridors/distances/t0/conefor_1_0_86_bcc_x86.exe -nodeFile nodes_",x[i,2],".txt -conFile distances_", x[i,2],".txt -t dist notall -confProb ",x[i,3]*conversion," 0.36788 -PC -nodetypes -prefix ", x[i,2],"')")  
test<-paste0("shell('C:/Thesis_analysis/Development_corridors/distances/t1/conefor_1_0_86_bcc_x86.exe -nodeFile nodes_",x[i,2],".txt -conFile distances_", x[i,2],".txt -t dist notall -confProb ",x[i,3]*conversion," 0.36788 -PC -nodetypes -prefix ", x[i,2],"')")  

test

#shell('C:/Data/cci_connectivity/scratch/conefor_runs/inputs/test/conefor_1_0_86_bcc_x86.exe -nodeFile nodes_22681782_1.txt -conFile distances_22681782.txt -t dist notall -confProb 787.011729 0.36788 -PC -nodetypes -prefix 22681782_1')

command_list=c()
nodeCount=c()



#loop through and make commands based on dataframe
for (i in 1:length(Com[,1])){
  count<-length(read.table(paste0("nodes_",x[i,2],".txt"))[,1])
  #if (length(nodeList[,1])<1000){
  line<-paste0("shell('C:/Thesis_analysis/Development_corridors/conefor/data/t0/conefor_1_0_86_bcc_x86.exe -nodeFile nodes_adj_",x[i,2],".txt -conFile distances_", x[i,2],".txt -t dist notall -confProb ",x[i,3]*conversion," 0.36788 -PC -prefix ", x[i,2],"')")  
  print (line)
  print (count)    
  nodeCount<-append(nodeCount,count)
  command_list<-append(command_list,line)
  #} else { 
   # print("too many nodes, skipping")
  #}
}


command_dframe<-data.frame(cbind(command_list,nodeCount))
command_dframe

write.csv(command_dframe, paste0(out_path, "/","command_line_t0.csv"),col.names=F, row.names=F )

