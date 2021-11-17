#' uncorrected ifnb Seurat object list
#'
#' @source SeuratData
#'
#' @format Named List of 2 Seurat objects
#' @examples
#' \dontrun{
#'  findDEG
#' }
"ifnb_split"

#' corrected ifnb Seurat object list
#'
#' @source SeuratData
#'
#' @format Named List of 2 Seurat objects
#' @examples
#' \dontrun{
#'  findDEG
#' }
"ifnb_split_corrected"

#' DEG dataframe, output of findDEG(ifnb_split, ifnb_split_corrected, clusterVars = c('seurat_clusters','seurat_clusters'), logFCThresh=2)
#'
#' @source IntegrationScore
#'
#' @format dataframe with six columns
#' \describe{
#' \item{gene}{gene symbol}
#' \item{cluster}{cluster name}
#' \item{avg_log2FC_pre}{average log2FC of gene in cluster before correction}
#' \item{avg_log2FC_post}{average log2FC of gene in cluster after correction}
#' \item{delta}{avg_log2FC_pre - avg_log2FC_post}
#' \item{batch}{batch name}
#' }
#' @examples
#' \dontrun{
#'  corrDEG
#' }
"deg_df"
