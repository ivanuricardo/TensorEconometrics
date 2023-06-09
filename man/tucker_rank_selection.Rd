% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tensor_decompositions.R
\name{tucker_rank_selection}
\alias{tucker_rank_selection}
\title{Select the rank of each mode of a tensor using Tucker approximation}
\usage{
tucker_rank_selection(tnsr, c = 0, num_obs)
}
\arguments{
\item{tnsr}{A tensor object}

\item{c}{Regularization parameter to avoid division by zero. Default is given in 
Xia, Xu, and Zhu 2015}

\item{num_obs}{The number of observations for the parameter tensor}
}
\value{
A vector with the estimated rank for each mode
}
\description{
Given a tensor, this function computes the optimal rank for each mode using
the SVD of the flattened tensor. WARNING: Can be slow for large tensors.
Additionally, for determination of c, see Xia, Xu, and Zhu 2015, Wang et. al 2022.
}
