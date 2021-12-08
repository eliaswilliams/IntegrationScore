#' Finds the correlation pre/post batch correction of the DEG by cluster.
#'
#' Creates a data frame with the spearman and pearson correlation pre/post
#' batch correction per cluster.
#'
#' @param DEG_df data frame with DEG information for each batch pre and
#'         post correction, output from findDEG
#' @return data frame with the spearman and pearson correlation estimates and
#'         p values for each cluster.
#'
#' @examples
#' data("deg_df")
#' corrDEG(deg_df)
#'
#' @export
#' @import dplyr
#' @importFrom stats setNames cor.test
#' @import SeuratData
corrDEG <- function(DEG_df) {

        batchNames = unique(DEG_df$batch)

        batch1DEG = dplyr::filter(DEG_df, DEG_df$batch==batchNames[1])
        batch2DEG = dplyr::filter(DEG_df, DEG_df$batch==batchNames[2])

        batch1Clusters <- as.character(unique(batch1DEG$cluster))
        batch2Clusters <- as.character(unique(batch2DEG$cluster))

        numRows <- length(batch1Clusters) + length(batch2Clusters)
        scores_df <- stats::setNames(as.data.frame(matrix(nrow = numRows, ncol = 6)),
                              c("batch", "cluster",
                                "spearman_estimate", "spearman_p_val",
                                "pearson_estimate", "pearson_p_val"))

        for (i in 1:length(batch1Clusters)) {
                batch1DEG_subset = batch1DEG[batch1DEG$cluster==batch1Clusters[i],]
                if (nrow(batch1DEG_subset)>2) {
                        corr_spearman = stats::cor.test(batch1DEG_subset$avg_log2FC_pre, batch1DEG_subset$avg_log2FC_post, method="spearman")
                        corr_pearson = stats::cor.test(batch1DEG_subset$avg_log2FC_pre, batch1DEG_subset$avg_log2FC_post, method="pearson")
                        scores_df[i,] = c(batchNames[1], batch1Clusters[i],
                                          as.numeric(corr_spearman$estimate),
                                          as.numeric(corr_spearman$p.value),
                                          as.numeric(corr_pearson$estimate),
                                          as.numeric(corr_pearson$p.value))
                }
                else {
                        scores_df[i,] = c(batchNames[1], batch1Clusters[i], NA, NA,
                                          NA, NA)
                }

        }

        for (i in 1:length(batch2Clusters)) {
                batch2DEG_subset = batch2DEG[batch2DEG$cluster==batch2Clusters[i],]
                if (nrow(batch2DEG_subset)>2) {
                        corr_spearman = stats::cor.test(batch2DEG_subset$avg_log2FC_pre, batch2DEG_subset$avg_log2FC_post, method="spearman")
                        corr_pearson = stats::cor.test(batch2DEG_subset$avg_log2FC_pre, batch2DEG_subset$avg_log2FC_post, method="pearson")
                        scores_df[i + length(batch1Clusters),] = c(batchNames[2], batch2Clusters[i],
                                                                   as.numeric(corr_spearman$estimate),
                                                                   as.numeric(corr_spearman$p.value),
                                                                   as.numeric(corr_pearson$estimate),
                                                                   as.numeric(corr_pearson$p.value)
                        )
                }
                else {
                        scores_df[i,] = c(batchNames[2], batch2Clusters[i], NA, NA,
                                          NA, NA)
                }

        }

        return(scores_df)
}
# [END]
