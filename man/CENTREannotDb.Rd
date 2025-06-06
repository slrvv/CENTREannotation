% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CENTREannotDb.R
\docType{class}
\name{CENTREannotDb}
\alias{CENTREannotDb}
\alias{CENTREannotDb-class}
\alias{CENTREannotgeneDb-object}
\alias{CENTREannotenhDb-object}
\alias{CENTREannotationDb}
\alias{tables}
\title{Class object for the CENTRE annotation data}
\usage{
CENTREannotationDb(x)

tables(x)
}
\arguments{
\item{x}{sqlite file path}
}
\value{
class CENTREannotDb
}
\description{
The CENTRE annotation data is accessed through objects of \code{CENTREannotDb} class.
\code{CENTREannotenhDb} provides access to the ENCODE screen V3 annotation
for Human https://screen.encodeproject.org and \code{CENTREannotenhDb} gives access to
GENCODE basic gene annotation version 40.
}
\details{
Using \code{tables(x)} on a \code{CENTREannotDb} object returns the tables and columns
for each table in the database.
}
\examples{
tables(CENTREannotgeneDb)



}
\references{
Based on \link[CompoundDb:CompDb]{CompoundDb::CompDb}.
}
