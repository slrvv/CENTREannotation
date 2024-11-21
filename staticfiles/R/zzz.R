################################################################################
#
# Load function
# 
################################################################################

#CENTREannotationData/ENCODEAnnotation-GRCh38-cCREsV3.db
.onLoad <- function(libname, pkgname) {
  ns <- asNamespace(pkgname)
  dataname <- "ENCODEAnnotation-GRCh38-cCREsV3.db"
  dbfile <- system.file("extdata", dataname, package=pkgname, lib.loc=libname)
  db <- CENTREannotationDb(dbfile)
  objname <- "CENTREannotenhDb"
  assign(objname, db, envir=ns)
  namespaceExport(ns, objname)
  dataname <- "gencode_hg38_v40.db"
  dbfile <- system.file("extdata", dataname, package=pkgname, lib.loc=libname)
  db <- CENTREannotationDb(dbfile)
  objname <- "CENTREannotgeneDb"
  assign(objname, db, envir=ns)
  namespaceExport(ns, objname)
}

