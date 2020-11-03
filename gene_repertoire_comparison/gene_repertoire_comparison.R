# clear
cat("\014")
rm(list = ls())

# installing packages - Run lines 6-9 only the first time you run the script
#install.packages("stats")
#install.packages("data.table")
#install.packages("gtools")
#install.packages("mutoss")

# libraries
library(stats)
library(data.table)
library(gtools)
library(mutoss)

# Table of files and groups
file_types <- c("EN", "T")
corresponding_groups <- c("EM", "CIN")

# Extracting codes and groups from files
files_dir <- 'input'
files <- list.files(files_dir)
file_codes <- c()
groups <-  c()

for (file in files){
  
  pecies <- strsplit(file, "_")
  code <- pecies[[1]][3]
  this_code <- unlist(strsplit(code, "[.]"))[1]
  file_codes <- c(file_codes , this_code)
  
  for (j in 1:length(file_types)){
    if (startsWith(this_code, file_types[j])){
      groups <- c(groups, corresponding_groups[j])
    }
  }
}

# Creating the matrices

data_counts <- data.frame()
data_freqs <- data.frame()

for (i in 1:length(files)){
  
  file = files[i]
  file_path <- paste(files_dir, '/', file, sep = "")
  data <- read.table(file_path, sep = "", header = TRUE)
  
  row1 <- c(data$N)
  row2 <- c(data$Freq)
  
  df1 <- data.frame(row1)
  df1 <- transpose(df1)
  names(df1) <- c(data$Gene)
   
  df2 <- data.frame(row2)
  df2 <- transpose(df2)
  names(df2) <- c(data$Gene)
   
  data_counts = smartbind(data_counts, df1)
  data_freqs = smartbind(data_freqs, df2)
  
}
row.names(data_counts) <- file_codes
row.names(data_freqs) <- file_codes
data_counts[is.na(data_counts)] <- 0
data_freqs[is.na(data_freqs)] <- 0

newcolnames <- c()
for (name in colnames(data_counts)){
  newcolnames <- c(newcolnames, strsplit(name, split = " ")[[1]][2])
}
colnames(data_counts) <- newcolnames
colnames(data_freqs) <- newcolnames

data_counts <- data_counts[, order(names(data_counts))]
data_freqs <- data_freqs[, order(names(data_freqs))]

# Extracting p_values
p_vals <- c()
#a <- unclass(factor(groups))

for (i in 1:ncol(data_counts)){
  w_test <- kruskal.test(data_counts[[i]] ~ groups)
  p_vals <- c(p_vals, w_test$p.value)
  
}
genes <- colnames(data_counts)

# Sorting
genes <- genes[order(p_vals, decreasing=FALSE)]
spvals <- sort(p_vals, index.return = TRUE)
p_vals <- spvals$x
sort_idices <- spvals$ix
rank <- c(1:length(p_vals))

# BH correction
Q1 <- c()
Q2 <- c()
alpha1 <- 0.1
alpha2 <- 0.05

for (i in 1:length(p_vals)){
  Q1 <- c(Q1, i*alpha1/length(p_vals))
  Q2 <- c(Q2, i*alpha2/length(p_vals))
}

bh_table_1 <- BH(pValues = p_vals, alpha = alpha1, silent = TRUE)
bh_1 <- bh_table_1$rejected

bh_table_2 <- BH(pValues = p_vals, alpha = alpha2, silent = TRUE)
bh_2 <- bh_table_2$rejected

bf_test <- bonferroni(p_vals, alpha = 0.05, silent = TRUE)
bf <- bf_test$rejected
bf_q <- rep(0.05/length(p_vals)  , times = length(p_vals))

# Constructing the total table
mydata <- data.frame(p_vals,genes, rank, Q1, bh_1, Q2, bh_2, bf_q, bf)
colnames(mydata) <- c("p-values","genes", "rank", "(i/m)Q (Q=0.1)", "BH correction (Q = 0.1)",
                      "(i/m)Q (Q=0.05)", "BH correction (Q = 0.05)",
                      "Bonferroni threshold", "Bonferroni correction (a = 0.05)")
rownames(mydata) <- sort_idices
write.csv(mydata, 'output/analysis.csv')