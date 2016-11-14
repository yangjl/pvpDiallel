findit <- function(chri, mypos){
  sub <- subset(gerpsnp, chr == chri)
  idx <- which.min(abs(sub$pos - mypos))
  print(sub[idx,])
}

findit(chri=1, mypos=136*10^6)
findit(chri=2, mypos=92.9*10^6)
findit(chri=3, mypos=100.7*10^6)
findit(chri=4, mypos=106.1*10^6)

findit(chri=5, mypos=109.2*10^6)
findit(chri=6, mypos=50*10^6)

findit(chri=7, mypos=62.5*10^6)
findit(chri=8, mypos=49*10^6)
findit(chri=9, mypos=72.7*10^6)
findit(chri=10, mypos=52.4*10^6)
