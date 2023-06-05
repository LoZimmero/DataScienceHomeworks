septdata<-read.delim("C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/ffdatools/counts/tcount-bglsep_1.txt")
plot(septdata$CWIN,septdata$COUNT,xlab = "CWIN",ylab = "count",col="blue",type = "ol",xlim = c(0,300),ylim = c(0,1200))
title(main="September data")

octdata<-read.delim("C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/ffdatools/counts/tcount-bgloct_1.txt",header = FALSE)
plot(octdata$V1,octdata$V2,xlab = "CWIN",ylab = "count",col="blue",type = "ol",xlim = c(0,300),ylim = c(0,600))
title(main="October data")

### Si potrebbe usare la differenza tra un valore di count e il successivo per vedere quando finisce di variare in maniera significativa
# calcola la differenza tra i valori successivi di count
diff.countsept <- -(diff(septdata$COUNT))
diff.countoct <- -(diff(octdata$V2))

# aggiungi NA alla fine per allineare con i valori di CWIN, o all'inizio se fai inverso
diff.countsept <- c(NA,diff.countsept)
diff.countoct <- c(NA,diff.countoct)

# crea il grafico
plot(septdata$CWIN, diff.countsept, xlab = "CWIN", ylab = "difference in count", col="blue", type = "o", xlim = c(0,300), ylim = c(0,300))
title(main = "Variation in CWIN - September")
plot(octdata$V1, diff.countoct, xlab = "CWIN", ylab = "difference in count", col="blue", type = "o", xlim = c(0,300), ylim = c(0,150))
title(main = "Variation in CWIN - October")

### fine parte che non c'è nell'homework ###

##Qua si gira lo script per generare interarrivals

###importiamo interarrivals
pathsept<- "C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/ffdatools/tuples-bglsep_1-120/interarrivals.txt"
pathoct<- "C:/Users/fonde/Documents/GitHub/DataScienceHomeworks/Homework1/ffdatools/tuples-bgloct_1-100/interarrivals.txt"

interarrivals<-read.delim(pathsept,header = FALSE)

#Calkcolo ecdf
TTF<-ecdf(interarrivals$V1)

#knots ci restituisce i punti in cui una certa funzione è stata valutata
#l'output sarà quindi una parte di tutti gli interarrivi
t<-knots(TTF)
par(cex=1.3)
plot(t,TTF(t),col="red",xlim=c(0,50000),type="ol",xlab = "time(s)",ylab = "P ( X<X(t) )")
title(main="ECDF - September interarrivals")
title(main="ECDF - October interarrivals")

#questa è la reliability empirica
r<- 1-TTF(t)
title(main="ECDF and Reliability - October interarrivals")
legend("topright", legend = c("Reliability", "ECDF"), col = c("blue", "red"), pch = 1)

lines(t,r,col="blue",xlim=c(0,50000),type="ol",xlab = "time(s)",ylab = "p")

#sovrapponiamo il modello ai punti sperimentali
plot(t,r,xlim=c(0,40000))

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

hyperexp3 <- nls(r~0.5*exp(-(l1*t))+0.3*exp(-(l2*t))+0.2*exp(-(l3*t)), start = list(
  l1=0.1/mean(interarrivals$V1),
  l2=1/mean(interarrivals$V1),
  l3=0.9/mean(interarrivals$V1)
))

lines( t, predict(hyperexp1), col="green", lwd=2)
lines( t, predict(hyperexp2), col="magenta", lwd=2)
lines( t, predict(hyperexp3), col="orange", lwd=2)

legend("topright", legend = c("ECDF","hyperexp 1","hyperexp 2","hyperexp 3"), col = c("black","green","magenta","orange"), pch = 1)
title("Models fitting - Hyperexponential variations (zoomed)")

lines( t, predict(expfit), col="blue", lwd=2)
lines( t, predict(weifit), col="red", lwd=2)

legend("topright", legend = c("ECDF","expfit", "weifit","hyperexp","hyperexp","hyperexp"), col = c("black","blue", "red","green","magenta","orange"), pch = 1)
title("Models fitting (zoomed)")

##tets di ks
ks.test(r,predict(expfit))
ks.test(r,predict(weifit))
ks.test(r,predict(hyperexp1))
ks.test(r,predict(hyperexp2))
ks.test(r,predict(hyperexp3))

### Analisi su interarrivals

# Calcola le statistiche descrittive
summary(interarrivals$V1)

# Calcola la media
mean_time <- mean(interarrivals$V1)

# Calcola la mediana
median_time <- median(interarrivals$V1)

# Calcola la deviazione standard
sd_time <- sd(interarrivals$V1)

# Crea un istogramma con più bin
hist(interarrivals$V1, breaks = 30, main = "Interarrival times - September",freq = FALSE,
     xlab = "Interarrival Time (seconds)",
     col = "lightblue", border = "black")
lines(density(interarrivals$V1), col="red", lwd=2)

# Crea un boxplot
boxplot(interarrivals$V1, main = "Interarrival Times - September",boxwex=0.4,
        ylab = "Interarrival Time (seconds)", col = "lightblue",
        names = c("Interarrivals"))

# Aggiungi i valori al boxplot
text(1, mean_time, paste("Mean =", round(mean_time, 2)), adj = c(0,1.5))
text(1, median_time, paste("Median =", round(median_time, 2)), adj = c(0, -1.5))
text(1, max(interarrivals$V1), paste("Max =", max(interarrivals$V1)), adj = c(0, -1.5))
text(1, min(interarrivals$V1), paste("Min =", min(interarrivals$V1)), adj = c(0, 1.5))

# Crea un grafico della distribuzione con i valori di tendenza centrale
plot(density(interarrivals$V1), main = "Interarrival times distribution - October",
     xlab = "Interarrival Time (seconds)")
abline(v = mean_time, col = "red", lwd = 2)  # Media
abline(v = median_time, col = "blue", lwd = 2)  # Mediana

# Aggiungi una legenda
legend("topright", legend = c("Mean", "Median"),
       col = c("red", "blue"), lwd = 2)
