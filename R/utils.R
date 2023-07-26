create_dsn_list <- function(named_vector) {
  named_table <- data.frame(Alias = names(named_vector),
                            DSN = named_vector, row.names = NULL)
}

