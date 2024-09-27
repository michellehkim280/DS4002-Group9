# DS 4002 - Project 1
setwd("C:/Users/risgu/Desktop/DS 4002")

library(dplyr)
library(ggplot2)
library(tm)
library(stringr)

Data1 <- read.csv("drugLibTest_raw.csv")
Data2<- read.csv("drugsComTest_raw.csv")

# Pulling birth control data into a new dataset
table(Data1$condition) # allows us to see how many "birth control" conditions there are + additional texts
allbc<-Data1%>%
  filter(condition=="birth control" | 
           condition=="birth control, heavy periods"|
           condition=="birth control/control of menstrual cycle"|
           condition=="birth control/period regularity")

# Doing same thing for Data2
Data2table<-table(Data2$condition) 
#View(Data2table) # 9648 observations for "Birth Control"

allbc2<-Data2%>%
  filter(condition=="Birth Control")

# Do not need both datasets -> only using 'drugsComTest_raw.csv'

# Exploratory Data Analysis ---------------------------------------

# Bar graph showing number of patients on each birth control type
ggplot(allbc2, aes(x=drugName))+geom_bar() # too many drugs, need to narrow this down

# More EDA done in Python - separate file 

# Calculate sentiment scores based on review text data
## Importing the Lexicon
liu.pos.words <- scan("./positive-words.txt", 
                      what = "character", 
                      comment.char = ";", encoding = "UTF-8")

liu.pos.words
liu.neg.words <- scan("./negative-words.txt", 
                      what = "character", 
                      comment.char = ";", encoding = "UTF-8")
liu.neg.words

## Generating scores for the words
liu.pos.scores <- rep(1, length(liu.pos.words))
liu.neg.scores <- rep(-1, length(liu.neg.words))

liu.lexicon <- c(liu.pos.words, liu.neg.words)
head(liu.lexicon)

liu.scores <- c(liu.pos.scores, liu.neg.scores)
head(liu.scores)

# Text mining
# Functions to remove URL and other characters:
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x) 
usableText <- function(x) stringr::str_replace_all(x,"[^[:graph:]]", " ")

corpus0 <- Corpus(VectorSource(allbc2$review))
corpus1 <- tm_map(corpus0, removeURL)
corpus2 <- tm_map(corpus1, removeNumPunct)
corpus3 <- tm_map(corpus2, tolower)
corpus4 <- tm_map(corpus3, removePunctuation)
corpus5 <- tm_map(corpus4, removeNumbers)
corpus6 <- tm_map(corpus5, removeWords, stopwords("english"))

# Converting from corpus back to text
for(i in 1:length(corpus6)){
  allbc2$review.tm[i] <- strwrap(corpus6[[i]], 
                                 width=10000)
}
# review.tm (processed text) now added as a column -> doing sentiment analysis on this
#library(stringr) # Function to score text
scoring.texts <- function(text, pos, neg) {require(plyr) 
  require(stringr)
  scores <- ldply(text, function(text, pos, neg) {
    words0 <- str_split(text, '\\s+')
    words <- unlist(words0)
    positive <- sum(!is.na(match(words, pos)))
    negative <- sum(!is.na(match(words, neg)))
    score <- positive - negative
    all <- data.frame(score, positive, negative)
    return(all)
  }, pos, neg)
  scores.df = data.frame(scores, text=text)
  return(scores.df)
}
bc.scores <- scoring.texts(text = allbc2$review.tm, 
                              pos = liu.pos.words, neg = liu.neg.words)
head(bc.scores)

# Rename column text to review.tm to be able to merge on shared column
bc.scores <- dplyr::rename(bc.scores, review.tm = text)

# Add scores to allbc2 data
sentimentdf<-merge(x=allbc2, y=bc.scores[!duplicated(allbc2$review.tm), ],
                   by="review.tm", all.x=TRUE)
#write.csv(sentimentdf, file="sentimentdf.csv", row.names=FALSE)


#Organizing birth control brands by frequency of reviews
counts<-table(sentimentdf$drugName) 
ordereddrugs<-sort(counts, decreasing=TRUE) # first 10 rows = most reviewed drugs

# New dataset of top ten drugs
toptenbc<-sentimentdf%>%
  filter(drugName=="Etonogestrel" | 
           drugName=="Levonorgestrel"|
           drugName=="Ethinyl estradiol / norethindrone"|
           drugName=="Nexplanon"|
           drugName=="Ethinyl estradiol / norgestimate"|
           drugName=="Ethinyl estradiol / levonorgestrel"|
           drugName=='Implanon'|
           drugName=='Mirena'|
           drugName=='Skyla'|
           drugName=='Lo Loestrin Fe')

#write.csv(toptenbc, file="toptenbc.csv", row.names=FALSE)

#New dataset of less-reviewed drugs (>=20 reviews)
lessbc<-sentimentdf%>%
  filter(drugName=="Sronyx" | 
           drugName=="Tri-Previfem"|
           drugName=="Beyaz"|
           drugName=="Generess Fe"|
           drugName=="Gianvi"|
           drugName=="Reclipsen"|
           drugName=='Cryselle'|
           drugName=='Ocella'|
           drugName=='LoSeasonique'|
           drugName=='Ortho Mecronor')
#write.csv(lessbc, file="lessbc.csv", row.names=FALSE)


# Rating vs sentiment score scatterplot
#-- Top 10
ggplot(toptenbc, aes(x=rating, y=score, color=drugName))+
  geom_point(position='jitter')+ labs(title="Patient Rating vs Sentiment Score - Top 10",
                                      col="Birth Control")
#-- Less Reviewed
ggplot(lessbc, aes(x=rating, y=score, color=drugName))+
  geom_point(position='jitter')+ labs(title="Patient Rating vs Sentiment Score - Less Reviewed",
                                      col="Birth Control")

# Boxplots to show range of patient ratings per drug
#-- Top 10
ggplot(toptenbc, aes(x=drugName, y=rating, fill=drugName))+geom_boxplot()+
  labs(title='Range of Patient Ratings - Top 10', fill = 'Birth Control',
       x='Birth Control', y='Rating')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#-- Less Reviewed
ggplot(lessbc, aes(x=drugName, y=rating, fill=drugName))+geom_boxplot()+
  labs(title='Range of Patient Ratings - Less Reviewed', fill = 'Birth Control',
       x="Birth Control", y="Rating")+theme(axis.text.x = element_text(angle = 45,
                                                                       hjust = 1))

# Boxplots to show the range of sentiment score per drug
#-- Top 10
ggplot(toptenbc, aes(x=drugName, y=score, fill=drugName))+geom_boxplot()+
  labs(title='Range of Sentiment Scores - Top 10', x='Birth Control',
       y='Sentiment Score', fill="Birth Control")+
  theme(axis.text.x = element_text(angle = 70, hjust = 1))

#-- Less Reviewed
ggplot(lessbc, aes(x=drugName, y=score, fill=drugName))+geom_boxplot()+
  labs(title='Range of Sentiment Scores - Less Reviewed', x='Birth Control',
       y='Sentiment Score', fill="Birth Control")+
  theme(axis.text.x = element_text(angle = 70, hjust = 1))