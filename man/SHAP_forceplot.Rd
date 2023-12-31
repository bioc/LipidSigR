% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SHAP_forceplot.R
\name{SHAP_forceplot}
\alias{SHAP_forceplot}
\title{SHAP_forceplot}
\usage{
SHAP_forceplot(
  shap_score,
  topN_feature = 10,
  cluster_method = "ward.D",
  group_num = 10,
  plotly = TRUE
)
}
\arguments{
\item{shap_score}{The output data frame of \code{\link{SHAP}} (list[[1]]).}

\item{topN_feature}{An integer of top N features to be shown.}

\item{cluster_method}{A character string indicating the cluster method to
be computed. (default: ward.D).}

\item{group_num}{An integer indicating the numbers of groups to be shown.}

\item{plotly}{Logical value. If TRUE, return the resulting plots dynamically.}
}
\value{
Return a list of 1 data frame and 1 plot.
\enumerate{
\item plot_data: data frame, information of force plot.
\item f_plot: SHAP force plot.
}
}
\description{
The function stacks the SHAP values for each observation and
shows how the final output was obtained as a sum of each predictor’s
attributions through the force plot. (optional to randomly plot a certain
portion of the data in case the dataset is large.)
}
\examples{
library(SHAPforxgboost)
library(dplyr)
data("ML_exp_data")
data("ML_lipid_char_table")
data("ML_condition_table")
condition_table <- ML_condition_table[85:144, ]
exp_data <- ML_exp_data[1:40, ] \%>\%
     select(feature, condition_table$sample_name)
lipid_char_table <- ML_lipid_char_table[1:40, ]
char_var <- colnames(lipid_char_table)[-1]
ML_data <- ML_data_process(exp_data, group_info = condition_table,
                           lipid_char_table, char_var[1],
                           exclude_var_missing=TRUE, missing_pct_limit=50,
                           replace_zero=TRUE, zero2what='min',
                           xmin=0.5,replace_NA=TRUE,
                           NA2what='min', ymin=0.5, pct_transform=TRUE,
                           data_transform=TRUE,
                           trans_type='log', centering=FALSE, scaling=FALSE)
ML_output <- ML_final(ML_data[[2]], ranking_method='Random_forest',
                      ML_method='Random_forest', split_prop=0.3, nfold=3)
SHAP_output <- SHAP(ML_data[[2]], best_model=ML_output[[8]],
                    best_model_feature=ML_output[[9]],
                    ML_method='Random_forest', feature_n=10, nsim=5,
                    plotly=TRUE)
SHAP_forceplot(SHAP_output[[1]], topN_feature=10,
               cluster_method = "ward.D", group_num = 10, plotly=TRUE)
}
