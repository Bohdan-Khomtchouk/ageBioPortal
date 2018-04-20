library(httr)
library(jsonlite)
library(data.table)
library(dplyr)
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
#' Max POST is 200. limited to 15 per second. Takes the phenotype search and returns all of the information based on the rsids contained in that list.
#' 
#' @param dt Data.table. From the phenotype_search function
#' @genotypes logical. 	Include individual genotypes. Containts a huge amount of data, DO NOT USE ON A LARGE LIST.
#' @phenotypes logical. 	Include phenotypes. This function returns information like related genes, traits, source, and genes
#' @pops logical. Include population allele frequencies
#' @population_genotypes logical. Include population genotype frequencies
#' @json logical. To be written to rsids_data_info.json or not
#' @ret logical. To have the data returned in R or not.
#' 
#' @return List of lists containing rsids and information.
#' @return file "rsid_info_data.json" in the user directory
#' 
#' @import jsonlite httr data.table dplyr
#' 
#' @examples
#' search <- phenotype_search("coronary artery disease")
#' 
#' cad.data <- return_all_rsid_info(search, phenotypes = TRUE) #returns ALL of the rsid info on cataracts. May take some time.
#' 
#' cad.GPC5.LRFN2 <- cad[grep("GPC5|LRFN2", cad$attributes.associated_gene, ignore.case = TRUE),]
#' cad.data.GPC5.LRFN2 <- return_all_rsid_info(cad.GPC5.LRFN2, genotypes = TRUE, pops=TRUE, population_genotypes=TRUE)
#' 
#' @export
return_all_rsid_info <- function(dt, genotypes=FALSE, phenotypes=FALSE, pops=FALSE, population_genotypes=FALSE, json = TRUE, ret = TRUE) {
  server = "rest.ensembl.org"
  input <- paste0("variation/homo_sapiens", "?")
  
  eargs = c(paste("genotypes", as.numeric(genotypes), sep="="), paste("phenotypes", as.numeric(phenotypes), sep="="),
            paste("pops", as.numeric(pops), sep="="), paste("population_genotypes", as.numeric(population_genotypes), sep="="))
  input <- paste0(input, paste(eargs, collapse=";"))
  
  url <- paste(server, input, sep="/")
  
  rsids <- unique(dt[Variation != "NULL"]$Variation) #using only the RSID, we do not want doubling of rsids.
  results <- list()
  for (i in 1:ceiling(length(rsids) / 200)) {
    vals <- ((i-1)*200+1):(i*200)
    body <- paste('{ "ids" :', paste("[", paste0('"', rsids[vals], '"', collapse = ', '), "]"), '}')
  
    message("Retrieving set ", i, " of 200 rsids")
    
    results[[i]] <- url %>% 
                    POST(content_type_json(), accept_json(), body = body) %>%
                    stop_for_status() %>%
                    content() %>%
                    toJSON(pretty = TRUE) %>%
                    fromJSON(flatten = TRUE)
  }
  if (json) {
    file <- file("rsid_info_data.json", "w")
    write(toJSON(results, pretty = TRUE), file)
    
    close(file)
  }
  
  #results <- rbind_pages(results)
  ifelse(ret, return(results), return())
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




