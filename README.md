
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
#> Downloading GitHub repo paulmeinz/ezHawkSQL@HEAD
#> cpp11 (0.4.5 -> 0.4.6) [CRAN]
#> xfun  (0.39  -> 0.40 ) [CRAN]
#> purrr (1.0.1 -> 1.0.2) [CRAN]
#> gert  (1.9.2 -> 1.9.3) [CRAN]
#> Installing 4 packages: cpp11, xfun, purrr, gert
#> Installing packages into 'C:/Users/w1563070/AppData/Local/Temp/RtmpauhXTb/temp_libpath58dc7a1668d6'
#> (as 'lib' is unspecified)
#> 
#>   There are binary versions available but the source versions are later:
#>       binary source needs_compilation
#> cpp11  0.4.5  0.4.6             FALSE
#> purrr  1.0.1  1.0.2              TRUE
#> 
#> package 'xfun' successfully unpacked and MD5 sums checked
#> package 'gert' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  C:\Users\w1563070\AppData\Local\Temp\RtmpELWQnY\downloaded_packages
#> installing the source packages 'cpp11', 'purrr'
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>          checking for file 'C:\Users\w1563070\AppData\Local\Temp\RtmpELWQnY\remotes47545b2f7fb6\paulmeinz-ezHawkSQL-2b9209b/DESCRIPTION' ...     checking for file 'C:\Users\w1563070\AppData\Local\Temp\RtmpELWQnY\remotes47545b2f7fb6\paulmeinz-ezHawkSQL-2b9209b/DESCRIPTION' ...   ✔  checking for file 'C:\Users\w1563070\AppData\Local\Temp\RtmpELWQnY\remotes47545b2f7fb6\paulmeinz-ezHawkSQL-2b9209b/DESCRIPTION' (669ms)
#>       ─  preparing 'ezHawkSQL':
#>    checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
#>       ─  checking for LF line-endings in source and make files and shell scripts
#>       ─  checking for empty or unneeded directories
#>      Omitted 'LazyData' from DESCRIPTION
#>       ─  building 'ezHawkSQL_1.0.0.tar.gz'
#>      
#> 
#> Warning: package 'ezHawkSQL' is in use and will not be installed
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

Now that you’ve worked out your DSN situation, you can use the SQL
helper functions that I’ve written to make SQL EZ. The first helper
function allows you to read queries - read_query(). This function can
either read a single select query or it can read a multi-step query. The
multi-step query must begin with the execution of several temp table
steps (and/or other steps that do not return a data set) and end with a
select statement that pulls the data. Each step should be divided by
‘—step—’ so the function can easily distinguish between SQL steps. In
the event of a multi-step query, the function will return a named
vector. Each element will be a step in the query (in it’s relative order
of execution), and each element will be provided a name based on the
order of execution (e.g., “Step 1”, “Step 2”, etc.)

``` r
my_sql_query_directory <- 'spam_sql.txt'
query <- read_query(my_sql_query_directory)
```

Next you can use sql_query() to gather data from your favorite data
source. This requires two arguments - a query and an alias. If you do
not provide an alias, sql_query will use your default alias. This means
you only need to provide a query! How neat.

``` r
sql_query("select spam from beautiful_spam where spam = 'yum'", 'spam')

# OR
my_sql_query_directory <- 'spam_sql.txt'
query <- read_query(my_sql_query_directory)
sql_query(query)
```

sql_query() query will however not work super well for a multi-step
query - e.g. a query that has several preparatory steps prior to pulling
the final data set. For that, you can use multistep_sql_query(). This
function takes as it’s first argument a named list of queries in the
order of execution (e.g. first element gets executed first, etc.). The
second argument is your DSN alias.

``` r
step1 <- "select spam into #spam_table from beautiful_spam"
step2 <- "select * from #spam_table"
queries <- c('Step 1' = step1, 'Step 2' = step2)
multistep_sql_query(queries)
```
