#' @name CENTREannotation-package
#'
#' @title CENTREannotation: Hub package for the annotation data of CENTRE
#' (GENCODE v40 and SCREEN v3)
#'
#' @format SQLite databases with GENCODE v40 and SCREEN v3 data.
#'
#' @source \url{https://www.gencodegenes.org/human/release_40.html}
#' \url{https://screen.encodeproject.org}
#'
#' @description
#' This is an AnnotationHub package for the CENTRE Bioconductor
#' software package. It contains the GENCODE version 40 annotation and ENCODE
#' Registry of candidate cis-regulatory elements (cCREs) version 3. All
# 'for Human hg38 genome.
#'
#' @examples
#' \donttest{
#' library(AnnotationHub)
#' hub <- AnnotationHub()
#' eh <- query(hub, "CENTREannotation")
#' }
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
