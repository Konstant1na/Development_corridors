
#####################################################
###############    Split Nodes    ################### 
#####################################################


mainDir<- "C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/"
setwd(mainDir)
eco<- list.files()
eco<- eco[10]
time<- "t1"

setwd(paste0(mainDir,eco,"/clean/",time))
dir.create(file.path(mainDir,eco,paste0("/clean/",time,"_splits")))

file_list<- list.files()
file_list

string_pattern<- "nodes_*"
file_list<- file_list[lapply(file_list, function(x) length(grep(string_pattern, x, value=FALSE))) ==1 ]
file_list

file_list2<- lapply(file_list, read.table)
file_list<- strsplit(file_list, ".txt")
names(file_list2)<- file_list
file_list2<- lapply(file_list2, setNames, nm=c("node", "area"))
file_list2<- mapply(cbind, file_list2, "split"="node", SIMPLIFY=F)
file_list2<- lapply(file_list2, function(x) {x$split<- -1;return(x)})


n<-0
for (i in file_list2){

	#i$split<- -1
	q<- seq(1,nrow(i), 10)	
	n<- n+1
	k<- 0
for(j in q){

	k<- k+1

	if(nrow(i)<= (j+10)) { 
	i$split<- -1
	i$split[j:nrow(i)]<- 1

	write.table(i, paste0(mainDir, eco,"/clean/",time,"_splits/",names(file_list2)[n],"_",k,".txt"),col.names=F, row.names=F )

	}else {
	i$split<- -1
	i$split[j:(j+10)]<- 1

	write.table(i, paste0(mainDir, eco,"/clean/",time,"_splits/",names(file_list2)[n],"_",k,".txt"),col.names=F, row.names=F )

		}	
	}	
	
}


###################################################################################################


### tries###

###for(i in q){

#	k<- k+1
	
	#file_list2<- lapply(file_list2, function(x) {x$split<- -1;return(x)})


	#split<- lapply(file_list2, function(x) {ifelse(nrow(x)< (i+10), x$split[i:nrow(x)]<- 1;return(x),x$split[i:(i+10)]<- 1;return(x))})



	
#split<- sapply(file_list2, function(x) if(nrow(x)<= (i+10)) {x$split[i:nrow(x)]<- 1;return(x)
#											}
#											else {x$split[i:(i+10)]<- 1;return(x)
#																})
												
#	sapply(names(split), function(x) write.table(split[[x]], 
#		file=paste0("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/Central_African_mangroves/new/",x,"_", k,".txt"), 
#		col.names=F, row.names=F ))

#}
#split<- lapply(file_list2, function(x) {if(nrow(x)< (10+10), x$split[10:nrow(x)]<- 1,x$split[10:(i+10)]<- 1)})


