#' Create a set of permutations/signflips.
#'
#' @description Compute a permutation matrix used as argument in \link{aovperm}, \link{lmperm}, \link{clusterlm} functions. The first column represents the identity permutation. Generally not suited for the "huh_jhun" method, as the dimension of this matrix does not correspond to the number of observations and may vary for different factors.
#' @param np A numeric value for the number of permutations. Default is 5000.
#' @param n A numeric value for the number of observations.
#' @param type A character string to specify the type of transformations: "permutation" and "signflip" are available. See details.
#' @param counting A character string to specify the selection of the transformations. "all" and "random" are available. See details.
#' @return A matrix n x np containing the permutations/signflips. First permutation is the identity.
#' @details \code{couting} can set to :\cr
#' \code{"random"} : \code{np} random with replacement permutations/signflips among the \code{n!}/\code{2^n}  permutations/signflips.\cr
#' \code{"all"} : all \code{n!}/\code{2^n} possible permutations/signflips.\cr
#' @importFrom permute allPerms
#' @importFrom permute how
#' @examples
#' ## data
#' data("emergencycost")
#'
#' ## Create a set of 2000 permutations
#' set.seed(42)
#' pmat = Pmat(np = 2000, n = nrow(emergencycost))
#' sfmat = Pmat(np = 2000, n = nrow(emergencycost), type = "signflip")
#'
#' ## centrering the covariate to the mean
#' emergencycost$LOSc <- scale(emergencycost$LOS, scale = FALSE)
#'
#' ## ANCOVA
#' mod_cost_0 <- aovperm(cost ~ LOSc*sex*insurance, data = emergencycost, np = 2000)
#' mod_cost_1 <- aovperm(cost ~ LOSc*sex*insurance, data = emergencycost, P = pmat)
#' mod_cost_2 <- aovperm(cost ~ LOSc*sex*insurance, data = emergencycost, P = pmat)
#' mod_cost_3 <- aovperm(cost ~ LOSc*sex*insurance, data = emergencycost, P = sfmat)
#' mod_cost_4 <- aovperm(cost ~ LOSc*sex*insurance, data = emergencycost,type="signflip")
#'
#' ## Same p-values for both models 1 and 2 but different of model 0
#' mod_cost_0
#' mod_cost_1
#' mod_cost_2
#' mod_cost_3
#' mod_cost_4
#'
#' @export
#' @family pmat
Pmat <- function(np = 5000, n, type = "permutation", counting = "random"){
  type <- match.arg(type, c("permutation","signflip"))
  counting <- match.arg(counting,c("random","all"))
  #warnings type dimension
  if(type=="permutation"){
  switch(counting,
         "all" = {
           if(n > 8){
           warning("'all' permutations are not feasible for n > 8, Pmat is computed with the 'random' counting.")
             counting <- "random"}},
         {
           if(n <= 8){
             if(factorial(n) <= np){
               warning("n!<= np 'all' permutations are feasible, Pmat is computed with the 'all' counting.")
               counting <- "all"
               }
             }
           }
         )}else if(type=="signflip")
           {switch(counting,
                  "all" = {
                    if(n > 18){
                      warning("'all' signflip are not feasible for n > 18, Pmat is computed with the 'random' counting.")
                      counting <- "random"}},
                  {
                    if(2^n <= np){
                        warning("2^n <= np 'all' signflip are feasible, Pmat is computed with the 'all' counting.")
                        counting <- "all"
                      }

                  }
           )}
  #creating matrix
  if(type=="permutation"){
  switch(counting,
         "random"={P <- cbind(1:n, replicate(np - 1, sample(n, n, replace = F)))},
         "all"={
             P <- t(allPerms(n,control = how(observed = T)))
             #as.matrix
             attr(P, "control") <- NULL
             attr(P, "observed") <- NULL
             class(P) <- "matrix"
             np <- factorial(n)})}
    else if(type=="signflip"){
      switch(counting,
             "random" = {P <- cbind(rep(1, n), replicate(np - 1, sample(c(1, -1), n, replace = T)))},
             "all" = {
               P <- t(as.matrix(expand.grid(as.data.frame(t(cbind(rep(1,n),rep(-1,n)))))))
               rownames(P) <- NULL
               np <- 2^n})
             }

  attr(P,which = "type") <- type
  attr(P,which = "counting") <- counting
  attr(P,which = "np") <- np
  attr(P,which = "n") <- n
  class(P) <- "Pmat"
  return(P)
}




