.onAttach <- function(libname, pkgname) {
  packageStartupMessage(crayon::green('Welcome to ezHawkSQL!'))
  dsn_check <- is.null(options()$ez.dsn)
  if (dsn_check) {
    packageStartupMessage(crayon::red("\U2717 - Detecting no DSNs!"))
    packageStartupMessage(crayon::red("Make sure to set your DSN using set_dsn()"))
  } else {
    dsn_values <- options()$ez.dsn
    dsn_value_table <- knitr::kable(create_dsn_list(dsn_values))
    dsn_default <- options()$ez.dsn.default
    packageStartupMessage(crayon::green("\nYour current default DSN is:"))
    packageStartupMessage(cat(crayon::white(names(dsn_default))))
    packageStartupMessage(cat(crayon::green("\nHere's a list of your current DSNs:")),
                          appendLF = FALSE)
    packageStartupMessage(print(dsn_value_table))

  }
}
