## The set up of the class and properties is based on the CompDb class and
## package

#' @name CENTREannotDb
#'
#' @import BiocGenerics AnnotationHub
#' @title Class object for the CENTRE annotation data
#'
#' @aliases CENTREannotDb-class 
#' @return class CENTREannotDb
#'
#' @description
#'
#' The CENTRE annotation data is accessed through objects of `CENTREannotDb` class.
#' That either provides access to the ENCODE screen V3 annotation
#' for Human https://screen.encodeproject.org or gives access to
#' GENCODE basic gene annotation version 40.
#'
#' @details
#'
#' Using `tables(x)` on a `CENTREannotDb` object returns the tables and columns
#' for each table in the database.
#'
#' @examples
#' ##load the screen V3 annotation
#' ah <- AnnotationHub::AnnotationHub()
#' screen <- ah[["AH116731"]]
#' tables(screen) #get all tables and columns in the data base
#' @references Based on CompoundDb::CompDb.

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
CENTREannotDb <- function(x) {
    return(.initialize_centredb(.CENTREannotDb(
        conn = x,
        dbflags = SQLITE_RO,
        packageName = "CENTREannotation"
    )))
}

#' @importFrom DBI dbDriver dbGetQuery dbConnect dbListTables dbDisconnect dbIsValid
#' 
.initialize_centredb <- function(x) {
    con <- .dbconn(x)
    x@dbname <- dbfile(con)
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

#' @importFrom DBI dbIsValid
.dbconn <- function(x) {
    if (!dbIsValid(x@conn)) {
        dbConnect(dbDriver("SQLite"), dbname = dbfile(x@conn), flags = .dbflags(x))
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
    con <- .dbconn(x)
    x <- CENTREannotDb(con)
    .tables(x)
}
.get_property <- function(x, name) {
    x@.properties[[name]]
}
