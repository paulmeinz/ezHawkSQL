#' Execute a single query
#'
#' @param dsn The alias of your dsn. Uses default dsn if not specified.
#' @param query The query from which you would like to get data.
#' @param close Close and destroy the connection once the query is complete?
#' @param ... Additional arguments passed to odbc::dbGetQuery()
#'
#' @return Presuming your query is written properly. Returns a data frame of data
#'   (e.g. isn't inserting data into a temp table)
#' @export
#'
#' @examples \dontrun{sql_query("select foo from bar where beans = 'beans'")}
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
