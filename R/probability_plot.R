#' @title probability_plot
#' @description The function computes and visualizes the average predicted 
#' probabilities of each sample in testing data from all CV runs and allows 
#' users to explore those incorrect or uncertain labels. \\
#' @description Return two plots.
#' \enumerate{
#' \item the distribution of predicted probabilities in two reference labels
#' \item a confusion matrix composed of sample number and proportion
#' }
#' @param data an machine learning model after cross-validation. An output 
#' data frame of \code{\link{ML_final}} (list[[1]], cv_model_result).
#' @param feature_n A numeric value specifying the number of features to 
#' be computed.
#' @param plotly Logical value. If TRUE, return the resulting plots dynamically.
#' @return Return a list of 2 tibbles and 2 plots.
#' \enumerate{
#' \item cm_data: a tibble of confusion matrix.
#' \item probability_plot: plot, the distribution of predicted probabilities 
#' in two reference labels.
#' \item cm_plot: plot. A confusion matrix composed of 
#' sample number and proportion.
#' \item data: a tibble of predicted probability and labels.
#' }
#' @export
#' @examples
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
#'                            lipid_char_table,
#'                            char_var[1], exclude_var_missing=TRUE,
#'                            missing_pct_limit=50, replace_zero=TRUE,
#'                            zero2what='min', xmin=0.5,replace_NA=TRUE,
#'                            NA2what='min', ymin=0.5, pct_transform=TRUE,
#'                            data_transform=TRUE, trans_type='log',
#'                            centering=FALSE, scaling=FALSE)
#' ML_output <- ML_final(ML_data[[2]],ranking_method='Random_forest',
#'                       ML_method='Random_forest', split_prop=0.3, nfold=3)
#' probability_plot(ML_output[[1]], feature_n=10, plotly=TRUE)
probability_plot <- function(data, feature_n ,plotly=TRUE){
  
  data <- as.data.frame(data)
  if(!class(feature_n) %in% c("numeric", "integer")){
    stop('feature_n must be integer')
  }else{
    if(!feature_n %in% unique(data$feature_num)){
      stop(paste0('feature_n must be one of ', 
                  paste(unique(data$feature_num), collapse=", ")))
    }
  }
  data <- data %>% dplyr::group_by(ID, feature_num) %>%
    dplyr::mutate(pred_prob=mean(pred_prob, na.rm=TRUE)) %>%
    dplyr::select(-3, -8) %>% unique() %>%
    dplyr::mutate(pred_label=ifelse(pred_prob > 0.5, 1, 0))
  
  if(plotly == TRUE){
    probability_plot <-  data %>% dplyr::filter(feature_num == feature_n) %>%
      dplyr::mutate(true_label=as.factor(true_label)) %>%
      plotly::plot_ly(x=~true_label, 
                      y=~pred_prob, 
                      type='violin', 
                      box=list(visible=FALSE), 
                      points=FALSE, showlegend=FALSE,
                      color=~true_label,
                      colors=c("#132B43", "#56B1F7")) %>%
      plotly::add_markers(x=~jitter(as.numeric(paste(true_label))), 
                          y=~pred_prob,
                          text=~paste("Actual group :", 
                                      true_label, 
                                      "<br>Predicted probability :", 
                                      round(pred_prob, 2)), 
                          hoverinfo="text")%>%
      plotly::layout(xaxis=list(zeroline=FALSE, title="Actual group"),
                     yaxis=list(zeroline=FALSE, 
                                title="Predicted probabilities"),
                     title=list(size =15, y=0.99, x=0.1, 
                                text="Average sample probability in all CVs"))
  }else{
    probability_plot <- data %>% 
      dplyr::filter(feature_num == feature_n) %>%
      dplyr::mutate(true_label=as.factor(true_label)) %>%
      as.data.frame() %>%
      ggplot2::ggplot(ggplot2::aes(x=true_label, y=pred_prob, 
                                   color=true_label)) + 
      ggplot2::geom_violin(trim=FALSE) + 
      ggplot2::geom_jitter(shape=16, position=ggplot2::position_jitter(0.2)) +
      ggplot2::scale_color_manual(values=c("#132B43", "#56B1F7")) +
      ggthemes::theme_hc() + 
      ggplot2::labs(y="Predicted probabilities",
                    x="Actual group", 
                    title="Average sample probability in all CVs") + 
      ggplot2::guides(color="none")
  }

  cm_data <-  data %>% dplyr::filter(feature_num == feature_n)

  cm <- caret::confusionMatrix(as.factor(cm_data$true_label), 
                               as.factor(cm_data$pred_label))

  cm_d <- as.data.frame(cm$table) %>%
    dplyr::group_by(Reference) %>%
    dplyr::mutate(pct=round(Freq/sum(Freq), 2))

  cm_plot <- cm_d %>%
    dplyr::mutate(label=stringr::str_c(as.character(Freq), 
                                       ' (', as.character(pct), ')')) %>%
    ggplot2::ggplot(ggplot2::aes(x=Reference , y=Prediction, fill=pct))+
    ggplot2::geom_tile() +
    ggplot2::scale_fill_gradient(low="white", high="#08306b") +
    ggplot2::theme_bw() +
    ggplot2::labs(x='Actual group', y='Predicted group', 
                  title='Confusion matrix')+
    ggplot2::geom_text(ggplot2::aes(label=label,color=pct > 0.5)) +
    ggplot2::scale_color_manual(guide="none", values=c("black", "white")) +
    ggplot2::guides(fill="none") +
    ggplot2::coord_equal()
  if(plotly == TRUE){
    cm_plot <- plotly::ggplotly(cm_plot)
  }

  cm_data$pred_prob <- round(cm_data$pred_prob, 3)

  return(list(cm_data, probability_plot, cm_plot, data))
}



