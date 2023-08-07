#' Execute a single query
#'
#' @param dsn The alias of your dsn. Uses default dsn if not specified.
#' @param dsn_alias The alias of the DSN you would like to use.
#' @param query The query from which you would like to get data.
#' @param ... Additional arguments passed to odbc::dbGetQuery()
#'
#' @return Presuming your query is written properly. Returns a data frame of data
#'   (e.g. isn't inserting data into a temp table)
#' @export
#'
#' @examples \dontrun{sql_query("select foo from bar where beans = 'beans'")}
sql_query <- function(query, dsn_alias = names(options()$ez.dsn.default),
                      ...) {

  # check to see if the alias exists
  if(is.na(options()$ez.dsn[dsn_alias])) {
    stop('That alias doesnt exist in your DSNs')}

  # get the dsn from dsn list and unname it (odbc doenst like names)
  dsn <- unname(options()$ez.dsn[dsn_alias])

  con <- odbc::dbConnect(odbc::odbc(), dsn)
  data <- odbc::dbGetQuery(con, query, ...)

  # destroy connection
  odbc::dbDisconnect(con)
  remove(con)

  data
}

#' Read a SQL query from a text file
#'
#' This is function allows the user to read a query from a text file. No validation
#' of that file is conducted. In other words, this function could read any text file.
#' For functions that use multiple temp table steps. Separate each query by '---step---'
#' so that each step can be idenfitied. Don't do this for CTE expressions.
#'
#' @param file The directory/filename of the text file.
#'
#' @return A character string from the text file.
#' @export
#'
#' @examples \dontrun{read_query("my_file.txt")}
read_query <- function(file) {
  query <- readr::read_file(file)
  query <- gsub("[\r\n]", "", query)
  query <- stringr::str_split_1(query, '---step---')
  steps <- generate_steps(query)
  names(query) <- steps
  query
}

#' Execute a multi-step query
#'
#' If you have a multi-step query that requires the creation of a couple temp
#' tables, you can use this function to execute each in order and then pull
#' data from the final query.
#'
#' @param query A character vector with each query. The queries should be in
#'   the order you wish them to be executed. Each element in this vector should
#'   also be given a name.
#' @param dsn_alias The dsn alias you wish to use. Defaults to your default dsn.
#'
#' @return A dataset
#' @export
#'
#' @examples \dontrun{multistep_sql_query(query)}
multistep_sql_query <- function(query,
                                 dsn_alias = names(options()$ez.dsn.default)) {
  if (length(query) < 2) {
    stop("This doesn't appear to be a multi-step query. Use sql_query()")
  }

  dsn <- unname(options()$ez.dsn[dsn_alias])
  con <- odbc::dbConnect(odbc::odbc(), dsn)

  for (i in 1:(length(query)-1)) {
    print(paste('Executing ', names(query)[i], sep = ''))
    DBI::dbExecute(con, unname(query[i]), immediate = TRUE)
  }

  print(paste('Executing ', names(query)[length(query)], sep = ''))
  data <- odbc::dbGetQuery(con, unname(query[length(query)]))
  odbc::dbDisconnect(con)
  remove(con)

  data
}
