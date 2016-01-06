### Jinliang Yang
### Sept 19th, 2015


get_variance <- function(){
  k <- read.csv("data/num_effect.csv")
  
  a2 <- k[, c(1, 6)]
  d2 <- k[, c(1, 7)]
  names(a2)[2] <- "h2"
  names(d2)[2] <- "h2"
  a2$eff <- "add"
  d2$eff <- "dom"
  out2 <- rbind(a2, d2)
  out2$file <- gsub(".*/|_.*", "", out2$file)
  out2$file <- toupper(out2$file)
  return(out2)
}


############
get_dense <- function(pwd="largedata/snpeff/"){
  traits <- tolower(c("ASI", "DTP", "DTS", "EHT", "GY", "PHT", "TW"))
  out <- data.frame()
  for(i in 1:7){
    kval <- read.table(paste0(pwd, traits[i], "_k.txt"), header=TRUE)
    kval$trait <- traits[i]
    out <- rbind(out, kval)
  }
  out$trait <- toupper(out$trait)
  return(out)
}


#############################################
library(ggplot2, lib="~/bin/Rlib/")
source("~/Documents/Github/zmSNPtools/Rcodes/multiplot.R")

med2 <- data.frame(trait=c("ASI", "DTP", "DTS", "EHT", "GY", "PHT", "TW"), 
                   phph=c(-0.24725, -0.08345, -0.10605,  0.29005,  1.24175,  0.25460, -0.00955 ))
med2$traitlw <- tolower(med2$trait)
#bymed2 <- with(trait, reorder(trait, pBPHmax, median))
bymed2 <- med2[order(med2$phph),]
out1 <- get_variance()
out2 <- get_dense(pwd="largedata/snpeff/")


#########################################
theme_set(theme_grey(base_size = 18)) 

p1 <- ggplot(out1, aes(x=factor(file, levels=bymed2$trait), y=h2, 
                       fill=factor(eff, labels=c("A", "D")))) + 
  geom_bar(position=position_dodge(), stat="identity") +
  xlab("") +
  ylab("Accumulative Variance") +
  ggtitle("") + theme_bw() +
  labs(fill="Effect") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=12))

out2$trait <- factor(out2$trait, levels=bymed2$trait)
p2 <- ggplot(data=out2) +
  geom_density(aes(x= h, y=-..scaled.., fill= as.factor(trait)) ) +
  #guides(fill=FALSE) +
  labs(y=NULL, fill="Trait") + theme_bw() +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
  coord_flip() + xlab("Degree of Dominance (k)") + ylab("") + facet_grid(~ trait) 

multiplot(p1, p2, cols=2)


########
pdf("graphs/Fig3_eff_var.pdf", width=13, height=5)
multiplot(p1, p2, cols=2)
dev.off()



