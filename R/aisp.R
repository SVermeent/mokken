# Modified on October 14 2015
"aisp" <- function(X, search = "normal", 
                      lowerbound =.3, 
                      alpha = .05, 
                      StartSet = FALSE,
                      popsize = 20, 
                      maxgens = default.maxgens, 
                      pxover = 0.5, 
                      pmutation = 0.1,
                      verbose = FALSE)
{
   X <- check.data(X)
   params <- c(lowerbound, alpha, pxover, pmutation)
   cparams <- c("lowerbound", "alpha", "pxover", "pmutation")
   for (i in 1:4){
     if(!is.numeric(params[i])|is.na(params[i])) stop(cparams[i], " is not numeric")
     if (params[i] < 0) {warning(paste("Negative ",cparams[i],". ",cparams[i]," is set to 0")); assign(cparams[i],0)}
     if (params[i] > 1) {warning(paste(cparams[i]," greater than 1. ",cparams[i]," is set to 1")); assign(cparams[i],1)}
   }
   default.maxgens <- 10^(log2(ncol(X)/5)) * 1000
   if(is.numeric(popsize)&!is.na(popsize)) popsize <- as.integer(popsize) else stop("popsize is not numeric")
   if(popsize < 1) stop("popsize is nonpositive")
   if(is.numeric(maxgens)&!is.na(maxgens)) maxgens <- as.integer(maxgens) else stop("maxgens is not numeric")
   if(maxgens < 1) stop("maxgens is nonpositive")
   if(search == "ga"){ 
     output <- NULL
     for (lb in lowerbound){ 
        ga <- search.ga(X, popsize, maxgens, alpha, lb, pxover, pmutation)
        output <- cbind(output, ga)
     }
     dimnames(output) <- list(dimnames(X)[[2]], lowerbound)
   } else {
     if(search == "extended") output <- search.extended(verbose) else output <- search.normal(X, lowerbound, alpha, StartSet, verbose)
   }  
   return(output)   
}
