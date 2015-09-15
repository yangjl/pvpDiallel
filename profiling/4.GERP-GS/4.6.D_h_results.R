### Jinliang Yang
### 09/08/2015



files <- list.files(path="largedata/snpeff", pattern="snpe$", full.names=TRUE)


h1 <- read.table(files[10], header=TRUE)
names(h1) <- c("snpid","chr","pos","Effect_A","Effect_D","Effect_A2","Effect_D2","h2_mrk_A", 
               "h2_mrk_D","H2_mrk","h2_mrk_A_p","h2_mrk_D_p","H2_mrk_p","log10_h2_mrk_A","log10_h2_mrk_D","log10_H2_mrk")

h1$h <- h1$Effect_D/h1$Effect_A
 
tem <- h1$h

hist(tem[tem> -1 & tem <1])  

length(tem[tem > 0 & tem < 1])
length(tem[tem > -1 & tem < 0])
length(tem[tem > 1])
length(tem[tem < -1])
length(tem[tem=0])



sum(subset(h1, h > 1)$H2_mrk)
sum(subset(h1, h > 0 & h < 1)$H2_mrk)
sum(subset(h1, h > -1 & h < 0)$H2_mrk)
sum(subset(h1, h < -1)$H2_mrk)


temh <- h1[, c("snpid", "h")]
temh <- temh[!is.na(temh$h),]
temh[temh$h > 2, ]$h <- 2
temh[temh$h < -2, ]$h <- -2
write.table(temh, "largedata/snpeff/gy_h.txt", sep="\t", row.names=FALSE, quote=FALSE)



