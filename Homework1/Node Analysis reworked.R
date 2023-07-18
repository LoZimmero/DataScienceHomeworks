##Prima si gira lo script per generare interarrivals
install.packages("png")
library(png)
library(fmsb)

##########
find_confidence_interval <- function(my_list, alpha) {
  # R program to find the confidence interval
  
  # Calculate the mean of the sample data
  mean_value <- mean(my_list)
  
  # Compute the size
  n <- length(my_list)
  
  # Find the standard deviation
  standard_deviation <- sd(my_list)
  
  # Find the standard error
  standard_error <- standard_deviation / sqrt(n)
  degrees_of_freedom = n - 1
  t_score = qt(p=alpha/2, df=degrees_of_freedom,
               lower.tail=F
  )
  margin_error <- t_score * standard_error
  
  # Calculating lower bound and upper bound
  lower_bound <- mean_value - margin_error
  upper_bound <- mean_value + margin_error
  
  # Print the confidence interval
  c(lower_bound,upper_bound)
}

#########
# Specifica i path dei nodi
node_dirs <- c("R62-M0-N0_output-100", "R62-M0-N4_output-100", "R62-M0-NC_output-100","R63-M1-N0_output-100","R63-M1-N8_output-100","R63-M1-NC_output-100")
nodes <- substr(node_dirs, 1, 9)
# Get current file path
CURR_FILE_PATH <- getwd()

#solo per il pc di federico
CURR_FILE_PATH<-paste0(CURR_FILE_PATH,"/GitHub/DataScienceHomeworks/Homework1")

FFDATOOLS <- paste(CURR_FILE_PATH, "/ffdatools", sep="")

all_data <- list()

#Serve a levare la notazione scientifica (opz.)
options(scipen = 5)

# Itera sui nodi
for (i in 1:length(node_dirs)) {
  nodedir <- node_dirs[i]
  node <- nodes[i]
  
  # Specifica il percorso del file dati
  path <- paste0(CURR_FILE_PATH,"/ffdatools/tuples-nodes/", nodedir, "/interarrivals.txt")
  
  #path per i grafici
  vis_path_node<-paste0(CURR_FILE_PATH,"/Visualizations/Nodes/",node,"/",sep="")
  interarrivals<-read.delim(path,header = FALSE)
  vis_path<-paste0(vis_path_node,"Reliability modelling/",sep="")
  
  data<-interarrivals
  find_confidence_interval(data$V1,0.05)
  find_confidence_interval(data$V1,0.10)
  
  if (!dir.exists(vis_path)) {
    dir.create(vis_path, recursive = TRUE)
  }
  
  print("MEAN")
  print(mean(interarrivals$V1))
  print("MEDIAN")
  print(median(interarrivals$V1))
  print("SD")
  print(sd(interarrivals$V1))
  print("SIQR")
  print(SIQR(interarrivals$V1))
  
  
  #Calcolo ecdf
  TTF<-ecdf(interarrivals$V1)
  
  #knots ci restituisce i punti in cui una certa funzione è stata valutata
  #l'output sarà quindi una parte di tutti gli interarrivi
  plot_title<-paste0("Node ",node," - ECDF")
  png(filename=paste0(vis_path,plot_title,'.png'),width = 1000,height = 800)
  t<-knots(TTF)
  par(cex=1.3)
  plot(t,TTF(t),col="red",xlim=c(0,50000),type="ol",xlab = "time(s)",ylab = "P ( X<X(t) )")
  title(main=plot_title)
  dev.off()
  
  #questa è la reliability empirica
  
  plot_title<-paste0("Node ",node," - ECDF and Reliability")
  png(filename=paste0(vis_path,plot_title,'.png'),width = 1000,height = 800)
  plot(t,TTF(t),col="red",xlim=c(0,50000),type="ol",xlab = "time(s)",ylab = "P ( X<X(t) )")
  r<- 1-TTF(t)
  title(main=plot_title)
  legend("topright", legend = c("Reliability", "ECDF"), col = c("blue", "red"), pch = 1)
  lines(t,r,col="blue",xlim=c(0,50000),type="ol",xlab = "time(s)",ylab = "p")
  dev.off()
  
  #sovrapponiamo il modello ai punti sperimentali
  
  plot_title<-paste0("Node ",node," - Hyperexponential variations")
  png(filename=paste0(vis_path,plot_title,'.png'),width = 1000,height = 800)
  plot(t,r)
  title(main=plot_title)
  
  expfit<-nls(r~exp(-(l*t)), start = list(l=1/mean(interarrivals$V1)))
  weifit<-nls(r~exp(-(l*t)^a), start = list(l=1/mean(interarrivals$V1), a=0.9))
  
  hyperexp1 <- nls(r~0.5*exp(-(l1*t))+0.5*exp(-(l2*t)), start = list(
    l1=1/mean(interarrivals$V1),
    l2=0.1/mean(interarrivals$V1) 
  ))
  
  hyperexp2 <- nls(r~0.3*exp(-(l1*t))+0.7*exp(-(l2*t)), start = list(
    l1=1/mean(interarrivals$V1),
    l2=0.1/mean(interarrivals$V1) 
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
  png(filename=paste0(vis_path,plot_title,'.png'),width = 1000,height = 800)
  plot(t,r)
  title(main=plot_title)
  
  lines( t, predict(expfit), col="blue", lwd=2)
  lines( t, predict(weifit), col="red", lwd=2)
  lines( t, predict(hyperexp1), col="green", lwd=2)
  lines( t, predict(hyperexp2), col="magenta", lwd=2)
  lines( t, predict(hyperexp3), col="orange", lwd=2)
  
  legend("topright", legend = c("ECDF","expfit", "weifit","hyperexp","hyperexp","hyperexp"), col = c("black","blue", "red","green","magenta","orange"), pch = 1)
  dev.off()
  
  ##tets di ks
  print(coef(expfit))
  print(ks.test(r,predict(expfit)))
  print(coef(weifit))
  print(ks.test(r,predict(weifit)))
  print(coef(hyperexp1))
  print(ks.test(r,predict(hyperexp1)))
  print(coef(hyperexp2))
  print(ks.test(r,predict(hyperexp2)))
  print(coef(hyperexp3))
  print(ks.test(r,predict(hyperexp3)))
  
  
  models <- list(expfit, weifit, hyperexp1, hyperexp2, hyperexp3)
  model_names <- c("expfit", "weifit", "hyperexp1", "hyperexp2", "hyperexp3")
  
  for (i in 1:length(models)) {
    model <- models[[i]]
    model_name <- model_names[i]
    
    residuals <- residuals(model)
    vis_path<-paste0(vis_path_node,"Reliability modelling/",model_name,"/",sep="")
    
    if (!dir.exists(vis_path)) {
      dir.create(vis_path, recursive = TRUE)
    }
    
    
    plot_title <- paste0("Node ",node, " - Residuals vs Predicted ", model_name)
    png(filename = paste0(vis_path, plot_title, '.png'),width = 1000,height = 800)
    predicted_response <- predict(model)
    plot(predicted_response, residuals, 
         xlab = "Predicted", ylab = "Residuals", 
         main = plot_title)
    abline(h = 0, col = "red")
    dev.off()
    
    plot_title <- paste0("Node ",node, " - Residuals vs Experiment Number ", model_name)
    png(filename = paste0(vis_path, plot_title, '.png'),width = 1000,height = 800)
    plot(residuals, 
         xlab = "Experiment Number", ylab = "Residuals", 
         main = plot_title)
    abline(h = 0, col = "red")
    dev.off()
    
    # Aggiunta del QQ Plot
    plot_title_qq <- paste0("Node ", node, " - QQ Plot ", model_name)
    png(filename = paste0(vis_path, plot_title_qq, '.png'),width = 1000,height = 800)
    qqnorm(residuals, main = plot_title_qq, ylab = "Quantiles of residuals")
    qqline(residuals, col = "red")
    dev.off()
  }
  
  
  
  
  # Carica i dati
  interarrivals <- read.delim(path, header = FALSE)
  
  # Aggiungi i dati alla lista
  all_data[[node]] <- interarrivals$V1
  
  # Calcola le statistiche descrittive
  print(paste("Summary for Node ", node))
  print(summary(interarrivals$V1))
  
  mean_time <- mean(interarrivals$V1)
  
  median_time <- median(interarrivals$V1)
  
  sd_time <- sd(interarrivals$V1)
  
  vis_path<-paste0(vis_path_node,"interarrival analysis/",sep="")
  
  
  if (!dir.exists(vis_path)) {
    dir.create(vis_path, recursive = TRUE)
  }
  
  # Crea un istogramma
  png(filename = paste0(vis_path,"Node ", node, " - Interarrival times.png"),width = 1000,height = 800)
  hist(interarrivals$V1, breaks = 30, main = paste("Interarrival times - Node ", node), freq = FALSE,
       xlab = "Interarrival Time (seconds)",
       col = "lightblue", border = "black")
  lines(density(interarrivals$V1), col = "red", lwd = 2)
  dev.off()
  
  # Crea un grafico della distribuzione con i valori di tendenza centrale
  png(filename = paste0(vis_path,"Node ", node, " - Interarrival times distribution.png"),width = 1000,height = 800)
  plot(density(interarrivals$V1), main = paste("Interarrival times distribution - Node", node),
       xlab = "Interarrival Time (seconds)")
  abline(v = mean_time, col = "red", lwd = 2)  # Media
  abline(v = median_time, col = "blue", lwd = 2)  # Mediana
  
  # Aggiungi una legenda
  legend("topright", legend = c("Mean", "Median"),
         col = c("red", "blue"), lwd = 2)
  dev.off()
}


# Crea un boxplot combinato per tutti i nodi
png(filename = paste0(CURR_FILE_PATH,"/Visualizations/Nodes/Interarrival_Times_All_Nodes.png"),width = 1000,height = 800)
boxplot(all_data, main = "Interarrival Times - All Nodes",
        boxwex = 0.4, ylab = "Interarrival Time (seconds)", col = c("lightblue", "lightgreen"),
        names = nodes)
dev.off()
