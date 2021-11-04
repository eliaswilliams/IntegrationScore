#' Calculates the Pre/Post Batch Correction Differentially Expressed Genes
#'
#' Creates a data frame with the DEGs of each batch pre and post correction.
#'
#' @param srtObjPre Seurat object of the uncorrected data
#' @param srtObjPost Seurat object of the corrected data
#' @param batchNames character vector of length 2 with the batch names
#' @param clusterVars character vector of the cluster columns in Seurat objects,
#'                    these must be clusters obtained prior to batch correction
#'                    on each batch separately
#' @param minPct minimum percent for Seurat::FindMarkers
#' @param logFCThresh threshold for Seurat::FindMarkers
#'
#' @return data frame with DEG information for each batch pre and
#'         post correction
#'
#' @export
findDEG <- function(srtObjPre, srtObjPost, batchNames, clusterVars, minPct, logFCThresh) {
        # split the original expression object into batches
        batch1Pre <- subset(srtObjPre, subset = batch==batchNames[1])
        batch2Pre <- subset(srtObjPre, subset = batch==batchNames[2])

        # split the corrected expression object into batches
        batch1Post <- subset(srtObjPost, subset = batch==batchNames[1])
        batch2Post <- subset(srtObjPost, subset = batch==batchNames[2])

        # make sure objects' idents are the clusterVar
        batch1Pre <- Seurat::SetIdent(batch1Pre, clusterVars[1])
        batch2Pre <- Seurat::SetIdent(batch2Pre, clusterVars[2])
        batch1Post <- Seurat::SetIdent(batch1Post, clusterVars[1])
        batch2Post <- Seurat::SetIdent(batch2Post, clusterVars[2])

        # find DEGs for all subsets using the given parameters
        batch1PreDEG = Seurat::FindAllMarkers(batch1Pre, min.pct=minPct,
                                              logfc.threshold=logFCThresh)
        batch2PreDEG = Seurat::FindAllMarkers(batch2Pre, min.pct=minPct,
                                              logfc.threshold=logFCThresh)
        batch1PostDEG = Seurat::FindAllMarkers(batch1Post, min.pct=minPct,
                                               logfc.threshold=logFCThresh)
        batch2PostDEG = Seurat::FindAllMarkers(batch2Post, min.pct=minPct,
                                               logfc.threshold=logFCThresh)

        # build data frame
        batch1PreDEG = dplyr::select(batch1PreDEG, gene, cluster,
                                               avg_log2FC_pre=avg_log2FC)
        batch2PreDEG = dplyr::select(batch2PreDEG, gene, cluster,
                                               avg_log2FC_pre=avg_log2FC)
        batch1PostDEG = dplyr::select(batch1PostDEG, gene, cluster,
                                                 avg_log2FC_post=avg_log2FC)
        batch2PostDEG = dplyr::select(batch2PostDEG, gene, cluster,
                                                 avg_log2FC_post=avg_log2FC)

        batch1DEG = dplyr::inner_join(batch1PreDEG, batch1PostDEG,
                               by=c("cluster", "gene"))
        batch2DEG = dplyr::inner_join(batch1PostDEG, batch2PostDEG,
                               by=c("cluster", "gene"))

        # calculate log2FC delta
        batch1DEG$delta = batch1DEG$avg_log2FC_pre - batch1DEG$avg_log2FC_post
        batch2DEG$delta = batch2DEG$avg_log2FC_pre - batch2DEG$avg_log2FC_post

        # finish building data frame and return
        batch1DEG$batch = batchNames[1]
        batch2DEG$batch = batchNames[2]

        DEG_df = rbind(batch1DEG, batch2DEG)

        return(DEG_df)

}
