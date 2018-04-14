#' Ensembl Hosts
#' goes back to 2015 incase one site is down
#' additional args; , 'aug2017.', 'may2017.', 'mar2017.', 'dec2016.'
hosts <- paste("http://", c(''), "rest.ensembl.org", sep='')

gene <- "WHSC1"
library(jsonlite)
library(httr)
library(xml2)
library(data.table)

#' Check ensembl hosts for a working version
#'
#' @param host server
#'
#' @import jsonlite
#' @import httr
#' @import xml2
host_ping <- function(host) {
  ext <- '/info/ping?'
  r <- GET(paste(host, ext, sep=''), content_type("application/json"))
  stop_for_status(r)
  warn_for_status(r)
  return(fromJSON(toJSON(content(r)))$ping)
}

#' Search Ensembl by Ontology
#' by definition
#'
#' @param search_term
#'
#' @return data.frame-like struct of the return call
#'
search_ontology <- function(server, search_term) {
  ext <- paste("/ontology/name/", search_term, '?', sep='')
  r <- GET(paste(server, ext, sep = ""), content_type("application/json"))
  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}

#' Search Ensembl by Taxonomy
#' Which is to say by "species"
#'
#' @param server
#' @param search_term
#'
#' @return data.frame-like struct of the return call
#'
search_taxonomy <- function(server, search_term) {
  ext <- paste("/taxonomy/name/", search_term, '?', sep='')
  r <- GET(paste(server, ext, sep = ""), content_type("application/json"))
  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}

#' Xref species symbol
#' Looks up an external symbol and returns all Ensembl objects linked to it.
#' This can be a display name for a gene/transcript/translation,
#' a synonym or an externally linked reference.
#' If a gene's transcript is linked to the supplied symbol the service will return both gene and transcript (it supports transient links).
#'
#' @param server
#' @param species
#' @param symbol
#' @param external_db null
#' @param object_type null
#'
#' @return data.frame-like struct of the return call
xref_symbol <- function(server, species, symbol, external_db = NULL, object_type = NULL) {
  if (!is.null(external_db)) {
    external_db <- paste("external_db=", external_db, sep='')
  }
  if (!is.null(object_type)) {
    object_type <- paste("object_type=", object_type, sep='')
  }
  ext <- paste("/xrefs/symbol/", species, "/", symbol, "?", external_db, object_type, sep = '')
  r <- GET(paste(server, ext, sep=''), content_type("application/json"))

  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}

#' Xref species name
#' Performs a lookup based upon the primary accession or
#' display label of an external reference and returning the information we hold about the entry.
#'
#' @param server
#' @param species
#' @param symbol
#' @param external_db null
#' @param object_type null
#'
#' @return data.frame-like struct of the return call
xref_name <- function(server, species, name, external_db = NULL, object_type = NULL) {
  if (!is.null(external_db)) {
    external_db <- paste("external_db=", external_db, sep='')
  }
  if (!is.null(object_type)) {
    object_type <- paste("object_type=", object_type, sep='')
  }
  ext <- paste("/xrefs/name/", species, "/", name, "?", external_db, object_type, sep = '')
  r <- GET(paste(server, ext, sep=''), content_type("application/json"))

  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}

#' Retrieves the information for all the families that contains the gene identified by a symbol
#'
#' @param server
#' @param species
#' @param symbol
#'
#' @return something
fms <- function(server, species, symbol) {

  ext <- paste("/family/member/symbol/", species, "/", symbol, "?", sep="")

  r <- GET(paste(server, ext, sep=''), content_type("application/json"))

  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}

#' Retrieves the cafe tree of the gene tree that contains the gene / transcript / translation stable identifier
#'
#' @param server
#' @param id ensembl stable ID
#'
#' @return Something else
cgmi <- function(server, id) {
  ext <- paste("/cafe/genetree/member/id/", id,"?", sep='')

  r <- GET(paste(server, ext, sep=""), content_type("application/json"))

  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}


#' Retrieves a family information using the family stable identifier
#'
#' @param server
#' @param id
#'
#' @return something
fi <- function(server, family_id){
  ext <- paste("/cafe/id/", id,"?", sep='')

  r <- GET(paste(server, ext, sep = ""), content_type("application/json"))

  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}

#' Find the species and database for a symbol in a linked external database
#'
#' @param server
#' @param species
#' @param symbol
#'
#' @return
ls <- function(server, species, symbol) {
  ext <- paste("/lookup/symbol/", species, "/", symbol, "?", sep="")

  r <- GET(paste(server, ext, sep=""), content_type("application/json"))

  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}

#' Find the species and database for a symbol in a linked external database
#'
#' @param server
#' @param id
#'
#' @return
li <- function(server, id) {
  ext <- paste("/lookup/id/", id, "?", sep="")

  r <- GET(paste(server, ext, sep=""), content_type("application/json"))

  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}

#' Uses the given identifier to return the archived sequence
#'
#' @param server
#' @param id
#'
#' @return
archive_id <- function(server, id){
  ext <- paste("/archive/id/", id, "?", sep="")

  r <- GET(paste(server, ext, sep=""), content_type_json())

  stop_for_status(r)

  return(fromJSON(toJSON(content(r))))
}

#' Lists all available species, their aliases, available adaptor groups and data release.
#'
#' @param server
#'
#' @return all available species, their aliases, and yeah
info_species <- function(server) {
  ext <- "/info/species?"

  r <- GET(paste(server, ext, sep = ""), content_type("application/json"))

  stop_for_status(r)

  # use this if you get a simple nested list back, otherwise inspect its structure
  # head(data.frame(t(sapply(content(r),c))))
  return(fromJSON(toJSON(content(r))))
}




ensemblHost <- "rest.ensembl.org"

#' Finds ensembl ID from HGNC symbol
#' Random results, cannot depend on this method
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
