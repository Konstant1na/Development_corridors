

library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(scales)
library(stringr)


##Node importances (lists), "Nimp0" and "Nimp1"
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/t0/node_importance")
file_list<- list.files()
file_list
Nimp0<- lapply(file_list,function(x) read.table(x, h=TRUE))

setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/t1/node_importance")
file_list<- list.files()
file_list
Nimp1<- lapply(file_list,function(x) read.table(x, h=TRUE))







	### 1. PLOT PC VALUES FOR T0 AND T1 (indices data) ###
## load and prepare data 
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/data")
Ind<- read.table("Indices.txt", h=TRUE)
setwd("C:/Thesis_analysis/Development_corridors/species_metadata")
sp<- read.csv("spp_name_id_category_joined.csv", h=TRUE)#species info

df<- merge(Ind, sp, by= "id_no", all.x=TRUE)

dfPC<- filter(df, indice=="PCnum")
dfECA<- filter(df, indice=="EC(PC)")
	#dtEC$binomial<- as.factor(dtEC$binomial)
	
##plot (dfPC or dfECA)
ggplot(dfPC, aes(x=binomial, y=value, fill= time))+ 
	geom_bar(stat="identity",position=position_dodge(width = -1),color="black")+
	coord_flip()+
	theme_minimal()+
	labs(x = "Species", y = "Value", title= "PC in t0 and t1" )+
	theme(plot.title = element_text(color="black", size=14, face="bold.italic", element_text(hjust = 5)))+
	scale_fill_manual(values=c("#006633","#CCC999"), name="PC",labels=c("t0", "t1"))+
	scale_x_discrete(labels = function(x) str_wrap(x, width = 10))
	


	
	
	
	
	### 2. SHOW PERCENTAGE CHANGE OF ECA (indices and node data) ###
## A) ECA percentage change
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/data")
Ind<- read.table("Indices.txt", h=TRUE)

dfPC<- filter(Ind, indice=="PCnum")
dfECA<- filter(Ind, indice=="EC(PC)")

#percentage of ECA change
EC0<- mean(dfECA$value[which(dfECA$time=="t0")]); EC1<- mean(dfECA$value[which(dfECA$time=="t1")])

ECperc<- format(round(((EC1-EC0)/EC0)*100, 1), nsmall = 1)
ECperc


## B) Get nodes and area 
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/data")
Narea<- read.table("NodeArea.txt", h=TRUE)


## C) Get the total node area in t0 and t1
Area0<- sum(Narea$area0)
Area1<- sum(Narea$area0[which(Narea$node1!= "NA")])

#percentage of Patch Area change
Areaperc<- format(round(((Area1-Area0)/Area0)*100, 1), nsmall = 1)
Areaperc


##D) Plot ECA vs patch are change
a<- paste0(round((EC0*100)/Area0, 1), "%")
b<- paste0(round((EC1*100)/Area1, 1), "%")
data<- data.frame(Index=c("ECA", "Area", "ECA", "Area"), time= c( "After", "After","Before","Before"), 
	value= c(EC0, Area0, EC1, Area1), change= c(a, " ", b, " ") )

data2<- data.frame(index=c("ECA", "ECA"), time= c("Before", "After"), value= c(EC0, EC1))
	

	
	
ggplot(data, aes(x=time, y=value, fill= Index, label=change))+ 
	geom_bar(stat="identity",color="black", width= 0.5)+
	geom_text(data=data, aes(x = time, y = value), position = position_stack(vjust = 1.3))+
	theme_minimal()+
	scale_x_discrete(labels= c("Before", "After"))+
	theme(plot.title = element_text(color="black", size=14, face="bold.italic", element_text(hjust = 0.5)),
		axis.line = element_line(colour = "black", size = 0.5, linetype = "solid"),
		panel.grid.major = element_blank(), axis.ticks= element_line(colour="black"), legend.title= element_blank())+
	scale_y_continuous(breaks = seq(0, 250000, 20000))+
	labs(x = "Time", y = "Size (km2)",title= "Change of Patch Area and ECA" )+
	scale_fill_manual(values=c("#BDB76B","#8B1C62"))
	
	
	

ggplot(data2, aes(x=time, y=value, fill= index))+ 
	geom_bar(stat="identity",color="black", width= 0.45)+
	theme_tufle()+
	geom_rangeframe()+
	labs(x = "Time", y = "Value",title= "ECA Change" )+
	#theme(plot.title = element_text(color="black", size=14, face="bold.italic", element_text(hjust = 5)),
		#legend.title=element_blank(),legend.position = c(0.92, 0.65),
		#legend.background = element_rect(fill="white",size=0.7, linetype="solid", colour ="black"))+
	scale_fill_manual(values=c("#BDB76B"))#,"#8B1C62"))

	
	
	
	
	
	
	### 3. WHICH ARE THE MOST IMPORTANT NODES? (node and node importance data) ###
## A) Importance values
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/data")
Nimp<- read.table("NodeImportance.txt", h=TRUE)

NimpS<-  aggregate(varPC0 ~ node, data=Nimp, sum)
NimpM<- aggregate(varPC0 ~ node, data=Nimp, mean)

## B) Create data frame for pie chart
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/data")
Narea<- read.table("NodeArea.txt", h=TRUE)

Imp<- merge(Narea, NimpS, by.x= "node0", by.y= "node", all.y=TRUE)#using sum
Imp<- merge(Narea, NimpM, by.x= "node0", by.y= "node", all.y=TRUE)#using mean

Imp<- Imp [!(is.na(Imp$area0)),]
Imp$node1[which(is.na(Imp$node1))]<- 0

Imp$state[which(Imp$node1!=0)]<- "Not Affected" 
Imp$state[which(Imp$node1==0)]<- "Affected"

# set categorical values based on summary()
# - using sum
Imp$importance[which(Imp$varPC0>-1 & Imp$varPC0<114100)]<- "Low"
Imp$importance[which(Imp$varPC0>= 114100 & Imp$varPC0<2497000)]<- "Moderate"
Imp$importance[which(Imp$varPC0>= 2497000 & Imp$varPC0<828800000)]<- "High"
# - using mean
Imp$importance[which(Imp$varPC0>-1 & Imp$varPC0<74860)]<- "Low"
Imp$importance[which(Imp$varPC0>=74860  & Imp$varPC0<1874000)]<- "Moderate"
Imp$importance[which(Imp$varPC0>=1874000 & Imp$varPC0<290000000)]<- "High"


Imp<- Imp[with(Imp, order(node0)), ]
Imp<- Imp[, c(1,6,7)]; Imp<- unique(Imp)

df<- aggregate(Imp, by= list(Imp$importance, Imp$state), FUN= length)
df<- mutate(group_by(df, Group.2), percent = importance / sum(importance) * 100) %>% ungroup()
df<- group_by(df,Group.2) %>% mutate(percent = (importance/sum(importance))*100)
df$percent<- round(df$percent, 1)
## D) Create pie chart
  
#' x      numeric vector for each slice
#' group  vector identifying the group for each slice
#' labels vector of labels for individual slices
#' col    colors for each group
#' radius radius for inner and outer pie (usually in [0,1])
donuts <- function(x, group = 1, labels = NA, col = NULL, radius = c(.7, 1)) {
  group <- rep_len(group, length(x))
  ug  <- unique(group)
  tbl <- table(group)[order(ug)]

  col <- if (is.null(col))
    seq_along(ug) else rep_len(col, length(ug))
  col.main <- Map(rep, col[seq_along(tbl)], tbl)
  col.sub  <- lapply(col.main, function(x) {
    al <- head(seq(0, 1, length.out = length(x) + 2L)[-1L], -1L)
    Vectorize(adjustcolor)(x, alpha.f = al)
  })

  plot.new()

  par(new = TRUE)
  pie(x, border = NA, radius = radius[2L],
      col = unlist(col.sub), labels = labels)
title("Node Importance")

  par(new = TRUE)
  pie(x, border = NA, radius = radius[1L],
      col = unlist(col.main), labels = NA)
	 legend("topleft", c("Affected", "Not Affected"), cex=0.8, fill=col)
}

with(df,
     donuts(percent, Group.2, sprintf('%s: %s%%', Group.1, percent),
            col = c('red','darkgreen'))
)

## E) Create a bar plot
a<- sum(df$node0[which(df$Group.1== "Low")])
b<- sum(df$node0[which(df$Group.1== "Moderate")])
c<- sum(df$node0[which(df$Group.1== "High")])
d<- sum(df$node0[which(df$Group.1== "Low" & df$Group.2== "Not Affected")])
e<- sum(df$node0[which(df$Group.1== "Moderate" & df$Group.2== "Not Affected")])
f<- sum(df$node0[which(df$Group.1== "High" & df$Group.2== "Not Affected")])

data<- data.frame(Importance= c("Low","Moderate","High","Low","Moderate","High"), 
		Time= c( "After", "After", "After","Before", "Before","Before"), Count= c(b, a, c, e, d, f ))
data<- group_by(data, Time) %>% mutate(Percent = (Count/sum(Count))*100)
data$Percent<- as.factor(round(data$Percent, 1))



ggplot(data, aes(x=Time , y=Count, fill= Importance, label= Percent))+ 
	geom_bar( stat="identity",width= 0.5, colour= "black")+
	scale_fill_manual(values = c("red2", "yellow2", "green4"),labels = c("High", "Moderate", "Low"), name= "Node \nImportance")+
	geom_text(data=data, aes(x = Time, y = Count, label = paste0(Percent,"%")), size=4, position = position_stack(vjust = 0.5))+
	scale_y_continuous(breaks=seq(0,900,150))+
	scale_x_discrete(labels= c("Before", "After"))+
	theme_minimal()+
	theme(plot.title = element_text(color="black", size=14, face="bold.italic", element_text(hjust = 0.5)),
		axis.line = element_line(colour = "black", size = 0.5, linetype = "solid"),
		panel.grid.major = element_blank(), axis.ticks= element_line(colour="black"))+
	labs(title= "Change of Node Number")
	

	



#################   IGNORE  #########################		
	### 4. RELATIONSHIP OF ECA AND STUDY AREA (indices data) ###
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/data")
Ind<- read.table("Indices.txt", h=TRUE)
#t0
dtEC0<- filter(Indt0, indice== "EC(PC)")
meanECA0<- mean(dtEC[,5])
AL<- 22247509 #km2

ECAnorm0 = round(100* (meanECA0/(AL)), 2)
ECAnorm0

#t1
dtEC1<- filter(Indt1, indice== "EC(PC)")
meanECA1<- mean(dtEC1[,5])

ECAnorm1 = round(100* (meanECA1/(AL)),2)
ECAnorm1
#####################################################







	### 5. WHICH SPECIES ARE AFFECTED THE MOST? (node data) ###
## A) Get data and prepare them for plotting
setwd("C:/Thesis_analysis/Development_corridors/conefor/run_1/outputs/data")
Ind<- read.table("Indices.txt", h=TRUE)
setwd("C:/Thesis_analysis/Development_corridors/species_metadata")
sp<- read.csv("spp_name_id_category_joined.csv", h=TRUE)#species info

df<- merge(Ind, sp, by= "id_no", all.x=TRUE)

dfPC<- filter(df, indice=="PCnum")
dfECA<- filter(df, indice=="EC(PC)")

df<- reshape(dfPC, idvar=c("id_no","season", "distance", "probability","indice", "binomial", "category"),
	timevar="time", direction="wide")
df$state<- ifelse(df$value.t0==df$value.t1, "Not Affected", "Affected")


dfsp<- aggregate(df, by= list(df$state, df$category), FUN= length)
dfsp<- mutate(group_by(dfsp, Group.1), percent = state / sum(state) * 100) %>% ungroup()
dfsp$percent<- round(dfsp$percent, 1)
## B) Create pie chart
donuts <- function(x, group = 1, labels = NA, col = NULL, radius = c(.7, 1)) {
  group <- rep_len(group, length(x))
  ug  <- unique(group)
  tbl <- table(group)[order(ug)]

  col <- if (is.null(col))
    seq_along(ug) else rep_len(col, length(ug))
  col.main <- Map(rep, col[seq_along(tbl)], tbl)
  col.sub  <- lapply(col.main, function(x) {
    al <- head(seq(0, 1, length.out = length(x) + 2L)[-1L], -1L)
    Vectorize(adjustcolor)(x, alpha.f = al)
  })

  plot.new()

  par(new = TRUE)
  pie(x, border = NA, radius = radius[2L],
      col = unlist(col.sub), labels = labels)
title("Species")

  par(new = TRUE)
  pie(x, border = NA, radius = radius[1L],
      col = unlist(col.main), labels = NA)
	 legend("topleft", c("Affected", "Not Affected"), cex=0.8, fill=col)
}

with(dfsp,
     donuts(percent, Group.1, sprintf('%s: %s%%', Group.2, percent),
            col = c('yellow','darkgreen'))
)









donuts <- function(x, group = 1, labels = NA, col = NULL, radius = c(.7, 1)) {
  group <- rep_len(group, length(x))
  ug  <- unique(group)
  tbl <- table(group)[order(ug)]

  col <- if (is.null(col))
    seq_along(ug) else rep_len(col, length(ug))
  col.main <- Map(rep, col[seq_along(tbl)], tbl)
  col.sub  <- lapply(col.main, function(x) {
    al <- head(seq(0, 1, length.out = length(x) + 2L)[-1L], -1L)
    Vectorize(adjustcolor)(x, alpha.f = al)
  })

  plot.new()

  pie(x, border = NA, radius = radius[2L],
      col = unlist(col.sub), labels = labels)
title("Species")
	 legend("topleft", c("Affected", "Not Affected"), cex=0.8, fill=col)
}

with(dfsp,
     donuts(distance, Group.1, sprintf('%s: %s%%', Group.2, percent),
            col = c('yellow','darkgreen'))
)















	### 6. MAP OF NODES IN t0 AND t1

library(maps)
library(sp)
library(rgdal)
library(GISTools)
library(ggsn)
library(maptools)



# Nodes	
nodes<- readOGR(dsn="C:/Thesis_analysis/Development_corridors/GIS/inputs/flat_file", layer="Export_Output2")	
nodes<- gBuffer(nodes, byid=TRUE, width=0) 	

nodes@data$id<- rownames(nodes@data)	
Nodes<- fortify(nodes, region= "id")
nodes@data<- merge(nodes@data,Imp, by.x= "nodiddiss2", by.y= "node", all.x= TRUE)
Nodes<- merge(Nodes, nodes@data, by= "id")
	#Nodes$varPC0[which(is.na(Nodes$varPC0))]<- 0

Nodesf<- subset(Nodes, FID_corrid== "-1")
Nodesr<- subset(Nodes, FID_corrid!= "-1")



# Africa
africa<- readOGR(dsn="C:/Thesis_analysis/Development_corridors/GIS/inputs/Africa_SHP", layer= "Africa_WGS84")
Africa<- fortify(africa, region="COUNTRY")
	#Africa<- subset(Africa, long> -18 & long<13 & lat>2 &lat<13)

# Corridors
corridors<- readOGR(dsn="C:/Thesis_analysis/Development_corridors/GIS/inputs/corridors", layer= "CorridorsWSG")
Corridors<- fortify(corridors, region="ORIG_FID")
Corridors<- subset(Corridors,id %in% c("5","6","11", "29") )

# Map
theme_opts <- list(theme(panel.grid.minor = element_blank(),
                             panel.grid.major = element_blank(),
                             panel.background = element_blank(),
                             plot.background = element_blank(),
                             panel.border = element_blank(),
                             axis.line = element_blank(),
                             axis.text.x = element_blank(),
                             axis.text.y = element_blank(),
                             axis.ticks = element_blank(),
                             axis.title.x = element_blank(),
                             axis.title.y = element_blank(),
                             legend.position = c(0.05,0.5),legend.direction = "vertical",
                             plot.title=element_text(face = "bold", size= 15,hjust = 0.5), 
							 legend.title=element_text(face="bold", hjust = .5)))



map<- ggplot(data=Africa, aes(x=long, y=lat, group=group))+
	geom_polygon(colour = "black", size = 0.1, fill = "gray", aes(group = group))+
	geom_polygon(data= Nodes, aes(x=long.x, y=lat.x, group=group, fill= varPC0))+
	geom_polygon(data=Corridors, aes(x=long, y=lat, group=group, alpha=0.3), show.legend = FALSE)+
	#geom_polygon(data=Nodesf, aes(x=long.x, y=lat.x, group=group), colour= "green4",fill ="green4")+
	#geom_polygon(data=Nodesr, aes(x=long.x, y=lat.x, group=group),colour= "red3",fill = "red3")+
	theme_opts+
	scale_fill_gradientn(colours = c("green4", "yellow", "red3"),name= "Patch \nImportance\n",
		breaks=c(15000000,286000000),labels=c("Low", "Hight"),values = rescale(c(0, 0.85,0.93,1)))+
	labs(title = "Developmen Corridors and Importance of Forest Patces In West Africa")+
	guides(colour = guide_legend(nrow = 3))
	
#whole map	
map+coord_fixed(xlim = c(-18,13),ylim = c(2,13))+
	scalebar(location="bottomleft",y.min=2.7, y.max=10, x.min=-17, x.max=11, dist=100, dd2km= TRUE, model='WGS84',st.dist=0.05, st.bottom=TRUE, st.size= 2.7)+
	north(Africa,  location="topright", scale = 0.02, symbol = 3, anchor= c(x= 14, y=13))
#left 
map+coord_fixed(xlim =c(-13.5,0.5),ylim = c(4,11))+
	scalebar(location="bottomleft",y.min=4.7, y.max=10, x.min=-12, x.max=1, dist=50, dd2km= TRUE, model='WGS84',st.dist=0.05, st.bottom=TRUE, st.size= 2.7)+
	north(Africa,  location="topright", scale = 0.008, symbol = 3, anchor= c(x= 1, y=10.5))+
	theme(legend.position = c(0.05,0.35))
#center
map+coord_fixed(xlim = c(0.5,13),ylim = c(2,13))+
	scalebar(location="bottomleft",y.min=4.7, y.max=10, x.min=-12, x.max=1, dist=50, dd2km= TRUE, model='WGS84',st.dist=0.05, st.bottom=TRUE, st.size= 2.7)+
	north(Africa,  location="topright", scale = 0.008, symbol = 3, anchor= c(x= 1, y=10.5))+
	theme(legend.position = c(0.05,0.35))
#right
map+coord_fixed(xlim = c(3.5,12),ylim = c(5,9.5))+
	scalebar(location="bottomright",y.min=5.4, y.max=10, x.min=4, x.max=12, dist=50, dd2km= TRUE, model='WGS84',st.dist=0.05, st.bottom=TRUE, st.size= 2.7)+
	north(Africa,  location="topright", scale = 0.008, symbol = 3, anchor= c(x= 12, y=9.5))+
	theme(legend.position = c(0.05,0.35))
################################


