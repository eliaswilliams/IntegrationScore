#' Plot deltas by cluster of most altered genes under batch correction.
#'
#' @param DEG_df data frame with DEG information for each batch pre and
#'         post correction, output from findDEG
#' @param nTop integer specifying number of top genes to consider
#' @return ggplot object
#' @export
plotDelta <- function(DEG_df, nTop) {

        avg_deg_df <- DEG_df %>%
                dplyr::group_by(gene, batch) %>%
                dplyr::summarise(mean_abs_delta = mean(abs(delta))) %>%
                dplyr::arrange(desc(mean_abs_delta))

        top_genes <- paste0(avg_deg_df[1:nTop,]$gene, "_", avg_deg_df[1:nTop,]$batch)

        deg_df$gene_batch <- paste0(DEG_df$gene, "_", DEG_df$batch)

        deg_df_sub <- DEG_df %>% dplyr::filter(gene_batch %in% top_genes)

        plt1 <- ggplot2::ggplot(deg_df_sub, ggplot2::aes(x = cluster, y = delta, fill = cluster))
        plt1 <- plt1 + ggplot2::geom_col()
        plt1 <- plt1 + ggplot2::facet_wrap(~ gene + batch, ncol = min(nTop %/% 4, 4))
        plt1 <- plt1 + labs(title="Most Altered Genes Under Correction")
        plt1 <- plt1 + ggplot2::theme(axis.text.x=element_blank())

        plt2 <- ggplot(deg_df, aes(x = delta))
        plt2 <- plt2 + geom_histogram()
        plt2 <- plt2 + facet_wrap(~ batch, ncol = 1,scales = 'free_y')
        plt2 <- plt2 + labs(title="Delta(log2FC) Under Correction By Batch")

        return(plt2 + plt1)
}
