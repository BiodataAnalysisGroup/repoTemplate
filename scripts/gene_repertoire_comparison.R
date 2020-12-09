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

# input and output folder
inputfolder <- paste(dirname(getwd()), "/input/gene_repertoire_comparison/", sep = '')
outputfolder <- paste(dirname(getwd()), "/output/gene_repertoire_comparison/", sep = '')

# Table of files and groups
file_types <- c("EN", "T")
corresponding_groups <- c("EN", "CIN")

# Extracting codes and groups from files
files_dir <- inputfolder
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
p_vals_kruskal <- c()
p_vals_chisq <- c()
p_vals_fisher <- c()
#a <- unclass(factor(groups))

for (i in 1:ncol(data_counts)){
  
  # Kruskal Test
  w_test <- kruskal.test(data_counts[[i]]~groups)
  #print(paste('kruskal p-value = ', w_test$p.value, sep = ''))
  p_vals_kruskal <- c(p_vals_kruskal, w_test$p.value)
  
  # Chisq Test
  if (length(unique(data_counts[[i]] )) != 1){
    chisq_test <- chisq.test(data_counts[[i]], groups)
    #print(paste('Chi-square p-value = ', chisq_test$p.value, sep = ''))
    p_vals_chisq <- c(p_vals_chisq, chisq_test$p.value)
    
    fisher_test <- fisher.test(data_counts[[i]], groups)
    #print(paste('Fisher p-value = ', fisher_test$p.value, sep = ''))
    p_vals_fisher <- c(p_vals_fisher, fisher_test$p.value)
  } else {
    p_vals_chisq <- c(p_vals_chisq, 'NaN')
    p_vals_fisher <- c(p_vals_fisher, 'NaN')
  }
}
p_vals_kruskal[which(p_vals_kruskal == 'NaN')] <- 0
p_vals_chisq[which(p_vals_chisq == 'NaN')] <- 0
p_vals_fisher[which(p_vals_fisher == 'NaN')] <- 0

p_vals_fisher <- as.numeric(p_vals_fisher)
p_vals_chisq <- as.numeric(p_vals_chisq)
genes <- colnames(data_counts)

# Sorting
genes_kruskal <- genes[order(p_vals_kruskal, decreasing=FALSE)]
genes_chisq <- genes[order(p_vals_chisq, decreasing=FALSE)]
genes_fisher <- genes[order(p_vals_fisher, decreasing=FALSE)]

spvals_kruskal <- sort(p_vals_kruskal, index.return = TRUE)
spvals_chisq <- sort(p_vals_chisq, index.return = TRUE)
spvals_fisher <- sort(p_vals_fisher, index.return = TRUE)

p_vals_kruskal <- spvals_kruskal$x
p_vals_chisq <- spvals_chisq$x
p_vals_fisher <- spvals_fisher$x

sort_indices_kruskal <- spvals_kruskal$ix
sort_indices_chisq <- spvals_chisq$ix
sort_indices_fisher <- spvals_fisher$ix

rank_kruskal <- c(1:length(p_vals_kruskal))
rank_chisq <- c(1:length(p_vals_chisq))
rank_fisher <- c(1:length(p_vals_fisher))

# BH correction
Q1_kruskal <- c()
Q2_kruskal <- c()

Q1_chisq <- c()
Q2_chisq <- c()

Q1_fisher <- c()
Q2_fisher <- c()

alpha1 <- 0.1
alpha2 <- 0.05

for (i in 1:length(p_vals_kruskal)){
  Q1_kruskal <- c(Q1_kruskal, i*alpha1/length(p_vals_kruskal))
  Q2_kruskal <- c(Q2_kruskal, i*alpha2/length(p_vals_kruskal))
  
  Q1_chisq <- c(Q1_chisq, i*alpha1/length(p_vals_chisq))
  Q2_chisq <- c(Q2_chisq, i*alpha2/length(p_vals_chisq))
  
  Q1_fisher <- c(Q1_fisher, i*alpha1/length(p_vals_fisher))
  Q2_fisher <- c(Q2_fisher, i*alpha2/length(p_vals_fisher))
  
}

# Kruskal
bh_table_1_kruskal<- BH(pValues = p_vals_kruskal, alpha = alpha1, silent = TRUE)
bh_1_kruskal <- bh_table_1_kruskal$rejected

# Chisq
bh_table_1_chisq<- BH(pValues = p_vals_chisq, alpha = alpha1, silent = TRUE)
bh_1_chisq <- bh_table_1_chisq$rejected

# Fisher
bh_table_1_fisher<- BH(pValues = p_vals_fisher, alpha = alpha1, silent = TRUE)
bh_1_fisher <- bh_table_1_fisher$rejected

# Kruskal
bh_table_2_kruskal <- BH(pValues = p_vals_kruskal, alpha = alpha2, silent = TRUE)
bh_2_kruskal <- bh_table_2_kruskal$rejected

# Chisq
bh_table_2_chisq <- BH(pValues = p_vals_chisq, alpha = alpha2, silent = TRUE)
bh_2_chisq <- bh_table_2_chisq$rejected

# Fisher
bh_table_2_fisher <- BH(pValues = p_vals_fisher, alpha = alpha2, silent = TRUE)
bh_2_fisher <- bh_table_2_fisher$rejected

# Kruskal
bf_test_kruskal <- bonferroni(p_vals_kruskal, alpha = 0.05, silent = TRUE)
bf_kruskal <- bf_test_kruskal$rejected
bf_q_kruskal <- rep(0.05/length(p_vals_kruskal)  , times = length(p_vals_kruskal))

# Chisq
bf_test_chisq <- bonferroni(p_vals_chisq, alpha = 0.05, silent = TRUE)
bf_chisq <- bf_test_chisq$rejected
bf_q_chisq <- rep(0.05/length(p_vals_chisq)  , times = length(p_vals_chisq))

# Fisher
bf_test_fisher <- bonferroni(p_vals_fisher, alpha = 0.05, silent = TRUE)
bf_fisher <- bf_test_fisher$rejected
bf_q_fisher <- rep(0.05/length(p_vals_fisher)  , times = length(p_vals_fisher))


# Constructing the total table - Krusal
mydata <- data.frame(p_vals_kruskal,genes_kruskal, rank_kruskal, Q1_kruskal, bh_1_kruskal, Q2_kruskal, bh_2_kruskal, bf_q_kruskal, bf_kruskal)
colnames(mydata) <- c("p-values (Kruskal)","genes", "rank", "(i/m)Q (Q=0.1)", "BH correction (Q = 0.1)",
                      "(i/m)Q (Q=0.05)", "BH correction (Q = 0.05)",
                      "Bonferroni threshold", "Bonferroni correction (a = 0.05)")
rownames(mydata) <- sort_indices_kruskal
write.csv(mydata, paste(outputfolder, 'analysis_kruskal.csv', sep = ''))

# Constructing the total table - Chisq
mydata <- data.frame(p_vals_chisq,genes_chisq, rank_chisq, Q1_chisq, bh_1_chisq, Q2_chisq, bh_2_chisq, bf_q_chisq, bf_chisq)
colnames(mydata) <- c("p-values (Chi-square)","genes", "rank", "(i/m)Q (Q=0.1)", "BH correction (Q = 0.1)",
                      "(i/m)Q (Q=0.05)", "BH correction (Q = 0.05)",
                      "Bonferroni threshold", "Bonferroni correction (a = 0.05)")
rownames(mydata) <- sort_indices_chisq
write.csv(mydata, paste(outputfolder, 'analysis_chi-square.csv', sep = ''))

# Constructing the total table - Fisher
mydata <- data.frame(p_vals_fisher,genes_fisher, rank_fisher, Q1_fisher, bh_1_fisher, Q2_fisher, bh_2_fisher, bf_q_fisher, bf_fisher)
colnames(mydata) <- c("p-values (Fisher)","genes", "rank", "(i/m)Q (Q=0.1)", "BH correction (Q = 0.1)",
                      "(i/m)Q (Q=0.05)", "BH correction (Q = 0.05)",
                      "Bonferroni threshold", "Bonferroni correction (a = 0.05)")
rownames(mydata) <- sort_indices_fisher
write.csv(mydata, paste(outputfolder, 'analysis_fisher.csv', sep = ''))