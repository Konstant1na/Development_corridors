
###############################################################
######################## Conefor Data #########################
###############################################################




setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables")

Compl<- read.table("CSnE_info.txt", h=T)

Compl<- Compl[,c(1,3,4,6,10)]




            ###################
            ##Euclidean files##
            ###################

#Distances#

out_path= "C:/Users/Konstantina/Desktop/Distance/Conefor_analysis/data/euclidean"

for (i in unique(Compl$id_no)){

	dt<- subset(Compl, id_no==i)
	dt<- dt[, c(2,3,5)]
	head(dt)
	
	write.table(dt, paste0(out_path,"/","Distances_", i,".txt"), col.names= F,row.names=F)
	
	}


	
	
            ######################
            ##Circuitscape files##
            ######################

#Distances#

out_path= "C:/Users/Konstantina/Desktop/Distance/Conefor_analysis/data/circuitscape"

for (i in unique(Compl$id_no)){

	dt<- subset(Compl, id_no==i)
	dt<- dt[, c(2,3,4)]
	head(dt)
	
	#write.table(dt, paste0(out_path,"/","Distances_", i,".txt"), col.names=F,row.names=F)
	
	}



	
            #####################	
            ####### Nodes #######	
            #####################

library(plyr)
library(microbenchmark)

setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/raw/rasters_and_shp_cells")
out_path= "C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables"


#file_list <- list.files()
#df <- ldply(file_list, read.dbf)
#write.table(df,paste0(out_path,"/dbf_ALL"))

setwd(out_path)

dbf_All<- read.table("dbf_All", h=T)
dbf_All<- dbf_All[,c(4,3,6)]
colnames(dbf_All) [2] <- "from_node_.x"


out_path2= "C:/Users/Konstantina/Desktop/Distance/Conefor_analysis/data/nodes2"
for (i in unique(dbf_All$id_no)){

	a<- subset(dbf_All, id_no==i)
	a<- a[, c(2,3)]
	
	write.table(unique(a),paste0(out_path2, "/","Nodes_", i,".txt"), col.names=F, row.names=F)
}



	

            #####################
            ### Command lines ###
            #####################

setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables")

#Make of Com -> Dataset with all info + dispersal estimates in meters
	#Compl<- read.table("CSnE_info.txt", h=T)
	#Compl<- Compl[,c(1,2,3,4,5,6,10)]

	#Dist<- read.csv("Dispersal_estimates.csv", h=T)
	#Dist<- Dist[,c(5,20)]
	#colnames(Dist) [1]<- "id_no"
	#colnames(Dist) [2]<- "Disp_mean"

	#Com<- merge(Compl, Dist, by="id_no")

	#Com$Disp_mean<- Com$Disp_mean*1000 #get distances into meters
	#write.table(Com,"CSnE_Disp.txt")




	###CONVERT DISPERSAL ESTIMATES INTO OHMS (Load datasets from fitted_lines script)

Com<- read.table("CSnE_Disp.txt", h=TRUE)
	
##all
Com$Disp_mean<- log(Com$Disp_mean) #all_log
Com$Disp_mean<- (Com$Disp_mean-1898)/34479 #all_linear
Com$Disp_mean<- (log(Com$Disp_mean)-10.14)/0.46 #all_exponential

##groups_linear
G1$Disp_mean<- (G1$Disp_mean+44429)/149314#G1
G2$Disp_mean<- (G2$Disp_mean+34423)/52009#G2
G3$Disp_mean<- (G3$Disp_mean+94938)/59731#G3

#groups_exponential
G1$Disp_mean<- (log(G1$Disp_mean)-9.252)/2.274#G1
G2$Disp_mean<- (log(G2$Disp_mean)-8.793)/1.214#G2
G3$Disp_mean<- (log(G3$Disp_mean)-9.181)/0.681#G3

#clear duplicates and merge group datasets
G1$id_no<- factor(G1$id_no);G2$id_no<- factor(G2$id_no);G3$id_no<- factor(G3$id_no)
t1<- table(G1$id_no);t2<- table(G2$id_no);t3<- table(G3$id_no)
G1$id_no<- as.integer(G1$id_no);G2$id_no<- as.integer(G2$id_no);G3$id_no<- as.integer(G3$id_no)
G1<- filter(G1,  ! id_no %in% c("22678883","22681018","22681724","22681782","22681841","22682689","22682860","22682908","22683764","22688944",
"22706553","22707043","22707957","22710791","22713287","22714920","22715090","22715222","22716487","22717733","22717746",
"22718031","22718783","22718787","22718791","22718921","22719083","22719104","22719298","22719558","22727786","22730755"))
G2<- subset(G2,  ! id_no %in% c("22678883","22681782","22682689","22684160","22690628","22706553","22707043","22707957","22708037","22709909",
"22713083","22713213","22713365","22714920","22717733","22718031","22719083","22719104","22719293","22730755","22718791","22681841"))
G3<- subset(G3,  ! id_no %in% c("22681018","22681724","22682860","22688944","22710791","22713287","22715090","22716487","22717746","22718783",
"22718921","22719298","22719558","22727786","22715222"))

Com<- rbind(G1,G2,G3)





#FOR E vs CS: Use Com when running all_data and groups
#but use 'Linear' or 'Exponential' and 'Disp_meanT' when running for IUCNhub, DistC, Order, Family, Genus and uber
#which you get from the fitted_lines script
#FOR CS vs BUFFER: use 'CSnBuf' and change 'Disp_meanT' to 'Disp_meanTL1/Disp_meanTL1.5/Disp_meanTL2'

out_path= "C:/Users/Konstantina/Desktop/Distance/Comparison/Conefor_analysis/command" 					  
setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables")
CSnBuf<- read.table("CSnBuf_T.txt", h=T)

for (i in unique(Com$id_no)){##change here

	dt<- subset(Com, id_no==i)##here
	#print(dt)
	
	a<- unique(dt$Disp_mean)##here
	print(a)
	
	write.table(dt, paste0(out_path,"/", i, "_",a))
	
	}

	
setwd(out_path)

if (file.exists("command_line_cs.csv")) file.remove("command_line_CS.csv")
file_list <- list.files()
file_list


dt<- strsplit(file_list, "_")
a<- lapply(dt, function(x) {paste0("shell('C:/Users/Konstantina/Desktop/Distance/Comparison/Conefor_analysis/data/circuitscape/coneforWin64.exe -nodeFile Nodes_",x[1],".txt -conFile Distances_", x[1],".txt -t dist notall -confProb ",x[2]," 0.36788 -PC -removal -prefix ", x[1],"')")} )

a<- (unlist(lapply(a, paste, collapse=" ")))

write.csv(a, "command_line_E.csv")

	
	

