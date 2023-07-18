#librerie
install.packages("png")
library(png)
install.packages("factoextra")
library(factoextra)


#path setings
path_homework<-getwd()
#solo per federico
path_homework<-paste0(path_homework,"/GitHub/DataScienceHomeworks/Homework2/")
plots<-paste0(path_homework,"/Visualizations/")


############
###TASK 1###
############
#bisogna eseguire hclust e kmeans sui dati di partenza, produrre dendrogramma,
#analisi di sensibilità e confrontare i due risultati

execute_kmeans <- function(data, k=4) {
  #questa funzione esegue kmeans per un dato k e produce il grafico
  fit <- kmeans(data, k)
  plot(data, col=fit$cluster+1, pch=16)
  points(fit$centers, pch=7, col="black")
}


#import dei dati da flows1.csv
flows<-read.csv(paste0(path_homework,"flows1.csv"),header = TRUE)


####K-MEANS###################
#analisi di sensibilità kmeans
#si esegue kmeans per vari valori di k e si plotta l'andamento del withinss
tss<-seq(1,10,1) 
for ( i in 1:10) tss[i] <- kmeans(flows,i)$tot.withinss
png(filename = paste0(plots, "Task1 - Sensibility analysis kmeans.png"), width = 1000, height = 800)
plot(tss, main = "Sensibility analysis - kmeans tot.withinss", type = "o", lwd = 1.5, xlab = "k",cex=2, cex.main = 2)
dev.off()

#plot per il valore ottimale trovato, ovvero k=4. Siccome sono 8 dimensioni verranno plottate tutte le coppie di due dimensioni
png(filename = paste0(plots, "Task1 - kmeans.png"), width = 1000, height = 800)
execute_kmeans(flows,4)
dev.off()



####HCLUST#######
#definizione della distanza ed esecuzione del clustering
d<-dist(flows,method = "euclidean")
fit<-hclust(d,method="ward.D")

#plot del dendrogramma
png(filename = paste0(plots,"Task1 - hclust plot.png"), width = 1000, height = 800)
plot(fit, labels = FALSE)
groups <- cutree(fit, k=4) 
rect.hclust(fit, k=4, border="red")
dev.off()

############
###TASK 2###
############

plot_variance_explained <- function(pc, percentage_line = 90) {
  #questa funzione mostra quante PC servono per raggiungere il 90% della varianza spiegata
  
  # Calcolo della varianza percentuale spiegata da ogni PC
  var_exp <- (pc$sdev^2 / sum(pc$sdev^2)) * 100
  print("Percentuale di varianza spiegata da ogni PC:")
  print(var_exp)
  
  cum_var_exp <- cumsum(var_exp)
  
  # Creazione del grafico
  plot(cum_var_exp, type = "b", xlab = "number of PCs", ylab = "% of variance explained",
       main = "Percentage of variance explained by PCs", ylim = c(0, 100), cex.main = 2)
  
  # Tracciamento della linea alla percentuale specificata
  abline(h = percentage_line, col = "red", lwd = 2, lty = 2)
  
  # Aggiunta dell'annotazione
  text(x = length(cum_var_exp), y = percentage_line-4, 
       labels = paste(percentage_line, "% of the variance"), pos = 2, col = "red")
}

#PCA UNSCALED
PC <- prcomp(data, scale=FALSE)

# Unscaled screeplot
png(filename = paste0(plots, "Task2 - unscaled screeplot.png"), width = 1000, height = 800)
screeplot(PC, main = "PC with scale=FALSE")
dev.off()

# Unscaled biplot
png(filename = paste0(plots, "Task2 - unscaled biplot.png"), width = 1000, height = 800)
fviz_pca_var(PC)
dev.off()

#unscaled 90% variance explained
png(filename = paste0(plots, "Task2 - unscaled PCs variance.png"), width = 1000, height = 800)
plot_variance_explained(PC,90)
dev.off()

#[1] "Percentuale di varianza spiegata da ogni PC:"
#[1] 9.932418e+01 6.506203e-01 2.201085e-02 3.187339e-03 4.460643e-07 3.933665e-10 5.977741e-12 1.260364e-14


#PCA SCALED
PC <- prcomp(data, scale=TRUE)

# scaled screeplot
png(filename = paste0(plots, "Task2 - scaled screeplot.png"), width = 1000, height = 800)
screeplot(PC, main = "PC with scale=TRUE")
dev.off()

# Scaled biplot
png(filename = paste0(plots, "Task2 - scaled biplot.png"), width = 1000, height = 800)
fviz_pca_var(PC)
dev.off()

#scaled 90% variance explained
png(filename = paste0(plots, "Task2 - scaled PCs variance.png"), width = 1000, height = 800)
plot_variance_explained(PC,90)
dev.off()

#[1] "Percentuale di varianza spiegata da ogni PC:"
#[1] 31.9454414 24.2796545 13.4219435 11.8890142 11.0679474  5.3059265  1.1063661  0.9837064


############
###TASK 3###
############

#Con scale=TRUE biplot per analizzare le coppie di variabili correlate/anticorrelate/non correlate

PC <- prcomp(data, scale=TRUE)
fviz_pca_var(PC)


# Identificare tutte le variabili correlate e anticorrelate
# Fatto tramite analisi visiva
# anticorrelate: ("Total.TCP.Flow.Time" - "Average.Packet.Size"), ("Bwd.Packet.Length.Std" - "Total.TCP.Flow.Time")
# non correlate: ("Fwd.IAT.Std" - "Total.Length.of.Bwd.Packet"), ("Flow.Duration" - "Total.Length.of.Bwd.Packet"),
                # ("Fwd.IAT.Std" - "Total.Fwd.Packet"), ("Flow.Duration" - "Total.Fwd.Packet"), ("Total.Fwd.Packet", "Total.TCP.Flow.Time")
                # ("Flow.Bytes.s" - "Average.Packet.Size")
# correlate: ("Bwd.Packet.Length.Std" - "Average.Packet.Size"), ("Fwd.IAT.Std" - "Flow.Duration"), ("Total.Length.of.Bwd.Packet" - "Total.Fwd.Packet")

analyze_var<-function(data,xname,yname,corr,vis_path){
  #Questa funzione produce uno scatterplot, un modello lineare e un grafico con intervalli di confidenza e predizione
  x=data[[xname]]
  y=data[[yname]]
  
  #scatterplot
  png(filename = paste0(vis_path, "Task3 - Scatterplot of ",xname," - ",yname," (",corr,").png"), width = 1000, height = 800)
  plot(x,y,main=paste0("Scatterplot of ",xname," - ",yname," (",corr,")"),xlab=xname,ylab=yname, cex.main = 2)
  dev.off()
  
  #model fitting
  if (corr != "uncorrelated") {
    png(filename = paste0(vis_path, "Task3 - Linear regression model for ",xname," - ",yname," (",corr,").png"), width = 1000, height = 800)
    plot(x,y,main=paste0("Linear regression model for ",xname," - ",yname," (",corr,")"),xlab=xname,ylab=yname, cex.main = 2)
    model<-lm(y ~ x)
    abline(model,col="blue")
    print(paste0("R squared for ",xname," - ",yname," regression model: ",summary(model)$r.squared))
    cint<-predict(model, level = 0.95, interval = "confidence") 
    pint<-predict(model, level = 0.95, interval = "prediction") 
    
    lines(x, cint[,2], type="o", lty=2, col="magenta") 
    lines(x, cint[,3], type="o", lty=2, col="magenta") 
    lines(x, pint[,2], type="o", lty=2) 
    lines(x, pint[,3], type="o", lty=2)
    dev.off()
  }
}

# Variabili anticorrelate
analyze_var(flows, "Total.TCP.Flow.Time", "Average.Packet.Size", "anticorrelated",plots)
analyze_var(flows, "Bwd.Packet.Length.Std", "Total.TCP.Flow.Time", "anticorrelated",plots)

# Variabili non correlate
analyze_var(flows, "Fwd.IAT.Std", "Total.Length.of.Bwd.Packet", "uncorrelated",plots)
analyze_var(flows, "Flow.Duration", "Total.Length.of.Bwd.Packet", "uncorrelated",plots)
analyze_var(flows, "Fwd.IAT.Std", "Total.Fwd.Packet", "uncorrelated",plots)
analyze_var(flows, "Flow.Duration", "Total.Fwd.Packet", "uncorrelated",plots)
analyze_var(flows, "Total.Fwd.Packet", "Total.TCP.Flow.Time", "uncorrelated",plots)
analyze_var(flows, "Flow.Bytes.s", "Average.Packet.Size", "uncorrelated",plots)

# Variabili correlate
analyze_var(flows, "Bwd.Packet.Length.Std", "Average.Packet.Size", "correlated",plots)
analyze_var(flows, "Fwd.IAT.Std", "Flow.Duration", "correlated",plots)
analyze_var(flows, "Total.Length.of.Bwd.Packet", "Total.Fwd.Packet", "correlated",plots)

############
###TASK 4###
############
scale=FALSE
PC <- prcomp(data, scale=scale)
PC1 <- PC$x[,1]
PC2 <- PC$x[,2]
pc_df <- data.frame(PC1 = PC1, PC2 = PC2)



####K-MEANS##########
#analisi di sensibilità kmeans

tss<-seq(1,10,1) 
for ( i in 1:10) tss[i] <- kmeans(pc_df,i)$tot.withinss
png(filename = paste0(plots, "Task4 scale=",scale," - Sensibility analysis kmeans.png"), width = 1000, height = 800)
plot(tss, main = "Sensibility analysis - kmeans tot.withinss", type = "o", lwd = 1.5, xlab = "k",cex=2, cex.main = 2)
dev.off()

k=4
png(filename = paste0(plots,"Task4 scale=",scale,"- Kmeans with k=",k,".png"), width = 1000, height = 800)
fit <- kmeans(pc_df, k)
plot(main=paste0("Kmeans with k=",k," and scale=",scale),pc_df, col=fit$cluster+1, pch=16, cex.main = 2)
points(fit$centers, pch=7, col="black")
dev.off()

png(filename = paste0(plots,"Task4 scale=",scale,"- Kmeans with k=",k," (zoomed).png"), width = 1000, height = 800)
fit <- kmeans(pc_df, k)
plot(main=paste0("Kmeans with k=",k," (zoomed, scale=",scale,")"),pc_df, col=fit$cluster+1, pch=16, xlim = c(-4,4), ylim = c(-5,2), cex.main = 2)

#scale=FALSE
#plot(main=paste0("Kmeans with k=",k," (zoomed, scale=",scale,")"),pc_df, col=fit$cluster+1, pch=16, xlim = c(-4000000000,200000000), ylim = c(-100000000,100000000), cex.main = 2)
points(fit$centers, pch=7, col="black")
dev.off()

k=6
png(filename = paste0(plots,"Task4 scale=",scale,"- Kmeans with k=",k,".png"), width = 1000, height = 800)
fit <- kmeans(pc_df, k)
plot(main=paste0("Kmeans with k=",k," and scale=",scale),pc_df, col=fit$cluster+1, pch=16, cex.main = 2)
points(fit$centers, pch=7, col="black")
dev.off()

png(filename = paste0(plots,"Task4 scale=",scale,"- Kmeans with k=",k," (zoomed).png"), width = 1000, height = 800)
fit <- kmeans(pc_df, k)
plot(main=paste0("Kmeans with k=",k," (zoomed, scale=",scale,")"),pc_df, col=fit$cluster+1, pch=16, xlim = c(-4,4), ylim = c(-5,2), cex.main = 2)
points(fit$centers, pch=7, col="black")
dev.off()


####HCLUST#######
d<-dist(pc_df,method = "euclidean")
fit<-hclust(d,method="ward.D")

png(filename = paste0(plots,"Task4 scale=",scale,"- hclust plot with k=4.png"), width = 1000, height = 800)
plot(main=paste0("Kmeans with k=4 and scale=",scale),fit, labels = FALSE, cex.main = 2) 
groups <- cutree(fit, k=4) 
rect.hclust(fit, k=4, border="red")
dev.off()

png(filename = paste0(plots,"Task4 scale=",scale,"- hclust plot with k=6.png"), width = 1000, height = 800)
plot(main=paste0("Kmeans with k=6 and scale=",scale),fit, labels = FALSE, cex.main = 2) 
groups <- cutree(fit, k=6) 
rect.hclust(fit, k=6, border="red")
dev.off()


