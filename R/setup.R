library(jsonlite)
library(httr)
library(xml2)
library(data.table)


server <- "rest.ensembl.org"
server2 <- "https://rest.genenames.org"
ext <- "info/assembly"



setup <- function(ensembl_server, gn_server) {

  species <- fromJSON(request(GET, ensembl_server, "info_species"))
  species <- as.data.table(species$species)
}

#' rest.ensembl.org requester function.
#'
#' @param funct Supports POST or GET based on the function
#' @param server use the default or an archived version
#' @param ext Extension based on the rest API functions
#' @param ... Searchable strings. Either :species : symbol or just :symbol
#' @param eargs additional args based on the function used
#'
#' @return Contents of R. In JSON format, need to return from JSON
#'
#' @examples
#' req <- request(GET, server = "rest.ensembl.org", ext = "family/member/symbol",
#'                "human", "NSD2",
#'                eargs = c("db_type=core", "aligned=1")) #See https://rest.ensembl.org/documentation/info/family_member_symbol for more info
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

#' Similar to request but XML instead of JSON
request_xml <- function(funct, server, ext, ..., eargs = NULL) {
  input <- paste(ext, ..., sep="/")
  link <- paste(server, input, sep="/")

  r <- funct(link, content_type_xml())

  stop_for_status(r)
  return(r)
}

#' Genenames.org (HGNC) rest API requests. Can convert smybols into appropriate IDs for multiple databases
#' Current extensions supported are:
#'     "search/:symbol"
#'     "search/symbol/:symbol" which includes wildcards like "*" or "?". Use https://www.genenames.org/help/rest-web-service-help for more information
#'     "fetch/:symbol" <- which actually retrieves the data about that specific symbol
#'
#' @param funct GET or POST. Currently used with GET
#' @param server Use default of rest.genenames.org
#' @param ext Extension. Supported extensions are above
#' @param ... Search terms or more extensions to the URL
#' @param eargs More args (currently unused)
#'
#' @return content from the request fromJson format (needs a better format)
#'
#' @example
#' req <- request_gn(GET, server = "https://rest.genenames.org", ext= "fetch/symbol", "NSD2")
request_gn <- function(funct, server = "https://rest.genenames.org", ext, ..., eargs = NULL) {
  input <- paste(ext, ..., sep="/")
  url <- paste(server, input, sep="/")

  r <- funct(url, content_type_json(), accept_json())

  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}


#' Streamlines searching for a symbol -> Ensembl ID from HGNC
#' If fails fallback to "xref/symbol/human/symbol" from the rest API
#'
#' @param symbol Symbol of the gene that is being looked at
#'
#' @return all possible IDs for that symbol. This can be across multiple genomes or the same but different parts.
ensembl_from_symb <- function(symbol) {
  tmp <- request_gn(GET, server2, "fetch/symbol", symbol)

  ids <- unlist(tmp$response$doc)
  ids <- ids["ensembl_gene_id"]
  return(ids)
}

#' Furthur streamlines searching symbol to retrieving the relevant data from just the symbol
#'
#' @param symbol HGNC symbol
#'
#' @return currently only the first ID. Have not decided how to handle multiple IDs
symb_to_data <- function(symbol) {
  ids <- ensembl_from_symb(symbol)
  if (is.null(ids)) return(NULL)

  for (id in ids) {
    data <- request(GET, server, "genetree/member/id", id)
    return(data)
  }
}


ensemblHost <- "rest.ensembl.org"
#' Finds ensembl ID from HGNC symbol
#' Random results, CANNOT DEPEND ON THIS METHOD AT THE MOMENT
#' How it was done previously: Download a genelist and search through that instead, if failed then turn to an archived version of ensembl that is far more stable
#' to search
#'
#' @param hgnc_symbol
#'
#' @return ensembl ID of the hgnc_symbol
search_hgnc.web <- function(hgnc_symbol) {
  ensembl <- biomaRt::useMart('ENSEMBL_MART_ENSEMBL', dataset = "hsapiens_gene_ensembl")

  rep_ensembl <- biomaRt::getBM(attributes = c('ensembl_gene_id', 'hgnc_symbol', 'ucsc'),
                                filter='hgnc_symbol', values=hgnc_symbol, mart=ensembl)
  rep_ensembl <- as.data.table(rep_ensembl)

  if (nrow(rep_ensembl) == 0) {
    return(print("No Data Available"))
  }
  ids = data.table::data.table(hgnc_symbol)

  names(ids)  = c("hgnc_symbol")

  tmp <- merge(ids, rep_ensembl, by='hgnc_symbol', sort=FALSE)

  tmp = subset(tmp, ucsc != "")

  return(unique(tmp[['ensembl_gene_id']]))
}
