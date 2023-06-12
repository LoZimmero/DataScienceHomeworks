library(dplyr)
library(boot)

# Importa interarrivals
interarrivals<-read.delim("C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/ffdatools/tuples-CSTest-250/interarrivals.txt")

# Usa i dati da interarrivals
data <- interarrivals

# Calcola la media e la deviazione standard
mean_time <- mean(data$X1, na.rm = TRUE)
std_dev <- sd(data$X1, na.rm = TRUE)

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

