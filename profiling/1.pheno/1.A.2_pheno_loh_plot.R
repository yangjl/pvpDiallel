# Jinliang Yang
# Octo. 27th, 2014
# purpose: levels of heterosis


#######
plot_loh <- function(trait=trait, ...){
  par(mfrow=c(1,2))
  bymed <- with(trait, reorder(trait, pMPH, median))
  boxplot(pMPH ~ bymed, data=trait,
          xlab = "phenotypic traits", ylab= "pMPH", col="lightgray", 
          main="percentage of mid-parental heterosis")
  
  bymed2 <- with(trait, reorder(trait, pBPHmax, median))
  boxplot(pBPHmax ~ bymed2, data=trait,
          xlab = "phenotypic traits", ylab= "pBPHmax", col="lightgray", 
          main="percentage of better parental heterosis")
  
}
#####
trait <- read.csv("data/trait_matrix.csv")
plot_loh(trait=trait)


