% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/exp_compo_by_lipidinfo.R
\name{exp_compo_by_lipidinfo}
\alias{exp_compo_by_lipidinfo}
\title{exp_compo_by_lipidinfo}
\usage{
exp_compo_by_lipidinfo(exp_data, lipid_char_table, char_var, plotly = TRUE)
}
\arguments{
\item{exp_data}{A data frame of predictors, including
features (molecule, lipid class, etc.) and their expression of each sample.
NAs are not allowed. The name of the first column must be
"feature" (lipid species).}

\item{lipid_char_table}{A data frame of lipid characteristics such as
name(feature) of lipid, class of lipid, the total length of lipid, and
Fatty acid (FA_) related characteristics. NAs are allowed. The name of the
first column must be "feature" (lipid species).}

\item{char_var}{A character string of the lipid characteristic selected by
users from the column name of \bold{lipid_char_table}, such as 'class'.}

\item{plotly}{Logical value. If TRUE, return the resulting plots dynamically.}
}
\value{
Return 2 plots.
\enumerate{
\item A bar plot depicts the expression level of each sample within each
group (e.g., PE, PC) of selected characteristics (e.g., class).
\item A stacked horizontal bar chart of lipid class composition by the
user-input parameter, \bold{'char_var'} (such as class) .
}
}
\description{
This function provides two plots depending on the
"Lipid characteristics" table uploaded by users.
\enumerate{
\item A bar plot of lipid expression, which depicts the expression level of
each sample within each group (e.g., PE, PC) of
selected characteristics (e.g., class).
\item A stacked horizontal bar chart of the percentage of
characteristics in each sample.
}
}
\examples{
library(dplyr)
data("profiling_exp_data")
data("profiling_lipid_char_table")
exp_data <- profiling_exp_data
lipid_char_table <- profiling_lipid_char_table
char_var <- colnames(lipid_char_table)[-1]
exp_compo_by_lipidinfo(exp_data, lipid_char_table, char_var[1], plotly=TRUE)
}
