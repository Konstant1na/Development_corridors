
#####################################################
#######  Calculating Time for Running on HPC  #######
#####################################################


setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/metadata")

calc<- read.table("calculations.txt", header=FALSE)
names(calc)<- c("count", "disp_mean", "hours", "min", "sec")

calc$size<- calc$count+calc$disp_mean
calc$time<- (calc$hours*60)+ calc$min+ 1


summary(lm(log(calc$time)~calc$size))
z <- nls(time ~ I(exp(1)^(a + size*b)), data = calc, start = list(a=-0.4, b=0.05), trace=TRUE)





library(plyr)
library(tidyr)


setwd("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/metadata")

file_list<- list.files()

stringPattern="*.csv"
file_list<-file_list[lapply(file_list,function(x) length(grep(stringPattern,x,value=FALSE))) ==1]
file_list

file_list2<- lapply(file_list, read.csv, header=TRUE)
file_list2<- lapply(file_list2, function(x) {x$size<- x$count+x$Disp_mean;return(x)})

file_list2<- lapply(file_list2, function(x) {x$time<- as.numeric((0.0003*(x$size^2)) - (0.147*x$size) + 11.123)/60  ;return(x)})#polynomial
file_list2<- lapply(file_list2, function(x) {x$time<- (0.6672*exp(1)^(0.0046*(x$size)))/60  ;return(x)})#exponential

file_list2<- lapply(file_list2, function(x) replace(x,x<0, 1))

#file_list2<- lapply(file_list2, function(x)  within(x, hours<- as.numeric(do.call('rbind', strsplit(as.character(x$time),".",fixed=TRUE)))))
file_list2<- lapply(file_list2, function(x) {x$time<- (format(round(x$time, 2), nsmall=2, scientific=FALSE));return(x)})
file_list3<- lapply(file_list2, function(x) {x$time<- as.character(x$time);return(x)})

file_list3<- lapply(file_list3, function(x) separate(x,time, into = c("hours", "mins"), sep = "\\."))
file_list3<- lapply(file_list3, function(x) {x$hours<- as.numeric(x$hours);return(x)})
file_list3<- lapply(file_list3, function(x) {x$mins<- as.numeric(x$mins);return(x)})

names(file_list2)<- file_list

sapply(names(file_list2), function(x) write.table(file_list2[[x]], 
	file=paste0("C:/Thesis_analysis/Development_corridors/conefor/ecoregions/metadata/",x,".txt"),  row.names=F ))







