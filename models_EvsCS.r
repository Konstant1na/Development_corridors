
#######################################
########### Models E vs CS ############
#######################################


library(Hmisc)
library(stats)
library(plyr)
library(dplyr)
library(nls2)





                      ###### All DATA ######
					  
setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables")

Com<- read.table("CSnE_Disp.txt", h=T)
				  

##LINEAR MODEL
fit1<- lm(Dist_E~Dist_CS, Com)
plot(Com$Dist_CS, Com$Dist_E)
abline(fit1, col= "red")
lines(Com$Dist_E, Com$Dist_CS^fit1$coefficient[2], col="red",lwd=4)
summary(fit1)

##EXPONENTIAL MODEL R2 = 0.36
summary(lm(log(Dist_E)~Dist_CS, Com))

C2<- nls(Dist_E ~ I(exp(1)^(a + b * Dist_CS)), data = Com, start = list(a = 9,b = 0.8), trace = T)
summary(C2)

RSS.e <- sum(residuals(C2)^2)
TSS <- sum((Com$Dist_E - mean(Com$Dist_E))^2)
R2 <- 1 - (RSS.e/TSS)

plot(Com$Dist_CS,Com$Dist_E)
r <- range(Com$Dist_CS)
xNew <- seq(r[1],r[2],length.out = 200)
yNew <- predict(C2,list(Dist_CS = xNew))
lines(xNew,yNew, col="red")





                       ###### GROUPS ######
					   
setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables")

Com<- read.table("CSnE_Disp.txt", h=T)					   
					   
					   
G1<- filter(Com, Dist_CS<0.4 & Dist_E>0 | Dist_CS < 0.5 & Dist_E > 8000 |  Dist_CS< 0.7 & Dist_E> 18000 |
			Dist_CS< 0.8 & Dist_E > 38000|Dist_CS< 0.9 & Dist_E > 40000 | Dist_CS < 1.1 & Dist_E > 60000 |
			Dist_CS< 1.2 & Dist_E> 80000 | Dist_CS<1.3 & Dist_E> 90000)		  

G2<- filter(Com,  Dist_CS > 0.5 & Dist_E < 8000 |  Dist_CS> 0.7 & Dist_E< 18000 |
			Dist_CS> 0.8 & Dist_E < 38000|Dist_CS> 0.9 & Dist_E < 40000 | Dist_CS > 1.1 & Dist_E < 60000 |
			Dist_CS> 1.2 & Dist_E< 80000 | Dist_CS>1.3 & Dist_E< 90000);G2<- filter(G2, Dist_CS< 1.5 & Dist_E>10000|
			Dist_CS<1.7 & Dist_E> 20000| Dist_CS<1.9 & Dist_E> 40000|Dist_CS<2.1 & Dist_E> 60000|
			Dist_CS<2.3 & Dist_E> 80000| Dist_CS< 2.5 & Dist_E> 100000|Dist_CS<2.7 & Dist_E> 130000|
			Dist_CS<3.0 & Dist_E> 160000)			

					   
G3<- filter(Com, Dist_CS> 1.5 & Dist_E<10000|Dist_CS>1.7 & Dist_E< 20000| Dist_CS>1.9 & Dist_E< 40000|
			Dist_CS>2.1 & Dist_E< 60000| Dist_CS>2.3 & Dist_E< 80000| Dist_CS> 2.5 & Dist_E< 100000|
			Dist_CS>2.7 & Dist_E< 130000|Dist_CS>3.0 & Dist_E< 160000)	

G<- list(G1, G2, G3)			



##LINEAR MODEL 		
lapply(G, function(x) summary(lm(Dist_E~Dist_CS,x)))

for (i in G){

	fit1<- lm(Dist_E~Dist_CS, i)
	plot(i$Dist_CS, i$Dist_E)
	abline(fit1, col= "red")
}

#EXPONENTIAL MODEL
for (i in G ) {
	fit<- lm(log(Dist_E)~Dist_CS, i)
	A<- fit$coefficient[1] ; B<- fit$coefficient[2]
	
	C2<- nls(Dist_E ~ I(exp(1)^(b + a * Dist_CS)), data = i, start = list(a = A,b = B), trace = T)
	print(C2)

	RSS.e <- sum(residuals(C2)^2)
	TSS <- sum((i$Dist_E - mean(i$Dist_E))^2)
	R2 <- 1 - (RSS.e/TSS)
	print(R2)
	
	plot(i$Dist_CS,i$Dist_E)
	r <- range(i$Dist_CS)
	xNew <- seq(r[1],r[2],length.out = 200)
	yNew <- predict(C2,list(Dist_CS = xNew))
	lines(xNew,yNew, col="red")
		}
		
			

					######## IUCNhab,Order,DistC,Family_name,Genus,uber ########
					
setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables")

Com<- read.table("CSnE_Disp.txt", h=TRUE);Com<- Com[c(1,2,5,6,7,8)]
Com2<- read.table("CSnE_info.txt", h=TRUE);Com2<- Com2[c(1,11,12,19,22,23,24)]
Com2<- Com2[!duplicated(Com2[1]),]; Com2$binomial<- sub("\\_.*", "", Com2$binomial)
colnames (Com2) [2]<- "Genus"; Com2$Genus <- as.factor(Com2$Genus)
Com3<- merge(Com, Com2, by= c("id_no"), all=FALSE)



#use of IUCNhab, Order, DistC, Family_name, Genus, uber
					
##LINEAR MODEL

L<- list()
fn<- function(x) (x - fit1$coefficient[1])/fit1$coefficient[2]

for (i in unique(Com3$DistC)){##change here
	
	a<- subset(Com3, DistC==i)##here;#subset
	
	fit1<- lm(Dist_E~Dist_CS, a); print(summary(fit1))#model
	plot(a$Dist_CS, a$Dist_E)#plot
	abline(fit1, col= "red")
	title(i)
	
	a<- transform(a, Disp_meanT = fn(Disp_mean))#transform dispersal estimates
	
	L[[i]]<- a
	Linear <- do.call(rbind, lapply(L, data.frame, stringsAsFactors=FALSE))#new data set
	rownames(Linear) <- NULL
	}





##POWER MODEL #not working
CG1<-nls(Dist_E~I(Dist_CS^power), data=G1, start= list(power=1), trace=T)

C<- nls2(Dist_E~I(Dist_CS^power), data=G1, start= list(power=1), trace=T,"brute-force")


##EXPONENTIAL MODEL
L<- list()
fn<- function(x) (log(x)-coeff[2])/coeff[1]

for (i in unique(Com3$Family)) {##change here
	
	a<- subset(Com3, Family==i)##here; #subset
	
	fit<- lm(log(Dist_E)~Dist_CS, a)#find model start points
	summary(fit)
	A<- fit$coefficient[1] ; B<- fit$coefficient[2]
	
	C2<- nls(Dist_E ~ I(exp(1)^(b + a * Dist_CS)), data = a, start = list(a = A,b = B), trace = T)#model
	coeff<- coef(C2)
	print(summary(C2))
	
	
	RSS.e <- sum(residuals(C2)^2)
	TSS <- sum((a$Dist_E - mean(a$Dist_E))^2)
	R2 <- 1 - (RSS.e/TSS)
	print(R2) # Get R-squared 
	
	plot(a$Dist_CS,a$Dist_E)#plot
	r <- range(a$Dist_CS)
	xNew <- seq(r[1],r[2],length.out = 200)
	yNew <- predict(C2,list(Dist_CS = xNew))
	lines(xNew,yNew, col="red")
	title(i)
	
	a<- transform(a, Disp_meanT = fn(Disp_mean))#transform dispersal estimates based on model 
	
	L[[i]]<- a
	Exponential <- do.call(rbind, lapply(L, data.frame, stringsAsFactors=FALSE))#create new data frame
	rownames(Exponential) <- NULL
		}					
#In console you get a and b and after [1] there is the R-squared of the nls model



				###### PCA ######

library(FactoMineR)
library(factoextra)
library(PCAmixdata)

setwd("C:/Users/Konstantina/Desktop/Distance/Comparison/merged_tables")

Com2<- read.table("CSnE_info.txt", h=T)
Apaquali<- Com2[,c(11:13,19,22:25)];Apaquanti<- Com2[,c(18,20,21,26:28)] 

#Multiple correspondance analysis, only categorical variables, no important results				
MCA<- MCA(Apaquali, ncp=5, graph=T)
summary(MCA)

#PCA with mix data

PCAmix<- PCAmix(X.quanti= Apaquanti, X.quali=Apaquali)
summary(PCAmix)#suggest binomial(Genus), uber and Family_name

	
############################################	



   











