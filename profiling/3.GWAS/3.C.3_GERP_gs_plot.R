# Jinliang Yang
# 12/3/2014
# plot prediction results in local machine


dtp1 <- read.csv("cache/DTP_trainres.csv")
dtp1$snpset <- as.character(dtp1$snpset)
dtp1[1:12,]$snpset <- "GERP"
boxplot(R2 ~ snpset, data=dtp1,
        xlab = "SNP sets", ylab= "Prediction accuracy (R^2)", col=c("red",rep( "lightgray", times=10)), 
        main="Trait= DTP, GERP>0 (N=506,898)", names=c("GERP>0", 1:10))

###### GERP>2
asi2 <- read.csv("cache/ASI_29kres.csv")
asi2$snpset <- gsub("ASI_", "", asi2$file)
asi2$snpset <- gsub("_.*", "", asi2$snpset)
dtp2 <- read.csv("cache/DTP_29kres.csv")
dtp2$snpset <- gsub("DTP_", "", dtp2$file)
dtp2$snpset <- gsub("_.*", "", dtp2$snpset)

par(mfrow=c(1,2))
boxplot(R2 ~ snpset, data=asi2,
        xlab = "SNP sets", ylab= "Prediction accuracy (R^2)", col=c("red",rep( "lightgray", times=10)), 
        main="Trait= ASI, GERP>2 (N=28,977)", names=c("GERP>2", 1:10) )
boxplot(R2 ~ snpset, data=dtp2,
        xlab = "SNP sets", ylab= "Prediction accuracy (R^2)", col=c("red",rep( "lightgray", times=10)), 
        main="Trait= DTP, GERP>2 (N=28,977)", names=c("GERP>2", 1:10) )

###### GERP < -4
asi3 <- read.csv("cache/ASI_sm4.csv")
asi3$snpset <- gsub("ASI_", "", asi3$file)
asi3$snpset <- gsub("_s.*", "", asi3$snpset)
asi3[1:12,]$snpset <- "GERP"

dtp3 <- read.csv("cache/DTP_sm4kres.csv")
dtp3$snpset <- gsub("DTP_", "", dtp3$file)
dtp3$snpset <- gsub("_.*", "", dtp3$snpset)

par(mfrow=c(1,2))
boxplot(R2 ~ snpset, data=asi3,
        xlab = "SNP sets", ylab= "Prediction accuracy (R^2)", col=c("red",rep( "lightgray", times=10)), 
        main="Trait= ASI, GERP>0 (N=37,664)", names=c("GERP>2", 1:10) )
boxplot(R2 ~ snpset, data=dtp3,
        xlab = "SNP sets", ylab= "Prediction accuracy (R^2)", col=c("red",rep( "lightgray", times=10)), 
        main="Trait= DTP, GERP>0 (N=37,664)", names=c("GERP>2", 1:10) )









