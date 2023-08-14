.onAttach <- function(libname, pkgname) {
  packageStartupMessage(crayon::green('Welcome to ezHawkSQL!'))
  dsn_values <- eval(parse(text = Sys.getenv('ezHawkDSN')))
  if(dsn_values == "") {suppressWarnings(set_dsn(dsn = dsn_values))}
  dsn_check <- is.null(options()$ez.dsn)
  if (dsn_check) {e
    packageStartupMessage(crayon::red("\U2717 - Detecting no DSNs!"))
    packageStartupMessage(crayon::red("Make sure to set your DSN using set_dsn()"))
  } else {
    dsn_default <- options()$ez.dsn.default
    packageStartupMessage(crayon::green("\nYour current default DSN is:"))
    packageStartupMessage(crayon::white(names(dsn_default)))
    packageStartupMessage(crayon::green(strwrap("\nHere's a list of your current DSNs
                                        aliases:")),
                          appendLF = FALSE)
    packageStartupMessage(crayon::white(paste('\n',names(dsn_values), sep = '- ')
                                        ))

  }
}
