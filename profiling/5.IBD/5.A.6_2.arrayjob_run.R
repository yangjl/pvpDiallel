### Jinliang Yang
### Jan. 9th, 2014


### Get inputdf for each mode
get_inputdf <- function(mygeno=a2, pwd){
  #7traits x 3 modes x 12 permuation x  5 fold 100 rand x
  inputdf <- data.frame()
  
  #test run of the 66 diallel of trait per se with additive model
  ti <- tolower(c("ASI", "DTP", "DTS", "EHT",  "GY", "PHT",  "TW"))
  res <- c(0.38, 0.46, 0.46, 15, 88, 41, 0.64)
  gen <- c(0.18, 5.1, 6.0, 123, 65, 377, 0.82)
  
  for(i in 1:7){ #traits
    for(p in 1:12){ #gerp
      for(f in 1:5){ #5-fold
        for(r in 1:100){ #pheno
          tem <- data.frame(
            pi = 0.995, geno = mygeno[p],
            trainpheno = paste0(pwd, ti[i], "_train", f, "_sp", r, ".txt"),
            testpheno = paste0(pwd, ti[i], "_test", f, "_sp", r, ".txt"),
            chainLength=41000, burnin=1000, varGenotypic=gen[i], varResidual=res[i]
          ) 
          inputdf <- rbind(inputdf, tem)
        }
      }
    }
  }
  return(inputdf)
}

library(farmeR)
####### For trait perse
pwd <- "/home/jolyang/Documents/Github/pvpDiallel/largedata/pheno/CV5fold/"
a2 <- list.files(path="/home/jolyang/Documents/Github/pvpDiallel/largedata/newGERPv2/allgeno", 
                 pattern="a2.gs.newbin$", full.names=TRUE)
d2 <- list.files(path="/home/jolyang/Documents/Github/pvpDiallel/largedata/newGERPv2/allgeno", 
                 pattern="d2.gs.newbin$", full.names=TRUE)
h2 <- list.files(path="/home/jolyang/Documents/Github/pvpDiallel/largedata/newGERPv2/allgeno", 
                 pattern="h2.gs.newbin$", full.names=TRUE)
### add
inputdf <- get_inputdf(mygeno=a2, pwd)
run_GenSel4(inputdf, inpdir="largedata/newGERPv2/allgeno_perse_a", 
            email="yangjl0930@gmail.com", runinfo = c(FALSE, "med", 1) )
write.table(inputdf, "largedata/newGERPv2/inputdf_a2_perse_42000.csv", sep=",", quote=FALSE)

### dom
inputdf2 <- get_inputdf(mygeno=d2, pwd)
run_GenSel4(inputdf=inputdf2, inpdir="largedata/newGERPv2/allgeno_perse_d", 
            email="yangjl0930@gmail.com", runinfo = c(FALSE, "bigmeml", 1) )
write.table(inputdf2, "largedata/newGERPv2/inputdf_d2_perse_42000.csv", sep=",", quote=FALSE)
###>>> In this path: cd /home/jolyang/Documents/Github/pvpDiallel
###>>> RUN: sbatch -p bigmeml --mem 8196 --ntasks=1 slurm-script/run_gensel_array.sh

### k=0.5
inputdf3 <- get_inputdf(mygeno=h2, pwd)
run_GenSel4(inputdf=inputdf3, inpdir="largedata/newGERPv2/allgeno_perse_k5", 
            email="yangjl0930@gmail.com", runinfo = c(FALSE, "serial", 1) )
write.table(inputdf2, "largedata/newGERPv2/inputdf_d2_perse_42000.csv", sep=",", quote=FALSE)









