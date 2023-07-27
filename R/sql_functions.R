#' Execute a single query
#'
#' @param dsn
#' @param query
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
sql_query <- function(query, dsn_alias = names(options()$ez.dsn.default),
                      close = TRUE,
                      ...) {

  # check to see if the alias exists
  if(is.na(options()$ez.dsn[dsn_alias])) {
    stop('That alias doesnt exist in your DSNs')}

  # get the dsn from dsn list and unname it (odbc doenst like names)
  dsn <- unname(options()$ez.dsn[dsn_alias])

  con <- odbc::dbConnect(odbc::odbc(), dsn)
  data <- odbc::dbGetQuery(con, query, ...)

  # destroy connection
  if (close) {
  odbc::dbDisconnect(con)
  remove(con)
  }

  data
}
