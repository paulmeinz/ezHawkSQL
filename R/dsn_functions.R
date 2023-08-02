#' Set DSN names for local servers
#'
#' This function temporarily sets your DSNs for use in sql queries.
#'
#' @param dsn A named character vector. The names of this list should correspond
#'   to an 'Alias' you will reference in code later. The values should be datasource
#'   names from your integrated security environment.
#' @param default Your default dsn (presumably the dsn you will use most frequently).
#'   If this is left unspecified, set_dsn presumes the first supplied value in dsn
#'   is your default.
#' @return Sets the ez.dsn user defined option and your default DSN which is
#'   stored in ez.dsn.default
#' @examples
#' dsns <- c('Alias1' = 'dsn1', 'Alias2' = 'dsn2')
#' set_dsn(dsns, default = 'Alias2')
#'
#' @export
#'
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
#' See a printed list of your DSNs and corresponding Aliases
#'
#' @return Returns a printed list of your current set DSNs within in this session.
#' @export
#'
#' @examples get_dsn()
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
#' Clears your current DSN List
#' @return Clears the DSNs out of your current session.
#' @export
#'
#' @examples reset_dsn() # Be careful with this!
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
#' Helps you set the default DSN for this session.
#' @param alias The alias for the DSN that you would like to set as default
#'
#' @return Sets your default DSN, a.k.a. the global option ez.dsn.default.
#' @export
#'
#' @examples
#' dsns <- c('Alias1' = 'dsn1', 'Alias2' = 'dsn2')
#' set_dsn(dsns)
#' set_default_dsn(default = 'Alias2')
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
#' @param new_value The new value your want to add. This should be in the form
#'   of a named character vector. With the name so your vector representing
#'   DSN aliases and the values representing DSNs from your integrated security
#'   environment.
#' @param from_alias If you hope to replace a current Alias/DSN, specify it here.
#'   Otherwise new_value will be appended to your current DSNs.
#'
#' @return Adds/modifies your session DSNs, a.k.a options()$ez.dsn
#' @export
#'
#' @examples
#' dsns <- c('Alias1' = 'dsn1', 'Alias2' = 'dsn2')
#' set_dsn(dsns)
#' new_dsn <- c('Alias3' = 'dsn3')
#' alter_dsn(new_value = new_dsn, from_alias = 'Alias2')
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

#' Manually Save Your DSN List to .Renviron
#' Allows you to modify your .Renviron to permanently save your session DSNs.
#' @return Opens the .Renviron edit window.
#' @export
#'
#' @examples save_dsn()
save_dsn <- function() {
  dsn_list <- create_dsn_list(options()$ez.dsn) %>%
    dplyr::mutate(string = paste("'", Alias, "' = '", DSN ,"'", sep = ''))
  cat(crayon::green('Paste this into your .Renviron after ezHawkDSN = \n'))
  print(paste(dsn_list$string, collapse = ','))
  usethis::edit_r_environ()
}
