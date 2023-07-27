create_dsn_list <- function(named_vector) {
  named_table <- data.frame(Alias = names(named_vector),
                            DSN = named_vector, row.names = NULL)
}

validate_dsn <- function(dsn) {
  if (!is.character(dsn)) {
    stop('DSN must be a character vector')
  }
  if (is.null(names(dsn))) {
    stop(strwrap("DSN vector must be named. The names are referred to as 'aliases'
         in this package."))
  }
}
