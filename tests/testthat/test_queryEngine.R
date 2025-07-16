test_that("fetch_data works as intented", {
    expected <- data.frame(
        enhancer_id = c("EH38E1519132", "EH38E1519134"),
        start = c(9363676, 9364325)
    )
    ah <- AnnotationHub::AnnotationHub()
    CENTREannotenhDb <- ah[["AH116731"]]
    
    fetched <- fetch_data(CENTREannotenhDb,
        columns = c("enhancer_id", "start"),
        entries = c("EH38E1519134", "EH38E1519132"),
        column_filter = "enhancer_id"
    )
    expect_equal(fetched, expected, tolerance = 1e-6)

    ah <- AnnotationHub::AnnotationHub()
    CENTREannotgeneDb <- ah[["AH116730"]]
    fetched <- fetch_data(CENTREannotgeneDb,
        columns = c("gene_id1", "chr"),
        entries = c("ENSG00000000419"),
        column_filter = "gene_id1"
    )

    expected <- data.frame(
        gene_id1 = c("ENSG00000000419"),
        chr = c("chr20")
    )

    expect_equal(fetched, expected, tolerance = 1e-6)
    # catch error when column name doesnt exist
    expect_error(fetch_data(CENTREannotenhDb,
        columns = c("enhancer_id", "start", "blipblup"),
        entries = c("EH38E1519134", "EH38E1519132"),
        column_filter = "enhancer_id"
    ))
    # catch error missing Db oject
    expect_error(fetch_data(
        columns = c("enhancer_id", "start"),
        entries = c("EH38E1519134", "EH38E1519132"),
        column_filter = "enhancer_id"
    ))

    # catch error missing columns
    expect_error(fetch_data(CENTREannotenhDb,
        entries = c("EH38E1519134", "EH38E1519132"),
        column_filter = "enhancer_id"
    ))
})
