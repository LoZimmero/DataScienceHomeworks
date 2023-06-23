
path_homework<-getwd()

#solo per federico
path_homework<-paste0(path_homework,"/GitHub/DataScienceHomeworks/Homework2")

flows<-read.csv(paste0(path_homework,"/flows1.csv"),header = TRUE)
d<-dist(flows,method = "euclidean")
fit<-hclust(d,method="ward.D")
# Apri un nuovo dispositivo grafico PNG
png(filename = paste0(path_homework,"/plot.png"), width = 30000, height = 8000)

# Genera il grafico
plot(fit)

# Chiudi il dispositivo grafico, salvando l'immagine
dev.off()

groups <- cutree(fit, k=4) 
rect.hclust(fit, k=4, border="red") 
groups

tss<-seq(1,10,1) 
for ( i in 1:10) tss[i] <- kmeans(flows,i)$tot.withinss
plot ( tss , type="ol", xlab="k")
groups<-cutree(fit,k=3)


