context("Utility Checker")

server <- "https://rest.ensembl.org"

test_that("Can ping", {
  expect_silent(host_ping(server))
})

test_that("search by ontology and taxonomy works", {
  expect_silent(search_ontology(server, "diabetes"))
  expect_silent(search_taxonomy(server, "humans"))
})

test_that("xref servers works", {
  expect_silent(xref_symbol("human", "WHSC1"))
})
