#' Set DSN names for local servers
#'
#' @param dsn
#'
#' @return
#' @export
#'
#' @examples
set_dsn <- function(dsn = NULL, default = 1) {
  validate_dsn(dsn)

  if (is.null(dsn)) {
    stop(strwrap("You're gonna need to provide a DSN name. If you want to
      reset/change your DSN for the current session, use reset_dsn() or
      alter_dsn(), respectively"))
  }

  options(ez.dsn = dsn)

  if (is.null(default)
      | length(default) > 1
      | !default %in% names(options()$ez.dsn)) {
    options(ez.dsn.default = dsn[default])
    warning('Setting first listed DSN as Default')
  } else {
    options(ez.dsn.default = dsn[default])
  }

  warning(crayon::green(strwrap('NOTE any session DSN settings will not
                                be saved to your next session. Edit
                                .Renviron for that.')))
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
                            Use set_dsn() to set a new DSN. NOTE:
                            These changes will not be saved for your
                            next session.')))
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
  warning(crayon::green(strwrap('NOTE any changes to your DSN in this
                                session will not be saved for future sessions.
                                Modify .Renviron for permanent changes.')))
}

#' Alter your current DSN List
#'
#' @param new_value
#' @param from_alias
#'
#' @return
#' @export
#'
#' @examples
alter_dsn <- function(new_value, from_alias = NULL) {
  validate_dsn(new_value)

  if (!is.null(from_alias)) {
    stopifnot('from_alias must be an alias from your current DSN list.' =
                all(from_alias %in% names(options()$ez.dsn)))

    stopifnot('new_value must be the same length as from_alias' =
                length(new_value) == length(from_alias))
  }

  if (is.null(from_alias)) {
    current_dsns <- options()$ez.dsn
    current_dsns <- c(current_dsns, new_value)
    options(ez.dsn = current_dsns)
  }

  if (!is.null(from_alias)) {
    current_dsns <- options()$ez.dsn
    current_dsns[from_alias] <- new_value
    names(current_dsns)[names(current_dsns) == from_alias] <- names(new_value)
    options(ez.dsn = current_dsns)
  }

  if(!options()$ez.dsn.default %in% options()$ez.dsn) {
    options(ez.dsn.default = options()$ez.dsn[1])
    warning(strwrap("You've overwritten your default. Setting to the first
                    DSN in your list"))
  }

  warning(crayon::green(strwrap('NOTE any changes to your DSN in this
                                session will not be saved for future sessions.
                                Modify .Renviron for permanent changes.')))

}
