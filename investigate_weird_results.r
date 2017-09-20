
#################################
### Investigate Weird Results ###
#################################

library(rgdal)

setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/output/node_importances")
Nodes<- read.table("Nodesformap.txt")
Imp<- read.table("Node_importances.txt")
Nodes$change<- Nodes$varPC1-Nodes$varPC0
# write out a new shapefile (including .prj component)

nodes<- readOGR(dsn="C:/Thesis_analysis/Development_corridors/GIS/inputs/flat_file/ecoregions/with_forest_loss", layer="west_africa")

nodes@data<- merge(nodes@data, Imp, by.x= "nodiddiss4", by.y= "Node", all.x= TRUE)

writeOGR(nodes,  dsn="C:/Thesis_analysis/Development_corridors/GIS/inputs/flat_file/ecoregions/with_forest_loss",layer="west_africa_Imp2", driver="ESRI Shapefile")

west_africa