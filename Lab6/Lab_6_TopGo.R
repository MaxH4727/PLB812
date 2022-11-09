#Install topGO
if (!require("topGO", quietly = TRUE))
  BiocManager::install("topGO")
#Install GO.db
if (!require("GO.db", quietly = TRUE))
  BiocManager::install("GO.db")
#Load the libraries
library(topGO)
library(GO.db)

#Set Working Directory
setwd("/Users/maxharman/Library/CloudStorage/OneDrive-MichiganStateUniversity/Documents/Michigan State/PLB812/PLB812-main/Lab6")
#Read in our genes
res <- read.csv("Lab5_DESeq_output.csv",header=TRUE)
head(res)
table(res$sig)

#res$id <- data.frame(id = sub(".Araport11.447","",res$id))
#Still not sure why this didn't work :/ - The id column names looked good, but the factor coulnd't read them. Wrong object type?
gene_names <- c()
for (gene_id in res$id) {
  
  name <- gsub(".Araport11.447", "", gene_id)
  gene_names <- append(gene_names, name)
}
res$id <- gene_names
head(res)

#Read in topGO terms
goTerms <- readMappings(file="Athaliana_topGO.tsv")
head(goTerms)
#Format higher expressed genes
upGenes <- factor(as.integer(res$id %in% res[res$pval < 0.05 & res$log2FC >= 1,]$id))
names(upGenes) <- res$id
head(upGenes)
table(upGenes)

#Format down-regulated genes
downGenes <- factor(as.integer(res$id %in% res[res$pval < 0.05 & res$log2FC <= -1,]$id))
names(downGenes) <- res$id
head(downGenes)
table(downGenes)

#GO term Enrichment for Biological Process - UpGenes
BP <- new("topGOdata",description="Biological Process",ontology="BP",
          allGenes=upGenes,annot=annFUN.gene2GO,nodeSize=3,gene2GO=goTerms)
FisherBP <- runTest(BP,algorithm="parentchild",statistic="fisher")
BPgenTable <- GenTable(BP,Fisher=FisherBP,ranksOf="Fisher",
                       topNodes=length(score(FisherBP)))
BPgenTable$Fisher<-gsub("< ","",BPgenTable$Fisher)
BPgenTable$fdr <- p.adjust(BPgenTable$Fisher,method="fdr")
head(BPgenTable)
#GO term Enrichment for Molecular Function
MF <- new("topGOdata",description="Molecular Function",ontology="MF",
          allGenes=upGenes,annot=annFUN.gene2GO,nodeSize=3,gene2GO=goTerms)
FisherMF <- runTest(MF,algorithm="parentchild",statistic="fisher")
MFgenTable <- GenTable(MF,Fisher=FisherMF,ranksOf="Fisher",
                       topNodes=length(score(FisherMF)))
MFgenTable$Fisher<-gsub("< ","",MFgenTable$Fisher)
MFgenTable$fdr <- p.adjust(MFgenTable$Fisher,method="fdr")
#GO term Enrichment for Cellular Component
CC <- new("topGOdata",description="Cellular Component",ontology="CC",
          allGenes=upGenes,annot=annFUN.gene2GO,nodeSize=3,gene2GO=goTerms)
FisherCC <- runTest(CC,algorithm="parentchild",statistic="fisher")
CCgenTable <- GenTable(CC,Fisher=FisherCC,ranksOf="Fisher",
                       topNodes=length(score(FisherCC)))
CCgenTable$Fisher<-gsub("< ","",CCgenTable$Fisher)
CCgenTable$fdr <- p.adjust(CCgenTable$Fisher,method="fdr")

#GO term Enrichment for Biological Process - downGenes
BP_down <- new("topGOdata",description="Biological Process",ontology="BP",
          allGenes=downGenes,annot=annFUN.gene2GO,nodeSize=3,gene2GO=goTerms)
FisherBP_down <- runTest(BP_down,algorithm="parentchild",statistic="fisher")
BPgenTable_down <- GenTable(BP_down,Fisher=FisherBP_down,ranksOf="Fisher",
                       topNodes=length(score(FisherBP_down)))
BPgenTable_down$Fisher<-gsub("< ","",BPgenTable_down$Fisher)
BPgenTable_down$fdr <- p.adjust(BPgenTable_down$Fisher,method="fdr")
head(BPgenTable_down)
#GO term Enrichment for Molecular Function
MF_down <- new("topGOdata",description="Molecular Function",ontology="MF",
          allGenes=downGenes,annot=annFUN.gene2GO,nodeSize=3,gene2GO=goTerms)
FisherMF_down <- runTest(MF_down,algorithm="parentchild",statistic="fisher")
MFgenTable_down <- GenTable(MF_down,Fisher=FisherMF_down,ranksOf="Fisher",
                       topNodes=length(score(FisherMF_down)))
MFgenTable_down$Fisher<-gsub("< ","",MFgenTable_down$Fisher)
MFgenTable_down$fdr <- p.adjust(MFgenTable_down$Fisher,method="fdr")
#GO term Enrichment for Cellular Component
CC_down <- new("topGOdata",description="Cellular Component",ontology="CC",
          allGenes=downGenes,annot=annFUN.gene2GO,nodeSize=3,gene2GO=goTerms)
FisherCC_down <- runTest(CC_down,algorithm="parentchild",statistic="fisher")
CCgenTable_down <- GenTable(CC_down,Fisher=FisherCC_down,ranksOf="Fisher",
                       topNodes=length(score(FisherCC_down)))
CCgenTable_down$Fisher<-gsub("< ","",CCgenTable_down$Fisher)
CCgenTable_down$fdr <- p.adjust(CCgenTable_down$Fisher,method="fdr")

head(CCgenTable_down)


write.csv(BPgenTable, "/Users/maxharman/Library/CloudStorage/OneDrive-MichiganStateUniversity/Documents/Michigan State/PLB812/PLB812-main/Lab6\\higher_expressed_BP.csv")
write.csv(BPgenTable_down, "/Users/maxharman/Library/CloudStorage/OneDrive-MichiganStateUniversity/Documents/Michigan State/PLB812/PLB812-main/Lab6\\lower_expressed_BP.csv")
write.csv(MFgenTable, "/Users/maxharman/Library/CloudStorage/OneDrive-MichiganStateUniversity/Documents/Michigan State/PLB812/PLB812-main/Lab6\\higher_expressed_MF.csv")
write.csv(MFgenTable_down, "/Users/maxharman/Library/CloudStorage/OneDrive-MichiganStateUniversity/Documents/Michigan State/PLB812/PLB812-main/Lab6\\lower_expressed_MF.csv")
write.csv(CCgenTable, "/Users/maxharman/Library/CloudStorage/OneDrive-MichiganStateUniversity/Documents/Michigan State/PLB812/PLB812-main/Lab6\\higher_expressed_CC.csv")
write.csv(CCgenTable_down, "/Users/maxharman/Library/CloudStorage/OneDrive-MichiganStateUniversity/Documents/Michigan State/PLB812/PLB812-main/Lab6\\lower_expressed_CC.csv")




#Format higher expressed with no log2fold cutoof
upGenes <- factor(as.integer(res$id %in% res[res$padj < 0.05 & res$log2FC > 0,]$id))
names(upGenes) <- res$id
table(upGenes)
#GO term Enrichment for Biological Process
BP <- new("topGOdata",description="Biological Process",ontology="BP",
          allGenes=upGenes,annot=annFUN.gene2GO,nodeSize=3,gene2GO=goTerms)
FisherBP <- runTest(BP,algorithm="parentchild",statistic="fisher")
BPgenTable <- GenTable(BP,Fisher=FisherBP,ranksOf="Fisher",
                       topNodes=length(score(FisherBP)))
BPgenTable$Fisher<-gsub("< ","",BPgenTable$Fisher)
BPgenTable$fdr <- p.adjust(BPgenTable$Fisher,method="fdr")
#GO term Enrichment for Molecular Function
MF <- new("topGOdata",description="Molecular Function",ontology="MF",
          allGenes=upGenes,annot=annFUN.gene2GO,nodeSize=3,gene2GO=goTerms)
FisherMF <- runTest(MF,algorithm="parentchild",statistic="fisher")
MFgenTable <- GenTable(MF,Fisher=FisherMF,ranksOf="Fisher",
                       topNodes=length(score(FisherMF)))
MFgenTable$Fisher<-gsub("< ","",MFgenTable$Fisher)
MFgenTable$fdr <- p.adjust(MFgenTable$Fisher,method="fdr")
#GO term Enrichment for Cellular Component
CC <- new("topGOdata",description="Cellular Component",ontology="CC",
          allGenes=upGenes,annot=annFUN.gene2GO,nodeSize=3,gene2GO=goTerms)
FisherCC <- runTest(CC,algorithm="parentchild",statistic="fisher")
CCgenTable <- GenTable(CC,Fisher=FisherCC,ranksOf="Fisher",
                       topNodes=length(score(FisherCC)))
CCgenTable$Fisher<-gsub("< ","",CCgenTable$Fisher)
CCgenTable$fdr <- p.adjust(CCgenTable$Fisher,method="fdr")

#Function for making dot plots of Enriched GO terms
GOdotplot <- function(x,fdr=0.05){
  require(ggplot2)
  x=head(x[x$fdr <= fdr,],10)
  ggplot(x[x$fdr <= fdr,],aes(x=Significant/Annotated,
                              y=reorder(Term,Significant/Annotated))) + 
    geom_point(aes(color=fdr,size=Significant)) + 
    theme_bw() +
    scale_color_continuous(low="red",high="blue") +
    xlab("Gene Ratio (DEGs/Annotated Genes)") + 
    ylab("") +
    labs(size="Gene Count",color="FDR") +
    ggtitle("Top 10 Enriched GO Terms")
}
GOdotplot(MFgenTable)
#Install Rgraphviz
if (!require("Rgraphviz", quietly = TRUE))
  BiocManager::install("Rgraphviz")
showSigOfNodes(MF, score(FisherMF), firstSigNodes = 20, useInfo = 'all')

#Function for running topGO on a list of genes
#This run each of the above analyses for a gene list and output a table and plots
topGO <- function(genelist,goTerms,nodeSize,fdr=0.05,filename,path="",returnData=FALSE){
  require(topGO)
  require(GO.db)
  ifelse(!dir.exists(path),dir.create(path), FALSE)
  BP <- new("topGOdata",description="Biological Process",ontology="BP",
            allGenes=genelist,annot=annFUN.gene2GO,nodeSize=nodeSize,gene2GO=goTerms)
  MF <- new("topGOdata",description="Molecular Function",ontology="MF",
            allGenes=genelist,annot=annFUN.gene2GO,nodeSize=nodeSize,gene2GO=goTerms)
  CC <- new("topGOdata",description="Cellular Compartment",ontology="CC",
            allGenes=genelist,annot=annFUN.gene2GO,nodeSize=nodeSize,gene2GO=goTerms)
  FisherBP <- runTest(BP,algorithm="parentchild",statistic="fisher")
  FisherMF <- runTest(MF,algorithm="parentchild",statistic="fisher")
  FisherCC <- runTest(CC,algorithm="parentchild",statistic="fisher")
  BPgenTable <- GenTable(BP,Fisher=FisherBP,ranksOf="Fisher",
                         topNodes=length(score(FisherBP)))
  BPgenTable$Fisher<-gsub("< ","",BPgenTable$Fisher)
  MFgenTable <- GenTable(MF,Fisher=FisherMF,ranksOf="Fisher",
                         topNodes=length(score(FisherMF)))
  MFgenTable$Fisher<-gsub("< ","",MFgenTable$Fisher)
  CCgenTable <- GenTable(CC,Fisher=FisherCC,ranksOf="Fisher",
                         topNodes=length(score(FisherCC)))
  CCgenTable$Fisher<-gsub("< ","",CCgenTable$Fisher)
  BPgenTable$fdr <- p.adjust(BPgenTable$Fisher,method="BH")
  MFgenTable$fdr <- p.adjust(MFgenTable$Fisher,method="BH")
  CCgenTable$fdr <- p.adjust(CCgenTable$Fisher,method="BH")
  write.csv(BPgenTable[BPgenTable$fdr <= fdr,],paste(path,filename,"_BP.csv",sep=""),
            row.names=FALSE,quote=FALSE)
  ggsave(paste(path,filename,"_BP.pdf",sep=""),plot=GOdotplot(BPgenTable,fdr=fdr))
  write.csv(MFgenTable[MFgenTable$fdr <= fdr,],paste(path,filename,"_MF.csv",sep=""),
            row.names=FALSE,quote=FALSE)
  ggsave(paste(path,filename,"_MF.pdf",sep=""),plot=GOdotplot(MFgenTable,fdr=fdr))
  write.csv(CCgenTable[CCgenTable$fdr <= fdr,],paste(path,filename,"_CC.csv",sep=""),
            row.names=FALSE,quote=FALSE)
  ggsave(paste(path,filename,"_CC.pdf",sep=""),plot=GOdotplot(CCgenTable,fdr=fdr))
  if(returnData){
    return(list(BP=BPgenTable,MF=MFgenTable,CC=CCgenTable))
  }
}
