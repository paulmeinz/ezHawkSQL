#' Set DSN names for local servers
#'
#' @param dsn
#'
#' @return
#' @export
#'
#' @examples
set_dsn <- function(dsn = NULL, default = null) {

  if (is.null(dsn)) {
    stop(strwrap("You're gonna need to provide a DSN name. If you want to
      reset/change, you DSN use reset_dsn() or
      alter_dsn(), respectively"))
  }

  options(ez.dsn = dsn)

  if (is.null(default)
      | length(default) > 1
      | !default %in% names(options()$ez.dsn)) {
    options(ez.dsn.default = dsn[1])
    warning('Setting first DSN as Default')
  } else {
    options(ez.dsn.default = dsn[alias])
  }

}

#' Get DSNs and Default DSN
#'
#' @return
#' @export
#'
#' @examples
get_dsn <- function() {
  dsn_list <- options()$ez.dsn
  dsn_list <- create_dsn_list(dsn_list)
  dsn_default <- options()$ez.dsn.default
  cat(crayon::green("Your default DSN is currently set to:"))
  cat(paste(names(dsn_default),'\n'))
  cat(crayon::green("Your Current List of DSN's is:"))
  print(knitr::kable(dsn_list))
}

#' Clear DSN list
#'
#' @return
#' @export
#'
#' @examples
#'
reset_dsn <- function() {
  options(ez.dsn = NULL)
  options(ez.dsn.default = NULL)

  cat(crayon::green(strwrap('DSN list and default DSN cleared.
                            Use set_dsn() to set a new DSN.')))
}

#' Set Your Default DSN
#'
#' @param alias
#'
#' @return
#' @export
#'
#' @examples
set_default_dsn <- function(alias = NULL) {
  if(is.null(alias)) {
    stop("You're gonna need to provide a value for your default DSN.")
  }

  if(!alias %in% names(options()$ez.dsn) | length(alias) > 1) {
    stop(strwrap("The alias you supply for the default must be a single value
            that exists in your DSN list"))
  }

  options(ez.dsn.default = options()$ez.dsn[alias])
}

alter_dsn <- function(from_alias = NULL, to = NULL) {

}
