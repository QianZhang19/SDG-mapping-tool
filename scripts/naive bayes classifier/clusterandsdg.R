documentkcluster <- read.csv("documentkcluster.csv")
documenttesttable <- read.csv("documenttesttable.csv", header=T)
library(tidyr)
test <- gather(data = documenttesttable,key = "document",value = "yesorno", X1:paste0("X",dim(documenttesttable)[2]-1,sep=""))
yes <- test[test$yesorno==1,]
colnames(yes) <- c("sdg","document","yes")
x <- dim(documenttesttable)[2]-1
yes[,2] <- seq(1:x)
table <- select(merge(documentkcluster, yes),-yes)
