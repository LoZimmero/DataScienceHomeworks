## Apriori
library("arules")
library("arulesViz")
# Get current file path
CURR_FILE_PATH <- getwd()

#solo per il pc di federico
CURR_FILE_PATH<-paste0(CURR_FILE_PATH,"/GitHub/DataScienceHomeworks/Homework1")


# method paste() to join strings. MUST use sep="" to avoid adding empty space between strings
FFDATOOLS <- paste(CURR_FILE_PATH, "/ffdatools", sep="")

datasept<-read.transactions(paste0(FFDATOOLS,"/transactions_sept.txt"),sep = ",")
dataoct<-read.transactions(paste0(FFDATOOLS,"/transactions_oct.txt"),sep = ",")

rulessept<-apriori(datasept, parameter = 
                 list(support=0.25, 
                      minlen=2,maxlen=10, target="frequent itemsets")) 
inspect(sort(rulessept, by="support"))

rulesoct<-apriori(dataoct, parameter = 
                 list(support=0.25,
                      minlen=2,maxlen=10, target="frequent itemsets")) 
inspect(sort(rulesoct, by="support"))
