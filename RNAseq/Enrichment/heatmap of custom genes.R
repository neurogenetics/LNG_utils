#create pathway of genes in pathway from DESeq dds
library("pheatmap")
#Get Module of Interest Genes (in this case a KEGG Pathway)
library(EnrichmentBrowser)
kegg.gs=getGenesets(org = "mmu",db = "kegg",gene.id.type = "SYMBOL")
MOI<-kegg.gs$mmu05022_Pathways_of_neurodegeneration
x=MOI #or whatever gives you a list of genes
y=rownames(dds)
z=Reduce(intersect,list(v1=x,v2=y))
ntd <- normTransform(dds)
pdf(file = "MOI_heatmap.pdf")
pheatmap(assay(ntd)[z,],cluster_rows = F, show_rownames = T, cluster_cols = F,annotation_col=df,scale = "row")
dev.off()
