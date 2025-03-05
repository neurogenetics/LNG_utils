library(Seurat)
library(scCustomize)
library(harmony)

lognorm_harmonyintegrate <- function(seurat_obj, n_varfeats = 2000, vars_to_regress, harmony_batches,
                                     n_dims = NULL, cluster_res){
  seurat_obj[["RNA"]] <- JoinLayers(seurat_obj[["RNA"]])
  seurat_obj <- NormalizeData(seurat_obj)
  seurat_obj <- FindVariableFeatures(seurat_obj, nfeatures = n_varfeats)
  seurat_obj <- ScaleData(seurat_obj, vars.to.regress = vars_to_regress)
  seurat_obj <- RunPCA(seurat_obj)
  
  seurat_obj <- RunHarmony(object = seurat_obj, reduction = "pca", group.by.vars = harmony_batches,
                           reduction.save = 'harmony', plot_convergence = T, lambda = NULL)
  print(ElbowPlot(seurat_obj, reduction = "harmony", ndims = 50))
  
  if (is.null(n_dims)) {
    n_dims <- as.numeric(readline(prompt = "Enter the number of dimensions to use for neighbors/UMAP: "))
  }
  
  seurat_obj <- FindNeighbors(seurat_obj, reduction = "harmony", dims = 1:n_dims)
  seurat_obj <- RunUMAP(seurat_obj, reduction = "harmony", dims = 1:n_dims, reduction.name = "umap_harmony")
  seurat_obj <- FindClusters(seurat_obj, resolution = cluster_res)
  
}

#' The following function includes capability to do join WNN clustering of true mutliome (paried RNA/ATAC)

lognorm_harmonyintegrate_multi <- function(seurat_obj, n_varfeats = 2000, vars_to_regress, harmony_batches,
                                     n_dims_RNA = NULL, n_dims_ATAC = NULL, cluster_res){
  seurat_obj[["RNA"]] <- JoinLayers(seurat_obj[["RNA"]])
  seurat_obj[["ATAC"]] <- JoinLayers(seurat_obj[["ATAC"]])
  
  DefaultAssay(seurat_obj) <- "RNA"
  seurat_obj <- NormalizeData(seurat_obj)
  seurat_obj <- FindVariableFeatures(seurat_obj, nfeatures = n_varfeats)
  seurat_obj <- ScaleData(seurat_obj, vars.to.regress = vars_to_regress)
  seurat_obj <- RunPCA(seurat_obj)
  
  DefaultAssay(seurat_obj) <- "ATAC"
  seurat_obj <- FindTopFeatures(seurat_obj, min.cutoff = 5)
  seurat_obj <- RunTFIDF(seurat_obj)
  seurat_obj <- RunSVD(seurat_obj)
  
  seurat_obj <- RunHarmony(object = seurat_obj, reduction = "pca", group.by.vars = harmony_batches,
                           reduction.save = 'harmony_RNA', lambda = NULL)
  
  seurat_obj <- RunHarmony(object = seurat_obj, group.by.vars = harmony_batches, reduction = 'lsi',
                           assay.use = 'ATAC', project.dim = FALSE, reduction.save = "harmony_ATAC")
  
  print(ElbowPlot(seurat_obj, reduction = "harmony_RNA", ndims = 50))
  
  if (is.null(n_dims_RNA)) {
    n_dims_RNA <- as.numeric(readline(prompt = "Enter the number of dimensions to use for RNA: "))
  }
  
  print(ElbowPlot(seurat_obj, reduction = "harmony_ATAC", ndims = 50))
  
  if (is.null(n_dims_ATAC)) {
    n_dims_ATAC <- as.numeric(readline(prompt = "Enter the number of dimensions to use for ATAC: "))
  }
  
  seurat_obj <- FindMultiModalNeighbors(object = seurat_obj, reduction.list = list("harmony_RNA", "harmony_ATAC"),
                                        dims.list = list(1:n_dims_RNA, 2:n_dims_ATAC), modality.weight.name = "RNA.weight")
  
  seurat_obj <- RunUMAP(object = seurat_obj, nn.name = "weighted.nn", reduction.name = "wnn.umap", assay = "RNA")
  seurat_obj <- FindNeighbors(seurat_obj)
  seurat_obj <- FindClusters(seurat_obj, graph.name = 'wsnn', resolution = cluster_res)
  
  return(seurat_obj)
}

