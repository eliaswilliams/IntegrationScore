#' Plot deltas by cluster of most altered genes under batch correction.
#' Plot deltas by cluster of most altered genes under batch correction.
#'
#' @param deg_df data frame with DEG information for each batch pre and
#'         post correction, output from findDEG
#' @param nTop integer specifying number of top genes to consider
#'
#' @return ggplot object
#'
#' @examples
#' data("deg_df")
#' plotDelta(deg_df, 16)
#'
#' @export
#' @import dplyr
#' @import ggplot2
#' @import ggpubr
plotDelta <- function(deg_df, nTop) {

        avg_deg_df <- deg_df %>%
                dplyr::group_by(.data$gene, .data$batch) %>%
                dplyr::summarise(mean_abs_delta = mean(abs(.data$delta))) %>%
                dplyr::arrange(desc(.data$mean_abs_delta))

        top_genes <- paste0(avg_deg_df[1:nTop,]$gene, "_", avg_deg_df[1:nTop,]$batch)

        deg_df$gene_batch <- paste0(deg_df$gene, "_", deg_df$batch)

        deg_df_sub <- deg_df %>% dplyr::filter(.data$gene_batch %in% top_genes)

        plt1 <- ggplot2::ggplot(deg_df_sub, ggplot2::aes(x = deg_df_sub$cluster, y = deg_df_sub$delta, fill = deg_df_sub$cluster))
        plt1 <- plt1 + ggplot2::geom_col()
        plt1 <- plt1 + ggplot2::facet_wrap(~ deg_df_sub$gene + deg_df_sub$batch, ncol = min(nTop %/% 4, 4))
        plt1 <- plt1 + ggplot2::labs(title="Most Altered Genes Under Correction")
        plt1 <- plt1 + ggplot2::theme(axis.text.x=ggplot2::element_blank())

        plt2 <- ggplot2::ggplot(deg_df, ggplot2::aes(x = deg_df$delta))
        plt2 <- plt2 + ggplot2::geom_histogram(bins = 30)
        plt2 <- plt2 + ggplot2::facet_wrap(~ deg_df$batch, ncol = 1, scales = 'free_y')
        plt2 <- plt2 + ggplot2::labs(title="Delta(log2FC) Under Correction By Batch")

        return(ggpubr::ggarrange(plt2, plt1, ncol = 2))
}
# [END]
