#' Oncoprint data formatting
#'
#' @param file string MAKE SURE THAT YOU USE "/" SLASHES IN WINDOWS
#' @param gene_name string HUGO id like PTEN
#'
#' @return JSON formatted file for your query.
#'
#' @exmaple
#' temp <- odf(file, "PTEN")
#' cat(temp)
#' write(temp, newfile)
odf <- function(file, gene_name) {
  returns <- grep(gene_name, readLines(file), ignore.case = TRUE, value=TRUE)
  returns <- strsplit(returns, "\t")
  names <- c()
  for(i in 1:length(returns)) {
    names <- cbind(names, returns[[i]][1])
    returns[[i]] <- returns[[i]][3:length(returns[[i]])]
  }
  names(returns) <- names
  print(names)

  json <- toJSON(returns)
  return(json)
}
