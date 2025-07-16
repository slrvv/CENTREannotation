test_that("CENTREannotDb obj connection works as intented", {
    ah <- AnnotationHub::AnnotationHub()
    CENTREannotgeneDb <- ah[["AH116730"]]
    CENTREannotgeneDb <- CENTREannotDb(CENTREannotgeneDb@conn)
    expect_false(RSQLite::dbIsValid(CENTREannotgeneDb@conn))
    expect_true(RSQLite::dbIsValid(.dbconn(CENTREannotgeneDb)))
    
    
    ah <- AnnotationHub::AnnotationHub()
    CENTREannotenhDb <- ah[["AH116731"]]
    CENTREannotenhDb <- CENTREannotDb(CENTREannotenhDb@conn)
    expect_false(RSQLite::dbIsValid(CENTREannotenhDb@conn))
    expect_true(RSQLite::dbIsValid(.dbconn(CENTREannotenhDb)))
})
