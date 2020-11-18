# Welcome to the new project!
# Please mind to maintain the structure of the file and the total project
# as it is

# Initialization - clearing up console and variables
cat("\014")
rm(list = ls())
dev.off(dev.list()["RStudioGD"])

# Libraries - Here you should add your own libraries
# Warning: The following libraries are not used at all, they are just examples
library(stats)
library(readxl)

# Input and output folder
inputfolder <- paste(dirname(getwd()), "/input/analysis/", sep = '')
outputfolder <- paste(dirname(getwd()), "/output/analysis/", sep = '')

# Creating the output direction
# If the output folder already exists, a warning will appear in your console.
dir.create(outputfolder)

############## ANALYSIS ###############
# This is the analysis part
# Feel free to write your own code here

# EXAMPLE - Please read it and then remove the lines 27-42,
# in order fill your own code

# Loading file
fn <- paste(inputfolder, 'example.txt', sep = '')
inputstring <- readChar(fn, file.info(fn)$size)

# Analysis - printing
print(inputstring)

# Saving to output file
outputstring <- 'This is the output string.'
outputfile <-paste(outputfolder, 'output.txt', sep = '')
writeLines(c(outputstring), outputfile)

# GOOD LUCK