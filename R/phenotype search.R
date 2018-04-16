server <- "rest.ensembl.org"

request <- function(funct, server = "rest.ensembl.org", ext, ..., eargs = NULL) {
  input <- paste(paste(ext, ..., sep="/"), "?", sep="")
  if (!is.null(eargs)) {
    input <- paste(input, paste(eargs, collapse=";"), sep="")
  }

  link <- paste(server, input, sep="/")

  r <- funct(link, content_type_json())

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
phenotype_search <- function(phenotype, species = "human", include_children = FALSE) {
  server = "rest.ensembl.org"
  p <- gsub(" ", "_", phenotype)
  earg = NULL
  if (include_children == TRUE) {
    earg = c("include_children=1")
  }
  results <- request(GET, server, ext = "phenotype/term", species, p, eargs = earg)
  results <- fromJSON(results)
  return(results)
}
