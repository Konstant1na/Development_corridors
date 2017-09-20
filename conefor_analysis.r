
###############################################
############    Conefor_analysis   ############
###############################################

library(ggplot2)
library(dplyr)


####E vs CS
setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/Conefor_analysis/results/EvsCS/uber_linear")#change folder to compare

CS<- read.table("results_all_overall_indices_CS.txt", h=F)
colnames(CS) [1]<- "id_no"
colnames(CS) [2]<- "Disp_mean"
colnames(CS) [3]<- "ConfProb"
colnames(CS) [4]<- "Index"
colnames(CS) [5]<- "Value_CS"

E<- read.table("results_all_overall_indices_E.txt", h=F)
colnames(E) [1]<- "id_no"
colnames(E) [2]<- "Disp_mean"
colnames(E) [3]<- "ConfProb"
colnames(E) [4]<- "Index"
colnames(E) [5]<- "Value_E"

E<- subset(E, E[,4]=="PCnum")
CS<- subset(CS, CS[,4]=="PCnum")

CS_E<- merge(CS, E, by= "id_no")
CS_E<- CS_E[c(1:5,9)]
CS_E$difPC<- CS_E[,5]-CS_E[,6]
CS_E$id_no<- as.factor(CS_E$id_no)

i<- getwd()
i<- strsplit(i, "/"); i<- unlist(i); i<- i[10]

ggplot(CS_E, aes(x=id_no, y=difPC))+ geom_bar(stat="identity")+ coord_flip()+  ggtitle(i)


# Paired t-test
t.test(CS_E$Value_CS,CS_E$Value_E,paired=TRUE)
plot(CS_E$Value_CS,CS_E$Value_E)


# Affected species

setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables")

sp<- read.table("Uber_54Species_list.txt", h=TRUE)

sp_all<- filter(sp, num== 22710791| num== 22688944| num== 22683764)
sp_log<- filter(sp, num== 22719558| num== 22717733| num== 22713287| num== 22707043)
sp_family<- filter(sp, num== 22707043| num== 22682689| num== 22719083)
sp_uber<- filter(sp, num== 22717733| num== 22707043| num== 22682689| num== 22713287)
sp_groups<- filter(sp, num== 22707043| num== 22717733| num== 22719558)


##### CS vs Buffers
setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/Conefor_analysis/results/CSvsBuffer/Exponential2")#change folder to compare

CS<- read.table("results_all_overall_indices_CS.txt", h=F)
colnames(CS) [1]<- "id_no"
colnames(CS) [2]<- "Disp_mean"
colnames(CS) [3]<- "ConfProb"
colnames(CS) [4]<- "Index"
colnames(CS) [5]<- "Value_CS"

Buf<- read.table("results_all_overall_indices_Buf.txt", h=F)
colnames(Buf) [1]<- "id_no"
colnames(Buf) [2]<- "Disp_mean"
colnames(Buf) [3]<- "ConfProb"
colnames(Buf) [4]<- "Index"
colnames(Buf) [5]<- "Value_Buf"

Buf<- subset(Buf, Buf[,4]=="PCnum")
CS<- subset(CS, CS[,4]=="PCnum")

CS_Buf<- merge(CS, Buf, by= "id_no")




# Paired t-test
T<- t.test(CS_Buf$Value_CS,CS_Buf$Value_Buf,paired=TRUE)
#a<-capture.output(T, file=NULL, append=F)
#plot(CS_Buf$Value_CS,CS_Buf$Value_Buf)
#write.table(a, "yo.txt")











