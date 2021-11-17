#' Runs corrDEG with different cutoff levels for log 2 FC then plots the results.
#'
#' @param DEG_df data frame with DEG information for each batch pre and
#'         post correction, output from findDEG
#' @param granularity integer giving number of cutoffs
#' @param estimate test to plot, either pearson or spearman
#' @param byCluster whether or not to aggregate scores by averaging over cluster
#' @return ggplot with the spearman and pearson correlation estimates and
#'         for each cluster at each cutoff.
#'
#' @examples
#' data("deg_df")
#' plotCorrByCutoff(deg_df, 50)
#'
#' @export
plotCorrByCutoff <- function(DEG_df, granularity, estimate="pearson", byCluster=T) {

        # create data frame for the results
        DEG_outlier_scores <- data.frame(batch=character(),
                                         cluster=character(),
                                         cutoff=integer(),
                                         spearman_estimate=double(),
                                         spearman_p_val=double(),
                                         pearson_estimate=double(),
                                         pearson_p_val=double())

        # order DEG list by pre-batch correction fold change
        DEG_df <- DEG_df[order(-DEG_df$avg_log2FC_pre), ]

        # iterate over DEG list with increasingly large cutoffs, score subsets
        for (cutoff in seq(1, nrow(DEG_df), by=(nrow(DEG_df)-1) %/% granularity)) {
                DEG_df_sub <- DEG_df[1:cutoff, ]
                scores_df <- corrDEG(DEG_df_sub)

                scores_df$cutoff <- cutoff

                DEG_outlier_scores <- rbind(DEG_outlier_scores, scores_df)

        }


        DEG_outlier_scores <- na.omit(DEG_outlier_scores)


        DEG_outlier_scores$spearman_estimate <- as.numeric(DEG_outlier_scores$spearman_estimate)
        DEG_outlier_scores$spearman_p_val <- as.numeric(DEG_outlier_scores$spearman_p_val)
        DEG_outlier_scores$pearson_estimate <- as.numeric(DEG_outlier_scores$pearson_estimate)
        DEG_outlier_scores$pearson_p_val <- as.numeric(DEG_outlier_scores$pearson_p_val)

        if (estimate == 'spearman') {
                DEG_outlier_scores$active_estimate = DEG_outlier_scores$spearman_estimate
        }
        else {
                DEG_outlier_scores$active_estimate = DEG_outlier_scores$pearson_estimate
        }

        if (byCluster == FALSE) {
                avg_outlier_scores <- DEG_outlier_scores %>%
                        dplyr::group_by(.data$cutoff, .data$batch) %>%
                        dplyr::summarise(mean_rho = mean(.data$active_estimate))

                plt <- ggplot2::ggplot(avg_outlier_scores, ggplot2::aes(x = avg_outlier_scores$cutoff,
                                                      y = avg_outlier_scores$mean_rho,
                                                      colour = avg_outlier_scores$batch))
                plt <- plt + ggplot2::geom_line()
                plt <- plt + ggplot2::scale_y_continuous(name="spearman rho",
                                                limit=c(-1, 1))
                plt <- plt + ggplot2::labs(title="Average Pre/Post Correction Correlation By # of DEGs Considered")
        }
        else {
                plt <- ggplot2::ggplot(DEG_outlier_scores, ggplot2::aes(x = avg_outlier_scores$cutoff,
                                                      y = avg_outlier_scores$active_estimate,
                                                      colour = avg_outlier_scores$cluster,
                                                      linetype = avg_outlier_scores$batch))
                plt <- plt + ggplot2::geom_line()
                plt <- plt + ggplot2::scale_y_continuous(name="spearman rho",
                                                limit=c(-1, 1))
                plt <- plt + ggplot2::facet_wrap( ~ avg_outlier_scores$cluster)
                plt <- plt + ggplot2::labs(title="Pre/Post Correction Correlation By # of DEGs Considered")
        }

        return(plt)
}
