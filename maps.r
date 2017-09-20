

##########################################
#############     Maps      ##############
##########################################



library(maps)
library(sp)
library(rgdal)
library(GISTools)
library(ggplot2)
library(ggsn)
library(maptools)
library(scales)


# Nodes	
nodes<- readOGR(dsn="C:/Thesis_analysis/Development_corridors/GIS/inputs/flat_file/hansenNew_eco_20km_passNew_kba_corr_floss1_wgs84", layer="hansenNew_eco_20km_passNew_kba_corr_floss1_WAfrica_wgs84")	
nodes<- gBuffer(nodes, byid=TRUE, width=0) 	

	
# Node Importance data
setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/output/node_importances")
Imp<- read.table("Node_importances.txt")

nodes@data$id<- rownames(nodes@data)	
Nodes<- fortify(nodes, region= "id")
nodes@data<- merge(nodes@data,Imp, by.x= "nodiddiss4", by.y= "Node", all.x= TRUE)
Nodes<- merge(Nodes, nodes@data, by= "id")


#Manipulate data

	#setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/input/")
	#eco<- list.files()
	#eco<- as.matrix(eco)
	#eco<- gsub("_", " ",eco)
eco<- c("Central African mangroves", "Cross Niger transition forests", "Cross Sanaga Bioko coastal forests", "Eastern Guinean forests", 
		"Guinean forest savanna mosaic", "Guinean mangroves", "Guinean montane forests", "Niger Delta swamp forests",
		"West Sudanian savanna", "Western Guinean lowland forests")

Nodes2<- Nodes
		
Nodes2<- Nodes[(Nodes$ECO_NAME %in% eco),]
Nodes2$varPC0[is.na(Nodes2$varPC0)]<- 1
Nodes2$varPC1[is.na(Nodes2$varPC1)]<- 1
Nodes2$change<- Nodes2$varPC1-Nodes2$varPC0

Nodes2$change[which(Nodes2$varPC0==1)]<- "NA"
Nodes2$change[which(Nodes2$varPC1==0)]<- 0

Nodes2$change2[which(Nodes2$varPC0==Nodes2$varPC1)]<- "No Change"
Nodes2$change2[which(Nodes2$change>0)]<- "Increased Importance"
Nodes2$change2[which(Nodes2$change=="NA")]<- "No Data"
Nodes2$change2[which(Nodes2$FID_loss_o!=-1)]<- "Lost Forest"
Nodes2$change2[which(Nodes2$change<0)]<- "Decreased Importance"


Nodes2$forestloss[which(Nodes2$FID_loss_o!=-1)]<- "Lost Forest"
Nodes2$forestloss[which(Nodes2$FID_loss_o==-1)]<- "Forest"

# Africa
africa<- readOGR(dsn="C:/Thesis_analysis/Development_corridors/GIS/inputs/Africa_SHP", layer= "Africa_WGS84")
Africa<- fortify(africa, region="COUNTRY")
	
# Ecoregions
ecoregions<- readOGR(dsn="C:/Thesis_analysis/Development_corridors/GIS/inputs/official_teow/official", layer= "wwf_terr_ecos_africa_wgs84")
	
	
# Corridors
corridors<- readOGR(dsn="C:/Thesis_analysis/Development_corridors/GIS/inputs/corridors", layer= "CorridorsWSG")
Corridors<- fortify(corridors, region="ORIG_FID")
Corridors<- subset(Corridors,id %in% c("5","6","11", "29") )

# Map theme
theme_opts <- list(theme(panel.grid.minor = element_blank(),
                             panel.grid.major = element_blank(),
                             panel.background = element_blank(),
                             plot.background = element_rect(fill = "lightblue", colour = 'black'),
                             panel.border = element_blank(),
                             axis.line = element_blank(),
                             axis.text.x = element_blank(),
                             axis.text.y = element_blank(),
                             axis.ticks = element_blank(),
                             axis.title.x = element_blank(),
                             axis.title.y = element_blank(),
                             legend.position = c(0.07,0.35),legend.direction = "vertical",
							 legend.text=element_text(size=8),legend.key.size =  unit(0.3, "in"),
                             plot.title=element_text(face = "bold", size= 15,hjust = 0.5), 
							 legend.title=element_text(face="bold", hjust = .5, size= 10)))

colsImp <- c("No Data" = "grey47", "Lost Forest" = "yellow1", "Decreased Importance" = "red", 
		"Increased Importance" = "darkgreen", "No Change" = "palevioletred2")
		
colsCont<- c("Lost Forest"= "yellow1", "Forest"= "darkgreen")




### Africa ###

map<- ggplot(data=Africa, aes(x=long, y=lat, group=group))+
	geom_polygon(colour = "black", size = 0.1, fill = "grey91", aes(group = group))+
	geom_polygon(data= Nodes2, aes(x=long, y=lat, group=group, fill= forestloss))+
	theme_opts+
	scale_fill_manual(values=colsCont)+
	theme(legend.position="none")

#ggsave("africa.tiff",plot= map, dpi = 400,  
	#path ="C:/Users/Kspil/Documents/Studies/Nature Managment KU/2nd Year/Thesis Project/Presentations/INC_August2017")





### Before and After ###

map<- ggplot(data=Africa, aes(x=long, y=lat, group=group))+
	geom_polygon(colour = "black", size = 0.1, fill = "grey91", aes(group = group))+
	geom_polygon(data= Nodes2, aes(x=long, y=lat, group=group, fill= forestloss))+
	theme_opts+
	scale_fill_manual(values=colsCont, name= "Lost Forest (2000-2014) \n \n")

	#whole map	
a<- map+coord_fixed(xlim = c(-15.8,11.2),ylim = c(-0.75,12.4))+
	scalebar(location="bottomleft",y.min=0, y.max=9, x.min=-10, x.max=11, dist=100, dd2km= TRUE, model='WGS84',st.dist=0.05, st.bottom=TRUE, st.size= 2.7)+
	north(Africa,  location="topright", scale = 0.02, symbol = 1, anchor= c(x= 10, y=12))+
	theme(legend.position = c(0.1,0.35))
	
	#left 
map+coord_fixed(xlim =c(-16,0.5),ylim = c(3.8,12.6))+
	scalebar(location="bottomleft",y.min=4.2, y.max=10, x.min=-12, x.max=1, dist=50, dd2km= TRUE, model='WGS84',st.dist=0.05, st.bottom=TRUE, st.size= 2.7)+
	north(Africa,  location="topright", scale = 0.011, symbol = 1, anchor= c(x= 0.5, y=12.6))+
	theme(legend.position = c(0.095,0.32))
	
	#right
map+coord_fixed(xlim = c(1.65,11.7),ylim = c(-0.6,8.3))+
	scalebar(location="bottomright",y.min=-0.3, y.max=5, x.min=3, x.max=5, dist=50, dd2km= TRUE, model='WGS84',st.dist=0.05, st.bottom=TRUE, st.size= 2.7)+
	north(Africa,  location="topright", scale = 0.011, symbol = 1, anchor= c(x= 11.4, y=0.4))+
	theme(legend.position = c(0.15,0.35))	

ggsave("study area.tiff",plot= a, dpi = 400,  
	path ="C:/Users/Kspil/Documents/Studies/Nature Managment KU/2nd Year/Thesis Project/Presentations/INC_August2017")
ggsave(filename = "exp_map3.png",
       plot = a, width = 6.7, height = 7, path = "C:/Users/Kspil/Documents/Studies/Nature Managment KU/2nd Year/Thesis Project/Presentations/INC_August2017",
       scale = 2, dpi = 600, units= "cm")
	
	
### Mean Importance(varPC) Change ###

map<- ggplot(data=Africa, aes(x=long, y=lat, group=group))+
	geom_polygon(colour = "black", size = 0.1, fill = "grey91", aes(group = group))+
	geom_polygon(data= Nodes2, aes(x=long, y=lat, group=group, fill= change2))+
	theme_opts+
	scale_fill_manual(values=colsImp, name= "Lost Forest (2000-2014) \n \n")
	
	#whole map	
map+coord_fixed(xlim = c(-15.8,11.2),ylim = c(-0.75,12.4))+
	scalebar(location="bottomleft",y.min=0, y.max=9, x.min=-10, x.max=11, dist=100, dd2km= TRUE, model='WGS84',st.dist=0.05, st.bottom=TRUE, st.size= 2.7)+
	north(Africa,  location="topright", scale = 0.02, symbol = 1, anchor= c(x= 10, y=12))+
	theme(legend.position = c(0.1,0.35))
	
	#left 
map+coord_fixed(xlim =c(-16,0.5),ylim = c(3.8,12.6))+
	scalebar(location="bottomleft",y.min=4.2, y.max=10, x.min=-12, x.max=1, dist=50, dd2km= TRUE, model='WGS84',st.dist=0.05, st.bottom=TRUE, st.size= 2.7)+
	north(Africa,  location="topright", scale = 0.011, symbol = 1, anchor= c(x= 0.5, y=12.6))+
	theme(legend.position = c(0.095,0.32))
	
	#right
map+coord_fixed(xlim = c(1.65,11.7),ylim = c(-0.6,8.3))+
	scalebar(location="bottomright",y.min=-0.3, y.max=5, x.min=3, x.max=5, dist=50, dd2km= TRUE, model='WGS84',st.dist=0.05, st.bottom=TRUE, st.size= 2.7)+
	north(Africa,  location="topright", scale = 0.011, symbol = 1, anchor= c(x= 11.4, y=0.4))+
	theme(legend.position = c(0.15,0.35))	
	