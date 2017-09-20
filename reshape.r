
library(tools)


################
##Circuitscape##
################

setwd("C:/Users/Konstantina/Desktop/Distance/raw/Circuitscape/Without")


file_list <- list.files()
out_path="C:/Users/Konstantina/Desktop/Distance/Circuitscape/Without"

for (file in file_list){
	
	print (file)
	df<-read.table(file)

	#dt<- strsplit(file,"c")[[1]]
	#dt<-dt[c(FALSE,TRUE,FALSE)]
	#dt<- (dt[[1]])
	#print(dt)
	#dt<-(dt[[2]])
	#dt<-gsub("b", "", dt, ignore.case=FALSE, fixed=FALSE)
	#print (dt)
	#df$id_no<-dt
	
	#colnames(df) [1]<- "to_node_id"
	#colnames(df) [2]<- "from_node_"
	#colnames(df) [3]<- "Dist_CS"
	#head(df)
	
	#a<- strsplit(file,"c")
	#a<- sapply(dt,`[`,2)
	a<- strsplit(file, "_")
	a<-a[c(FALSE,TRUE,FALSE,FALSE)]
	print(a)
	
	df$to_node_id<- paste0(a,df[,1])
	df$from_node_<- paste0(a,df[,2])
	df$link<- paste0(df[,1],"_",df[,2])
	df$link2<- paste0(df[,2],"_",df[,1])
	
	#df<- df[c(1,2,5,6,3,4)]
	#write.table(df,paste0(out_path,"/",file))
 }
 
 
	
 
 setwd("C:/Users/Konstantina/Desktop/Distance/Circuitscape/With")


file_list <- list.files()
out_path="C:/Users/Konstantina/Desktop/Distance/Circuitscape/clean"
 
 
  for (file in file_list){
 
	a<-read.table(file)
	
	colnames(a) [1]<- "to_node_id"
	colnames(a) [2]<- "from_node_"
	colnames(a) [3]<- "Dist_CS"
	head(a)
	
	#dt<- strsplit(file,"c")
	#dt<- sapply(dt,`[`,2)
	#dt<-a[c(FALSE,TRUE,FALSE)]
	#print(dt)
	
	
	#dt<- strsplit(dt,"_")[[1]]
	#dt<- (dt[[1]])
	#dt<-a[c(FALSE,TRUE,FALSE)]
	#print(dt)
	
	
	a$link<- paste0(a[,1],"_",a[,2])
	a$link2<- paste0(a[,2],"_",a[,1])
	
	a<- a[c(1,2,5,6,3,4)]
	
	#write.table(a,paste0(out_path,"/",file))
	}
 
 
 
setwd("C:/Users/Konstantina/Desktop/Distance/Circuitscape/clean")


file_list <- list.files()

file_list
out_path="C:/Users/Konstantina/Desktop/Distance/Circuitscape/merged_tables/"

for (file in file_list){
  print (file)

  if (!exists("dataset")){
    dataset <- read.table(file, header=TRUE)
  }
  if (exists("dataset")){
    temp_dataset <-read.table(file, header=TRUE)
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
 
  }
}

str(dataset)
out_path="C:/Users/Konstantina/Desktop/Distance/merged_tables/"
write.table(dataset,paste0(out_path,"/","merged_tableCS.txt"))


#############
##Euclidean##
#############


in.folder<-("C:/Users/Konstantina/Desktop/Distance/reshape_e")
 
setwd(in.folder)
file_list <- list.files()
out_path="C:/Users/Konstantina/Desktop/Distance/reshape_e2"

for (file in file_list){
	#out_name<-file
	print (file)
	df<-read.table(file)

	dt<- strsplit(file,"E")[[1]]
	print (dt[[1]])
	dt<-(dt[[1]])
	dt<-gsub("b", "", dt, ignore.case=FALSE, fixed=FALSE)
	print (dt)
	df$id_no<-dt
	print (head(df))
	#write.table(df,paste0(out_path,"/",file))
 }
 

 
setwd(out_path) 
getwd()

file_list <- list.files()

file_list

for (file in file_list){
  print (file)

  if (!exists("dataset")){
    dataset <- read.table(file, header=TRUE)
  }
  if (exists("dataset")){
    temp_dataset <-read.table(file, header=TRUE)
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
 
  }
}

str(dataset)
out_path="C:/Users/Konstantina/Desktop/Distance/merged_tables/"
write.table(dataset,paste0(out_path,"/","merged_tableE.txt"))




#####################
#####Final Table#####
#####################


setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables")

CS<- read.table("merged_tableCS.txt", h=T)
E<- read.table("merged_tableE.txt", h=T)

CSnE<- merge(CS,E, by= c("id_no","link_id", "link_id"))

write.table(CSnE, "CSnE.txt")













