#'
#'
#'
#'@import sparklyr
#'@import dplyr
check_connection <- function(x) {
  sc <- spark_connect(master = 'local"')
}
