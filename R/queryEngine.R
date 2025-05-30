## A simple query engine for the CENTREannotation package based on the
## CompDb package adapted to CENTREannotation

#' @description
#'
#' Utility function to create a SQL query for a `CENTREannotDb` database
#' given the provided column names, entries and column filter.
#'
#' @param x `CENTREannotDb` type object
#' @param columns Columns to select. Equivalent to X in SELECT X
#' @param entries Element ID to select. Equivalent to ID in SELECT X FROM TABLE
#' WHERE ID in Z.
#' @param column_filter Column on which to apply filter. Equivalent to Z in
#' SELECT X FROM TABLE WHERE ID in Z.
#' @details
#'
#' + Check first that the `columns` are valid
#' + Fetch the data based on entries and column on which to filter.
#'
#' @md
#' @references Based on the internal query engine of [CompoundDb]
#' @noRd
.build_query <- function(x, columns, entries, column_filter) {
    if (missing(x)) {
        stop(" 'x' is required")
    }
    if (missing(columns)) {
        stop("'columns' is required")
    }

    tbls <- .tables(x)
    col_m <- columns[!columns %in% unique(unlist(tbls, use.names = FALSE))]
    msg <- paste(col_m, collapse = ", ")
    if (length(col_m != 0)) {
        stop(
            "Columns ", msg,
            " are not present in the database. Use 'tables' to list ",
            "all tables and their columns."
        )
    }
    paste0(
        paste0("select ", paste0(columns, collapse = ",")),
        paste0(" from ", names(tbls)),
        .where(entries, column_filter)
    )
}

#' @description
#'
#' Create the *where* condition for the SQL query based on the provided
#' filter column
#'
#' @md
#'
#' @noRd
.where <- function(entries, column_filter) {
    if (!missing(column_filter)) {
        paste0(
            " where ", column_filter, " in (",
            paste0(sprintf("'%s'", entries), collapse = ", "), ")"
        )
    }
}

#' @name fetch_data
#'
#' @import BiocGenerics
#' @title Fetch data from the CENTREannotDb databases
#'
#' @description
#' Main interface to fetch data from the CENTREannotation package databases
#' through the `CENTREannotDb` objects.
#'
#' @param x  A `CENTREannotDb` object, either `CENTREannotgeneDb` or
#' `CENTREannotenhDb`
#' @param columns Columns to select (vector or string). Equivalent to X in
#' SELECT X.
#' @param entries Element ID to select (vector or sting). Equivalent to ID in
#' SELECT X FROM TABLE WHERE ID in Z. If entries or column_filter is missing
#' the program assumes the query is SELECT X FROM TABLE.
#' @param column_filter Column on which to apply filter. Equivalent to Z in
#' SELECT X FROM TABLE WHERE ID in Z. If entries or column_filter is missing the
#' program assumes the query is SELECT X FROM TABLE.
#'
#' @return data.frame with the queried data.
#'
#' @references Based on the internal query engine of `CompoundDb`
#'
#' @examples
#' res <- fetch_data(CENTREannotenhDb,
#'     columns = c("enhancer_id", "start"),
#'     entries = c("EH38E1519134", "EH38E1519132"),
#'     column_filter = "enhancer_id"
#' )
#' @export
fetch_data <- function(x, columns, entries, column_filter) {
    con <- .dbconn(x)
    if (length(.dbname(x))) {
        on.exit(dbDisconnect(con))
    }
    data <- dbGetQuery(con, .build_query(x,
        columns = columns,
        entries = entries,
        column_filter = column_filter
    ))
    return(data)
}
