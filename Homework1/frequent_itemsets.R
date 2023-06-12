## Apriori
library("arules")
library("arulesViz")

data<-read.transactions("C:\\Users\\fonde\\Documents\\GitHub\\DataScienceHomeworks\\Homework1\\ffdatools\\tuplessept.txt ",sep = ",")
rules<-apriori(data, parameter = 
                 list(support=0.25, 
                      minlen=2,maxlen=30, target="frequent itemsets")) 
inspect(sort(rules, by="support"))

