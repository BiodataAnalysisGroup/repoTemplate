# clear
cat("\014")
rm(list = ls())
dev.off(dev.list()["RStudioGD"])

# installing packages - Run lines 7-11 only the first time you run the script
#install.packages("devtools")
#devtools::install_github('gastonstat/arcdiagram')
#install.packages("data.table")
#install.packages("RColorBrewer")
#install.packages("colorspace")

# Librarues
library(arcdiagram)
library(data.table)
library(RColorBrewer)
library(colorspace)


# library(igraph)
# library(reshape)
# library(dplyr)


# mis_graph = read.graph("lesmiserables.txt", format = "gml")
clono = list()

clono[["T14"]] = fread("arc_diagram/input/Clonotypes_T14.txt")
clono[["T19"]] = fread("arc_diagram/input/Clonotypes_T19.txt")
clono[["T20"]] = fread("arc_diagram/input/Clonotypes_T20.txt")

for(i in names(clono)){
        
        clono[[i]]$barcode = paste(clono[[i]]$Genes, clono[[i]]$CDR3, sep = " - ")
        
}

# get edgelist

# edgelist = get.edgelist(mis_graph)

edgelist = list()

samples = names(clono)

temp = data.table(from = 0, to = 0, weight = 0)

for(i in 1:(length(samples) - 1)){
        for(j in (i + 1):length(samples)){
                
                        temp$from = i
                        temp$to = j
                        temp$weight = length(which(clono[[samples[i]]]$barcode %in% clono[[samples[j]]]$barcode))
                        
                        edgelist[[paste(samples[i], samples[j], sep = "-")]] = temp   
        }
}

edgelist = rbindlist(edgelist)

# filter edges
# edgelist = edgelist[which(edgelist[,1] <= 15), ]
# edgelist = edgelist[which(edgelist[,2] <= 15), ]

# get vertex labels
# I can put name on clonotypes/samples

samples

# vlabels = get.vertex.attribute(mis_graph, "label")

# get vertex groups
# different samples
# vgroups = get.vertex.attribute(mis_graph, "group")

samples

# get vertex fill color
# different color for each group
# vfill = get.vertex.attribute(mis_graph, "fill")

vfill = brewer.pal(length(clono), name = "Dark2")

# get vertex border color
# border color for the nodes
# vborders = get.vertex.attribute(mis_graph, "border")

vborders = lighten(vfill, amount = 0.3, space = "combined")

# get vertex degree
# frequency of every clonotype
# degrees = degree(mis_graph)

degrees = c()

for(i in samples){
        degrees = c(degrees, length(unique(clono[[i]]$barcode)))
}

# get edges value
# how strong the connection is
values = edgelist$weight # get.edge.attribute(mis_graph, "value")



# arranging based on groups and clonotype frequency

# data frame with vgroups, degree, vlabels and ind
# x = data.frame(samples, degrees, samples, ind=1:vcount(mis_graph))
# arranging by vgroups and degrees
# y = arrange(x, desc(vgroups), desc(degrees))
# get ordering 'ind'
# new_ord = y$ind


# rm(mis_graph, x, y, vgroups)

# dev.new(width=10, height=10)

par(oma = c(0,0,0,0))

png(file = 'arc_diagram/output/arcplot.png', width = 1000, height = 600)
# plot arc diagram
arcplot(as.matrix(edgelist[,1:2]), 
        # ordering = new_ord, 
        labels = samples, 
        cex.labels = 0.8,
        show.nodes = TRUE, 
        col.nodes = vfill, 
        bg.nodes = vborders,
        cex.nodes = 5 * degrees / max(degrees), 
        pch.nodes = 21,
        lwd.nodes = 2, line = 0.5,
        outer = FALSE, 
        col.arcs = hsv(0, 0, 0.2, 0.25), 
        lwd.arcs = 5 * values / max(values))

dev.off()

