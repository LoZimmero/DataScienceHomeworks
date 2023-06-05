# Analisi dei dati di interarrivals.txt
#install.packages("fmsb")

CURR_FILE_PATH <- getwd()
FFDATOOLS <- paste(CURR_FILE_PATH,"/Homework1/ffdatools", sep="", collapse=NULL)

library(fmsb)
datasetOct <- read.delim(paste(FFDATOOLS,"/counts/tcount-bglsep_1",sep="", collapse=NULL), header=FALSE)
#View(datasetOct)

plot ( datasetOct$V1, datasetOct$V2, col="red", xlim=c(0,500), ylim=c(0,600), type="ol",
       xlab="CWIN", ylab="count")
# Da questo grafico ci piace CWIN=100


interarrivals <- read.table("D:/Universita/Corsi/DataScience/DataScience_2022-23/Esercitazioni/Homeworks/Homework1/ffdatools/tuples-bglsep_1-120/interarrivals.txt", quote="\"", comment.char="")
View(interarrivals)


mean <- mean(interarrivals$V1)
mean

sd <- sd(interarrivals$V1)
sd

median <- median(interarrivals$V1)
median

siqr <- SIQR(interarrivals$V1)
siqr

# Calcolo della CDF sui TTF
TTF<-ecdf(interarrivals$V1)

# knots() --> restituisce i nodi in cui è valutata la funzione TTF
t<-knots(TTF)
par(cex=1.3)
plot ( t, TTF(t), col="red", xlim=c(0,60000), type="ol", pch=16,
         xlab="time (s)", ylab="p")
# 1 - TTF(t) corrisponde alla reliability
r<-1-TTF(t)
lines ( t, r, col="blue", xlim=c(0,60000), type="ol", pch=16,
          xlab="time (s)", ylab="p")


# Valutazione dei modelli che approssimano meglio. Test nls() e valutazione del p-value
plot ( t, r)
# esponenziale
expfit<-nls(r~exp(-(l*t)), start = list(l=1/
                                            mean(interarrivals$V1)))
# weibull
# Possiamo provare anche con a=0.95
weifit<-nls(r~exp(-(l*t)^a), start = list(l=1/
                                              mean(interarrivals$V1), a=0.95))
# Iperesponenziale --> Devo vedere come si fa
hyperexp <- nls(r~0.5*exp(-(l1*t))+0.5*exp(-(l2*t)), start = list(
  l1=1/mean(interarrivals$V1),
  l2=0.1/mean(interarrivals$V1) # Mettiamo il secondo lambra 1/10 del primo
)
) # Possiamo anche modificare i 0.5 (gli alfa) e vedere se migliora o peggiora. 0.5 sembra buono
# L'imporntante è che la somma degli alfa è = 1


# Se i modelli danno risultati a cazzo che non convergono, possiamo provare a cambiare i lambda (l) usati

# Questo è per vedere se i modelli usati approssimano bene i dati osservati
lines( t, predict(expfit), col="blue", lwd=2)
lines( t, predict(weifit), col="red", lwd=2)
lines( t, predict(hyperexp), col="pink", lwd=2)

# Testing dei modelli con Kolmogorov-Smirnov
ks.test(r, predict(expfit))
ks.test(r, predict(weifit))
ks.test(r, predict(hyperexp))

# Vogliamo un p-value > di 0.05 e, se possibile, > 0.1.
# Entrambi i modelli vanno bene se studiamo il file d'esempio


# Association rule mining
# Installazione package
# install.packages("arules")
# install.packages("arulesViz")
# Invocazione del package (Equivalente di import)
library(arules)
library(arulesViz)

# Lettura del file
transactions <- read.csv("D:/Universita/Corsi/DataScience/DataScience_2022-23/Esercitazioni/AssociationRules/transactions.txt",
                         header=FALSE,
                         sep = ",")



#View(transactions)
itemFrequencyPlot(transactions, type="absolute")
rules <- apriori(transactions, 
                 parameter = list(supp=0.3,
                                  conf=0.5,
                                  minlen=2,
                                  maxlen=3, 
                                  target= "rules"
                 )
)
# Abbassando supporto e confidenza escono un sacco di regole in più

inspect(sort(rules, by="confidence"))
plot(rules)

