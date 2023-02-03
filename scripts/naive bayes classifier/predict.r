#load test data
test_raw <- read.delim("underpinning_part_stemming.txt", header=FALSE, col.names = c("test","text"))

#transform elements to factor
test_raw$test <- factor(test_raw$test)
str(test_raw$test)
table(test_raw$test)

##text mining
library(tm)
#create a volitile coprus that contains the “text” vector from our data frame
test_corpus <- VCorpus(VectorSource(test_raw$text))
print(test_corpus)

#tranformed all words to lower case letters
test_corpus_clean <- tm_map(test_corpus, content_transformer(tolower))
#remove numbers
test_corpus_clean <- tm_map(test_corpus_clean, removeNumbers)
#remove “to”, “and”, “but” and “or”.
test_corpus_clean <- tm_map(test_corpus_clean, removeWords, stopwords())
#remove punctuation
test_corpus_clean <- tm_map(test_corpus_clean, removePunctuation)

#stemming
#install.packages("SnowballC")
library(SnowballC)
test_corpus_clean <- tm_map(test_corpus_clean, stemDocument)

#remove wite space
test_corpus_clean <- tm_map(test_corpus_clean, stripWhitespace)
as.character(test_corpus_clean[[3]])

#perform tokenization
test_dtm <- DocumentTermMatrix(test_corpus_clean)

sdg_dtm_test <- test_dtm
#save vectors labeling rows
sdg_test_labels <- test_raw$test

#convert the matrix to “yes” and “no” categorical variables
convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}
sdg_test <- apply(sdg_dtm_test, MARGIN = 2, convert_counts)

#predict
sdg_test_pred <- predict(sdg_classifier, sdg_test)
#save results
testTable=table(sdg_test_pred, sdg_test_labels)
write.csv(testTable,"documenttesttable.csv")
#