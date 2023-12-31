% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PCA.R
\name{PCA}
\alias{PCA}
\title{PCA}
\usage{
PCA(
  exp_transform_table,
  group_info = NULL,
  sig_feature = NULL,
  scaling = TRUE,
  centering = TRUE,
  cluster_method = "kmeans",
  group_num = NULL,
  var1 = NULL,
  var2 = NULL,
  insert_ref_group = NULL,
  ref_group = NULL,
  n_PC,
  top_n_feature,
  plotly = TRUE
)
}
\arguments{
\item{exp_transform_table}{A data frame of predictors, including
features (molecule, lipid class, etc.) and their expression of each sample.
NAs are not allowed. The name of the first column must be
"feature" (lipid species).}

\item{group_info}{A data frame with sample name, label name, the group name
of samples (ctrl & exp), and pair number representing 'the pair' for the
t-test/Wilcoxon test. NAs are allowed.}

\item{sig_feature}{A character string for identifying significant variable
in \bold{exp_transform_table}.}

\item{scaling}{A logical value. If scaling = TRUE, each block is
standardized to zero means and unit variances. (default: TRUE).}

\item{centering}{A logical value indicating whether the variables should be
shifted to be zero centered. Alternately, a vector of length equal the
number of columns of x can be supplied. The value is passed to scale.}

\item{cluster_method}{A character string indicating which method to be used
for clustering. Allowed method include \bold{'kmeans'}, \bold{'kmedoids'},
\bold{'hclustering'}, \bold{'dbscan'},
\bold{'group_info'}. (default: 'kmeans')}

\item{group_num}{A positive integer specifying the number of clusters.
The number must be between 1 and 10.}

\item{var1}{A character string or numeric. According to the selected
cluster method.
\itemize{
  \item \emph{kmeans}: specifying the metric to be used for calculating
  dissimilarities between observations include \bold{"euclidean"} and
  \bold{"manhattan"}.
  \item \emph{hclustering}: which correlation coefficient is to be computed
  or which the distance measure to be used include \bold{"pearson"},
  \bold{"kendall"}, \bold{"spearman"}, \bold{"euclidean"},
  \bold{"manhattan"}, \bold{"maximum"}, \bold{"canberra"},
  \bold{"binary"}, \bold{"minkowski"}.
  \item \emph{dbscan}: size of the epsilon neighborhood.
}}

\item{var2}{A character string or numeric. According to the selected
cluster method.
\itemize{
  \item \emph{hclustering}: The agglomeration method to be used. This
  should be (an unambiguous abbreviation of) one of \bold{"ward.D"},
  \bold{"ward.D2"}, \bold{"single"}, \bold{"complete"},
  \bold{"average"} (=UPGMA), \bold{"mcquitty"} (= WPGMA),
  \bold{"median"} (= WPGMC), or \bold{"centroid"} (= UPGMC).
  \item \emph{dbscan}: number of minimum points in the eps
  region (for core points).
}}

\item{insert_ref_group}{A character string. The name of 'ctrl' after
name conversion.}

\item{ref_group}{A character string. The name of 'exp' after name conversion.}

\item{n_PC}{A numeric vector specifying the dimension(s) of interest.}

\item{top_n_feature}{A numeric value specifying the number of top
elements to be shown.}

\item{plotly}{Logical value. If TRUE, return the resulting plots dynamically.}
}
\value{
Return a list with 1 model, 2 data frame, and 4 plots.
\enumerate{
\item pca: prcomp (lists of the standard deviations, the matrix of variable
loading, the value of the rotated data, the centering and scaling )
\item pca_rotated_data: a data frame of PCA rotated data
\item pca_contrib_table: data frame, PCA contribution table
\item pca_biplot: PCA plot
\item pca_screeplot: Scree plot of top n principle components
\item feature_contrib: plot, the contribution of top N features of the
user-defined principal components.
\item pca_variable: correlation circle plot(factor map) of PCA variables.
}
}
\description{
PCA (Principal Component Analysis):  A method of dimensionality
reduction to transform data from a high-dimensional space into a
low-dimensional space so that the vital properties of the original data
can be retained.

This function calculates Principal component analysis with
the classical prcomp function and visualizes results by PCA plot and scree
plot. Furthermore, this function also visualizes the features' contribution
of the user-defined principal components and the correlation between a
feature (lipid species) and a principal component (PC).
}
\examples{
data("profiling_exp_data")
exp_data <- profiling_exp_data
exp_transform_table <- data_process(exp_data, exclude_var_missing=TRUE,
                                    missing_pct_limit=50,
                                    replace_zero=TRUE, zero2what='min',
                                    xmin=0.5, replace_NA=TRUE,
                                    NA2what='min', ymin=0.5,
                                    pct_transform=TRUE, data_transform=TRUE,
                                    trans_type='log', centering=FALSE,
                                    scaling=FALSE)
PCA(exp_transform_table, group_info=NULL, sig_feature=NULL, scaling=TRUE,
    centering=TRUE, cluster_method='kmeans', group_num=2, var1=NULL,
    var2=NULL, insert_ref_group=NULL,
    ref_group=NULL, n_PC=c(1,2), top_n_feature=10, plotly=TRUE)
}
