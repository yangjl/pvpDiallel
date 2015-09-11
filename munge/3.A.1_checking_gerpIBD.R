### Jinliang Yang


library("data.table", lib="~/bin/Rlib/")

h2 <- fread("largedata/SNP/gerpIBD_h_g2_h2.gs")
a2 <- fread("largedata/SNP/gerpIBD_h_g2_a2.gs")
d2 <- fread("largedata/SNP/gerpIBD_h_g2_d2.gs")
a2b <- fread("largedata/SNP/gerpIBD_h_g2_a2b.gs")
ab2 <- fread("largedata/SNP/gerpIBD_h_g2_ab2.gs")

h2 <- as.data.frame(h2)
a2 <- as.data.frame(a2)
d2 <- as.data.frame(d2)
a2b <- as.data.frame(a2b)
ab2 <- as.data.frame(ab2)



