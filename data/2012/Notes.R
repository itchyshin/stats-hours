#Chapter 1.
###making the mean table.... 
mWing<-as.numeric(tapply(Wing,BirdID,mean,na.rm=TRUE))
mTarsus<-as.numeric(tapply(Wing,BirdID,mean,na.rm=TRUE))
mBillL<-as.numeric(tapply(BillL,BirdID,mean,na.rm=TRUE))
mBillW<-as.numeric(tapply(BillW,BirdID,mean,na.rm=TRUE))
mTail<-as.numeric(tapply(Tail,BirdID,mean,na.rm=TRUE))
mWeight<-as.numeric(tapply(Weight,BirdID,mean,na.rm=TRUE))
mBirdID<-unique(BirdID)
ind.Sex<-match(mBirdID,BirdID)
mSex<-Sex[ind.Sex]
Data2<-data.frame(BirdID=mBirdID,Sex=mSex,Tarsus=mTarsus,BillL=mBillL,BillW=mBillW,Tail=mTail,Wing=mWing,Weight=mWeight)
write.table(Data2,file="meanBodySize.txt",row.names=FALSE, quote=FALSE)
write.csv(Data2,file="meanBodySize.csv",row.names=FALSE)
#####################################
# Chater 2 Collection
#####################################
Data<-read.csv("MBodySize.csv")
attach(Data)
str(Data)
mean(Tarsus)
sum(Tarsus)/length(Tarsus)
a.mean<-function(y){
	sum(y)/length(y)}
a.mean(Tarsus)
ls()
median(Tarsus)
length(Tarsus)/2
mode(Tarsus)
hist(Tarsus)
par(mfrow=c(1,3))
hist(Tarsus,breaks=10)
hist(Tarsus,breaks=20)
hist(Tarsus,breaks=40)
library(modeest)
library(help = "modeest")
mlv(Tarsus, method = "parzen", kernel = "gaussian")
var(Tarsus)
sum((Tarsus-mean(Tarsus))^2)/(length(Tarsus)-1)
sqrt(.Last.value)
sd(Tarsus)
sTarsus<-scale(Tarsus)
head(sTarsus)
head(zTarsus)
sd(sTarsus)
sd(zTarsus)
znormal<-rnorm(1e+06)
hist(znormal,breaks=100)
quantile(znormal)
summary(znormal)
qnorm(c(0.25, 0.75))
pnorm(.Last.value)
quantile(znormal,c(0.025,0.975))
qnorm(c(0.025,0.975))
# Fig znormal2
par(mfrow=c(1,2))
hist(znormal,breaks=100)
abline(v=qnorm(c(0.25,0.5,0.75)),lwd=2)
abline(v=qnorm(c(0.025,0.975)),lwd=2,lty="dashed")
plot(density(znormal))
abline(v=qnorm(c(0.25,0.5,0.75)),col="gray")
abline(v=qnorm(c(0.025,0.975)),lty="dotted",col="red")
abline(h=0,lwd=3,col="blue")
text(2,0.3,"Magic 1.96",col="green",adj=0)
text(-2,0.3,"Magic -1.96",col="green",adj=1)
# Fig TarsusWing
par(mfrow=c(1,3))
plot(Wing,Tarsus)
plot(Wing,Tarsus,xlim=c(70,86),ylim=c(16,21),xlab="Wing length (mm)",ylab="Tarsus length (mm)")
abline(lm(Tarsus~Wing))
Col<-ifelse(Sex=="F","red","blue")
Pch<-ifelse(Sex=="F",16,15)
plot(Wing,Tarsus,xlim=c(70,86),ylim=c(16,21),xlab="Wing length (mm)",ylab="Tarsus length (mm)",pch=Pch,col=Col)
Males<-which(Sex=="M")
abline(lm(Tarsus~Wing,subset=Males),col="blue",lty="dotted")
abline(lm(Tarsus~Wing,subset=-Males),col="red",lty="dotdash")
library(DAAG)
par(mfrow=c(1,3))
show.colors(type="singles")
show.colors(type="shades")
show.colors(type="gray")
par(mfrow=c(2,2))
par(mar=c(3,4,1,2))
boxplot(Wing~Sex,ylab="Wing length (cm)",names=c("Female","Male"))
plot(Sex,Wing,ylab="Wing length (cm)",names=c("Female","Male"),col=c("red","blue"))
Means<-tapply(Wing,Sex,mean)
barplot(Means,ylab="Wing length (cm)",names=c("Female","Male"),ylim=c(0,80),col=c("red","blue"))
library(gregmisc)
SEs<-tapply(Wing,Sex,sd)/sqrt(tapply(Wing,Sex,length))
CI.L<-Means-SEs*1.96
CI.U<-Means+SEs*1.96
barplot2(Means,ylab="Wing length (cm)",names=c("Female","Male"),ylim=c(70,80),plot.ci=TRUE,ci.l=CI.L,ci.u=CI.U,col=c("red","blue"))
pairs(Data[,-1],panel=panel.smooth)
library(car)
Data[,"Sex"]<-as.numeric(Sex)
spm(Data[,-1])
scatterplot(Tarsus~Wing|Sex)
###########
#Exercises Chapter 2
##########
# E1
new.median<-function(x) {
odd.even<-length(x)%%2
if (odd.even == 0) (sort(x)[length(x)/2]+sort(x)[1+ length(x)/2])/2
else sort(x)[ceiling(length(x)/2)]
}
# E2
Data<-read.csv("Anscombe.csv")
attach(Data)
str(Data)
tapply(Food,Type,) # to be finished
# E3
#################
####chapter 3
################
par(mfrow=c(2,2))
set.seed(123)
par(mfrow=c(2,2))
set.seed(123)
plot(density(rt(1e+06,4)),xlim=c(-5,5),ylim=c(0,0.6),main="t dist. with df = 4")
abline(h=0,col="blue")
abline(v=qt(c(0.025,0.975),4),col="red")
plot(density(rt(1e+06,10)),xlim=c(-5,5),ylim=c(0,0.6),main="t dist. with df = 10")
abline(h=0,col="blue")
abline(v=qt(c(0.025,0.975),10),col="red")
plot(density(rt(1e+06,170)),xlim=c(-5,5),ylim=c(0,0.6),main="t dist. with df = 170")
abline(h=0,col="blue")
abline(v=qt(c(0.025,0.975),170),col="red")
plot(density(rnorm(1e+06)),xlim=c(-5,5),ylim=c(0,0.6),main="z distribution")
abline(h=0,col="blue")
abline(v=qnorm(c(0.025,0.975)),col="red")
qt(c(0.025,0.975),4)
qt(c(0.025,0.975),10)
qt(c(0.025,0.975),170)
qnorm(c(0.025,0.975))
qt(c(0.025,0.975),1e+06)
mean(Tarsus)/(sd(Tarsus)/sqrt(length(Tarsus)))
##########
Means<-as.numeric(tapply(Tarsus,Sex,mean))
Diff<-Means[1]-Means[2]
SDs<-as.numeric(tapply(Tarsus,Sex,sd))
SEd1<-sqrt((SDs[1]/sqrt(sum(Sex=="F")))^2+(SDs[2]/sqrt(sum(Sex=="M")))^2)
tvalue<-Diff/SEd1
Females<-which(Sex=="F")
Males<-which(Sex=="M")
SEd2<- sqrt((sum((Tarsus[Females]-Means[1])^2)+sum((Tarsus[Males]-Means[2])^2))/(length(Tarsus)-2))*sqrt((1/length(Females))+(1/length(Males)))
##########
set.seed(123)
plot(density(rt(1e+06,169)))
abline(v=c(-1.5070,1.5079),col="red")
abline(h=0,col="blue")
text(c(-2,2),rep(0.02,2),rep("6.67%",2))
##############
par(mfrow=c(1,3))
plot(Wing~Tarsus)
lm1<-lm(Wing~Tarsus)
abline(lm1)
segments(Tarsus[15],Wing[15],Tarsus[15],predict(lm1)[15],lwd=3)
plot(Wing~Sex)
Sex01<-as.numeric(Sex)-1
plot(Wing~Sex01)
abline(lm(Wing~Sex01))
#########
par(mfrow=c(1,3))
plot(Wing~Tarsus,xlim=c(0,21),ylim=c(50,90))
abline(lm(Wing~Tarsus))
abline(v=0,lty="dotted")
cTarsus<-as.numeric(scale(Tarsus,scale=FALSE))
plot(Wing~cTarsus)
abline(lm(Wing~cTarsus))
abline(v=0,lty="dotted")
#zTarsus<-as.numeric(scale(Tarsus))
#plot(Wing~zTarsus)
#abline(lm(Wing~zTarsus))
#abline(v=0,lty="dotted")
par(mfrow=c(2,2))
plot(lm2)
par(mfrow=c(2,2))
plot(lm3)
#################
####chapter 4
################
Group<-gl(3,20,labels=c("F","J","M"))
set.seed(456)
Beak<-c(rnorm(20,13.3,0.5),rnorm(20,12.1,0.5),rnorm(20,13.3,0.5))
library(arm)
options(show.signif.stars=FALSE)
model1<-aov(Beak~Group)
model2<-lm(Beak~Group)
summary(model1)
summary(model2)
anova(model2)
########
par(mfrow=c(1,3))
plot(Beak~Group,ylim=c(11,15),ylab="Beak (mm)")
FJ<-which(Group!="M")
FM<-which(Group!="J")
GroupFJ<-ifelse(Group=="J",1,0)
GroupFM<-ifelse(Group=="M",1,0)
plot(Beak[FJ]~GroupFJ[FJ],ylim=c(11,15),xlab="Group",ylab="Beak (mm)")
abline(lm(Beak[FJ]~GroupFJ[FJ]))
abline(v=0,lty="dotted")
text(0.2,12.5,"Intercept\n(GroupF)")
text(0.8,13,"GroupJ")
plot(Beak[FM]~GroupFM[FM],ylim=c(11,15),xlab="Group",ylab="Beak (mm)")
abline(lm(Beak[FM]~GroupFM[FM]))
abline(v=0,lty="dotted")
text(0.2,13,"Intercept\n(GroupF)")
text(0.8,14,"GroupM")
########
plot(Group,Beak,col=c("red","green","blue"),ylab="Beak (cm)")
points(Group,Beak)
abline(h=tapply(Beak,Group,mean),col=c("red","green","blue") ,lwd=2)
abline(v=0.5,lty="dotted")
text(1.05,11.5,"Imaginary 0 line (Intercept)")
##########
######4 - ANCOVA
model4<-lm(Wing~Sex+Tarsus)
model5<-lm(Wing~Sex+Tarsus+Sex:Tarsus)
display(model4)
display(model5)
cTarsus<-scale(Tarsus,scale=FALSE)
model6<-lm(Wing~Sex+cTarsus+Sex:cTarsus)
display(model6)
#############
# model 4 
par(mfrow=c(1,2))
Col<-ifelse(Sex=="F","red","blue")
Pch<-ifelse(Sex=="F",16,15)
plot(Tarsus,Wing,xlab="Tarsus length (mm)",ylab="Wing length (mm)",main="model4",pch=Pch,col=Col)
b0<-model4$coefficients[1]
b1<-model4$coefficients[2]
b2<-model4$coefficients[3]
b4<-b0+b1
abline(a=b0,b=b2,col="red",lty="dotdash")
abline(a=b4,b=b2,col="blue",lty="dotted")
plot(Tarsus,Wing,xlab="Tarsus length (mm)",ylab="Wing length mm)",main="model5",pch=Pch,col=Col)
B0<-model5$coefficients[1]
B1<-model5$coefficients[2]
B2<-model5$coefficients[3]
B3<-model5$coefficients[4]
B4<-B0+B1
B5<-B2+B3
abline(a=B0,b=B2,col="red",lty="dotdash")
abline(a=B4,b=B5,col="blue",lty="dotted")
##############
# WingTarsus1 
par(mfrow=c(1,2))
Col<-ifelse(Sex=="F","red","blue")
Pch<-ifelse(Sex=="F",16,15)
plot(Tarsus,Wing,xlim=c(0,22),ylim=c(55,85),xlab="Tarsus length (mm)",ylab="Wing length (mm)",main="model4",pch=Pch,col=Col)
b0<-model4$coefficients[1]
b1<-model4$coefficients[2]
b2<-model4$coefficients[3]
b4<-b0+b1
abline(a=b0,b=b2,col="red",lty="dotdash")
abline(a=b4,b=b2,col="blue",lty="dashed")
abline(v=0,lty="dotted")
plot(Tarsus,Wing,xlim=c(0,22),ylim=c(55,85),xlab="Tarsus length (mm)",ylab="Wing length mm)",main="model5",pch=Pch,col=Col)
B0<-model5$coefficients[1]
B1<-model5$coefficients[2]
B2<-model5$coefficients[3]
B3<-model5$coefficients[4]
B4<-B0+B1
B5<-B2+B3
abline(a=B0,b=B2,col="red",lty="dotdash")
abline(a=B4,b=B5,col="blue",lty="dashed")
abline(v=0,lty="dotted")
#
plot(Tarsus,Wing,xlim=c(-22,22),ylim=c(30,85),xlab="Tarsus length (mm)",ylab="Wing length mm)",main="model5",pch=Pch,col=Col)
abline(a=B0,b=B2,col="red",lty="dotdash")
abline(a=B4,b=B5,col="blue",lty="dotted")
abline(v=0,lty="dotted")
########not yet
par(mfrow=c(1,2))
Col<-ifelse(Sex=="F","red","blue")
Pch<-ifelse(Sex=="F",16,15)
plot(cTarsus,Wing,xlab="Centred tarsus length (mm)",ylab="Wing length (mm)",main="model4c",pch=Pch,col=Col)
b0<-model4c$coefficients[1]
b1<-model4c$coefficients[2]
b2<-model4c$coefficients[3]
b4<-b0+b1
abline(a=b0,b=b2,col="red",lty="dotdash")
abline(a=b4,b=b2,col="blue",lty="dashed")
abline(v=0,lty="dotted")
text(-1,82,"slope(M)=1.01",col="blue")
text(1,74,"slope(F)=1.01",col="red")
plot(cTarsus,Wing,xlab="Centred tarsus length (mm)",ylab="Wing length mm)",main="model5c",pch=Pch,col=Col)
B0<-model5c$coefficients[1]
B1<-model5c$coefficients[2]
B2<-model5c$coefficients[3]
B3<-model5c$coefficients[4]
B4<-B0+B1
B5<-B2+B3
abline(a=B0,b=B2,col="red",lty="dotdash")
abline(a=B4,b=B5,col="blue",lty="dashed")
abline(v=0,lty="dotted")
text(-1,82,"slope(M)=1.04",col="blue")
text(1,74,"slope(F)=0.97",col="red")
##################
cTarsus<-scale(Tarsus,scale=FALSE)
model4c<-lm(Wing~Sex+cTarsus)
model5c<-lm(Wing~Sex+cTarsus+Sex:cTarsus)
display(model4c)
display(model5c)
anova(model4c)
anova(model5c)
mean(Wing[Sex=="M"])-mean(Wing[Sex=="F"])
#################
#### Chapter 5
#################
Chicks<-matrix(c(60,40,40,60),nrow=2,ncol=2)
rownames(Chicks)<-c("F","M")
colnames(Chicks)<-c("alive","dead")
Chicks
chisq.test(Chicks,correct=FALSE)
SuvC<-c(rep(c(1,0),c(60,40)),rep(c(1,0),c(40,60)))
SexC<-rep(c("F","M"),each=100)
glm1<-glm(SuvC~SexC,family=binomial(link=logit))
display(glm1)
anova(glm1)
###########
anova(glm1)
##############
> plot(density(rf(1e+06, 2, 57)), xlim = c(0, 60)) 
> abline(v = 51.997, col = "red")
plot(density(rchisq(1e+06,1)))
abline(v=8,col="red")
abline(h=0,col="blue")
1-pchisq(8,1)
par(mfrow=c(1,2))
plot(density(rf(1e+06,2,57)))
plot(density((rchisq(1e+06,2)/2)/(rchisq(1e+06,57)/57)))
abline(v=8,col="red")
abline(h=0,col="blue")
1-pchisq(8,1)
F257
###################
# PREP
Data<-read.csv("SparrowSurvival.csv",na.strings = "NA")
attach(Data)
str(Data)
Complete<-which(complete.cases(Data)==TRUE)
Data2<-Data[Complete,]
str(Data2)
pairs(Data2[,2:8])
write.csv(Data2,"SS1.csv")
detach(Data)
deatch(Data2)
#####################
###	
Data<-read.csv("ChickSurvival.csv")
attach(Data)
str(Data)
model<-glm(Survival~Sex+Mass2+BroodSize+Sex:Mass2+BroodSize:Sex+I(BroodSize^2)+JulianDate+Sex:JulianDate+I(JulianDate^2)+Sex:I(BroodSize^2),family=binomial)
summary(model)
model<-glm(Survival~Mass2+BroodSize+I(BroodSize^2)+JulianDate+I(JulianDate^2)+BroodSize:Mass2,family=binomial)
summary(model)
cMass2
par(mfrow=c(2,2))
plot(BroodSize,Survival)
plot(JulianDate,Survival)
plot(jitter(BroodSize),jitter(Survival))
plot(JulianDate,jitter(Survival))
##############
#Chapter 
###############
#####################practice
Data<-read.csv("FemaleSuccess.csv")
attach(Data)
str(Data)
Response<-cbind(Success,EggNo-Success)
model<-glm(Response~Age+I(Age^2),family=quasibinomial)
summary(model)
stepAIC(Response)
model<-glm(Success~Age,family=quasipoisson)
summary(model)
detach(Data)
rm(list=ls())
#############################
Data<-read.csv("FemaleSuccess1.csv")
attach(Data)
str(Data)
Response<-cbind(Fledglings,EggNo-Fledglings)
model<-glm(Response~Age,family=quasibinomial)
display(model)
summary(model)
model<-glm(Response~Age,binomial)
summary(model)
model<-glm(Fledglings~Age,poisson)
summary(model)
summary(model)
model<-glm(Fledglings~Age,quasipoisson)
summary(model)
model<-glm(Fledglings~Age,family=quasipoisson,offset=log(EggNo))
summary(model)
####
detach(Data)
rm(list=ls())
#############################
Data<-read.csv("EPPSuccess.csv")
attach(Data)
str(Data)
cor(Badge,Age)
m1<-glm(EPP~Badge,quasipoisson)
display(m1)
m2<-glm(EPP~Age,quasipoisson)
display(m2)
m3<-glm(EPP~Age+Badge+I(Age^2),quasipoisson)
display(m3)
########
cAge<-scale(Age,scale=FALSE)
zAge<-scale(Age)
m1<-glm(EPP~cAge+I(cAge^2) ,family=poisson)
m3<-glm(EPP~zAge+I(zAge^2) ,family=poisson)
display(m2)
display(m3)
############################
par(mfrow=c(1,2))
plot(jitter(cAge),log(EPP+0.5),xlim=c(-2,5),ylim=c(-7,3))
abline(a=0.16,b=1.63)
abline(v=0,lty="dotted")
curve(-0.71*x^2+0.16,-2,2,lty="dashed",add=TRUE)
plot(jitter(cAge),log(EPP+0.5),xlim=c(-2,5),ylim=c(-7,3))
abline(a=0.16,b=-0.71)
abline(v=0,lty="dotted")
plot(jitter(Age),log(EPP+0.5),xlim=c(-2,5),ylim=c(-7,3))
abline(a=-6.7,b=4.69)
abline(v=0,lty="dotted")
curve(-0.71*x^2+0.16,0,4,lty="dashed",add=TRUE)
#############################
# m1 - model one!
par(mfrow=c(2,2))
plot(jitter(cAge),log(EPP+0.5),xlim=c(-1.5,2.5),ylim=c(-4,4))
abline(v=0,lty="dotted")
curve(coef(m1)[1]+coef(m1)[2]*x+coef(m1)[3]*x^2,from=-1.5,to=2.5,add=TRUE)
#text(0.3,-0.4,"0.16",col="red")
plot(jitter(cAge),log(EPP+0.5),xlim=c(-1.5,2.5),ylim=c(-4,4))
abline(a=coef(m1)[1],b=coef(m1)[2],lty="twodash")
abline(v=0,lty="dotted")
#text(0.3,-0.4,"0.16",col="red")
plot(jitter(cAge^2),log(EPP+0.5),,xlim=c(-0.5,4.5),ylim=c(-4,4))
abline(a=coef(m1)[1],b=coef(m1)[3],lty="dashed")
abline(v=0,lty="dotted")
#text(0.3,-0.4,"0.16",col="red")
plot(jitter(cAge),log(EPP+0.5),xlim=c(-1.5,2.5),ylim=c(-4,4))
abline(a=coef(m1)[1],b=coef(m1)[2],lty="twodash")
abline(v=0,lty="dotted")
curve(coef(m1)[1]+coef(m1)[3]*x^2,from=-1.5,to=2.5,lty="dashed",add=TRUE)
#text(0.3,-0.4,"0.16",col="red")
#############################
##############
# m0 - model zero!
m0<-glm(EPP~Age+I(Age^2) ,family=poisson)
display(m0)
par(mfrow=c(2,2))
plot(jitter(Age),log(EPP+0.5),xlim=c(-2.5,4.5),ylim=c(-9,7))
abline(v=0,lty="dotted")
curve(coef(m0)[1]+coef(m0)[2]*x+coef(m0)[3]*x^2,from=-2.5,to=4.5,add=TRUE)
plot(jitter(Age),log(EPP+0.5),xlim=c(-2.5,4.5),ylim=c(-9,7))
abline(a=coef(m0)[1],b=coef(m0)[2],lty="twodash")
abline(v=0,lty="dotted")
plot(jitter(Age^2),log(EPP+0.5),,xlim=c(-2.5,16.5),ylim=c(-9,7))
abline(a=coef(m0)[1],coef(m0)[3],lty="dashed")
abline(v=0,lty="dotted")
plot(jitter(Age),log(EPP+0.5),xlim=c(-2.5,4.5),ylim=c(-9,7))
abline(a=coef(m0)[1],b=coef(m0)[2],lty="twodash")
abline(v=0,lty="dotted")
curve(coef(m0)[1]+coef(m0)[3]*x^2,from=-2.5,to=4.5,lty="dashed",add=TRUE)
