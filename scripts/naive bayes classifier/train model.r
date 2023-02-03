#load train data
sdg_raw <- read.delim("sdg17.txt", header=FALSE, col.names = c("sdg","text"))

#transform elements to factor
sdg_raw$sdg <- factor(sdg_raw$sdg)
str(sdg_raw$sdg)
table(sdg_raw$sdg)

##text mining
library(tm)
#create a volitile coprus that contains the “text” vector from our data frame
sdg_corpus <- VCorpus(VectorSource(sdg_raw$text))
print(sdg_corpus)

#tranformed all words to lower case letters
sdg_corpus_clean <- tm_map(sdg_corpus, content_transformer(tolower))
#remove numbers
sdg_corpus_clean <- tm_map(sdg_corpus_clean, removeNumbers)
#remove “to”, “and”, “but” and “or”.
sdg_corpus_clean <- tm_map(sdg_corpus_clean, removeWords, stopwords())
#remove punctuation
sdg_corpus_clean <- tm_map(sdg_corpus_clean, removePunctuation)

#stemming
#install.packages("SnowballC")
library(SnowballC)
sdg_corpus_clean <- tm_map(sdg_corpus_clean, stemDocument)

#remove wite space
sdg_corpus_clean <- tm_map(sdg_corpus_clean, stripWhitespace)
as.character(sdg_corpus_clean[[3]])

#perform tokenization
sdg_dtm <- DocumentTermMatrix(sdg_corpus_clean)

sdg_dtm_train <- sdg_dtm
#save vectors labeling rows
sdg_train_labels <- sdg_raw$sdg

#the proportion of sdg
prop.table(table(sdg_train_labels))

#the frequency of the words
library(wordcloud)
wordcloud(sdg_corpus_clean, max.words = 50, random.order = FALSE)
#for every topic
sdg1 <- subset(sdg_raw, type == "SDG1")
wordcloud(sdg1, max.words = 50, random.order = FALSE)

#Remove words from the matrix that appear less than 2 times.
sdg_freq_words <- findFreqTerms(sdg_dtm_train, 2)
str(sdg_freq_words)

#limit our Document Term Matrix to only include words in the sms_freq_vector. 
sdg_dtm_freq_train <- sdg_dtm_train[ , sdg_freq_words]

#convert the matrix to “yes” and “no” categorical variables
convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}
sdg_train <- apply(sdg_dtm_freq_train, MARGIN = 2, convert_counts)

#Use the e1071 package to impliment the Naive Bayes algorithm on the data
library(e1071)
sdg_classifier <- naiveBayes(sdg_train, sdg_train_labels)