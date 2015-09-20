### Jinliang Yang
### 09/08/2015

num_eff <- function(files){
  
  output <- data.frame()
  for(i in 1:length(files)){
    h1 <- read.table(files[i], header=TRUE)
    names(h1) <- c("snpid","chr","pos","Effect_A","Effect_D","Effect_A2","Effect_D2","h2_mrk_A", 
                   "h2_mrk_D","H2_mrk","h2_mrk_A_p","h2_mrk_D_p","H2_mrk_p","log10_h2_mrk_A","log10_h2_mrk_D","log10_H2_mrk")
    
    h1$k <- h1$Effect_D/h1$Effect_A
    
    tem <- h1$k
    
    out <- data.frame(file=files[i], 
                      k1=length(tem[tem > 1]),
                      k2=length(tem[tem > 0 & tem <= 1]), 
                      k3=length(tem[tem >= -1 & tem < 0]), 
                      k4=length(tem[tem < -1]),
                      h2_A=sum(h1$h2_mrk_A),
                      h2_D=sum(h1$h2_mrk_D))
    
    output <- rbind(output, out)
    
    message(sprintf("###>>> processing file: [ %s ]", files[i]))
  }
  return(output)
}


