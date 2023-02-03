library(readxl)
library(dplyr)
library(tidytext)
library(tm)
library(quanteda)
library(stringr)
library(plyr)
library(plotly)
# setwd("/Users/qianzhang/Desktop")

df <- read_excel("1.xlsx", col_names = F, range = cell_cols("E:E"))
colnames(df) <- "text"
tdf <- tibble(line = 1:nrow(df), text = df$text)
sdg <- read.delim("case study keywords.txt", header = FALSE, col.names = "text", stringsAsFactors = F)
text_df <- tdf %>% unnest_tokens(word, text)
punc_words <- tibble(word = c(
  "{", "}", "(", ")", "[", "]", ".",
  "|", "&", "*", "/", "//", "#", "\\",
  "~", ",", ":", ";", "?", "!", "\"",
  "-", "--", "...", "||", "&&"
))

text_cm <- text_df %>% anti_join(punc_words)
text_sw <- text_cm %>% anti_join(stop_words)
text_sw$word <- str_replace_all(text_sw$word, "[\\d.,-]+", "")
text_sw_dg <- text_sw %>% filter(word != "")
text_sw_dg$word <- str_to_lower(text_sw_dg$word)
text_res <- text_sw_dg %>%
  group_by(line) %>%
  summarise(text = paste(word, collapse = " "))

# Creating a corpus for the data which includes the SDG keywords and documents
text_corpus <- VCorpus(VectorSource(text_res$text))
text_stem <- tm_map(text_corpus, stemDocument)
doco <- data.frame(text = sapply(text_stem, identity), stringsAsFactors = F)
doc1 <- doco[-2, ]

doc1 <- str_replace_all(doc1, c("world health organis" = "worldhealthorganis", "asylum seeker" = "asylumseeker", "disadvantag countri" = "disadvantagcountri", "food poverti" = "foodpoverti", "alcohol abus" = "alcoholabus", "child health" = "childhealth", "mental health" = "mentalhealth", "public health" = "publichealth", "qualiti of care" = "qualitiofcare", "world health organis" = "worldhealthorganis", "number skill" = "numberskill", "primari school" = "primarischool", "secondari school" = "secondarischool", "teach assist" = "teachassist", "domest violenc" = "domestviolenc", "gender violenc" = "genderviolenc", "natur gas" = "naturgas", "nuclear power" = "nuclearpower", "ethnic minor" = "ethnicminor", "live condit" = "livecondit", "urban area" = "urbanarea", "urban regener" = "urbanregener", "resourc effeci" = "resourceffeci", "built environ" = "builtenviron", "climat chang" = "climatchang", "sea surfac" = "seasurfac", "water access" = "wateraccess", "water poverti" = "waterpoverti", "anim protect" = "animprotect", "land use" = "landuse", "stimul partnership" = "stimulpartnership"))


# phrase <- c("asylum seeker", "disadvantag countri", "food poverti", "alcohol abus", "child health", "mental health", "public health", "qualiti of care", "world health organis", "number skill", "primari school", "secondari school", "teach assist", "domest violenc", "gender violenc", "natur gas", "nuclear power", "ethnic minor", "live condit", "urban area", "urban regener", "resourc effeci", "built environ", "climat chang", "sea surfac", "water access", "water poverti", "anim protect", "land use", "stimul partnership")

doc2 <- unname(unlist(doc1))
doc <- as.data.frame(doc2)

# write.table(doc, file = "after date washing.txt")


# Giving doc the column name
colnames(doc) <- "text"
# Giving SDG and document name
namesdg <- paste0("sdg", 1:dim(sdg)[1])
namedoc_ <- paste0("doc_", 1:dim(doc)[1])
data <- rbind(sdg, doc)
corpdata <- corpus(data)
dfmdata <- dfm(corpdata)
meandata <- rowMeans(dfmdata)

# mean value for SDGs
x <- meandata[1:dim(sdg)[1]]
y <- meandata[(dim(sdg)[1] + 1):dim(data)[1]]

# write.csv(dfmdata,"text_words_matrix.csv",sep=",",row.names=F,quote=F)

mean <- merge(x, y)
# Euclidean distance calculation (absolute distance between each SDG and each document)
dist <- abs(mean$x - mean$y)
distance <- matrix(dist, nrow = length(x), ncol = length(y))
colnames(distance) <- namedoc_
rownames(distance) <- namesdg

# write.csv (distance, file ="1.csv")

d <- data.frame(
  sdg = rep(row.names(distance), ncol(distance)),
  doc_ = rep(colnames(distance), each = nrow(distance)),
  distance = as.vector(distance)
)

# quantile{stats} The generic function quantile produces sample quantiles corresponding to the given probabilities. The smallest observation corresponds to a probability of 0 and the largest to a probability of 1.
aquantile <- quantile(distance, probs = seq(0, 1, 0.25))
score <- 4
for (i in 1:score) {
  d$score[distance >= aquantile[i]] <- i
}
dt <- d[which(d$score %in% c(1, 2)), ]
dt$sdg <- str_replace(dt$sdg, "_distance", "")
write.csv(dt, file = "distance mapping.csv")
dt$sdg <- as.character(dt$sdg)
dt$doc_ <- as.character(dt$doc_)
sdgcount <- seq(1:dim(sdg)[1])

i <- 1

cache <- list()


for (i in sdgcount) {
  cache[[i]] <- dt$doc_[which(dt$sdg == paste0("sdg", i))]
}

u <- rbind.fill(
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
  data.frame(t(data.frame(cache[17])))
)

# Matrix transpose
u_ <- t(u)
colnames(u_) <- paste0("sdg", 1:dim(sdg)[1])

# write.csv (u_, file ="mapping result.csv",  na = "", row.names = FALSE)
