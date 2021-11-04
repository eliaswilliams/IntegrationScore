#' Finds the correlation pre/post batch correction of the DEG by cluster.
#'
#' Creates a data frame with the spearman and pearson correlation pre/post
#' batch correction per cluster.
#'
#' @param DEG_df data frame with DEG information for each batch pre and
#'         post correction, output from findDEG
#' @param batchNames character vector of length 2 with the batch names
#' @return data frame with the spearman and pearson correlation estimates and
#'         p values for each cluster.
#'
#' @export
scoreDEG <- function(DEG_df, batchNames) {

        batchNames = unique(DEG_df$batch)

        batch1DEG = subset(DEG_df, subset = batch==batchNames[1])
        batch2DEG = subset(DEG_df, subset = batch==batchNames[2])

        batch1Clusters <- as.character(unique(batch1DEG$cluster))
        batch2Clusters <- as.character(unique(batch2DEG$cluster))

        numRows <- length(batch1Clusters) + length(batch2Clusters)
        scores_df <- setNames(as.data.frame(matrix(nrow = numRows, ncol = 6)),
                              c("batch", "cluster",
                                "spearman_estimate", "spearman_p_val",
                                "pearson_estimate", "pearson_p_val"))

        for (i in 1:length(batch1Clusters)) {
                batch1DEG_subset = batch1DEG[batch1DEG$cluster==batch1Clusters[i],]
                corr_spearman = cor.test(batch1DEG_subset$avg_log2FC_pre, batch1DEG_subset$avg_log2FC_post, method="spearman")
                corr_pearson = cor.test(batch1DEG_subset$avg_log2FC_pre, batch1DEG_subset$avg_log2FC_post, method="pearson")
                scores_df[i,] = c(batch1Clusters[i], corr_spearman$estimate, corr_spearman$p.value,
                                        corr_pearson$estimate, corr_pearson$p.value)
        }

        for (i in 1:length(batch2Clusters)) {
                batch2DEG_subset = batch2DEG[batch2DEG$cluster==batch2Clusters[i],]
                corr_spearman = cor.test(batch2DEG_subset$avg_log2FC_pre, batch2DEG_subset$avg_log2FC_post, method="spearman")
                corr_pearson = cor.test(batch2DEG_subset$avg_log2FC_pre, batch2DEG_subset$avg_log2FC_post, method="pearson")
                scores_df[i + length(batch1Clusters),] = c(batch2Clusters[i], corr_spearman$estimate, corr_spearman$p.value,
                                  corr_pearson$estimate, corr_pearson$p.value)

        }

        return(scores_df)
}
