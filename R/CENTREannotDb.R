## The set up of the class and properties is based on the CompDb class and
## package

#' @name CENTREannotDb
#'
#' @import BiocGenerics
#' @title Class object for the CENTRE annotation data
#'
#' @aliases CENTREannotDb-class CENTREannotgeneDb-object CENTREannotenhDb-object
#'
#' @return class CENTREannotDb
#'
#' @description
#'
#' The CENTRE annotation data is accessed through objects of `CENTREannotDb` class.
#' `CENTREannotenhDb` provides access to the ENCODE screen V3 annotation
#' for Human https://screen.encodeproject.org and `CENTREannotenhDb` gives access to
#' GENCODE basic gene annotation version 40.
#'
#' @details
#'
#' Using `tables(x)` on a `CENTREannotDb` object returns the tables and columns
#' for each table in the database.
#'
#' @examples
#' tables(CENTREannotgeneDb)
#'
#' @references Based on [CompoundDb::CompDb].

#' @importClassesFrom DBI DBIConnection
setClassUnion("DBIConnectionOrNULL", c("DBIConnection", "NULL"))

#' @importFrom methods new is
#'
#' @exportClass CENTREannotDb
.CENTREannotDb <- setClass("CENTREannotDb",
    slots = c(
        conn = "DBIConnectionOrNULL",
        .properties = "list",
        dbname = "character",
        dbflags = "integer",
        packageName = "character"
    ),
    prototype = list(
        .properties = list(),
        conn = NULL,
        dbname = character(),
        dbflags = 1L,
        packageName = character()
    )
)


#' @param x sqlite file path
#
#' @importFrom RSQLite SQLITE_RO
#'
#' @rdname CENTREannotDb
CENTREannotationDb <- function(x) {
    return(.initialize_centredb(.CENTREannotDb(
        dbname = x,
        dbflags = SQLITE_RO,
        packageName = "CENTREannotation"
    )))
}

#' @importFrom DBI dbDriver dbGetQuery dbConnect dbListTables dbDisconnect
.initialize_centredb <- function(x) {
    con <- .dbconn(x)
    x@conn <- con
    if (length(.dbname(x)) && !is.null(con)) {
        on.exit(dbDisconnect(con))
    }
    ## fetch all tables and all columns for all tables.
    tbl_nms <- dbListTables(con)
    tbls <- lapply(tbl_nms, function(z) {
        colnames(dbGetQuery(con, paste0("select * from ", z, " limit 1")))
    })
    names(tbls) <- tbl_nms
    x@.properties$tables <- tbls
    x
}

.metadata <- function(x) {
    if (!is(x, "DBIConnection")) {
        n <- .dbname(x)
        x <- .dbconn(x)
        if (length(n) && !is.null(x)) {
            on.exit(dbDisconnect(x))
        }
    }
    dbGetQuery(x, "select * from metadata")
}

.metadata_value <- function(x, key) {
    metad <- .metadata(x)
    metad[metad$name == key, "value"]
}

#' @importFrom methods .hasSlot
.dbflags <- function(x) {
    if (.hasSlot(x, "dbflags")) {
        x@dbflags
    } else {
        1L
    }
}

.dbconn <- function(x) {
    if (length(.dbname(x))) {
        dbConnect(dbDriver("SQLite"), dbname = x@dbname, flags = .dbflags(x))
    } else {
        x@conn
    }
}

.dbname <- function(x) {
    if (.hasSlot(x, "dbname")) {
        x@dbname
    } else {
        character()
    }
}


#' @description Get a list of all tables and their columns.
#'
#' @param x `CENTREannotDb` object.
#'
#' @param name optional `character` to return the table/columns for specified
#'     tables.
#'
#' @param metadata `logical(1)` whether the metadata should be returned too.
#'
#' @noRd
.tables <- function(x, name, metadata = FALSE) {
    tbls <- .get_property(x, "tables")
    if (!missing(name)) {
        tbls <- tbls[name]
    }
    if (!metadata) {
        tbls <- tbls[names(tbls) != "metadata"]
    }
    tbls
}

#' @export
#'
#' @rdname CENTREannotDb
tables <- function(x) {
    .tables(x)
}

.get_property <- function(x, name) {
    x@.properties[[name]]
}
