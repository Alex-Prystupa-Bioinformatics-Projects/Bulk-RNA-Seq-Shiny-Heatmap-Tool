# Custom HeatMap Function

# Required Packages
library(pheatmap)
library(DESeq2)
library(dplyr)
library(glue)
library(RColorBrewer)
library(tibble)

# Function
plot.heatmap <- function(vst_deseq_obj, subset_genes, subset_groups = NULL, cluster_rows, cluster_cols) {
  
  # Colors Palette
  cell_colors <- colorRampPalette(c("#043177", "#244B88", "#FAFAFA", "#C62E2E", "#BF0F0F"))(50)
  
  # Get Counts Matrix
  counts.mat <- vst_deseq_obj@assays@data@listData %>% as.data.frame()
  
  # Subset Counts Matrix by Genes of Interest
  #gene.counts.mat <- counts.mat[subset_genes, ]
  gene.counts.mat <- subset(counts.mat, rownames(counts.mat) %in% subset_genes)
  
  # Get Sample Groups
  samples_groups <- vst_deseq_obj@colData %>% as.data.frame() %>% dplyr::select(group)
  
  # Check That Counts Matrix Columns & Samples Groups Row names match
  if (!identical(rownames(samples_groups), colnames(gene.counts.mat))) {
    rownames(samples_groups) <- colnames(gene.counts.mat)
  }
  
  # Subset Groups
  if (!is.null(subset_groups)) {
    samples_groups <- samples_groups %>% dplyr::filter(group %in% subset_groups)
    gene.counts.mat <- gene.counts.mat[ ,rownames(samples_groups)] # Bug here for Joe Pachella's RDS Object
  }

  # Plot Heatmap
  heatmap <- pheatmap::pheatmap(mat = gene.counts.mat, scale = "row", cluster_rows = cluster_rows, 
                                cluster_cols = cluster_cols, color = cell_colors, show_rownames = T, annotation_col = samples_groups)
  
  return(heatmap)
}

get.samples.groups <- function(vst_deseq_obj) {
  samples_groups <- vst_deseq_obj@colData %>% as.data.frame() %>% dplyr::pull(group) %>% unique()
  return(samples_groups)
}




