##Qua si gira lo script per generare interarrivals
install.packages("png")
library(png)
library(boot)

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
  print(c(lower_bound,upper_bound))
}

#########
# Specifica i dettagli dei nodi
node_dirs <- c("R62-M0-N0_output-100", "R62-M0-N4_output-100", "R62-M0-NC_output-100","R63-M1-N0_output-100","R63-M1-N8_output-100","R63-M1-NC_output-100")
nodes <- substr(node_dirs, 1, 9)
# Get current file path
CURR_FILE_PATH <- getwd()

#solo per il pc di federico
CURR_FILE_PATH<-paste0(CURR_FILE_PATH,"/GitHub/DataScienceHomeworks/Homework1")


# method paste() to join strings. MUST use sep="" to avoid adding empty space between strings
FFDATOOLS <- paste(CURR_FILE_PATH, "/ffdatools", sep="")

all_data <- list()

#Serve a levare la notazione scientifica
options(scipen = 5)

# Assumiamo che tu abbia già installato e caricato il pacchetto 'boot'. Se no, installalo con install.packages('boot') e poi caricalo con library(boot)

for (i in 1:length(node_dirs)) {
  nodedir <- node_dirs[i]
  node <- nodes[i]
  
  # Specifica il percorso del file dati
  path <- paste0(CURR_FILE_PATH,"/ffdatools/tuples-nodes/", nodedir, "/interarrivals.txt")
  
  vis_path_node<-paste0(CURR_FILE_PATH,"/Visualizations/Nodes/",node,"/",sep="")
  interarrivals<-read.delim(path,header = FALSE)
  vis_path<-paste0(vis_path_node,"Reliability modelling/",sep="")
  
  data<-interarrivals
  print(node)
  print("media:")
  mean_time <- mean(data$V1, na.rm = TRUE)
  print(mean_time)
  print("deviazione standard:")
  std_dev <- sd(data$V1, na.rm = TRUE)
  print(std_dev)
  
  # Calcolo dell'intervallo di confidenza al 90% e 95% con bootstrap
  boot_obj <- boot(data = data$V1, statistic = function(x,i) mean(x[i]), R = 1000)
  
  ci_90 <- boot.ci(boot.out = boot_obj, conf = 0.9, type = "bca")
  print("Intervallo di confidenza al 90%:")
  print(ci_90)
  
  ci_95 <- boot.ci(boot.out = boot_obj, conf = 0.95, type = "bca")
  print("Intervallo di confidenza al 95%:")
  print(ci_95)
  
}


