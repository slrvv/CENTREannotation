##########################################################################
# CENTREannotation: GENCODE and ENCODE cCREs
#########################################################################

# The data for GENCODE comprehensive gene annotation on the reference
# chromosomes was downloaded from
# https://www.gencodegenes.org/human/release_40.html
# in GTF file format Release 40. The file was then transformed from GTF to bed
# and the relevant columns where selected (chr, start, end, gene_id,
# orientation, transcript_id, gene_name, description, transcription_start) and
# we excluded exon annotation. The transcription start site was extended to a
# size of 499 for all genes. We include the column gene_id1 which contains the
# gene ID without version identifier.
# The data was transformed into a SQLite database using RSQLite


# The data for ENCODE cCREs was downloaded from https://screen.encodeproject.org V3
# under Downloads for all types of regulatory elements in Human.
# The BED file was downloaded and we added names to the columns. The regulatory
# element region was extended to a have a size of 500 and the middle point in the
# new reg element range was computed.
# The data was transformed into an SQLite database using RSQLite


