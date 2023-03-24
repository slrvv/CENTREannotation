##########################################################################
##
## CENTREannotation: GENCODE v40 and ENCODE cCREs v3
##
##########################################################################

meta <- data.frame(
	Title = c("GENCODE comprehensive gene annotation v40",
	"ENCODE Registry of cCREs V3"),
	Description = c(paste0("GENCODE comprehensive gene annotation v40"
	," on reference chromosomes only"),
	"ENCODE cCREs V3 all human cCREs"),
	BiocVersion = c("",""),
	Genome = rep("GRCh38", 2), 
	SourceType = c("gtf", "bed"),
	SourceUrl = c("https://www.gencodegenes.org/human/release_40.html",
	"https://screen.encodeproject.org"),
	SourceVersion = c("V40", "V3"),
	Species = rep("Homo Sapiens", 2),
	TaxonomyId = rep(9606, 2),
	Coordinate_1_based = TRUE, 
	DataProvider = c("GENCODE", "ENCODE cCREs"),
	Maintainer = "Sara Lopez <lopez_s@molgen.mpg.de>",
	RDataClass = c("",""),
	DispatchClass = c(rep("Rda", 2)),
	RDataPath = c("", ""),
	Tags = c("", ""),
	Notes = c("", "")
)

write.csv(meta, file="/inst/extdata/metadata.csv", row.names=FALSE)
