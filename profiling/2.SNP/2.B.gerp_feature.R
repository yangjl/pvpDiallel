### Jinliang Yang
### exploring genome-wide feature of GERP score

ele10 <- read.table("~/Documents/Data/GERP/roast.chrom.10.msa.in.rates.full.elems")


#Columns 6-8 arent actually listed in the README file. 
#Column 6 is the total number of bases within conserved elements up to a including
#that row. I believe that columns 7 and 8 correspond to the false positive rate assuming a given p-value, 
#but Id have to contact to Sidow lab to be sure.

gerp1 <- read.table("~/Documents/Data/GERP/roast.chrom.1.msa.in.rates.full", header=FALSE)
gerp1$pos <- 1:nrow(gerp1)


sub1 <- subset(gerp1, V2!=0)


hist(sub1$V2)


#plot(x=sub1$pos, y=sub1$V2)




