##########################################################################
##
## CENTREannotation: GENCODE v40 and ENCODE cCREs v3
##
##########################################################################

meta <- data.frame(
	Title = c("GENCODE basic gene annotation v40",
	"ENCODE Registry of cCREs V3"),
	Description = c(paste0("GENCODE comprehensive basic gene annotation v40"
	," on reference chromosomes only"),
	"ENCODE cCREs V3 all human cCREs"),
	BiocVersion = c(rep("3.18", 2)),
	Genome = rep("GRCh38", 2), 
	SourceType = c("GTF", "BED"),
	SourceUrl = c("https://www.gencodegenes.org/human/release_40.html",
	"https://screen.encodeproject.org"),
	SourceVersion = c("V40", "V3"),
	Species = rep("Homo sapiens", 2),
	TaxonomyId = rep(9606, 2),
	Coordinate_1_based = TRUE, 
	DataProvider = c("GENCODE", "ENCODE cCREs"),
	Maintainer = "Sara Lopez <lopez_s@molgen.mpg.de>",
	RDataClass = c("data.frame","data.frame"),
	DispatchClass = c(rep("Rda", 2)),
	Location_Prefix = c(rep("http://owww.molgen.mpg.de/~CENTRE_data/", 2)),
	RDataPath = c("gencode_v38.one.transcript2.rda", "ENCODEAnnotation-GRCh38-cCREsV3_all500.rda"),
	Tags = c(rep("AnnotationHub:AnnotationData:Organism", 2))
)

write.csv(meta, file= system.file("extdata",
                                  "metadata.csv",
                                  package = "CENTREannotation"),
          row.names=FALSE)
