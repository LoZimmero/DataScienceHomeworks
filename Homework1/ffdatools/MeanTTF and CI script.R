library(dplyr)
library(boot)
library(tidyr)
# Importa interarrivals
cw <- getwd()

##########ROBA AGGIUNTA#############

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
##########FINE ROBA AGGIUNTA#############


interarrivals<-read.delim(paste0(cw,"/ffdatools/tuples-bglsep_1-120/interarrivals.txt"),header = FALSE)

# Usa i dati da interarrivals
data <- interarrivals

# Calcola la media e la deviazione standard
mean_time <- mean(data$V1, na.rm = TRUE)
std_dev <- sd(data$V1, na.rm = TRUE)

##########ROBA AGGIUNTA#############
# Calcolo manuale di intervalli di confidenza.
# Step 1: Dividere i dati in liste di gruppi di 30 elementi
#n <- length(data$X17508)
#k <- 30
#processed_data <- split(data$X17508, rep(1:ceiling(n/k), each=k)[1:n])
# Step 2: Calcolare la media per ogni gruppo di 30 elementi
#processed_data <- lapply(processed_data, mean)
#processed_data <- unlist(as.list(t(processed_data)))

find_confidence_interval(data$V1,0.05)
find_confidence_interval(data$V1,0.10)
##########FINE ROBA AGGIUNTA#############

# Step 3: Recuperare dalla tabella della teoria lo Z(1-alpha) desiderato per 90% e 95% per samples da 30 elementi
#z90 <- 1.687
#z95 <- 2.042


# Calcola gli intervalli di confidenza al 90% e al 95%
ci_90 <- t.test(data$X1, conf.level = 0.90)$conf.int
ci_95 <- t.test(data$X1, conf.level = 0.95)$conf.int

# Stampa i risultati
print(paste("Media del time to failure:", mean_time, "±", (ci_90[2]-ci_90[1])/2))
print(paste("Deviazione standard del time to failure:", std_dev))
print(paste("Intervallo di confidenza al 90% del time to failure:", ci_90))
print(paste("Intervallo di confidenza al 95% del time to failure:", ci_95))

# extra
# Bootstrap
boot_obj <- boot(data = data$X1, statistic = function(data, indices) mean(data[indices]), R = 10000)

# Calcola gli intervalli di confidenza al 90% e al 95%
ci_boot_90 <- boot.ci(boot_obj, conf = 0.90, type = "perc")
ci_boot_95 <- boot.ci(boot_obj, conf = 0.95, type = "perc")

# Stampa i risultati
print(paste("Media del time to failure:", mean_time, "±", (ci_boot_90$percent[5] - ci_boot_90$percent[4])/2))
print(paste("Deviazione standard del time to failure:", std_dev))
print(paste("(Bootstrap) Intervallo di confidenza al 90% del time to failure:", ci_boot_90$percent[4:5]))
print(paste("(Bootstrap) Intervallo di confidenza al 95% del time to failure:", ci_boot_95$percent[4:5]))

