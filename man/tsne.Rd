% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tsne.R
\name{tsne}
\alias{tsne}
\title{tsne}
\usage{
tsne(
  exp_transform_table,
  group_info = NULL,
  sig_feature = NULL,
  pca = TRUE,
  perplexity = 5,
  max_iter = 500,
  cluster_method,
  group_num = NULL,
  var1 = NULL,
  var2 = NULL,
  insert_ref_group = NULL,
  ref_group = NULL,
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

\item{pca}{logical; Whether an initial PCA step should be
performed (default: TRUE).}

\item{perplexity}{numeric; Perplexity parameter
(should not be bigger than 3 * perplexity < nrow(X) - 1.}

\item{max_iter}{A integer; Number of iterations.}

\item{cluster_method}{A character string indicating which method to be used
for clustering. Allowed method include \bold{"kmeans"}, \bold{"kmedoids"},
\bold{"hclustering"}, \bold{"dbscan"}, \bold{"group_info"}.}

\item{group_num}{A positive integer specifying the number of clusters.
Group number must be between 1 and 10.}

\item{var1}{A character string or numeric.
According to the selected cluster method.
\itemize{
  \item \emph{kmeans}: specifying the metric to be used for calculating
  dissimilarities between observations include \bold{"euclidean"}
  and \bold{"manhattan"}.
  \item \emph{hclustering}: which correlation coefficient is to be computed
  or which the distance measure to be used include \bold{"pearson"},
  \bold{"kendall"}, \bold{"spearman"}, \bold{"euclidean"},
  \bold{"manhattan"}, \bold{"maximum"}, \bold{"canberra"}, \bold{"binary"},
  \bold{"minkowski"}.
  \item \emph{dbscan}: size of the epsilon neighborhood.
}}

\item{var2}{A character string or numeric. According to the selected
cluster method.
\itemize{
  \item \emph{hclustering}: The agglomeration method to be used. This
  should be (an unambiguous abbreviation of) one of \bold{"ward.D"},
  \bold{"ward.D2"}, \bold{"single"}, \bold{"complete"},
  \bold{"average"}(=UPGMA), \bold{"mcquitty"}(= WPGMA),
  \bold{"median"}(= WPGMC), or \bold{"centroid"} (= UPGMC).
  \item \emph{dbscan}: number of minimum points in the
  eps region (for core points).
}}

\item{insert_ref_group}{A character string. The name of 'ctrl'
after name conversion.}

\item{ref_group}{A character string. The name of 'exp'
after name conversion.}

\item{plotly}{Logical value. If TRUE, return the resulting plots dynamically.}
}
\value{
Return a list with 1 data frame and 1 plot.
\enumerate{
\item tsne_data: A data frame of tsne data.
\item tsne_plot: tsne plot.
}
}
\description{
A method of dimensionality reduction to transform data from a
high-dimensional space into a low-dimensional space so that the vital
properties of the original data can be retained.
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
tsne(exp_transform_table, group_info=NULL, sig_feature=NULL, pca=TRUE,
     perplexity=5, max_iter=500, cluster_method='kmeans', group_num=2,
     var1='euclidean', var2=NULL, insert_ref_group=NULL,
     ref_group=NULL, plotly=TRUE)
}
