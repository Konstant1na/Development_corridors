

#############################################
########### Models CS vs Buffers ############
#############################################


library(Hmisc)
library(stats)
library(plyr)
library(dplyr)
library(nls2)


							###### All DATA ######
					  
setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables")

CSnBuf<- read.table("CSnBuf.txt", h=T)

##LINEAR MODEL
fit1<- lm(effectDist2~Dist_CS, CSnBuf)
plot(CSnBuf$Dist_CS, CSnBuf$effectDist1)
abline(fit1, col= "red")
lines(CSnBuf$effectDist2, CSnBuf$Dist_CS^fit1$coefficient[1], col="red",lwd=4)
summary(fit1)

#add transformations
CSnBuf$Disp_meanTL1<- (CSnBuf$Disp_mean - fit1$coefficient[1])/fit1$coefficient[2]
CSnBuf$Disp_meanTL1.5<- (CSnBuf$Disp_mean - fit1$coefficient[1])/fit1$coefficient[2]
CSnBuf$Disp_meanTL2<- (CSnBuf$Disp_mean - fit1$coefficient[1])/fit1$coefficient[2]


##EXPONENTIAL MODEL 
summary(lm(log(effectDist1.5)~Dist_CS, CSnBuf))

C2<- nls(effectDist1.5 ~ I(exp(1)^(a + b * Dist_CS)), data = CSnBuf, start = list(a = 9,b = 0.8), trace = T)
summary(C2)

RSS.e <- sum(residuals(C2)^2)
TSS <- sum((CSnBuf$effectDist1.5 - mean(CSnBuf$effectDist1.5))^2)
R2 <- 1 - (RSS.e/TSS)

plot(CSnBuf$Dist_CS,CSnBuf$effectDist1.5)
r <- range(CSnBuf$Dist_CS)
xNew <- seq(r[1],r[2],length.out = 200)
yNew <- predict(C2,list(Dist_CS = xNew))
lines(xNew,yNew, col="red")

#add new transformations
coeff<- coef(C2)
CSnBuf$Disp_meanTE1<- (log(CSnBuf$Disp_mean) - coeff[2])/coeff[1]
CSnBuf$Disp_meanTE1.5<- (log(CSnBuf$Disp_mean) - coeff[2])/coeff[1]
CSnBuf$Disp_meanTE2<- (log(CSnBuf$Disp_mean) - coeff[2])/coeff[1]



#create dataset with transformed dispersal estimates
colnames(CSnBuf) [2]<- "id_no" ; CSnBuf<- CSnBuf[-c(9:12)] 
write.table(CSnBuf, "CSnBuf_T.txt")













