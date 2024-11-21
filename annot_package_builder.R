#Script to download the database and generate the package

library(RSQLite)
library(DBI)
library(data.table)

download_url <- function(url, dir_name){
  download.file(url = url, destfile = (file.path(dir_name, basename(url))))
}

create_db_connection <- function(package_location, db){
  return(DBI::dbConnect(RSQLite::SQLite(),file.path(package_location, "inst", "extdata",
                                                    db)))
}


# We perform all operations in a temporary directory, so cleanup is easier/automatic
tmp_dir = tempdir(check = FALSE)

# Download the sql database
mysqlite_dump_url <- "http://owww.molgen.mpg.de/~CENTRE_data/CENTREannotationData/ENCODEAnnotation-GRCh38-cCREsV3.db"
download_url(mysqlite_dump_url, tmp_dir)
mysqlite_dump_url2 <- "http://owww.molgen.mpg.de/~CENTRE_data/CENTREannotationData/gencode_hg38_v40.db"
download_url(mysqlite_dump_url2, tmp_dir)

## Create package structure
package_location = file.path(tmp_dir, "CENTREannotation")

dir.create(file.path(package_location, "inst", "extdata"), recursive = TRUE)
dir.create(file.path(package_location, "inst", "scripts"), recursive = TRUE)
dir.create(file.path(package_location, "inst", "doc"), recursive = TRUE)
dir.create(file.path(package_location, "man"), recursive = TRUE)
dir.create(file.path(package_location, "R"), recursive = TRUE)
dir.create(file.path(package_location, "vignettes"), recursive = TRUE)
dir.create(file.path(package_location, "doc"), recursive = TRUE)
## Copy static files
file.copy(from = "./staticfiles/NAMESPACE", 
          to = file.path(package_location, "NAMESPACE"))
file.copy(from = "./staticfiles/DESCRIPTION", 
          to = file.path(package_location, "DESCRIPTION"), overwrite = T)
file.copy(from = "./staticfiles/R/zzz.R", 
          to = file.path(package_location, "R/zzz.R"))
file.copy(from = "./staticfiles/R/CENTREannotDb.R", 
          to = file.path(package_location, "R/CENTREannotDb.R"))
file.copy(from = "./staticfiles/inst/extdata/metadata.csv", 
          to = file.path(package_location, "inst/extdata/metadata.csv"))
file.copy(from = "./staticfiles/vignettes/CENTREannotation.Rmd", 
          to = file.path(package_location, "vignettes/CENTREannotation.Rmd"))


file.copy(from = list.files("./staticfiles/inst/scripts", "+?\\.R$", full.names = TRUE),
          to = file.path(package_location, "inst/scripts"))
file.copy(from = list.files("./staticfiles/doc", "*",full.names = TRUE),
          to = file.path(package_location, "inst/doc"))
file.copy(from = list.files("./staticfiles/man", "+?\\.Rd$", full.names = TRUE),
          to = file.path(package_location, "man"), overwrite = T)


# Copy the sqlite into the package
file.copy(from = file.path(tmp_dir, "ENCODEAnnotation-GRCh38-cCREsV3.db"), 
          to = file.path(package_location, "inst", "extdata",
                         "ENCODEAnnotation-GRCh38-cCREsV3.db"),
          overwrite = TRUE)


metadata <- data.table::data.table(
  name = c(
    "source_name",
    "source_url",
    "source_date",
    "organism",
    "Db type",
    "supporting_package",
    "supporting_object"
  ),
  value = c(
    "CENTREannotation",
    "http://owww.molgen.mpg.de/~CENTRE_data/CENTREannotationData/ENCODEAnnotation-GRCh38-cCREsV3.db",
    Sys.Date(),
    "HSapiens",
    "CENTREannotDb",
    "CENTREannotation",
    "CENTREannotenhDb"
  )
)


annot_conn <- create_db_connection(package_location, "ENCODEAnnotation-GRCh38-cCREsV3.db")

dbWriteTable(annot_conn, "metadata", metadata, overwrite = T)
dbGetQuery(annot_conn, "SELECT * from metadata")
dbDisconnect(annot_conn)

file.copy(from = file.path(tmp_dir, "gencode_hg38_v40.db"), 
          to = file.path(package_location, "inst", "extdata",
                         "gencode_hg38_v40.db"),
          overwrite = TRUE)


metadata <- data.table::data.table(
  name = c(
    "source_name",
    "source_url",
    "source_date",
    "organism",
    "Db type",
    "supporting_package",
    "supporting_object"
  ),
  value = c(
    "CENTREannotation",
    "http://owww.molgen.mpg.de/~CENTRE_data/CENTREannotationData/gencode_hg38_v40.db",
    Sys.Date(),
    "HSapiens",
    "CENTREannotDb",
    "CENTREannotation",
    "CENTREannotgeneDb"
  )
)



annot_conn <- create_db_connection(package_location, "gencode_hg38_v40.db" )

dbWriteTable(annot_conn, "metadata", metadata, overwrite = T)
dbGetQuery(annot_conn, "SELECT * from metadata")
dbDisconnect(annot_conn)

system(paste0("R CMD check ", package_location))
system(paste0("R CMD build --resave-data=best --no-build-vignettes ", package_location))

