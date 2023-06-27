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