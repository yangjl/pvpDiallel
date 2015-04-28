### Jinliang Yang
### April 27th, 2014
### using MLM to compare models

library(lme4)

source("~/Documents/Github/zmSNPtools/Rcodes/rsquaredglmm.R")
source("~/Documents/Github/zmSNPtools/Rcodes/var_mlm.R")

ob <- load("PCamp_proj/cache/bmmoon.RData")

bmmoon$Phase <- paste0("P", bmmoon$Phase)
#bm <- subset(namp, Line %in% c("B73", "Mo17"))
out <- var_mlm(moon = bmmoon, nullmodel="~ (1 | Genotype.y/Rep)", fullmodel="~ Phase + (1 | Genotype.y/Rep)")
# Save the analysis results
write.csv(out, "PCamp_proj/cache/moonphase_bm.csv", row.names=FALSE, quote=FALSE)


