# Lab 6 DEseq2

library(readr)
library(tximport)
library(DESeq2)
library(dplyr)
library(rjson)
library(ggplot2)

setwd("/Users/maxharman/Library/CloudStorage/OneDrive-KansasStateUniversity/Documents/Michigan State/PLB812/PLB812-main/Lab5/htseq_readcount_tsvs")

#List files in directory
sampleFiles <- list.files("/Users/maxharman/Library/CloudStorage/OneDrive-KansasStateUniversity/Documents/Michigan State/PLB812/PLB812-main/Lab5/htseq_readcount_tsvs")
conditioncol1 <- data.frame(condition = sub("-1.tsv","",sampleFiles))
conditioncol2 <- data.frame(condition = sub("-2.tsv","",conditioncol1$condition))
conditioncol3 <- data.frame(condition = sub("-3.tsv","",conditioncol2$condition))

#Create sampleTable from the file names
sampleTable <- data.frame(sampleName = sub(".tsv","",sampleFiles),
                          fileName = sampleFiles,
                          genotype = sub(".tsv","",sampleFiles),
                          condition = conditioncol3)
                        
#Set the genotype column to factor
sampleTable$condition <- factor(sampleTable$condition)
#Load DESeq2
library(DESeq2)
#Create the DESeq2 object from the HTSeqCount tables
dds <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,
                                  directory = "/Users/maxharman/Library/CloudStorage/OneDrive-KansasStateUniversity/Documents/Michigan State/PLB812/PLB812-main/Lab5/htseq_readcount_tsvs",
                                  design= ~ condition)
#Change factor levels so WT is considered the reference genotype
dds$condition <- relevel(dds$condition, ref = "Control")
#Show the dds object
dds
#Prefilter
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]
#Show the dds object
dds
#Estimate Size Factor - library size
dds <- estimateSizeFactors(dds)
#Show the library size adjustment
dds$sizeFactor
#Estimate the dispersion
#This estimates the dispersion per gene
dds <- estimateDispersions(dds)
#Plot out the dispersions
plotDispEsts(dds)
#Variance stabilizing transformation
vsd <- vst(dds, blind=FALSE)
rld <- rlog(dds, blind=FALSE)
#Calculate distance between samples
sampleDists <- dist(t(assay(vsd)))
#Plot sample heatmap
library(pheatmap)
library(RColorBrewer)
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(colnames(vsd), vsd$type)
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)
#PCA of the samples
plotPCA(vsd, intgroup=c("genotype"))
#Call DE genes using the Wald Test
dds <- nbinomWaldTest(dds)
#Extract results for a pair-wise contrast
resultsTable <- as.data.frame(results(dds, contrast=c("condition","Control","Drought")))
head(resultsTable)
#Show how many genes padj < 0.05
nrow(na.omit(resultsTable[resultsTable$padj < 0.05,]))
#Genes with 2-fold change
nrow(na.omit(resultsTable[resultsTable$padj < 0.05 & resultsTable$log2FoldChange >= 1 | resultsTable$padj < 0.05 & resultsTable$log2FoldChange <= -1,]))
#Volcano Plot
plotMA(results(dds, contrast=c("condition","Control","Drought")), ylim=c(-2,2))
#Function for making a table of results for two conditions from dds
makeResultsTable <- function(x,compFactor,conditionA,conditionB,lfcThreshold=0,filter=FALSE){
  require(DESeq2)
  bml <- sapply(levels(dds@colData[,compFactor]),function(lvl) rowMeans(counts(dds,
                                                                               normalized=TRUE)[,dds@colData[,compFactor] == lvl]))
  bml <- as.data.frame(bml)
  y <- results(x,contrast=c(compFactor,conditionA,conditionB),
               lfcThreshold=lfcThreshold,independentFiltering=filter)
  y <- data.frame(id=gsub(pattern = "gene:",replacement = "",row.names(y)),
                  sampleA=c(conditionA),sampleB=c(conditionB),
                  baseMeanA=bml[,conditionA],baseMeanB=bml[,conditionB],
                  log2FC=y$log2FoldChange,pval=y$pvalue,padj=y$padj)
  row.names(y) <- c(1:nrow(y))
  return(y)
}
#Make new results table
res <- makeResultsTable(dds,"condition","Control","Drought",lfcThreshold=0,filter=TRUE)
head(res)
#Create a column where 1 = meets cutoff, 0 = does not meet cutoff
res$sig <- ifelse(res$padj < 0.05 & res$log2FC >= 0 & !is.na(res$padj) | res$padj < 0.05 & res$log2FC <= -1 & !is.na(res$padj) , "DE", "notDE")
head(res)
table(res$sig)
#Make the plot
ggplot(res) + geom_point(aes(x=log2(baseMeanA),y=log2(baseMeanB),color=sig))
#Plot counts for the PGAZAT gene
plotCounts(dds, gene="AT2G41850", intgroup="genotype")
#Return the data table
plotCounts(dds, gene="AT2G41850", intgroup="genotype", returnData = TRUE)
pgazat <- plotCounts(dds, gene="AT2G41850", intgroup="genotype", returnData = TRUE)