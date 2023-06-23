#librerie
install.packages("png")
library(png)
install.packages("factoextra")
library(factoextra)


###TASK 1###
#bisogna eseguire hclust e kmeans sui dati di partenza, produrre dendrogramma,
#analisi di sensibilità e confrontare i due risultati


path_homework<-getwd()
#solo per federico
path_homework<-paste0(path_homework,"/GitHub/DataScienceHomeworks/Homework2/")

plots<-paste0(path_homework,"/Visualizations/")

#import dei dati da flows1.csv
flows<-read.csv(paste0(path_homework,"flows1.csv"),header = TRUE)

####K-MEANS##########
#analisi di sensibilità kmeans
tss<-seq(1,10,1) 
for ( i in 1:10) tss[i] <- kmeans(flows,i)$tot.withinss

png(filename = paste0(plots,"Task1 - Sensibility analysis kmeans.png"),width = 1000,height = 800)
plot ( tss ,main=title("Sensibility analysis - kmeans tot.withinss"), type="ol", xlab="k")
dev.off()

#kmeans
fit<-kmeans(flows,4)
#plot (in realtà non so se si può plottare qualcosa, abbiamo un sacco di features non so come fare)


####HCLUST#######

d<-dist(flows,method = "euclidean")
fit<-hclust(d,method="ward.D")

#plot, esce male perché è GROSSO
png(filename = paste0(plots,"Task1 - hclust plot.png"), width = 1000, height = 800)
plot(fit, labels = FALSE) # ruota i nomi dell'asse x di 90 gradi
groups <- cutree(fit, k=4) 
rect.hclust(fit, k=4, border="red")
dev.off()

#analisi di sensibilità hclust 

#l'idea è quella di vedere a che altezza avviene il taglio al variare di 
#k e fare una analisi di sensibilità a partire da questo
#non è molto ma è lavoro onesto
#un altro metodo è quello di valutare la metrica di silhuette
####chatgpt###################################################################

# Calcoliamo l'altezza del taglio per ogni k da 1 a 10
k_values <- 1:10
heights <- sapply(k_values, function(k) {
  # Identifica quale fusione corrisponde a passare da k+1 a k cluster
  merge_step <- length(fit$merge[,1]) - k + 1
  # L'altezza del taglio è la dissimilarità alla fusione corrispondente
  fit$height[merge_step]
})

# Creiamo il plot utilizzando le funzionalità di base di R
png(filename = paste0(plots,"Task1 - Sensibility analysis hclust.png"), width = 1000, height = 800)
plot(k_values, heights, type = "b", xlab = "Number of clusters k", ylab = "Cut Height", 
     main = "Cut Height vs Number of clusters", pch=19)
dev.off()
####fine chatgpt#############################################################


###TASK 2###
#Usare il package fviz. Le cose seguenti devono essere fatte per scale=TRUE e scale=FALSE e poi confrontare i risultati

#PCA 

#screeplot

#biplot

#qualsiasi cosa serva per vedere quanta varianzacoprono le due PC

#qualsiasi cosa serva per vedere quante PC servono per coprire il 90% della varianza


###TASK 3###
#Da fare con scale=TRUE.

#Identificare tutte le variabili correlate e anticorrelate

#Per ogni coppia di variabili fare il seguente

#Produrre scatterplot x-y

#compute superimpose linear fitting (lm)

#compute R2

#add 95% regression confidence e prediction intervals allo scatterplot


###TASK 4###
#Da fare sul dataset post PCA con 2 PC, sia con scale=TRUE che scale=FALSE

#kmeans + grafico

#vilualizzazione datasets, cluster e centroidi, usare xlim e ylim per tagliare fuori gli outliers










