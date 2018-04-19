library(httr)
library(jsonlite)
library(data.table)
server <- "rest.ensembl.org"

request <- function(funct, server = "rest.ensembl.org", ext, ..., eargs = NULL) {
  input <- paste(paste(ext, ..., sep="/"), "?", sep="")
  if (!is.null(eargs)) {
    input <- paste(input, paste(eargs, collapse=";"), sep="")
  }

  link <- paste(server, input, sep="/")

  r <- funct(link, content_type_json(), accept_json())

  stop_for_status(r)
  return(toJSON(content(r), pretty=TRUE))
}

#' Search ensembl by exact phenotypes
#'
#' @param phenotype String. phenotype term to search
#' @param species String. Species to be searched
#' @param include_children logical. Quote - "Include annotations attached to child terms" (untested)
#'
#' @return contents of search in data.frame. See names() for more information about structure
#'
#' @examples
#' server <- "rest.ensembl.org"
#'
#' cataract <- phenotype_search('cataract', species = "homo_sapiens", FALSE)
#' head(cataract)
#' @import jsonlite httr data.table
#' 
#' @export
phenotype_search <- function(phenotype, species = "human", include_children = FALSE) {
  server = "rest.ensembl.org"
  p <- gsub(" ", "_", phenotype)
  earg = NULL
  if (include_children == TRUE) {
    earg = c("include_children=1")
  }
  results <- request(GET, server, ext = "phenotype/term", species, p, eargs = earg)
  results <- fromJSON(results, flatten=TRUE)
  results <- as.data.table(results)
  return(results)
}
#' Max POST is 200. limited to 15 per second
return_all_rsid_info <- function(dt, genotypes=FALSE, phenotypes=FALSE, pops=FALSE, population_genotypes=FALSE, json = TRUE, return = TRUE) {
  server = "rest.ensembl.org"
  input <- paste0("variation/homo_sapiens", "?")
  eargs = c(paste("genotypes", as.numeric(genotypes), sep="="), paste("phenotypes", as.numeric(phenotypes), sep="="),
            paste("pops", as.numeric(pops), sep="="), paste("population_genotypes", as.numeric(population_genotypes), sep="="))
  input <- paste0(input, paste(eargs, collapse=";"))
  
  url <- paste(server, input, sep="/")
  
  rsids <- dt[Variation != "NULL"]$Variation
  results <- list()
  for (i in 1:ceiling(length(rsids) / 200)) {
    vals <- ((i-1)*200+1):(i*200)
    body <- paste('{ "ids" :', paste("[", paste0('"', rsids[vals], '"', collapse = ', '), "]"), '}')
    message("Retrieving set ", i, " of 200 rsids")
    
    r <- POST(url, content_type_json(), accept_json(), body = body)
    stop_for_status(r)
    
    results[[i]] <- fromJSON(toJSON(content(r), pretty=TRUE), flatten = TRUE)
  }
  if (json) {
    file <- file("rsid_info_data.json", "w")
    write(toJSON(results, pretty = TRUE), file)
    
    close(file)
    #unlink("rsid_info_data.json")
  }
  #results <- rbind_pages(results)
  ifelse(return, return(results), return())
}


#' Rate Limiter to 15/sec
#' 
#' 
#' 
limit_rate <- function() {
  ptm <- proc.time()
  #do something
  a <- proc.time() - ptm
}




