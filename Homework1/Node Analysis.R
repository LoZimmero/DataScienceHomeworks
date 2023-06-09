##Qua si gira lo script per generare interarrivals
install.packages("png")
library(png)

###importiamo interarrivals

###qua ci va il nome della cartella
nodedir <- "R62-M0-N0_output-100"

node <- substr(nodedir, 1, 9)

path<-paste0("C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/ffdatools/tuples-nodes/",nodedir,"/interarrivals.txt")
vis_path<-"C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/Visualizations/Nodes"
interarrivals<-read.delim(path,header = FALSE)

#Calcolo ecdf
TTF<-ecdf(interarrivals$V1)

#knots ci restituisce i punti in cui una certa funzione è stata valutata
#l'output sarà quindi una parte di tutti gli interarrivi

plot_title<-paste0("Node ",node," - ECDF")
png(filename=paste0(vis_path,plot_title,'.png'), width = 800, height = 600)
t<-knots(TTF)
par(cex=1.3)
plot(t,TTF(t),col="red",xlim=c(0,50000),type="ol",xlab = "time(s)",ylab = "P ( X<X(t) )")
title(main=plot_title)
dev.off()

#questa è la reliability empirica

plot_title<-paste0("Node ",node," - ECDF and Reliability")
png(filename=paste0(vis_path,plot_title,'.png'), width = 800, height = 600)
plot(t,TTF(t),col="red",xlim=c(0,50000),type="ol",xlab = "time(s)",ylab = "P ( X<X(t) )")
r<- 1-TTF(t)
title(main=plot_title)
legend("topright", legend = c("Reliability", "ECDF"), col = c("blue", "red"), pch = 1)
lines(t,r,col="blue",xlim=c(0,50000),type="ol",xlab = "time(s)",ylab = "p")
dev.off()

#sovrapponiamo il modello ai punti sperimentali
# Ripristino dei parametri di grafica predefiniti

plot_title<-paste0("Node ",node," - Hyperexponential variations")
png(filename=paste0(vis_path,plot_title,'.png'), width = 800, height = 600)
plot(t,r)
title(main=plot_title)

expfit<-nls(r~exp(-(l*t)), start = list(l=1/mean(interarrivals$V1)))
weifit<-nls(r~exp(-(l*t)^a), start = list(l=1/mean(interarrivals$V1), a=0.9))

hyperexp1 <- nls(r~0.5*exp(-(l1*t))+0.5*exp(-(l2*t)), start = list(
  l1=1/mean(interarrivals$V1),
  l2=0.1/mean(interarrivals$V1) # Mettiamo il secondo lambda 1/10 del primo
))

hyperexp2 <- nls(r~0.3*exp(-(l1*t))+0.7*exp(-(l2*t)), start = list(
  l1=1/mean(interarrivals$V1),
  l2=0.1/mean(interarrivals$V1) # Mettiamo il secondo lambda 1/10 del primo
))

##temporary fix, doesn't work with october and september model parameters
hyperexp3 <- nls(r ~ 0.2 * exp(-(l1 * t)) + 0.3 * exp(-(l2 * t)) + 0.5 * exp(-(l3 * t)),
                 start = list(
                   l1 = 1 / mean(interarrivals$V1),
                   l2 = 0.5 / mean(interarrivals$V1),
                   l3 = 0.2 / mean(interarrivals$V1)
                 )
                 , #control = nls.control(minFactor = 0.001)
)



lines( t, predict(hyperexp1), col="green", lwd=2)
lines( t, predict(hyperexp2), col="magenta", lwd=2)
lines( t, predict(hyperexp3), col="orange", lwd=2)

legend("topright", legend = c("ECDF","hyperexp 1","hyperexp 2","hyperexp 3"), col = c("black","green","magenta","orange"), pch = 1)
dev.off()

plot_title<-paste0("Node ",node," - Reliability modelling")
png(filename=paste0(vis_path,plot_title,'.png'), width = 800, height = 600)
plot(t,r)
title(main=plot_title)

lines( t, predict(expfit), col="blue", lwd=2)
lines( t, predict(weifit), col="red", lwd=2)
lines( t, predict(hyperexp1), col="green", lwd=2)
lines( t, predict(hyperexp2), col="magenta", lwd=2)
lines( t, predict(hyperexp3), col="orange", lwd=2)

legend("topright", legend = c("ECDF","expfit", "weifit","hyperexp","hyperexp","hyperexp"), col = c("black","blue", "red","green","magenta","orange"), pch = 1)


##tets di ks
ks.test(r,predict(expfit))
ks.test(r,predict(weifit))
ks.test(r,predict(hyperexp1))
ks.test(r,predict(hyperexp2))
ks.test(r,predict(hyperexp3))


####chatgpt code#####
####aggiungo roba interessante#####
models <- list(expfit, weifit, hyperexp1, hyperexp2, hyperexp3)
model_names <- c("expfit", "weifit", "hyperexp1", "hyperexp2", "hyperexp3")

for (i in 1:length(models)) {
  model <- models[[i]]
  model_name <- model_names[i]
  
  residuals <- residuals(model)
  qqnorm(residuals)
  qqline(residuals)
   
  plot_title <- paste0("Node ",node, " - Residuals vs Predicted", model_name)
  png(filename = paste0(vis_path, plot_title, '.png'), width = 800, height = 600)
  predicted_response <- predict(model)
  plot(predicted_response, residuals, 
       xlab = "Predicted", ylab = "Residuals", 
       main = plot_title)
  abline(h = 0, col = "red")
  dev.off()
  
  plot_title <- paste0("Node ",node, " - Residuals vs Experiment Number", model_name)
  png(filename = paste0(vis_path, plot_title, '.png'), width = 800, height = 600)
  plot(residuals, 
       xlab = "Experiment Number", ylab = "Residuals", 
       main = plot_title)
  abline(h = 0, col = "red")
  dev.off()
}


### Analisi su interarrivals ########################
# Specifica i dettagli dei nodi
node_dirs <- c("R62-M0-N0_output-100", "R62-M0-N4_output-100", "R62-M0-NC_output-100")
nodes <- substr(node_dirs, 1, 9)

all_data <- list()

# Itera sui nodi
for (i in 1:length(node_dirs)) {
  nodedir <- node_dirs[i]
  node <- nodes[i]
  
  # Specifica il percorso del file dati
  path <- paste0("C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/ffdatools/tuples-nodes/", nodedir, "/interarrivals.txt")
  
  # Specifica il percorso di salvataggio dei grafici
  vis_path <- paste0("C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/Visualizations/Nodes/Interarrivals analysis/", node)
  
  # Carica i dati
  interarrivals <- read.delim(path, header = FALSE)
  
  
  # Aggiungi i dati alla lista
  all_data[[node]] <- interarrivals$V1
  
  # Calcola le statistiche descrittive
  print(paste("Summary for Node ", node))
  print(summary(interarrivals$V1))
  
  # Calcola la media
  mean_time <- mean(interarrivals$V1)
  
  # Calcola la mediana
  median_time <- median(interarrivals$V1)
  
  # Calcola la deviazione standard
  sd_time <- sd(interarrivals$V1)
  
  # Crea un istogramma con più bin
  png(filename = paste0(vis_path,node, " - Interarrival times.png"))
  hist(interarrivals$V1, breaks = 30, main = paste("Interarrival times - Node ", node), freq = FALSE,
       xlab = "Interarrival Time (seconds)",
       col = "lightblue", border = "black")
  lines(density(interarrivals$V1), col = "red", lwd = 2)
  dev.off()
  
  # Crea un grafico della distribuzione con i valori di tendenza centrale
  png(filename = paste0(vis_path,node, " - Interarrival times distribution.png"))
  plot(density(interarrivals$V1), main = paste("Interarrival times distribution - Node", node),
       xlab = "Interarrival Time (seconds)")
  abline(v = mean_time, col = "red", lwd = 2)  # Media
  abline(v = median_time, col = "blue", lwd = 2)  # Mediana
  
  # Aggiungi una legenda
  legend("topright", legend = c("Mean", "Median"),
         col = c("red", "blue"), lwd = 2)
  dev.off()
}
pathsept<- "C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/ffdatools/tuples-bgloct_1-100/interarrivals.txt"
interarrivals_sept<-read.delim(pathsept,header = FALSE)
all_data[["sept"]] <- interarrivals_sept$V1
all_data
nodes<-append(nodes,"sept")

#Serve a levare la notazione scientifica
options(scipen = 5)

# Crea un boxplot combinato per tutti i nodi
png(filename = "C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/Visualizations/Nodes/Interarrival_Times_All_Nodes.png")
boxplot(all_data, main = "Interarrival Times - All Nodes",
        boxwex = 0.4, ylab = "Interarrival Time (seconds)", col = c("lightblue", "lightgreen"),
        names = nodes)
dev.off()


