% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tensor_decompositions.R
\name{cp_rank_selection}
\alias{cp_rank_selection}
\title{Select the rank of a tensor using CP decomposition}
\usage{
cp_rank_selection(tnsr, max_rank)
}
\arguments{
\item{tnsr}{The input tensor.}

\item{max_rank}{The maximum rank to consider.}
}
\value{
A list with the selected rank and a vector of the approximation error
for each rank.
}
\description{
This function selects the rank of a tensor based on the ratio of the
approximation error between different rank values obtained by CP decomposition.
Additionally, it gives a plot for visual inspection of the fit
}
\examples{
# Load data
data(traditional_data)

# Convert data to tensor
traditional_tensor <- as.tensor(traditional_data)

# Select the rank of the tensor using CP decomposition
cp_rank_selection(traditional_tensor, 20)
}
