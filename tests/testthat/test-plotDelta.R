
data("deg_df")

test_that("returns ggplot", {
        expect_equal(class(plotDelta(deg_df, 10))[2], "ggplot")
})
