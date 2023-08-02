
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ezHawkSQL

<!-- badges: start -->
<!-- badges: end -->

ezHawkSQL is intended to make querying from R in an integrated security
environment easier. It contains a bunch of helper functions that help
you manage referenced DSNs during an R session and help you save DSNs to
your .Renviron. It also contains a set of functions that help you query
SQL databases using the aforementioned DSNs. The Hawk in the name
reflects the author’s current favorite community college mascot. Go
Hawks!

## Installation

You can install the development version of ezHawkSQL from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("paulmeinz/ezHawkSQL")
```

## Setting your DSNs

Upon start-up and initial attachment of this package, you may receive a
notification that you have no identified DSNs. That’s a bummer! However,
the ezHawkDSN package provides a number of helper functions to make this
easy.

The first thing you’ll want to do is use the set_dsn() function within
your R session. This function takes two arguments - dsn and default.
Here dsn should be a named character vector. Each item of this vector
should be a data source name from you current windows environment. The
names of these vector will act as aliases for your DSN (for convenience
purposes) and are therefore heretofore referred to as *aliases*

``` r
dsns <- c('foo' = 'bar', 'spam' = 'beautiful_spam')
set_dsn(dsn = dsns, default = 'spam')
#> Warning in set_dsn(dsn = dsns, default = "spam"): NOTE any session DSN settings
#> will not be saved to your next session.Edit .Renviron for that.
```

Then you can use get_dsn() to display the current dsns in your session.

``` r
get_dsn()
#> Your default DSN is currently set to:spam 
#> Your Current List of DSN's is:
#> 
#> |Alias |DSN            |
#> |:-----|:--------------|
#> |foo   |bar            |
#> |spam  |beautiful_spam |
```

And finally, the data source names you set during your session will not
be saved for the next session. If you are hoping to have the convenience
of entering your DSNs one time, you’ll need to make appropriate edits to
your .Renviron file. This is easy with ezHawkSQL! Just use the
save_dsn() function (which takes no arguments) and follow the
instructions.

``` r
save_dsn()
```

## Querying made easy

Now that you’ve worked out your DSN situation, you can use sql_query()
to gather data from your favorite data source. This requires two
arguments - a query and an alias. If you do not provide an alias,
sql_query will use your default alias. This means you only need to
provide a query! How neat.

``` r
sql_query("select spam from beautiful_spam where spam = 'yum'", 'spam')
```
