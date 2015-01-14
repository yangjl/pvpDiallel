### Jinliang Yang
### beanplot

#http://www.jstatsoft.org/v28/c01/paper

res0 <- read.csv("cache/cv_results.csv")

table(subset(res0, type=="real")$trait)
table(subset(res0, type=="random")$trait)


library("beanplot")


res1 <- subset(res0, mode == "d2")
par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
beanplot(R2 ~ type + trait, data = res1, ll = 0.04,
        main = "dominant GERP score", ylab = "body height (inch)", side = "both",
        border = NA, col = list(c("grey", "black"), c("blue", "red")))
#legend("bottomleft", fill = c("black", "grey"),
#       legend = c("Group 2", "Group 1"))

t.test(subset(res0, type=="real" & trait=="asi" & mode=="d2")$R2, 
       subset(res0, type=="random" & trait == "asi" & mode=="d2")$R2)



