### Jinliang Yang
### beanplot

#http://www.jstatsoft.org/v28/c01/paper

res1 <- read.csv("cache/res1.csv")

par(lend = 1, mai = c(0.8, 0.8, 0.5, 0.5))
beanplot(R2 ~ trait + mode, data = res1, ll = 0.04,
        main = "beanplot", ylab = "body height (inch)", side = "both",
        border = NA, col = list("black", c("blue", "red")))
legend("bottomleft", fill = c("black", "grey"),
       legend = c("Group 2", "Group 1"))



