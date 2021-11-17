#' Plot UMAPs of pre and post correction.
#'
#' @param srtObjPre Seurat object(s) of the uncorrected data
#' @param srtObjPost Seurat object(s) of the corrected data
#' @param colorBy variable to color plot by
#' @param nPC number of principle components to use
#' @param nFeatures number of top variable genes to use
#'
#' @return ggplot object
#'
#' @examples
#' library(Seurat)
#' data("ifbn_split")
#' data("ifnb_split_corrected")
#' plotUMAP(ifbn_split, ifnb_split_corrected, colorBy="stim")
#'
#' @export
plotUMAP <- function(srtObjPre, srtObjPost, colorBy,  nFeatures=2000, nPC=20) {

        # if Seurat objects are split, join them
        if (length(srtObjPre) > 1) {
                batchNames <- names(srtObjPre)
                srtObjPre <- merge(x=srtObjPre[[batchNames[1]]], y=srtObjPre[[batchNames[2]]])
        }
        if (length(srtObjPost) > 1) {
                batchNames <- names(srtObjPost)
                srtObjPost <- merge(x=srtObjPost[[batchNames[1]]], y=srtObjPost[[batchNames[2]]])
        }

        # perform UMAP steps on objects
        srtObjList = list(srtObjPre, srtObjPost)
        srtObjList <- lapply(X = srtObjList, FUN = function(x) {
                x <- Seurat::FindVariableFeatures(x, selection.method="vst", nfeatures=nFeatures, verbose = FALSE)
                x <- Seurat::ScaleData(x, features=Seurat::VariableFeatures(object=x), verbose = FALSE)
                x <- Seurat::RunPCA(x, npcs=nPC, verbose = FALSE)
                x <- Seurat::RunUMAP(x, dims = 1:nPC)

        })

        # set idents to given colorBy variable
        Seurat::Idents(srtObjList[[1]]) <- colorBy
        Seurat::Idents(srtObjList[[1]]) <- colorBy

        # generate plots and return
        uncorrected_umap <- Seurat::DimPlot(srtObjList[[1]], reduction='umap') + ggplot2::labs(title="No Batch Correction")
        corrected_umap <- Seurat::DimPlot(srtObjList[[2]], reduction='umap') + ggplot2::labs(title="After Batch Correction")
        umap_plot <- uncorrected_umap + corrected_umap

        return(umap_plot)
}
