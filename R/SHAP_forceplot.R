#' @title SHAP_forceplot
#' @description The function stacks the SHAP values for each observation and
#' shows how the final output was obtained as a sum of each predictor’s
#' attributions through the force plot. (optional to randomly plot a certain
#' portion of the data in case the dataset is large.)
#' @param shap_score The output data frame of \code{\link{SHAP}} (list[[1]]).
#' @param topN_feature An integer of top N features to be shown.
#' @param cluster_method A character string indicating the cluster method to
#' be computed. (default: ward.D).
#' @param group_num An integer indicating the numbers of groups to be shown.
#' @param plotly Logical value. If TRUE, return the resulting plots dynamically.
#' @return Return a list of 1 data frame and 1 plot.
#' \enumerate{
#' \item plot_data: data frame, information of force plot.
#' \item f_plot: SHAP force plot.
#' }
#' @export
#' @examples
#' library(SHAPforxgboost)
#' library(dplyr)
#' data("ML_exp_data")
#' data("ML_lipid_char_table")
#' data("ML_condition_table")
#' condition_table <- ML_condition_table[85:144, ]
#' exp_data <- ML_exp_data[1:40, ] %>%
#'      select(feature, condition_table$sample_name)
#' lipid_char_table <- ML_lipid_char_table[1:40, ]
#' char_var <- colnames(lipid_char_table)[-1]
#' ML_data <- ML_data_process(exp_data, group_info = condition_table,
#'                            lipid_char_table, char_var[1],
#'                            exclude_var_missing=TRUE, missing_pct_limit=50,
#'                            replace_zero=TRUE, zero2what='min',
#'                            xmin=0.5,replace_NA=TRUE,
#'                            NA2what='min', ymin=0.5, pct_transform=TRUE,
#'                            data_transform=TRUE,
#'                            trans_type='log', centering=FALSE, scaling=FALSE)
#' ML_output <- ML_final(ML_data[[2]], ranking_method='Random_forest',
#'                       ML_method='Random_forest', split_prop=0.3, nfold=3)
#' SHAP_output <- SHAP(ML_data[[2]], best_model=ML_output[[8]],
#'                     best_model_feature=ML_output[[9]],
#'                     ML_method='Random_forest', feature_n=10, nsim=5,
#'                     plotly=TRUE)
#' SHAP_forceplot(SHAP_output[[1]], topN_feature=10,
#'                cluster_method = "ward.D", group_num = 10, plotly=TRUE)
SHAP_forceplot <- function(shap_score, topN_feature=10,
                           cluster_method="ward.D", group_num=10,
                           plotly=TRUE){
  if(!cluster_method %in% c("ward.D", "ward.D2", "single", "complete",
                            "average", "mcquitty", "median", "centroid")){
    stop('cluster_method must be one of the strings "ward.D", "ward.D2",
         "single", "complete", "average", "mcquitty", "median", "centroid"')
  }
  if(!class(group_num) %in% c("numeric", "integer")){
    stop('nfold must be integer')
  }else{
    if(group_num <= 0 | group_num > nrow(shap_score)){
      warning_message <- paste0(
        "elements of 'group_num' must be between 1 and ", nrow(shap_score))
      stop(warning_message)
    }
  }
  if(topN_feature>10){
    warning("topN_feature will only use 10")
  }

  f_plot <- function (shapobs, id="sorted_id",
                      y_parent_limit=NULL, y_zoomin_limit=NULL,
                      x_rank='sorted_id', plotly=TRUE){
    shapobs_long <- data.table::melt.data.table(
      shapobs, measure.vars=colnames(shapobs)[!colnames(shapobs) %in%
                                                c(id, "group", "ID")])
    shapobs_long <- as.data.frame(shapobs_long)
    if(plotly == TRUE){
      if (dim(shapobs)[2]-1 <= 12) {
        p <- plotly::plot_ly(shapobs_long,
                             x=shapobs_long[,which(
                               colnames(shapobs_long) == x_rank)], y=~value,
                             type='bar', color=~variable, hoverinfo="text",
                             colors=RColorBrewer::brewer.pal(dim(
                               shapobs)[2]-1, "Paired"),
                             text=~paste("Sorted ID :",
                                         shapobs_long[,which(
                                           colnames(shapobs_long) == x_rank)],
                                         "\nShapley values by feature :",
                                         round(value, 3), "\nFeature :",
                                         variable))
      }else {
        p <- plotly::plot_ly(
          shapobs_long, x=shapobs_long[, which(
            colnames(shapobs_long) == x_rank)], y=~value,
          type='bar', color=~variable, hoverinfo="text",
          text=~paste("Sorted ID :", shapobs_long[, which(
            colnames(shapobs_long) == x_rank)],
            "\nShapley values by feature :", round(value, 3),
            "\nFeature :", variable))
      }
      p <- p %>%
        plotly::layout(barmode="relative",
                       title='SHAP force plot',
                       xaxis=list(title="Sorted ID"),
                       yaxis=list(title="Shapley values by feature:\n
                          (Contribution to the base value)"),
                       legend=list(title=list(text="Feature"),
                                   y=0.5, x=1.1, font=list(size=9)))
    }else{
      p <- ggplot2::ggplot(shapobs_long, ggplot2::aes_string(x=id, y="value" ,
                                           fill="variable")) +
        ggplot2::geom_col(width=1, alpha=0.9) +
        ggplot2::labs(fill='Feature', x='Sorted ID',
             y='SHAP values by feature:\n (Contribution to the base value)',
             title='SHAP force plot') +
        ggplot2::geom_hline(yintercept = 0, col = "gray40") +
        ggplot2::theme_bw() +
        ggplot2::coord_cartesian(ylim = y_parent_limit)
      if (dim(shapobs)[2]-1<=12){
        p <- p +
          ggplot2::scale_fill_manual(values=RColorBrewer::brewer.pal(
            dim(shapobs)[2]-1, 'Paired'))
      } else {
        p <- p + ggplot2::scale_fill_viridis_d(option = "D")
        # viridis color scale
      }
    }

    if (!is.null(y_parent_limit) & !is.null(y_zoomin_limit)) {
      warning("Just notice that when parent limit is set, the zoom in axis
              limit won't work, it seems to be a problem of ggforce.\n")
    }
    return(p)
  }
  if(topN_feature > 10){topN_feature <- 10}else{topN_feature <- topN_feature}

  plot_data <- SHAPforxgboost::shap.prep.stack.data(
    shap_contrib=shap_score,
    top_n=topN_feature,
    cluster_method=cluster_method, n_groups=group_num)
  f_plot <- f_plot(plot_data,
                   x_rank='sorted_id', plotly=plotly)
  plot_data <- plot_data %>% as.data.frame() %>%
    dplyr::select(ID, group, sorted_id, dplyr::everything())

  colnames(plot_data)[seq_len(3)] <- c('Sample ID', 'Group', 'Sorted ID')

  return(list(plot_data, f_plot))
}

