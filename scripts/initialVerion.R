---
title: "code-development"
author: "Qian"
date: "09/07/2019"
output: html_document
---
  
  
# Get the library. Library likes packages and we can use the function in each of the library
```{r}
# "readxl" is for read excel file
library(readxl)
library(dplyr)
library(tidytext)
library(stringr)
library(pacman)
library(tm)
library(data.table)
library(quanteda)
library(tidyr)
library(stringr)
library(rword2vec)
library(plyr)
library(plotly)
data(stop_words)
#setwd("/Users/qianzhang/Desktop")
```

# get the original data
```{r}
# reading the original data. Here is an example of xlsx file, you can change any form(pdf, text...) you want. But you need to use other functions. Details are in the INSTRUCTIONS.
df <- read_excel("LSEori.xlsx", col_names = T, range = cell_cols("E:E"))

# This is to change the colnames of df with "text"
colnames(df) <- "text"

# 
tdf <- tibble(line=1:nrow(df), text=df$text)

# keywords documents read (Case study or Publication)
sdg <- read.delim("case study keywords.txt", header=FALSE, col.names = "text",stringsAsFactors = F)

## Input data washing
# Separate the sentences into each word
text_df <- tdf %>% unnest_tokens(word, text)

# Select the unuseful punctuations in the documents
punc_words <- tibble(word=c("{", "}", "(", ")", "[", "]", ".",
                            "|", "&", "*", "/", "//", "#", "\\",
                            "~", ",", ":", ";", "?", "!", "\"",
                            "-", "--", "...", "||", "&&"))

# Removing these punctuations
text_cm <- text_df %>% anti_join(punc_words)

# Removing the stopwords (stopwords are "the", "a"...)
text_sw <- text_cm %>% anti_join(stop_words)

# Replacing all numbers into white space. (\d - numbers[0-9]; [\\d.,-]+ matching the numbers that appear more than once)
text_sw$word <- str_replace_all(text_sw$word, "[\\d.,-]+", "")

# Filtering out those white space
text_sw_dg <- text_sw %>% filter(word != "")

# Turning uppercase letter to lowercase letter
text_sw_dg$word <- str_to_lower(text_sw_dg$word)

# Combining each token that we dealt with into sentences
text_res <- text_sw_dg %>% group_by(line) %>% 
summarise(text=paste(word, collapse=" "))

#
text_corpus <- VCorpus(VectorSource(text_res$text))

# 
text_stem <- tm_map(text_corpus, stemDocument)

#
doco <- data.frame(text=sapply(text_stem, identity), stringsAsFactors=F)

#
doc1 <- doco[-2,]

#
doc2 <- unname(unlist(doc1))

#
doc <- as.data.frame(doc2)

# Giving doc the column name
colnames(doc) <- "text"

# Giving SDG and document name 
namesdg <- paste0("sdg",1:dim(sdg)[1])
namedoc_ <- paste0("doc_", 1:dim(doc)[1])


# To combine sdgs with documents
data <- rbind(sdg,doc)

# Creating a corpus for the data which includes the SDG keywords and documents
corpdata <- corpus(data)

# Creating a matrix for the corpus
dfmdata <- dfm(corpdata)

# Mean value getting in the each row of the matrix
meandata <- rowMeans(dfmdata)

# mean value for SDGs
x <- meandata[1:dim(sdg)[1]]

# mean value for documents
y <- meandata[(dim(sdg)[1]+1):dim(data)[1]]

# save the matrix as a .csv file.(if you want to see the matrix, deleting the "# " in the next piece of code)
# write.csv(dfmdata,"text_words_matrix.csv",sep=",",row.names=F,quote=F)

# 
mean <- merge(x,y)

# Euclidean distance calculation (absolute distance between each SDG and each document)
dist <- abs(mean$x-mean$y)

# Creating a matrix for the distance
distance <- matrix(dist,nrow = length(x),ncol = length(y))

# Column name giving
colnames(distance) <- namedoc_

# Row name giving
rownames(distance) <- namesdg

# save the matrix of distance as a .csv file.(if you want to see the matrix, deleting the "# " in the next piece of code)
# write.csv (distance, file ="1.csv")


## Set a score & give mapping level to tell the mapping results
# 
dfmdata2 <- setDT(as.data.frame(dfmdata),keep.rownames = F,key=NULL,check.names=FALSE)[]
text <-c(1:dim(dfmdata2)[1])

#
data2 <- data.frame(text,meandata)

# save the mean value results as a .csv file.(if you want to see the result, deleting the "# " in the next piece of code)
# write.csv(data2,"mean_value.csv",sep=",",row.names=F,quote=F)

#
d <- data.frame(sdg=rep(row.names(distance),ncol(distance)),
                doc_=rep(colnames(distance),each=nrow(distance)),
                distance=as.vector(distance))

#
aquantile <- quantile(distance, probs = seq(0,1,0.25))

# Set the score (the score can be changed. See INSTRUCTIONS)
score <- 4

# 
for (i in 1:score){
  d$score[distance >= aquantile[i]] <- i
}


# select 1 and 2 (the closer) (Here is the point to be changed. You can change depending on the accuracy level of mapping result you want(see INSTRUCTIONS) )
dt <- d[which(d$score %in% c(1,2)),]

#
dt$sdg <- str_replace(dt$sdg,"_distance","")

#
#write.csv (dt, file ="2.csv")

##document list for every sdg
dt$sdg <- as.character(dt$sdg)

#
dt$doc_ <- as.character(dt$doc_)

#
sdgcount <- seq(1:dim(sdg)[1])
i = 1
cache <- list()
for (i in sdgcount){
 cache[[i]] <- dt$doc_[which(dt$sdg == paste0("sdg",i))]
}

#   
u=rbind.fill(
  data.frame(t(data.frame(cache[1]))),
  data.frame(t(data.frame(cache[2]))),
  data.frame(t(data.frame(cache[3]))),
  data.frame(t(data.frame(cache[4]))),
  data.frame(t(data.frame(cache[5]))),
  data.frame(t(data.frame(cache[6]))),
  data.frame(t(data.frame(cache[7]))),
  data.frame(t(data.frame(cache[8]))),
  data.frame(t(data.frame(cache[9]))),
  data.frame(t(data.frame(cache[10]))),
  data.frame(t(data.frame(cache[11]))),
  data.frame(t(data.frame(cache[12]))),
  data.frame(t(data.frame(cache[13]))),
  data.frame(t(data.frame(cache[14]))),
  data.frame(t(data.frame(cache[15]))),
  data.frame(t(data.frame(cache[16]))),
  data.frame(t(data.frame(cache[17]))))

u_ <- t(u)
colnames(u_) <- paste0("sdg",1:dim(sdg)[1])
write.csv (u_, file ="paper3.csv",  na = "", row.names = FALSE)
```
