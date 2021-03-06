#' Calculates the Pre/Post Batch Correction Differentially Expressed Genes
#'
#' Creates a data frame with the DEGs of each batch pre and post correction.
#'
#' @param srtObjPre Named list of length 2 of 2 Seurat objects of the
#'                  uncorrected data split by batch, or single Seurat object to be split
#' @param srtObjPost Named list of length 2 of 2 Seurat objects of the corrected
#'                   data split by batch, or single Seurat object to be split
#' @param batchVar string of the batch variable column name
#' @param clusterVars character vector of the cluster columns in Seurat objects,
#'                    these must be clusters obtained prior to batch correction
#'                    on each batch separately
#' @param minPct minimum percent for Seurat::FindMarkers
#' @param logFCThresh threshold for Seurat::FindMarkers
#'
#' @return data frame with DEG information for each batch pre and
#'         post correction
#'
#' @examples
#' library(Seurat)
#' data("ifnb_split")
#' data("ifnb_split_corrected")
#' deg_df <- findDEG(ifnb_split, ifnb_split_corrected, clusterVars = c('seurat_clusters','seurat_clusters'), logFCThresh=2)
#'
#' @export
#' @import Seurat
findDEG <- function(srtObjPre, srtObjPost, batchVar, clusterVars=c("seurat_clusters","seurat_clusters"), minPct=0.15, logFCThresh=1.5) {

        # if seurat objects are not split, split them by batchVar
        if (length(srtObjPre) == 1) {
                srtObjPre <- Seurat::SplitObject(srtObjPre, split.by = batchVar)
        }
        if (length(srtObjPost) == 1) {
                srtObjPost <- Seurat::SplitObject(srtObjPost, split.by = batchVar)
        }


        # get batch names
        batchNames = names(srtObjPre)

        # split the original expression object into batches
        batch1Pre <- srtObjPre[[batchNames[1]]]
        batch2Pre <- srtObjPre[[batchNames[2]]]

        # split the corrected expression object into batches
        batch1Post <- srtObjPost[[batchNames[1]]]
        batch2Post <- srtObjPost[[batchNames[2]]]

        # UNUSED FEATURE
        # # map the pre clusters to the post object
        # clustersBatch1Pre <- data.frame(Cells = Seurat::Cells(batch1Pre))
        # clustersBatch1Pre[ , clusterVars[1]] <- batch1Pre@meta.data[[clusterVars[1]]]
        #
        # clustersBatch2Pre <- data.frame(Cells = Seurat::Cells(batch2Pre))
        # clustersBatch2Pre[ , clusterVars[2]] <- batch2Pre@meta.data[[clusterVars[2]]]
        #
        # batch1Post@meta.data[['Cells']] <- Seurat::Cells(batch1Post)
        # batch2Post@meta.data[['Cells']] <- Seurat::Cells(batch2Post)
        #
        # batch1Post@meta.data <- dplyr::left_join(batch1Post@meta.data, clustersBatch1Pre, by="Cells")
        # batch2Post@meta.data <- dplyr::left_join(batch2Post@meta.data, clustersBatch2Pre, by="Cells")

        # make sure objects' idents are the clusterVar
        Seurat::Idents(batch1Pre) <- clusterVars[1]
        Seurat::Idents(batch2Pre) <- clusterVars[2]
        Seurat::Idents(batch1Post) <- clusterVars[1]
        Seurat::Idents(batch2Post) <- clusterVars[2]

        # find DEGs for all subsets using the given parameters
        batch1PreDEG <- Seurat::FindAllMarkers(batch1Pre, min.pct=minPct,
                                              logfc.threshold=logFCThresh)
        batch2PreDEG <- Seurat::FindAllMarkers(batch2Pre, min.pct=minPct,
                                              logfc.threshold=logFCThresh)
        batch1PostDEG <- Seurat::FindAllMarkers(batch1Post, min.pct=minPct,
                                               logfc.threshold=logFCThresh)#min(logFCThresh, 0.25))
        batch2PostDEG <- Seurat::FindAllMarkers(batch2Post, min.pct=minPct,
                                               logfc.threshold=logFCThresh)#min(logFCThresh, 0.25))

        # check to see data frames are non empty
        if (nrow(batch1PreDEG) == 0 | nrow(batch2PreDEG) == 0 | nrow(batch1PostDEG) == 0 | nrow(batch2PostDEG) == 0) {
                return(-1)
        }

        # build data frame
        batch1PreDEG <- dplyr::select(batch1PreDEG, .data$gene, .data$cluster,
                                               avg_log2FC_pre=.data$avg_log2FC)
        batch2PreDEG <- dplyr::select(batch2PreDEG, .data$gene, .data$cluster,
                                               avg_log2FC_pre=.data$avg_log2FC)
        batch1PostDEG <- dplyr::select(batch1PostDEG, .data$gene, .data$cluster,
                                                 avg_log2FC_post=.data$avg_log2FC)
        batch2PostDEG <- dplyr::select(batch2PostDEG, .data$gene, .data$cluster,
                                                 avg_log2FC_post=.data$avg_log2FC)

        batch1DEG <- dplyr::inner_join(batch1PreDEG, batch1PostDEG,
                               by=c("cluster", "gene"))
        batch2DEG <- dplyr::inner_join(batch2PreDEG, batch2PostDEG,
                               by=c("cluster", "gene"))

        # calculate log2FC delta
        batch1DEG$delta <- batch1DEG$avg_log2FC_pre - batch1DEG$avg_log2FC_post
        batch2DEG$delta <- batch2DEG$avg_log2FC_pre - batch2DEG$avg_log2FC_post

        # finish building data frame and return
        batch1DEG$batch <- batchNames[1]
        batch2DEG$batch <- batchNames[2]

        DEG_df <- rbind(batch1DEG, batch2DEG)

        return(DEG_df)

}
# [END]
