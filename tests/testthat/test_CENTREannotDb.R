test_that("CENTREannotDb obj connection works as intented", {
    expect_false(RSQLite::dbIsValid(CENTREannotgeneDb@conn))
    expect_true(RSQLite::dbIsValid(.dbconn(CENTREannotgeneDb@conn)))

    expect_false(RSQLite::dbIsValid(CENTREannotenhDb@conn))
    expect_true(RSQLite::dbIsValid(.dbconn(CENTREannotenhDb@conn)))
})
