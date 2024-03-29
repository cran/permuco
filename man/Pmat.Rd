% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Pmat.R
\name{Pmat}
\alias{Pmat}
\title{Create a set of permutations/signflips.}
\usage{
Pmat(np = 5000, n, type = "permutation", counting = "random")
}
\arguments{
\item{np}{A numeric value for the number of permutations. Default is 5000.}

\item{n}{A numeric value for the number of observations.}

\item{type}{A character string to specify the type of transformations: "permutation" and "signflip" are available. See details.}

\item{counting}{A character string to specify the selection of the transformations. "all" and "random" are available. See details.}
}
\value{
A matrix n x np containing the permutations/signflips. First permutation is the identity.
}
\description{
Compute a permutation matrix used as argument in \link{aovperm}, \link{lmperm}, \link{clusterlm} functions. The first column represents the identity permutation. Generally not suited for the "huh_jhun" method, as the dimension of this matrix does not correspond to the number of observations and may vary for different factors.
}
\details{
\code{couting} can set to :\cr
\code{"random"} : \code{np} random with replacement permutations/signflips among the \code{n!}/\code{2^n}  permutations/signflips.\cr
\code{"all"} : all \code{n!}/\code{2^n} possible permutations/signflips.\cr
}
\examples{
## data
data("emergencycost")

## Create a set of 2000 permutations
set.seed(42)
pmat = Pmat(np = 2000, n = nrow(emergencycost))
sfmat = Pmat(np = 2000, n = nrow(emergencycost), type = "signflip")

## centrering the covariate to the mean
emergencycost$LOSc <- scale(emergencycost$LOS, scale = FALSE)

## ANCOVA
mod_cost_0 <- aovperm(cost ~ LOSc*sex*insurance, data = emergencycost, np = 2000)
mod_cost_1 <- aovperm(cost ~ LOSc*sex*insurance, data = emergencycost, P = pmat)
mod_cost_2 <- aovperm(cost ~ LOSc*sex*insurance, data = emergencycost, P = pmat)
mod_cost_3 <- aovperm(cost ~ LOSc*sex*insurance, data = emergencycost, P = sfmat)
mod_cost_4 <- aovperm(cost ~ LOSc*sex*insurance, data = emergencycost,type="signflip")

## Same p-values for both models 1 and 2 but different of model 0
mod_cost_0
mod_cost_1
mod_cost_2
mod_cost_3
mod_cost_4

}
\seealso{
Other pmat: 
\code{\link{Pmat_product}()},
\code{\link{as.Pmat}()}
}
\concept{pmat}
