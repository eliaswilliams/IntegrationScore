


test_that("returns ggplot", {
        data("deg_df")
        expect_equal(class(plotDelta(deg_df, 10))[2], "ggplot")
})
