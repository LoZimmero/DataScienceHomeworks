#librerie
install.packages("png")
library(png)
install.packages("factoextra")
library(factoextra)


###TASK 1###
execute_kmeans <- function(data, k=4) {
  fit <- kmeans(data, k)
  plot(data, col=fit$cluster+1, pch=16)
  points(fit$centers, pch=7, col="black")
}

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
png(filename = paste0(plots, "Task1 - Sensibility analysis kmeans.png"), width = 1000, height = 800)
plot(tss, main = "Sensibility analysis - kmeans tot.withinss", type = "o", lwd = 1.5, xlab = "k",cex=2, cex.main = 2)
dev.off()

png(filename = paste0(plots, "Task1 - kmeans.png"), width = 1000, height = 800)
execute_kmeans(flows,4)
dev.off()



####HCLUST#######

d<-dist(flows,method = "euclidean")
fit<-hclust(d,method="ward.D")

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
execute_PC <- function(data, scale=TRUE) {
  PC <- prcomp(data, scale=scale)
  screeplot(PC, main = paste0("PC with scale=", scale))
  PC
}
plot_variance_explained <- function(pc, percentage_line = 90) {
  # Calcolo della varianza percentuale spiegata da ogni PC
  var_exp <- (pc$sdev^2 / sum(pc$sdev^2)) * 100
  print("Percentuale di varianza spiegata da ogni PC:")
  print(var_exp)
  
  # Calcolo della varianza cumulativa
  cum_var_exp <- cumsum(var_exp)
  
  # Creazione del grafico
  plot(cum_var_exp, type = "b", xlab = "number of PCs", ylab = "% of variance explained",
       main = "Percentage of variance explained by PCs", ylim = c(0, 100))
  
  # Tracciamento della linea al percentuale specificata
  abline(h = percentage_line, col = "red", lwd = 2, lty = 2)
  
  # Aggiunta dell'annotazione
  text(x = length(cum_var_exp), y = percentage_line-4, 
       labels = paste(percentage_line, "% of the variance"), pos = 2, col = "red")
}

#UNSCALED
PC <- prcomp(data, scale=FALSE)
# Unscaled screeplot
png(filename = paste0(plots, "Task2 - unscaled screeplot.png"), width = 1000, height = 800)
screeplot(PC, main = "PC with scale=FALSE")
dev.off()
# Unscaled biplot
png(filename = paste0(plots, "Task2 - unscaled biplot.png"), width = 1000, height = 800)
fviz_pca_var(PC)
dev.off()
#unscaled 
png(filename = paste0(plots, "Task2 - unscaled PCs variance.png"), width = 1000, height = 800)
plot_variance_explained(PC,90)
dev.off()
#[1] "Percentuale di varianza spiegata da ogni PC:"
#[1] 9.932418e+01 6.506203e-01 2.201085e-02 3.187339e-03 4.460643e-07 3.933665e-10 5.977741e-12 1.260364e-14

#SCALED
PC <- prcomp(data, scale=TRUE)
# scaled screeplot
png(filename = paste0(plots, "Task2 - scaled screeplot.png"), width = 1000, height = 800)
screeplot(PC, main = "PC with scale=TRUE")
dev.off()
# Scaled biplot
png(filename = paste0(plots, "Task2 - scaled biplot.png"), width = 1000, height = 800)
fviz_pca_var(PC)
dev.off()
#scaled 
png(filename = paste0(plots, "Task2 - scaled PCs variance.png"), width = 1000, height = 800)
plot_variance_explained(PC,90)
dev.off()

#[1] "Percentuale di varianza spiegata da ogni PC:"
#[1] 31.9454414 24.2796545 13.4219435 11.8890142 11.0679474  5.3059265  1.1063661  0.9837064

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







#### Gabriele


CURR_PATH = getwd()

input_filepath = paste0(CURR_PATH, '/flows/flows1.csv')

data <- read.csv(input_filepath, sep=',', header = TRUE)

############### UTILS ################
in_image <- function(path, f) {
  png(filename = path)
  f
  dev.off()
}

############## Part 1 - Executing hclust and kmeans ##############

draw_dendrogram <- function(data, cluster_num=4) {
  d <- dist(data, method="euclidean")
  fit <- hclust(d, method = "ward.D")
  dendrogram <- as.dendrogram(fit)
  
  # Divide dendrogram from height:
  #par(mfrow=c(3,1)) # To plot 3 images at same time
  #plot(dendrogram, main="Full Dendrogram")
  #plot(cut(dendrogram, h=dendrogram_height)$upper, main="Upper part of Dendrogram")
  #plot(cut(dendrogram, h=dendrogram_height)$lower[[2]], main="Lower part of Dendrogram")
  
  par(mfrow=c(1,1))
  plot(fit)
  groups <- cutree(fit, cluster_num)
  rect.hclust(fit, k=cluster_num, border="red")
  dendrogram
}

draw_kmeans_analysis <- function(data, l=10) {
  tss <- seq(1,l,1)
  for (i in 1:l) tss[i] <- kmeans(data, i)$tot.withinss
  plot(tss, type="ol", xlab="k")
  tss
}

execute_kmeans <- function(data, k=5) {
  fit <- kmeans(data, k)
  plot(data, col=fit$cluster+1, pch=16)
  points(fit$centers, pch=7, col="black")
}

draw_dendrogram(data, 4)
draw_kmeans_analysis(data, 10) # Miglior numerO: 4
execute_kmeans(data, 4)

############## Part 2 - Executing PCA ##############
install.packages("factoextra") # tO install factoextra package
library('factoextra')

execute_PC <- function(data, scale=TRUE) {
  PC <- prcomp(data, scale=scale)
  screeplot(PC, main = paste0("PC with scale=", scale))
  PC
}

get_variance_explained_by <- function(pc, num_cols=2) {
  tot_var <- sum(pc$sdev[1:num_cols]^2/sum(pc$sdev^2))
  tot_var
}

plot_all_graph <- function(data, scaled=TRUE) {
  PC <- prcomp(data, scale=scaled)
  # Draw screeplot
  screeplot(pc)
  # Draw biplot
  fviz_pca_ind(pc)
  fviz_pca_var(pc)
}

# Scaled screeplot
in_image(paste0('outputs/screeplot_scaled.png'), {
  execute_PC(data, TRUE)
})

# Unscaled screeplot
in_image(paste0('outputs/screeplot_unscaled.png'), {
  execute_PC(data, FALSE)
})

# Scaled biplot
png('outputs/biplot_scaled.png')
PC <- prcomp(data, scale=TRUE)
PC
fviz_pca_var(PC)
dev.off()

# Unscaled biplot
png('outputs/biplot_unscaled.png')
PC <- prcomp(data, scale=FALSE)
fviz_pca_var(PC)
dev.off()

pc <- execute_PC(data, TRUE)
tot_var <- get_variance_explained_by(pc,5)
tot_var

# CASO SCALED:
# tot_var calcolato con solo le prime 2 componenti spiega il 56,2251% della varianza
# Per calcolare almeno il 90% bisogna usare almeno le prime 5 colonne
#
# CASO NON SCALED:
# tot_car calcolato con solo le prime 2 componenti spiega il 99.9748% della varianza



############## Part 3 - Aalyze correlation between attributes ##############

# Analyze biplot from scaled PC
pc <- execute_PC(data, TRUE)
fviz_pca_var(pc)

# Vabbe, si vede cose è in correlazione, cosa è in anticorrelazione e cosa non è relazionato

############## Part 4 - Aalyze dataset with only first 2 components of PCA ##############
pc <- execute_PC(data, TRUE)
pc
fviz_cos2(pc, choice = "var", axes = 1:2) # This plots most 2 significant columns. I think.


