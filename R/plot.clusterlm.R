#'Plot cluster or parameters.
#'
#' @description Plot method for class \code{clusterlm}.
#'
#' @param x A \code{clusterlm} object.
#' @param effect A vector of character naming the effects to display. Default is \code{"all"}.
#' @param type A character string that specified the values to highlight. \code{"statistic"} or \code{"coef"} are available. Default is \code{"statistic"}.
#' @param multcomp A character string specifying the method use to correct the p-value. It should match the one computed in the object. Default is the (first) method in the call to \link{clusterlm}. See \link{clusterlm}.
#' @param alternative A character string specifying the alternative hypothesis for the t-test. The available options are \code{"greater"}, \code{"less"} and \code{"two.sided"}. Default is \code{"two.sided"}.
#' @param enhanced_stat A logical. Default is \code{FALSE}. If \code{TRUE}, the enhanced statistic will be plotted overwise it will plot the observed statistic. Change for the \code{"tfce"} or the \code{"clustermass"} multiple comparisons procedures.
#' @param nbbaselinepts An integer. Default is 0. If the origin of the x axis should be shifted to show the start of the time lock, provide the number of baseline time points.
#' @param nbptsperunit An integer. Default is 1. Modify this value to change the scale of the label from the number of points to the desired unit. If points are e.g. sampled at 1024Hz, set to 1024 to scale into seconds and to 1.024 to scale into milliseconds.
#' @param distinctDVs Boolean. Should the DVs be plotted distictively, i.e. should the points be unlinked and should the name of the DVs be printed on the x axis ? Default is FALSE if the number of DV is large thant 15 or if the method is "clustermass" or "tfce".
#' @param ... further argument pass to plot.
#' @importFrom graphics points axis
#' @export
#'@family plot
plot.clusterlm <- function(x, effect = "all", type = "statistic", multcomp = x$multcomp[1], alternative = "two.sided", enhanced_stat = FALSE,
                           nbbaselinepts=0, nbptsperunit=1, distinctDVs=NULL, ...) {
  par0 <- par()

  dotargs <- list(...)
  dotargs_par <- dotargs[names(dotargs)%in%names(par())]
  dotargs <-  dotargs[!names(dotargs)%in%names(par())]
  ##select effect
  if("all" %in% effect){effect = names(x$multiple_comparison)}
  else if(sum(names(x$multiple_comparison)%in%effect) == 0){
    warning(" the specified effects do not exist. Plot 'all' effects.")
    effect = names(x$multiple_comparison)
  }
  effect_sel <- names(x$multiple_comparison)%in%effect

  ###switch mult comp
  switch(alternative,
         "two.sided" = {multiple_comparison = x$multiple_comparison[effect_sel]},
         "greater" = {multiple_comparison = x$multiple_comparison_greater[effect_sel]},
         "less" = {multiple_comparison = x$multiple_comparison_less[effect_sel]})

  pvalue = t(sapply(multiple_comparison,function(m){
    m[[multcomp]]$main[,2]}))

  statistic = t(sapply(multiple_comparison,function(m){
    m[["uncorrected"]]$main[,1]}))
  if(enhanced_stat){
    statistic = t(sapply(multiple_comparison,function(m){
      m[[multcomp]]$main[,1]}))
  }



  ##swich value
  switch(type,
         "coef"={
           data <- x$coef[effect_sel,]
           title <- "coefficients"
           hl <- NULL
         },
         "statistic" ={
           data <- statistic
           title <- paste(x$test, " statistic",sep="",collapse = "")
           if(multcomp=="clustermass"){
             switch(x$test,
                    "fisher"={hl <- x$threshold},
                    "t"={
                      switch (alternative,
                              "less" ={hl <- -c(abs(x$threshold))},
                              "greater" ={hl <- c(abs(x$threshold))},
                              "two.sided" ={hl <- c(abs(x$threshold))}
                      )})}
         })

  title =paste(title," : ", multcomp, " correction",sep="", collapse = "")



  #####
  p = sum(NROW(data))
  rnames = row.names(data)
  cnames = colnames(data)
  nbDV = ncol(data)



  ### should the DVs be named in plot and separated ?
  if (is.null(distinctDVs)){
    if (multcomp %in% c("clustermass", "tfce"))
      distinctDVs = FALSE
    else distinctDVs = (nbDV<16)
  }
  if ((distinctDVs==TRUE) &&  (multcomp %in% c("clustermass", "tfce")))
    warning("Computations and corrections have been based on adjacency of DVs but the the plot will show separated DVs")
  #####

  par0 <- list(mfcol = par()$mfcol,mar = par()$mar,oma = par()$oma)

  if(is.null(dotargs_par$mfcol)){dotargs_par$mfcol = c(p,1)}
  if(is.null(dotargs_par$mar)){dotargs_par$mar = c(0,4,0,0)}
  if(is.null(dotargs_par$oma)){dotargs_par$oma = c(4,0,4,1)}

  par(dotargs_par)
  #par(mfcol = c(p,1),mar = c(0,4,0,0),oma = c(4,0,4,1))
  for (i in 1:p) {
    if (distinctDVs) {
      plot((1:ncol(data)-nbbaselinepts)/nbptsperunit,
           data[i,],type = "p", xaxt = "n",xlab = "",ylab = rnames[i], pch=18, cex=2,
      )
      if(i==p) axis(1, at= (1:ncol(data)-nbbaselinepts)/nbptsperunit, labels=cnames)
    }
    else{
      if(i==p){xaxt = NULL}else{xaxt = "n"}
      plot((1:ncol(data)-nbbaselinepts)/nbptsperunit,
           data[i,],type = "l", xaxt = xaxt,xlab = "",ylab = rnames[i], ... = ...
      )
    }
    if(type == "statistic"){
      xi = which(pvalue[i,]< x$alpha)
      y = data[i,xi]
      col="red"
      #lines(x = x,y= y,lwd=par()$lwd*2,col=col)
      points(x = (xi-nbbaselinepts)/nbptsperunit, y = y, pch=18,col=col, cex=distinctDVs+1)
      if(multcomp=="clustermass"){
        abline(h=hl[i],lty=3)
        if(x$test=="t"&alternative=="two.sided"){
          abline(h=-hl[i],lty=3)
        }
      }
    }}
  title(title,outer = T,cex = 2)
  par0 <- par0[!names(par0)%in%c("cin","cra","csi","cxy","din","page")]
  par(par0)
}